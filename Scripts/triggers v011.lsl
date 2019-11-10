//==============================//
//  Melkaneas Grass Triggers    //
//==============================//

//====================OVERWIEV========================//
//Transparent pannel showing Triggers for the HypnoTV //
//====================================================//
integer face = 1;
integer MyChannel = 666;
string ImgURL = "https://i.imgur.com/58bENYv.png";
integer counter;

default
{
    state_entry()
    {
        llListen(MyChannel,"","","");
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
             PRIM_MEDIA_PERMS_INTERACT,PRIM_MEDIA_PERM_NONE,
             PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
    listen(integer channel, string name, key id, string message)
    {
        if (message == "boo!")
        {
        llSetTimerEvent(3.0);;
        }
        if (message == "baa!")
        {
        llSetTimerEvent(3.0);
        }
        if (message == "stand!")
        {
        llResetScript();
        }
    }
    timer()
        {
        ++counter;
    if (counter == 1)
    {
    string trigger1 =
        "<h3 style='color:de148a;font-size: 90pt'><br> &nbsp; SISSY &nbsp; &nbsp; BIMBO</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'> &nbsp; STUPID &nbsp; SLUT</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger1]);
    }
    if (counter == 2)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
    if (counter == 3)
    {
    string trigger2 =
        "<h3 style='color:de148a;font-size: 90pt'><br> &nbsp; CUNT &nbsp; &nbsp; FACE</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'>NOW &nbsp; &nbsp; WHORE</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger2]);

    }
    if (counter == 4)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
     if (counter == 5)
    {
    string trigger3 =
        "<h3 style='color:de148a;font-size: 90pt'><br> &nbsp; SLUT &nbsp; &nbsp; BRAT</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'>COCK &nbsp; SUCKER</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger3]);
    }
    if (counter == 6)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
    if (counter == 7)
    {
    string trigger4 =
        "<h3 style='color:de148a;font-size: 90pt'><br> &nbsp; SUCK &nbsp; &nbsp; COCK</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'> &nbsp; SISSY &nbsp; &nbsp; GASM</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger4]);

    }
    if (counter == 8)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
     if (counter == 9)
    {
    string trigger5 =
        "<h3 style='color:de148a;font-size: 90pt'><br>ANAL &nbsp; &nbsp; WHORE</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'> &nbsp; BITCH &nbsp; &nbsp; FUCK</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger5]);
    }
    if (counter == 10)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
    if (counter == 11)
    {
    string trigger6 =
        "<h3 style='color:de148a;font-size: 90pt'><br> &nbsp; BIMBO &nbsp; BAMBI</h3>
        <br><br><br><br><br><br><br><br><br><br><br><br>
        <h3 style='color:de148a;font-size: 90pt'> &nbsp; BARBIE &nbsp; DOLL</h3>
        ";
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, "data:text/html," + trigger6]);

    }
    if (counter == 12)
    {
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, ImgURL]);
    }
        if (counter == 13)
        {
        counter = 0;
        }
    }
} 
