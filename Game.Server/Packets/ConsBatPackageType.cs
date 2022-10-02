namespace Game.Server.Packets
{
    public enum ConsBatPackageType
    {
        START_OR_CLOSE = 1,
        ENTER_SELF_INFO = 2,
        ADD_PLAYER = 3,
        PLAYER_MOVE = 4,
        DELETE_PLAYER = 5,
        CHALLENGE = 6,
        PLAYER_STATUS = 7,
        SPLIT_MERGE = 8,
        UPDATE_SCENE_INFO = 9,
        UPDATE_SCORE = 16,
        CONSUME = 17,
        BROADCAST = 19,
        CONFIRM_ENTER = 21,
    }
}
