using Game.Base.Packets;
using Game.Server.Rooms;
using System.Collections.Generic;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(9)]
	public class RoomListUpdate : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int num3 = 10000;
			int num4 = 1011;
			if (num == 2 && num2 == -2)
			{
				num3 = packet.ReadInt();
				num4 = packet.ReadInt();
			}
			List<BaseRoom> list = new List<BaseRoom>();
			switch (num)
			{
			case 1:
				list.AddRange(RoomMgr.GetAllMatchRooms());
				break;
			case 2:
				list.AddRange(RoomMgr.GetAllPveRooms());
				break;
			}
			Player.Out.SendUpdateRoomList(list);
			return true;
        }
    }
}
