using System;
using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int) GameCmdType.GAME_ROOM)]
    public class GameRoom : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            byte code = packet.ReadByte();
            switch (code)
            {
                case 5:
                    RingStationMgr.RemovePlayer(player.ID);
                    break;
                default:
                    Console.WriteLine("RingStation.RoomGamePkg.TankHandle.GameRoom: {0}", code);
                    break;
            }

            return true;
        }
    }
}