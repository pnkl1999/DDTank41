using Game.Base.Packets;
using Game.Logic;
using log4net;
using System.Collections.Generic;
using System.Reflection;

namespace Fighting.Server.Rooms
{
    public class ProxyRoom
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private List<IGamePlayer> m_players;

        private int m_roomId;

        private int m_orientRoomId;

        private ServerClient m_client;

        public bool PickUpNPC;

        public int PickUpNPCTotal;

        public int PickUpCount;

        public int selfId;

        public bool startWithNpc;

        private int m_npcId;

        private bool m_isAutoBot;

        private bool m_isSmartBot;

        private int m_EliteGameType;

        private int m_ZoneID;

        public bool IsPlaying;

        public eGameType GameType;

        public eRoomType RoomType;

        public bool IsCrossZone;

        public int GuildId;

        public string GuildName;

        public int AvgLevel;

        public int FightPower;

        private BaseGame m_game;

        public bool HaveNewbie { get; set; }

        public int PickUpRate { get; set; }

        public int PickUpRateLevel { get; set; }

        public int RoomId=> m_roomId;

        public ServerClient Client=> m_client;

        public int NpcId
        {
			get
			{
				return m_npcId;
			}
			set
			{
				m_npcId = value;
			}
        }

        public bool isAutoBot=> m_isAutoBot;

        public bool isBotSnape
        {
			get
			{
				return m_isSmartBot;
			}
			set
			{
				m_isSmartBot = value;
			}
        }

        public int EliteGameType=> m_EliteGameType;

        public int ZoneId=> m_ZoneID;

        public int PlayerCount = 0;

        public BaseGame Game=> m_game;

        public ProxyRoom(int roomId, int orientRoomId, int zoneID, IGamePlayer[] players, ServerClient client, int npcId, bool pickUpWithNPC, bool isBot, bool isSmartBot)
        {
			m_npcId = npcId;
			m_roomId = roomId;
			m_orientRoomId = orientRoomId;
			m_players = new List<IGamePlayer>();
            m_players.AddRange(players);
			foreach (IGamePlayer p in players)
            {
                if (!p.IsViewer)
                {
                    PlayerCount++;
                }
            }
			m_client = client;
			PickUpNPC = pickUpWithNPC;
			m_isAutoBot = isBot;
			m_isSmartBot = isSmartBot;
			PickUpCount = 0;
			HaveNewbie = false;
			if (GameType == eGameType.EliteGameScore)
			{
				GetEliteGameType();
			}
			PickUpRate = 5;
			PickUpRateLevel = 1;
			PickUpNPCTotal = 0;
			m_ZoneID = zoneID;
        }

        private void GetEliteGameType()
        {
			if (m_players[0].PlayerCharacter.Grade <= 40)
			{
				m_EliteGameType = 1;
			}
			else
			{
				m_EliteGameType = 2;
			}
        }

        public void SendToAll(GSPacketIn pkg)
        {
			SendToAll(pkg, null);
        }

        public void SendToAll(GSPacketIn pkg, IGamePlayer except)
        {
			m_client.SendToRoom(m_orientRoomId, pkg, except);
        }

        public List<IGamePlayer> GetPlayers()
        {
			List<IGamePlayer> list = new List<IGamePlayer>();
			lock (m_players)
			{
				list.AddRange(m_players);
			}
			return list;
        }

        public bool RemovePlayer(IGamePlayer player)
        {
			bool flag = false;
			lock (m_players)
			{
				if (m_players.Remove(player))
				{
					flag = true;
				}
			}
			if (PlayerCount == 0)
			{
				ProxyRoomMgr.RemoveRoom(this);
			}
			return flag;
        }

        public void StartGame(BaseGame game)
        {
			IsPlaying = true;
			m_game = game;
			game.GameStopped += method_1;
			m_client.SendStartGame(m_orientRoomId, game);
        }

        private void method_1(AbstractGame abstractGame_0)
        {
			m_game.GameStopped -= method_1;
			IsPlaying = false;
			m_client.SendStopGame(m_orientRoomId, m_game.Id);
        }

        public void Dispose()
        {
			m_client.RemoveRoom(m_orientRoomId, this);
        }

        public override string ToString()
        {
			return $"RoomId:{m_roomId} OriendId:{m_orientRoomId} PlayerCount:{m_players.Count},IsPlaying:{IsPlaying},GuildId:{GuildId},GuildName:{GuildName}";
        }
    }
}
