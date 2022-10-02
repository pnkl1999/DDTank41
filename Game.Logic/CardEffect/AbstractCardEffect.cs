using Game.Logic.CardEffect;
using SqlDataProvider.Data;
using System;

namespace Game.Logic.CardEffects
{
    public abstract class AbstractCardEffect
    {
        private eCardEffectType m_type;

        protected Living m_living;

        public Random rand;

        public bool IsTrigger;

        private CardBuffInfo m_buffInfo;

        public CardBuffInfo BuffInfo=> m_buffInfo;

        public eCardEffectType Type=> m_type;

        public int TypeValue=> (int)m_type;

        public AbstractCardEffect(eCardEffectType type, CardBuffInfo buff)
        {
			rand = new Random();
			m_type = type;
			m_buffInfo = buff;
        }

        public virtual bool Start(Living living)
        {
			m_living = living;
			if (m_living.CardEffectList.Add(this))
			{
				return true;
			}
			return false;
        }

        public virtual bool Stop()
        {
			if (m_living != null)
			{
				return m_living.CardEffectList.Remove(this);
			}
			return false;
        }

        public virtual bool Pause()
        {
			if (m_living != null)
			{
				return m_living.CardEffectList.Pause(this);
			}
			return false;
        }

        public virtual void OnAttached(Living living)
        {
        }

        public virtual void OnRemoved(Living living)
        {
        }

        public virtual void OnPaused(Living living)
        {
        }
    }
}
