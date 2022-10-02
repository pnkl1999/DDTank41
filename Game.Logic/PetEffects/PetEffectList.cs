using System;
using System.Collections;
using System.Reflection;
using Bussiness.Managers;
using SqlDataProvider.Data;
using log4net;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

namespace Game.Logic.PetEffects
{

    public class PetEffectList
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected ArrayList m_effects;

        protected readonly Living m_owner;

        protected volatile sbyte m_changesCount;

        protected int m_immunity;


        public ArrayList List
        {
            get { return m_effects; }
        }
        public PetEffectList(Living owner, int immunity)
        {
            m_owner = owner;
            m_effects = new ArrayList(5);
            m_immunity = immunity;
        }

        public bool CanAddEffect(int id)
        {
            if (id > 999 || id < 0)
            {
                return true;
            }
            else
            {
                return ((1 << (id - 1)) & m_immunity) == 0;
            }
        }

        public virtual bool Add(AbstractPetEffect effect)
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
            
            return false;
        }
        public virtual bool Pause(AbstractPetEffect effect)
        {
            int index = -1;
            lock (m_effects)
            {
                index = m_effects.IndexOf(effect);
                if (index < 0)
                    return false;
            }

            effect.OnPaused(m_owner);
            OnEffectsChanged(effect);
            return true;

        }
        public virtual bool Remove(AbstractPetEffect effect)
        {
            int index = -1;
            lock (m_effects)
            {
                index = m_effects.IndexOf(effect);
                if (index < 0)
                    return false;
                m_effects.RemoveAt(index);
            }

            if (index != -1)
            {
                effect.OnRemoved(m_owner);
                OnEffectsChanged(effect);
                return true;
            }
            else
            {
                return false;
            }
        }

        public virtual void OnEffectsChanged(AbstractPetEffect changedEffect)
        {
            if (m_changesCount > 0)
                return;
            UpdateChangedEffects();
        }

        public void BeginChanges()
        {
            m_changesCount++;
        }

        public virtual void CommitChanges()
        {
            bool update;

            if (--m_changesCount < 0)
            {
                if (log.IsWarnEnabled)
                    log.Warn("changes count is less than zero, forgot BeginChanges()?\n" + Environment.StackTrace);
                m_changesCount = 0;
            }

            update = m_changesCount == 0;

            if (update)
                UpdateChangedEffects();
        }

        protected virtual void UpdateChangedEffects()
        {
        }

        public virtual AbstractPetEffect GetOfType(ePetEffectType effectType)
        {
            lock (m_effects)
            {
                foreach (AbstractPetEffect effect in m_effects)
                    if (effect.Type == effectType) return effect;
            }
            return null;
        }

        public virtual IList GetAllOfType(Type effectType)
        {
            ArrayList list = new ArrayList();
            lock (m_effects)
            {
                foreach (AbstractPetEffect effect in m_effects)
                    if (effect.GetType().Equals(effectType)) list.Add(effect);
            }
            return list;
        }

        public void StopEffect(Type effectType)
        {
            IList fx = GetAllOfType(effectType);
            BeginChanges();
            foreach (AbstractPetEffect effect in fx)
            {
                effect.Stop();
            }
            CommitChanges();
        }
        public void StopAllEffect()
        {
            if (m_effects.Count > 0)
            {
                AbstractPetEffect[] temp_effects = new AbstractPetEffect[m_effects.Count];
                m_effects.CopyTo(temp_effects);
                foreach (AbstractPetEffect effect in temp_effects)
                {
                    effect.Stop();
                }
                m_effects.Clear();
            }
        }

 

 

    }
}
