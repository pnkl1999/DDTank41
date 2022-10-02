using Game.Logic.Phy.Object;
using log4net;
using System;
using System.Collections;
using System.Reflection;

namespace Game.Logic.Effects
{
    public class EffectList
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected volatile sbyte m_changesCount;

        protected ArrayList m_effects;

        protected int m_immunity;

        protected readonly Living m_owner;

        public ArrayList List=> m_effects;

        public EffectList(Living owner, int immunity)
        {
			m_owner = owner;
			m_effects = new ArrayList(3);
			m_immunity = immunity;
        }

        public virtual bool Add(AbstractEffect effect)
        {
			if (CanAddEffect(effect.TypeValue))
			{
				lock (m_effects)
				{
					m_effects.Add(effect);
				}
				effect.OnAttached(m_owner);
				OnEffectsChanged(effect);
				return true;
			}
			if (effect.TypeValue == 9 && m_owner is SimpleBoss)
			{
				m_owner.State = 0;
			}
			return false;
        }

        public void BeginChanges()
        {
			m_changesCount++;
        }

        public bool CanAddEffect(int id)
        {
			if (id <= 40 && id >= 0)
			{
				return ((1 << id - 1) & m_immunity) == 0;
			}
			return true;
        }

        public virtual void CommitChanges()
        {
			if (--m_changesCount < 0)
			{
				if (log.IsWarnEnabled)
				{
					log.Warn("changes count is less than zero, forgot BeginChanges()?\n" + Environment.StackTrace);
				}
				m_changesCount = 0;
			}
			if (m_changesCount == 0)
			{
				UpdateChangedEffects();
			}
        }

        public virtual IList GetAllOfType(Type effectType)
        {
			ArrayList list = new ArrayList();
			lock (m_effects)
			{
				foreach (AbstractEffect effect in m_effects)
				{
					if (effect.GetType().Equals(effectType))
					{
						list.Add(effect);
					}
				}
				return list;
			}
        }

        public virtual AbstractEffect GetOfType(eEffectType effectType)
        {
			lock (m_effects)
			{
				foreach (AbstractEffect effect in m_effects)
				{
					if (effect.Type == effectType)
					{
						return effect;
					}
				}
			}
			return null;
        }

        public virtual void OnEffectsChanged(AbstractEffect changedEffect)
        {
			if (m_changesCount <= 0)
			{
				UpdateChangedEffects();
			}
        }

        public virtual bool Remove(AbstractEffect effect)
        {
			int index = -1;
			lock (m_effects)
			{
				index = m_effects.IndexOf(effect);
				if (index < 0)
				{
					return false;
				}
				m_effects.RemoveAt(index);
			}
			if (index != -1)
			{
				effect.OnRemoved(m_owner);
				OnEffectsChanged(effect);
				return true;
			}
			return false;
        }

        public void StopAllEffect()
        {
			if (m_effects.Count > 0)
			{
				AbstractEffect[] array = new AbstractEffect[m_effects.Count];
				m_effects.CopyTo(array);
				AbstractEffect[] array2 = array;
				for (int i = 0; i < array2.Length; i++)
				{
					array2[i].Stop();
				}
				m_effects.Clear();
			}
        }

        public void StopEffect(Type effectType)
        {
			IList allOfType = GetAllOfType(effectType);
			BeginChanges();
			foreach (AbstractEffect item in allOfType)
			{
				item.Stop();
			}
			CommitChanges();
        }

        protected virtual void UpdateChangedEffects()
        {
        }
    }
}
