using Game.Base.Packets;
using Game.Server.RingStation.Action;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    [GameCommandAttbute((int)GameCmdType.GAME_CMD)]
    public class GamePacket : IGameCommandHandler
    {
        public bool HandleCommand(RingStationRoomLogicProcessor process, VirtualGamePlayer player, GSPacketIn packet)
        {
            byte b = packet.ReadByte();
            //     Console.WriteLine("Packet :" + b);
            switch (b)
            {
                case 6:
                    player.NextTurn(packet);
                    break;
                case 100:
                    player.CurRoom.RemovePlayer(player);
                    break;
                case 101:
                    //player.SendCreateGame(packet);
                    break;
                case 103:
                    player.SendLoadingComplete(100);
                    //if (player.CurRoom.IsAutoBot)
                    //{
                    //    foreach (VirtualGamePlayer p in player.CurRoom.GetPlayers())
                    //    {
                    //        p.AddAction(new PlayerLoadingAction(20, 500));
                    //    }
                    //}
                    break;
                default:
                    break;
            }

            return true;
        }
    }
}