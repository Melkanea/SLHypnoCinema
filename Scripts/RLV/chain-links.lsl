key target; // UUID of the target object
integer RLVchan = -1812221819; //RLV Relay channel. do NOT change!

list pos;
//coordinate pharsing
vector vec;
float x;
float y;
float z;

string tele_target;
//===================================================================================//
debug(string info)
{
    //debugging messages

    llSay(DEBUG_CHANNEL, "Target: "+(string)target);
   // llSay(DEBUG_CHANNEL, "Target-Vector: "+(string)pos);          //spare for later
   // llSay(DEBUG_CHANNEL, "COUNTER: "+(string)vec);                //spare for later
    llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
   // llSay(DEBUG_CHANNEL, "Target-Key: "+(string)tele_target);     //spare for later
}
default
{
    state_entry()
    {
        llListen(RLVchan, "","","");


        target = llGetKey();   //Object where to be teleported.

        //User and object UUIDs
        list pos = llGetObjectDetails(target, ([ OBJECT_POS]));
        vector vec = llList2Vector(pos,0); //this is th vector
        //Vector Pharsing
        x = vec.x;
        y = vec.y;
        z = vec.z;

    }
    touch_start(integer say)
    {
            debug("");
            llSetTimerEvent(5);
            }

    timer()
    {
     //   llSay(RLVchan, (string)x);
      //  llSay(RLVchan, (string)y);
     //   llSay(RLVchan, (string)z);
     //   llSay(DEBUG_CHANNEL, (string)x);
     //   llSay(DEBUG_CHANNEL, (string)y);
     //   llSay(DEBUG_CHANNEL, (string)z);


        llRegionSay(RLVchan, "contact")
         //if it messes up
    }

}
