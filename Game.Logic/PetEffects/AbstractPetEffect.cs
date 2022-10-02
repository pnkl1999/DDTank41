using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Logic.PetEffects
{
    public abstract class AbstractPetEffect
    {
        private ePetEffectType m_type;
        protected Living m_living;
        public Random rand;
        public bool IsTrigger;        
        private PetSkillElementInfo m_eleInfo;
        public AbstractPetEffect(ePetEffectType type, string ElementID)
        {
            rand = new Random();
            m_type = type;
            m_eleInfo = PetMgr.FindPetSkillElement(int.Parse(ElementID));
            if (m_eleInfo == null)
            {
                m_eleInfo = new PetSkillElementInfo();
                m_eleInfo.EffectPic = "";
                m_eleInfo.Pic = -1;
                m_eleInfo.Value = 1;
            }
        }       

        public PetSkillElementInfo ElementInfo
        {
            get { return m_eleInfo; }
        }
        public ePetEffectType Type
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
            if (m_living.PetEffectList.Add(this))
            {
                return true;
            }
            return false;
        }

        public virtual bool Stop()
        {
            if (m_living != null)
            {
                return m_living.PetEffectList.Remove(this);
            }
            return false;
        }

        public virtual bool Pause()
        {
            if (m_living != null)
            {
                return m_living.PetEffectList.Pause(this);
            }
            return false;
        }

        public virtual void OnAttached(Living living) { }
        public virtual void OnRemoved(Living living) { }
        public virtual void OnPaused(Living living) { }


    }
}
