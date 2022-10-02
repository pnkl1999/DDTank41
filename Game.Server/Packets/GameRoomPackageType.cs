namespace Game.Server.Packets
{
    public enum GameRoomPackageType
    {
        GAME_ROOM_CREATE = 0,
        GAME_ROOM_LOGIN = 1,
        GAME_ROOM_SETUP_CHANGE = 2,
        GAME_ROOM_KICK = 3,
        GAME_ROOM_ADDPLAYER = 4,
        GAME_ROOM_REMOVEPLAYER = 5,
        GAME_TEAM = 6,
        GAME_START = 7,
        ROOMLIST_UPDATE = 9,
        GAME_ROOM_UPDATE_PLACE = 10,
        GAME_PICKUP_CANCEL = 11,
        GAME_PICKUP_STYLE = 12,
        GAME_PICKUP_WAIT = 13,
        ROOM_PASS = 14,
        GAME_PLAYER_STATE_CHANGE = 15,
        GAME_ROOM_FULL = 17,
        PASSED_WARRIORSARENA_10 = 34,
        No_WARRIORSARENA_TICKET = 35,
        LAST_MISSION_FOR_WARRIORSARENA = 33,
        SINGLE_ROOM_BEGIN = 18,
        FAST_INVITE_CALL = 19,
        GAME_ENERGY_NOT_ENOUGH = 20,
    }

}
