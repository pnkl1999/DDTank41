using Game.Logic;
using Game.Logic.Phy.Maps;
using Game.Server.Rooms;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.Games
{
    public class BattleGame : PVPGame
    {
        private BaseRoom m_roomRed;

        private BaseRoom m_roomBlue;

        public BaseRoom Red=> m_roomRed;

        public BaseRoom Blue=> m_roomBlue;

        public BattleGame(int id, List<IGamePlayer> red, BaseRoom roomRed, List<IGamePlayer> blue, BaseRoom roomBlue, Map map, eRoomType roomType, eGameType gameType, int timeType)
			: base(id, roomBlue.RoomId, red, blue, map, roomType, gameType, timeType)
        {
			m_roomRed = roomRed;
			m_roomBlue = roomBlue;
        }

        public override string ToString()
        {
			return new StringBuilder(base.ToString()).Append(",class=BattleGame").ToString();
        }
    }
}
