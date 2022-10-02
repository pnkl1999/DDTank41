using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(5)]
	public class RemovePlayer : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.CurrentRoom != null)
			{
				RoomMgr.ExitRoom(Player.CurrentRoom, Player);
			}
			return true;
        }
    }
}
