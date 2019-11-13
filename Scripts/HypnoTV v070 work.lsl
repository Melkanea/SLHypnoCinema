//===========================//
//  Melkaneas HypnoTV      //
//===========================//

//=========OVERVIEW==========//
//notecard reader to list
//set URL from list as Prim Media URL,
//
//restart at end of list
//Recieves and sends triggers on channel
//===========================//
//Melkaneas Brandyphilias Logo
string ImgURL = "https://i.imgur.com/vcQicbO.png";
//default Prim settings
vector color = <1.0,1.0,1.0>;
vector color1 = <0.0,0.0,0.0>;
integer face1 = ALL_SIDES;
integer face = 1;
integer counter = 0;
//URL set variables
string url;
//TIMER set for testing purposes increase to enjoy the spirals
float time = 10.0;
//SCRIPT COMUNICATION
integer MyChannel = 666;

// Generic Multi Notecard reader by Brangus Weir
// http://wiki.secondlife.com/wiki/LlGetNotecardLine
// Shortened by Melkanea to read only one card
list gOneCard;                          //the list the notecard get stored in
string gsCardOneName = "HypnoTVlist";   //NOTECARD NAME
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
//defines the current URL based on counter
setURLtoList(string url)
{
    string url = llList2String(gOneCard, counter);
    llOwnerSay((string)counter + " " + (string)url);
    llSetPrimMediaParams(face,
        [PRIM_MEDIA_CURRENT_URL, url ] );

}

//To get the perfect camera angle to watch the screen
setCamFocus(string cam)
{


    key uuid = llGetLinkKey(2);
    list focus = llGetObjectDetails(uuid, ([ OBJECT_POS]));
    vector foc = llList2Vector(focus,0);
    rotation focrot = llGetRootRotation();

    vector endfocus = foc * focrot ;

    key uuid1 = llGetLinkKey(3);
    list position = llGetObjectDetails(uuid1, ([ OBJECT_POS]));
    vector pos = llList2Vector(position,0);
    rotation posrot = llGetRootRotation();

    vector margin = <0,0,0>;
    vector endpos = (pos+margin) * posrot ;



    llSetCameraParams( [CAMERA_POSITION, endpos,
                        CAMERA_POSITION_LOCKED,TRUE,
                        CAMERA_FOCUS, endfocus ,
                        CAMERA_FOCUS_LOCKED, TRUE ,

                        CAMERA_ACTIVE,1 ]);

 }

    default
        {
            changed(integer change)
        {
            // reset script when the owner or the inventory changed
            if (change & (CHANGED_OWNER | CHANGED_INVENTORY))
                llResetScript();
        }
            state_entry()
            {

         //       llSetColor(color1, face1);

               llListen(MyChannel,"","","");
                llSetPrimMediaParams(face,  //sets default prim media, disable browser menu
                     [ PRIM_MEDIA_CURRENT_URL, ImgURL,
                      PRIM_MEDIA_PERMS_INTERACT,PRIM_MEDIA_PERM_NONE,
                      PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE ] );

                }
                listen(integer channel, string name, key id, string message)
                {
                if (message == "sit!")
                {
                    llOwnerSay("Welcome to Melkaneas HypnoCinema");
                    state hypno;
                }

            }
        }
state hypno
{
        state_entry()
        {

            initialize("");  //Notecard reader Init
            llSleep(1.0);
            llRequestPermissions(llGetOwner(),
            PERMISSION_CONTROL_CAMERA | 0);
            setCamFocus("");
            llOwnerSay("@setcam_unlock=n");
            llListen(MyChannel,"","","");
            llOwnerSay("HYPNO STATE");

        }

        listen(integer channel, string name, key id, string message)
        {

            if (message == "boo!")
                {
            integer lenght = llGetListLength(gOneCard);
            if (counter == lenght)
                { counter = 1;
                llOwnerSay((string)lenght + " " + "Links Present");
                }
            if (counter != lenght)
                {
                ++counter;
                setURLtoList("");

                }

            }
            llRegionSay(MyChannel,"buu!");
            if (message == "baa!")
            {
            integer lenght = llGetListLength(gOneCard);
            if (counter == -lenght)
                { counter = -1;
                llOwnerSay((string)lenght + " " + "Links Present");
                 }
            if (counter != -lenght)
                {
                --counter;
                setURLtoList("");

                }

            llRegionSay(MyChannel,"bii!");
            if (message == "stand!")
            {
            llOwnerSay("Thank You Come Again!");
            llResetScript();
            }
    }
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
}
