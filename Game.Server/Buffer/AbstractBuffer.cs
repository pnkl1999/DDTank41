using SqlDataProvider.Data;
using System;

namespace Game.Server.Buffer
{
    public class AbstractBuffer
    {
        protected BufferInfo m_info;

        protected GamePlayer m_player;

        public BufferInfo Info=> m_info;

        public AbstractBuffer(BufferInfo info)
        {
			m_info = info;
        }

        public bool Check()
        {
			return DateTime.Compare(m_info.BeginDate.AddMinutes(m_info.ValidDate), DateTime.Now) >= 0;
        }

        public virtual void Restore(GamePlayer player)
        {
			Start(player);
        }

        public virtual void Start(GamePlayer player)
        {
			m_info.UserID = player.PlayerId;
			m_info.IsExist = true;
			m_player = player;
			m_player.BufferList.AddBuffer(this);
        }

        public virtual void Stop()
        {
			m_info.IsExist = false;
			m_player.BufferList.RemoveBuffer(this);
			m_player = null;
        }

        public bool IsPayBuff()
        {
			return IsPayBuff(m_info.Type);
        }

        public bool IsPayBuff(int type)
        {
			if ((uint)(type - 50) <= 2u || (uint)(type - 70) <= 3u)
			{
				return true;
			}
			return false;
        }
    }
}
