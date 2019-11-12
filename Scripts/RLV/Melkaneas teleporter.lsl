

key     target = "00000000-0000-0000-0000-000000000000"; // UUID of the target object the victim will sit on. Must contain any sit script
integer sitscan = TRUE; // try to detect and lock people who sit manually (TRUE/FALSE)
// do not set sleeptime to 0!
integer ts;
list typeList;
list pos;
integer type;

vector vec;
float x;
float y;
float z;
//=======================================================================================================================//

key     victim = NULL_KEY; //current victim
integer freetime; //end of timer as unix timestamp
integer RLVchan = -1812221819; //RLV Relay channel. do NOT change!


debug(string txt)
{
    // uncomment the next line to see debugging messages
    llSay(DEBUG_CHANNEL, "AGENT-INFO: "+(string)typeList);
    llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
    llSay(DEBUG_CHANNEL, "Target-Key: "+(string)target);
    llSay(DEBUG_CHANNEL, "Owner-Key: "+(string)victim);
    llSay(DEBUG_CHANNEL, "Target-Vector: "+(string)pos);
    llSay(DEBUG_CHANNEL, "Counter: "+(string)ts);
}

relay(string type,key victim,string command) //send command to relay
{
    llRegionSayTo(victim, RLVchan, type+","+(string)victim+","+command);
}


//===================Melkaneas Triggered Teleporter=========================//
default
{
    state_entry()
    {


            llListen(RLVchan, "", "", "");
            llVolumeDetect(TRUE);


    }

    on_rez(integer num)
    {
        llResetScript();
    }
    touch_start(integer info)
    {
        debug("");
        ++ts;
        if (ts == 10)
        {
        llSensor("", "", ACTIVE | PASSIVE | AGENT, 60.0, PI); // activates the sensor.

        llSetTimerEvent(0.0);
        ts = 0;
        }
    }
    touch_end(integer info)
    {


        list pos = llGetObjectDetails(target, ([ OBJECT_POS])); //UUID to get position vector
        vector vec = llList2Vector(pos,0); //this is the vector need to pharse it.

        //vector pharsing
        float x = vec.x;
        float y = vec.y;
        float z = vec.z;
        }
    collision_start(integer num)
    {
        //User and object UUIDs
        key victim = llGetOwner(); //RLV User to Teleport.
        key target = llGetKey();   //Object where to be teleported.

    }
    collision_end(integer restrict)
    {
    llSensor("", "", ACTIVE | PASSIVE | AGENT, 20.0, PI); // activates the sensor.

    }

    listen(integer RLVchan, string name, key victim, string message)
    {
        if (type & AGENT)
        {
        relay("sit", "", "@sit:"+(string)target+"=force");
        }
        if (type & PASSIVE)
        {
        llSetTimerEvent(1.0);
        }
    }

    timer()
    {
        ++time;
        if(time == 5)
        llRegionSayTo(victim, RLVchan, "@tpto:+(string)x+/+(string)y+/+(string)z=force");


    }

sensor(integer numberDetected)
    {
        integer i;
        while(i < numberDetected)
        {
            integer type = llDetectedType(i);
            string message;
            message += (string)i + ", " + llDetectedName(i) + ", ";

            if (type & AGENT)
            {
                typeList += "AGENT";
            }
            if (type & ACTIVE)
            {
                typeList += "ACTIVE";
            }
            if (type & PASSIVE)
            {
                typeList += "PASSIVE";
            }
            if (type & SCRIPTED)
            {
                typeList += "SCRIPTED";
            }
            message += llDumpList2String(typeList, "|");
            llWhisper(0, message);
            ++i;
        }
    }

    no_sensor()
    {
        // This is impossible if range = 20.0 and you are standing within 10m!
        llWhisper(0, "Nothing is near me at present.");
    }
}
