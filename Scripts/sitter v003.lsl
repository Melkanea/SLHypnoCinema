integer MyChannel = 666;

default
{
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key av_sit = llAvatarOnSitTarget();
            if (av_sit)
            {
               llRegionSay(MyChannel,"sit!");
//test               llOwnerSay("sit");
            }
            if (av_sit == NULL_KEY)
            {
                llRegionSay(MyChannel,"stand!");
//test                llOwnerSay("stand");
            }
        }
    }
}
 
