/* Stock's */ 
stock ConvertDays(dias)
{

    new
        valueday = 86400*dias,
        daysconvert,
        gtime = gettime()
    ;

    #emit LOAD.S.PRI gtime
    #emit LOAD.S.ALT valueday
    #emit ADD
    #emit STOR.S.PRI daysconvert

    return daysconvert;
}

stock convertNumber(n)
{
    new dia, hr, mn, seg, resto;

    resto = n;
    seg = resto % 60;
    resto /= 60;
    mn = resto % 60;
    resto /= 60;
    hr = resto % 24;
    resto /= 24;
    dia = resto;

    new str[50];
    format(str, sizeof(str), "%ddias, %02dh %02dm %02ds", dia, hr, mn, seg);
    return str;
}

stock GetName(playerid)
{
    new name[24];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}