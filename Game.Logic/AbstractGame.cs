using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System.Threading;

namespace Game.Logic
{
    public class AbstractGame
    {
        private int int_0;

        protected eRoomType m_roomType;

        protected eGameType m_gameType;

        protected eMapType m_mapType;

        protected int m_timeType;

        private int int_1;

        public int Id=> int_0;

        public eRoomType RoomType=> m_roomType;

        public eGameType GameType=> m_gameType;

        public int TimeType=> m_timeType;

        public event GameEventHandle GameStarted;

        public event GameEventHandle GameStopped;

        public bool IsPVP()
        {
			if (m_roomType != 0 && m_roomType != eRoomType.Freedom)
			{
				if (m_roomType != eRoomType.EliteGameScore)
				{
					return m_roomType == eRoomType.EliteGameChampion;
				}
				return true;
			}
			return true;
        }

        public bool IsMatchOrFreedom()
        {
			if (m_roomType == eRoomType.Match || m_roomType == eRoomType.Freedom)
			{
				return true;
			}
			return false;
        }

        public AbstractGame(int id, eRoomType roomType, eGameType gameType, int timeType)
        {
			int_0 = id;
			m_roomType = roomType;
			m_gameType = gameType;
			m_timeType = timeType;
			switch (m_roomType)
			{
			case eRoomType.Match:
			case eRoomType.EliteGameScore:
			case eRoomType.EliteGameChampion:
				m_mapType = eMapType.PairUp;
				break;
			case eRoomType.Freedom:
				m_mapType = eMapType.Normal;
				break;
			default:
				m_mapType = eMapType.Normal;
				break;
			}
        }

        public virtual void Start()
        {
			OnGameStarted();
        }

        public virtual void Stop()
        {
			OnGameStopped();
        }
        public virtual void StopTimeOut()
        {
			OnGameStopped();
        }

        public virtual bool CanAddPlayer()
        {
			return false;
        }

        public virtual void Pause(int time)
        {
        }

        public virtual void Resume()
        {
        }

        public virtual void MissionStart(IGamePlayer host)
        {
        }

        public virtual void ProcessData(GSPacketIn pkg)
        {
        }

        public virtual Player AddPlayer(IGamePlayer player)
        {
			return null;
        }

        public virtual Player RemovePlayer(IGamePlayer player, bool IsKick)
        {
			return null;
        }

        public void Dispose()
        {
			if (Interlocked.Exchange(ref int_1, 1) == 0)
			{
				Dispose(disposing: true);
			}
        }

        protected virtual void Dispose(bool disposing)
        {
        }

        protected void OnGameStarted()
        {
			if (this.GameStarted != null)
			{
				this.GameStarted(this);
			}
        }

        protected void OnGameStopped()
        {
			if (this.GameStopped != null)
			{
				this.GameStopped(this);
			}
        }
    }
}
