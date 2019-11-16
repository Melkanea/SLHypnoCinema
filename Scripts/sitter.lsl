integer MyChannel = 666;

rotation localrot;
vector localpos;

default
{
    state_entry()
    {
        vector adjust = <-0.35,-3.2,2.75>;
        rotation adjust1 = <0.00000, 0.00000, 1.00000, -0.50000>;

        list params = llGetLinkPrimitiveParams( 2,
        [ PRIM_POS_LOCAL , PRIM_ROT_LOCAL ]
        );
        vector localpos = llList2Vector(params,0);
        rotation localrot = llList2Rot(params,1);

        vector finalpos = localpos+adjust;
        rotation finalrot = localrot+adjust1;

        llSitTarget(finalpos,finalrot);

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
                llOwnerSay("stand");
            }
        }
    }
    touch_start(integer kore)
    {


        vector localpos = llGetLocalPos();
        rotation localrot = llGetLocalRot();
        llSay(0, (string)localpos);
        llSay(0, (string)localrot);
        }
}
