integer MyChannel = 666;

integer localrot;
integer localpos;

default
{
    state_entry()
    {



        llSitTarget( <0.00000, 3.28426, 2.40625> , <0.00000, 0.00000, -1.00000, 0.00000> );

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
        list local = llGetPrimitiveParams( [ PRIM_POS_LOCAL  ,  PRIM_POSITION,  PRIM_ROT_LOCAL , PRIM_ROTATION ] );


        integer localrot = llList2Rot(local, 3);
        integer localpos = llList2Vector(local, 4);
        llSay(0, (string)localpos);
        llSay(0, (string)localrot);
        }
}
