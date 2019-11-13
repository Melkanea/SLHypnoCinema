integer chan = 666; //testing use regular RLV channel


//==============Melkanea`s RLV Teleport Command Builder==========//
//recieves message from target destination object
//gets uuid, object details, position vector
//pharses and builds RLV @tpto
//forces user to teleport to target object
//================================================================//
//object details list
list pos;
//coordinate pharsing
vector vec;
float x;
float y;
float z;
//=====================DEBUGGIG===========================//
debug(string info)
{
    //debugging messages
    llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );

    //llSay(DEBUG_CHANNEL, "The RTD's UUID is " + (string)id);

    // llSay(DEBUG_CHANNEL, "Target: "+(string)target);
    // llSay(DEBUG_CHANNEL, "lKey: "+(string)lKey);          //spare for later
    // llSay(DEBUG_CHANNEL, "lName: "+(string)lName);                //spare for later
    // llSay(DEBUG_CHANNEL, "Target-Key: "+(string)tele_target);     //spare for later
}
//=========================================================//
default
{
    state_entry()
    {
        llListen(chan, "","","");

    }
    touch_start(integer say)
    {
        debug(""); //if it messes up
    llSay(0,"@tpto:" (string)x+"/"+(string)y+"/"+(string)z=force )
    }
    listen (integer channel, string name, key id, string msg)
    {

        if (msg == "contact")
        {
            id = llGetKey();
            list pos = llGetObjectDetails(id, ([ OBJECT_POS]));
            vector vec = llList2Vector(pos,0);
            //Vector Pharsing
            x = vec.x;
            y = vec.y;
            z = vec.z;
        }
    }

}
