key target; // UUID of the target object
integer chan = 666; //RLV Relay channel. do NOT change!

list pos;
//coordinate pharsing
vector vec;
float x;
float y;
float z;
//Name2Key variables
key lKey;
string lName;
list lParts;

//===================================================================================//
debug(string info)
{
    //debugging messages

    //llSay(DEBUG_CHANNEL, "Target: "+(string)target);
     llSay(DEBUG_CHANNEL, "lKey: "+(string)lKey);          //spare for later
    llSay(DEBUG_CHANNEL, "lName: "+(string)lName);                //spare for later
    //llSay(DEBUG_CHANNEL, "TELEPORT: "+(string)x+"/"+(string)y+"/"+(string)z );
   // llSay(DEBUG_CHANNEL, "Target-Key: "+(string)tele_target);     //spare for later
}
default
{
    state_entry()
    {
        llListen(chan, "","","");

//===HTML RESPONSE == KEY && NAME ================================//
integer cmdName2Key = 19790;
integer cmdName2KeyResponse = 19791;

default {
    state_entry() {
        llMessageLinked( LINK_SET, cmdName2Key, "Test Name", NULL_KEY );
    }

    link_message( integer inFromPrim, integer inCommand, string inKeyData, key inReturnedKey ) {
        if( inCommand == cmdName2KeyResponse ) {
            list lParts = llParseString2List( inKeyData, [":"], [] );
            string lName = llList2String( lParts, 0 );
            key lKey = (key)llList2String(lParts, 1 );
        }
    }
}

    //    target = llGetKey();   //Object where to be teleported.

        //User and object UUIDs
    //    list pos = llGetObjectDetails(target, ([ OBJECT_POS]));
    //    vector vec = llList2Vector(pos,0); //this is th vector
        //Vector Pharsing
    //    x = vec.x;
    //    y = vec.y;
    //    z = vec.z;

    }
    touch_start(integer say)
    {

    debug(""); //if it messes up
    }




}
