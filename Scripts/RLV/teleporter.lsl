



/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */

/* Place the script in the prim you want to turn into the sensor.
 * The object will then detect collisions and tries to
 * force sit and lock the victim on the set target (see below).
 * It also tries to detect and lock people who just sit on the target
 * Feel free to contact me, Vala Vella, if you have questions
 * If you use this in your project I'd like to hear about it :) */

key     target = "00000000-0000-0000-0000-000000000000"; // UUID of the target object the victim will sit on. Must contain any sit script
integer sitscan = TRUE; // try to detect and lock people who sit manually (TRUE/FALSE)
integer lockseconds = 30; // time in seconds the victim will be locked to the target
integer sleeptime = 10; // time in seconds the victim has to leave the area after being freed to avoid instant regrabbing
// do not set sleeptime to 0!
integer counter;

vector vec;
float x;
float y;
float z;
//=======================================================================================================================//

key     victim = NULL_KEY; //current victim
integer freetime; //end of timer as unix timestamp
list    queue; // list for queueing victims in case more than one walk into the trap

integer RLVchan = -1812221819; //RLV Relay channel. do NOT change!
integer commchan; // channel to listen for client answers
float   targetmass; // mass of the target to check if someone is sitting
string  locktime; // lock time in human readable format
integer locked; // TRUE if someone is locked up
integer sitting; // TRUE is the victim is sitting on target (checked via RLV)

debug(string txt)
{
    // uncomment the next line to see debugging messages
    llSay(DEBUG_CHANNEL, "DEBUG-INFO: "+txt);
    llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
    llSay(DEBUG_CHANNEL, "Target-Key: "+(string)target);
    llSay(DEBUG_CHANNEL, "Owner-Key: "+(string)victim);
    llSay(DEBUG_CHANNEL, "Target-Vector: "+(string)pos);
    llSay(DEBUG_CHANNEL, "Counter: "+(string)counter);
}

relay(string type,key victim,string command) //send command to relay
{
    llRegionSayTo(victim, RLVchan, type+","+(string)victim+","+command);
}

default
{
    state_entry()
    {




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
            llSetTimerEvent(10);
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
    touch_start(integer info)
    {


//===================Melkaneas Triggered Teleporter=========================//

    ++counter;

    list pos = llGetObjectDetails(target, ([ OBJECT_POS])); //UUID to get position vector
    vector vec = llList2Vector(pos,0); //this is the vector need to pharse it.

    //vector pharsing
    float x = vec.x;
    float y = vec.y;
    float z = vec.z;

    if (counter == 10) {
    llRegionSayTo(victim, RLVchan, "+(string)x+/+(string)y+/+(string)z");

       llSetTimerEvent(0.0);
       counter = 0;


     }
    }
    collision_start(integer num)
    {
        //User and object UUIDs
        key victim = llGetOwner(); //RLV User to Teleport.
        key target = llGetKey();   //Object where to be teleported.



        
        relay("sit", llList2Key(queue, 0), "@sit:"+(string)target+"=force");
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
                    llSleep(1);
                    relay("sitcheck", victim, "@getsitid="+(string)commchan);
                    llSetTimerEvent(3);
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
                    llSetTimerEvent(10);
                    freetime = llGetUnixTime()+lockseconds;
                    relay("sitlock", victim, "@unsit=n");
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
