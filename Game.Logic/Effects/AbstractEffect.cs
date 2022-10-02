using System;
using Game.Logic.Phy.Object;

namespace Game.Logic.Effects
{
    public abstract class AbstractEffect
    {
        private eEffectType m_type;
        protected Living m_living;
        protected static Random rand;
        public bool IsTrigger;

        public AbstractEffect(eEffectType type)
        {
            rand = new Random();
            m_type = type;
        }

        public eEffectType Type
        {
            get { return m_type; }
        }

        public int TypeValue
        {
            get { return (int)m_type; }
        }

        public virtual bool Start(Living living)
        {
            m_living = living;
            if (m_living.EffectList.Add(this))
            {
                return true;
            }

            return false;
        }

        public virtual bool Stop()
        {
            if (m_living != null)
            {
                return m_living.EffectList.Remove(this);
            }

            return false;
        }

        public virtual void OnAttached(Living living)
        {
        }

        public virtual void OnRemoved(Living living)
        {
        }
    }
}