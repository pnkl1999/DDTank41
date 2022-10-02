using Game.Base.Packets;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute((byte)GameRoomPackageType.GAME_TEAM)]
	public class GameChangeTeam : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.CurrentRoom != null && Player.CurrentRoom.RoomType != 0)
			{
				RoomMgr.SwitchTeam(Player);
			}
			return true;
        }
    }
}
