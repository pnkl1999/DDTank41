namespace Game.Server.Packets
{
    public enum eLittleGamePackageInType
    {
        WORLD_LIST = 1,
        START_LOAD = 2,
        GAME_START = 3,
        SETCLOCK = 5,
        PONG = 6,
        NET_DELAY = 7,
        ADD_SPRITE = 0x10,
        REMOVE_SPRITE = 17,
        KICK_PLAYE = 18,
        MOVE = 0x20,
        UPDATE_POS = 33,
        GETSCORE = 49,
        ADD_OBJECT = 0x40,
        REMOVE_OBJECT = 65,
        INVOKE_OBJECT = 66,
        UPDATELIVINGSPROPERTY = 80,
        DoMovie = 81,
        DoAction = 96
    }
}
