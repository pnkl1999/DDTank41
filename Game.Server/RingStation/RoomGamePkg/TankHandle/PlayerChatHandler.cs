using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int)GameCmdType.CHAT_MSG)]
    public class PlayerChatHandler : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            return true;
        }
    }
}
