using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int) GameCmdType.DISCONNECT)]
    public class Disconnect : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            player.CurRoom.RemovePlayer(player);
            //Console.WriteLine(GameCmdType.DISCONNECT);
            return true;
        }
    }
}