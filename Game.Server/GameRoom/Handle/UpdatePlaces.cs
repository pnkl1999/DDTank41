using Game.Base.Packets;
using Game.Logic;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(10)]
	public class UpdatePlaces : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.CurrentRoom != null)
			{
				byte pos = packet.ReadByte();
				int place = packet.ReadInt();
				bool isOpened = packet.ReadBoolean();
				int placeView = packet.ReadInt();
				
				if (Player == Player.CurrentRoom.Host)
                {
					if (Player.CurrentRoom.RoomType != eRoomType.Freedom && pos >= 8)
					{
						return false;
					}
					RoomMgr.UpdateRoomPos(Player.CurrentRoom, pos, isOpened, place, placeView);
				}
				else
                {
					if (Player.CurrentRoom.RoomType != eRoomType.Freedom)
					{
						return false;
					}
					Player.CurrentRoom.SwitchToView(Player, placeView);
				}
			}
			return true;
        }
    }
}
