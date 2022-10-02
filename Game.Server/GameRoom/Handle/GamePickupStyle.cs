using Game.Base.Packets;
using Game.Logic;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(12)]
	public class GamePickupStyle : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.CurrentRoom != null)
			{
				int num = packet.ReadInt();
				Player.CurrentRoom.GameStyle = num;
				switch (num)
				{
				case 0:
					Player.CurrentRoom.GameType = eGameType.Free;
					break;
				case 1:
					Player.CurrentRoom.GameType = eGameType.Guild;
					break;
				}
				GSPacketIn pkg = Player.Out.SendRoomType(Player, Player.CurrentRoom);
				Player.CurrentRoom.SendToAll(pkg, Player);
			}
			return true;
        }
    }
}
