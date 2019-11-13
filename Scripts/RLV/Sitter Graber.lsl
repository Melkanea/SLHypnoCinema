

key target; // UUID of the target object the victim will sit on. Must contain any sit script
integer sitscan = TRUE; // try to detect and lock people who sit manually (TRUE/FALSE)
integer lockseconds = 5; // time in seconds the victim will be locked to the target
integer sleeptime = 20; // time in seconds the victim has to leave the area after being freed to avoid instant regrabbing
// do not set sleeptime to 0!

key victim = NULL_KEY; //current victim
integer freetime; //end of timer as unix timestamp
list queue; // list for queueing victims in case more than one walk into the trap

integer RLVchan = -1812221819; //RLV Relay channel. do NOT change!
integer commchan; // channel to listen for client answers
float   targetmass; // mass of the target to check if someone is sitting
string  locktime; // lock time in human readable format
integer locked; // TRUE if someone is locked up
integer sitting; // TRUE is the victim is sitting on target (checked via RLV)

//melkaneas vars
string counter;
key owner; // This will be the new owner
integer collision_total;

//===================================================================================//
debug(string txt)
{
    // uncomment the next line to see debugging messages
//    llSay(DEBUG_CHANNEL, "DEBUG-INFO: "+txt);
//    llSay(DEBUG_CHANNEL, "COUNTER: "+(string)tc);
  //  llSay(DEBUG_CHANNEL, "Target-Vector: "+(string)pos);
    //llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
   // llSay(DEBUG_CHANNEL, (string)x);
   // llSay(DEBUG_CHANNEL, (string)y);
   // llSay(DEBUG_CHANNEL, (string)z);

   // llSay(DEBUG_CHANNEL, "Total amount of collisions"+" "+(string)collision_total);
}

relay(string type,key victim,string command) //send command to relay
{
    llRegionSayTo(victim, RLVchan, type+","+(string)victim+","+command);
}

next() //process next entry in queue
{
    debug("next()");
    if (llGetObjectMass(target) > targetmass) //stop here if someone is sitting on the object
    {
        debug("Someone is sitting");
        queue = [];
        return;
    }
    if (victim == NULL_KEY && llGetListLength(queue) > 0)
    {
        key this = llList2Key(queue, 0);
        if (llVecDist(llList2Vector(llGetObjectDetails(this, [OBJECT_POS]), 0), llGetPos() ) < 10.0)
        {
            locked = FALSE;
            sitting = FALSE;
            relay("sit", llList2Key(queue, 0), "@sit:"+(string)target+"=force");
            llSetTimerEvent(10);
        }
        else
        {
            queue = llDeleteSubList(queue, 0, 0);
            next();
        }
    }
}
default
{
    state_entry()
    {
        target = llGetKey();   //Object where to be teleported.

        list    objectinfo = llGetObjectDetails(target, [OBJECT_NAME, OBJECT_POS]);
        if (llList2Vector(objectinfo, 1) != <0,0,0>) //check if target exists
        {
            targetmass = llGetObjectMass(target);
            locktime = (string)llFloor((float)lockseconds / 60)+" minutes";
            if (lockseconds%60) locktime += ", "+(string)(lockseconds%60)+" seconds";
            llOwnerSay("Set to target: "+llList2String(objectinfo, 0));
            llOwnerSay("Locktime: "+locktime);
            commchan = (integer)("0x"+llGetSubString((string)llGetKey(), 0, 6))+(integer)"0x70000000";
            debug("command channel: "+(string)commchan);
            debug("object mass: "+(string)targetmass);
            llListen(RLVchan, "", "", "");
            llListen(commchan, "", victim, "");
            llVolumeDetect(TRUE);
            llSetTimerEvent(5);

            llListen(RLVchan, "", llGetOwnerKey();, "" );

        }
        else
        {
            llOwnerSay("Set target not found. Please edit the script and check the settings");
        }
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    collision_start(integer num)
    {
    debug ((string)num+" collisions");
        if (!locked)
        {
            while (num)
            {
                num--;
                if (!~llListFindList(queue, [llDetectedKey(num)]) && victim == NULL_KEY) //if detected agent is not queued and no victim queue them
                {
                    queue += llDetectedKey(num);
                    debug (llList2CSV(queue));
                    if (llGetListLength(queue) == 1) next(); //process queue if it has one entry
                }
            }
        }

    }
    collision_end(integer teleport)
    {

    collision_total++;
    }

    listen(integer chn, string name, key id, string msg)
    {

        if (chn == RLVchan) //answers from relay
        {
            list    answer = llCSV2List(msg);
            key     rkey = llList2Key(answer, 1);
            if (rkey == llGetKey())
            {
                debug("RLV answer: "+msg);
                string  rhandle = llList2String(answer, 0);
                string  rcommand = llList2String(answer, 2);
                string  rok = llList2String(answer, 3);
                if (rhandle == "sit" && rok == "ok")
                {
                    llSetTimerEvent(0);
                    victim = llGetOwnerKey(id);
                    llSleep(2);
                    relay("sitcheck", victim, "@getsitid="+(string)commchan);
                    llSetTimerEvent(5);
                }
                if (rhandle == "sitlock" && rok == "ok" && llGetOwnerKey(id) == victim)
                {
                    llRegionSayTo(victim, 0, "You are locked for "+locktime);
                }
                if (rcommand == "!release" && rok == "ok" && llGetOwnerKey(id) == victim)
                {
                    debug("released");
                    locked = FALSE;
                    victim = NULL_KEY;
                    next();
                }
            }
        }
        else if (chn == commchan) //answers from the victims client
        {
            debug("Comm answer: "+msg);
            if ((key)msg == target) //when the victim is sitting on the target it will send the targets key on the comm channel
            {
                if (!locked)
                {
                    victim = id;
                    llSetTimerEvent(5);
                    freetime = llGetUnixTime()+lockseconds;
                    relay("sitlock", victim, "@unsit=y");
                    locked = TRUE;
                }
                sitting = TRUE;
            }

        }

    }
timer()
{
        if (locked)
        {
            if (llGetUnixTime() >= freetime)
            {
                relay("release", victim, "!release");
                llRegionSayTo(victim, 0, "You are free. You have "+(string)sleeptime+" seconds to leave!");
                locked = FALSE;
                llSetTimerEvent(sleeptime);
            }
            else if (sitting == TRUE)
            {
                sitting = FALSE;
                relay("sitcheck", victim, "@getsitid="+(string)commchan);
            }
        }
        else
        {
            llSetTimerEvent(5);
            if (llGetObjectMass(target) > targetmass && sitscan == TRUE)  //is someone sitting?
            {
                llSensor("", "", AGENT, llVecDist(llGetPos(), llList2Vector(llGetObjectDetails(target, [OBJECT_POS]), 0))+2.0, PI); // find possible victims
            }
            else
            {
                queue = llDeleteSubList(queue, 0, 0);
                victim = NULL_KEY;
                locked = FALSE;
                next();
            }
        }
}
    sensor(integer num)
    {
        while(num)
        {
            num--;
            if (llGetAgentInfo(llDetectedKey(num)) & AGENT_SITTING) relay("sitcheck", llDetectedKey(0), "@getsitid="+(string)commchan); // check if sitting and if so ask relay for object they are sitting on
        }
    }
}
