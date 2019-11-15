integer MyChannel = 666;

integer localrot;
integer localpos;

default
{
    state_entry()
    {



        llSitTarget( <240.18490, 55.37746, 1999.70100> , <0.00000, 0.00000, -1.00000, 0.00000> );

       // llSitTarget(localpos , localrot );
        }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key av_sit = llAvatarOnSitTarget();
            if (av_sit)
            {
               llRegionSay(MyChannel,"sit!");
              llOwnerSay("sit");
            }
            if (av_sit == NULL_KEY)
            {
                llRegionSay(MyChannel,"stand!");
//test                llOwnerSay("stand");
            }
        }
    }
    touch_start(integer kore)
    {  


        vector localrot = llGetLocalPos();
        rotation localpos = llGetLocalRot();
        llSay(0, (string)localpos);
        llSay(0, (string)localrot);
        }
}
