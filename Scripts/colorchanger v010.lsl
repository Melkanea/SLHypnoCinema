//===========================//
//  Melkaneas Color Changer  //
//===========================//

//=========OVERVIEW==========//
//Changes Color on Touch based on a notecard vector list
//===========================//
//default Prim settings
vector color1;
integer face = ALL_SIDES;
integer counter = -1 ;
//TIMER set for testing purposes increase to enjoy the spirals
float time = 10.0;
//SCRIPT COMUNICATION
integer MyChannel = 666;

// Generic Multi Notecard reader by Brangus Weir
// http://wiki.secondlife.com/wiki/LlGetNotecardLine
// Shortened by Melkanea to read only one card
list gOneCard;                          //the list the notecard get stored in
string gsCardOneName = "COLORS";   //NOTECARD NAME
string g_sNoteCardName;
list g_lTempLines;
integer g_iLine;
key g_kQuery;

initialize(string _action)
{
    if (_action == "")
        {
        loadNoteCard(gsCardOneName);
        }
    else if (_action == "finish")
        {
        integer len = llGetListLength(gOneCard);
        }
}
loadNoteCard(string _notecard )
{
    g_lTempLines = [];
    g_sNoteCardName = _notecard;
    g_iLine = 0;
    g_kQuery = llGetNotecardLine(g_sNoteCardName, g_iLine);
}
notecardFinished(string _notecard)
{
    if (_notecard == gsCardOneName)
    {
        gOneCard = g_lTempLines;
        initialize("finish");
    }
}
//end of notecard reader

//Melkaneas Magic
//Set Prim media to string read from list feed by notecard
//lists start at 0, counter starts at 1 to avoid default texture to be set at counter 0 [seems dumb but it works]
//defines the current color based on counter
setColortoList(string color)
{
    color1 = (vector)llList2String(gOneCard, counter);
//    llOwnerSay((string)counter + " " + (string)color1); //testing purposes only remove on final version
    if (counter != 0)
        {
        integer lenght = llGetListLength(gOneCard); //How can i only check it once? [WHELP!]
            if (counter == lenght)
            {
                counter = 0;
            }
            if (counter == -lenght)
            {
                counter = 0;
            }
        }
}
default
{
    state_entry()
    {
//test        llOwnerSay("Welcome to Melkaneas Color Changer");
        initialize("");  //Notecard reader Init
        llListen(MyChannel,"","","");
        llSetPrimitiveParams(
                [PRIM_GLOW, face, .1 ] );
        setColortoList("");
    }
    dataserver(key _query_id, string _data) //dataserver part of notecard reader
    {
        if (_query_id == g_kQuery)
            {
            if (_data != EOF)
                {
                g_lTempLines += _data;
                ++g_iLine;
                g_kQuery = llGetNotecardLine(g_sNoteCardName, g_iLine);
                }
            else
                {
                notecardFinished(g_sNoteCardName);
                }
            }
    }
    listen(integer channel, string name, key id, string message)
    {
    if (message == "buu!")
        {
//test        llSay(0,"Eeep!  Someone said "+message+" and scared me.");
        ++counter;
        setColortoList("");
//test        llOwnerSay("buu!" + (string)color1);
        llSetColor(color1, face);
        llTargetOmega(<0,0,.2>,PI,1.0);
        }

    if (message == "bii!")
        {
//test        llSay(0,"Ooop!  Someone said "+message+" and did not scare me.");
        --counter;
        setColortoList("");
//test        llOwnerSay("buu!" + (string)color1);
        llSetColor(color1, face);
        llTargetOmega(<0,0,.2>,-PI,1.0);
        }
    if (message == "stand!")
        {
        setColortoList("");
        llSetColor(color1, face);
        llTargetOmega(<0,0,.0>,PI,1.0);
        }
    }
}
