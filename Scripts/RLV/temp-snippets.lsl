//==============Melkanea`s RLV Teleport Destination==========//
//Target Destination of the User
//


integer chan = 666; //testing use regular RLV channel

//===================================================================================//
debug(string info)
{
    //debugging messages

    //llSay(DEBUG_CHANNEL, "Target: "+(string)target);
   // llSay(DEBUG_CHANNEL, "Target-Vector: "+(string)pos);          //spare for later
   // llSay(DEBUG_CHANNEL, "COUNTER: "+(string)vec);                //spare for later
    //llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
   // llSay(DEBUG_CHANNEL, "Target-Key: "+(string)tele_target);     //spare for later
}
default
{
    state_entry()
    {
    llListen(chan, "","",""); //use proper channel name
    }
    touch_start(integer say)
    {
    debug("");
    llRegionSay(chan, "contact");
    }
}
