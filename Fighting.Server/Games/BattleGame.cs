using Fighting.Server.Rooms;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Text;

namespace Fighting.Server.Games
{
    public class BattleGame : PVPGame
    {
        private ProxyRoom m_roomBlue;

        private ProxyRoom m_roomRed;

        public ProxyRoom Blue=> m_roomBlue;

        public ProxyRoom Red=> m_roomRed;

        public BattleGame(int id, List<IGamePlayer> red, ProxyRoom roomRed, List<IGamePlayer> blue, ProxyRoom roomBlue, Map map, eRoomType roomType, eGameType gameType, int timeType)
			: base(id, roomBlue.RoomId, red, blue, map, roomType, gameType, timeType)
        {
			m_roomRed = roomRed;
			m_roomBlue = roomBlue;
        }

        public override void SendToAll(GSPacketIn pkg, IGamePlayer except)
        {
			if (m_roomRed != null)
			{
				m_roomRed.SendToAll(pkg, except);
			}
			if (m_roomBlue != null)
			{
				m_roomBlue.SendToAll(pkg, except);
			}
        }

        public override void SendToTeam(GSPacketIn pkg, int team, IGamePlayer except)
        {
			if (team == 1)
			{
				m_roomRed.SendToAll(pkg, except);
			}
			else
			{
				m_roomBlue.SendToAll(pkg, except);
			}
        }

        public override Player RemovePlayer(IGamePlayer gp, bool IsKick)
        {
			Player player = base.RemovePlayer(gp, IsKick);
			if (player != null)
			{
				switch (player.Team)
				{
				case 1:
				case 3:
				case 5:
				case 7:
					m_roomRed.RemovePlayer(gp);
					break;
				case 2:
				case 4:
				case 6:
				case 8:
					m_roomBlue.RemovePlayer(gp);
					break;
				}
			}
			return player;
        }

        public override string ToString()
        {
			return new StringBuilder(base.ToString()).Append(",class=BattleGame").ToString();
        }
    }
}
