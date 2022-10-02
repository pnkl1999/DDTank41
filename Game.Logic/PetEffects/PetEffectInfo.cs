namespace Game.Logic
{
	public class PetEffectInfo
	{
		private bool m_activeGuard;

		private bool m_activePetHit;

		private int m_addAttackValue;

		private int m_addDameValue;

		private int m_addGuardValue;

		private int m_addLuckValue;

		private int m_bonusAgility;

		private int m_bonusAttack;

		private int m_bonusBaseDamage;

		private int m_bonusDefend;

		private int m_bonusGuard;

		private int m_bonusLucky;

		private int m_bonusPoint;

		private bool m_critActive;

		private int m_critRate;

		private int m_currentUseSkill;

		private int m_BallType;

		private bool m_isPetUseSkill;

		private int m_maxBlood;

		private int m_petBaseAtt;

		private int m_petDelay;

		private int m_reduceDefendValue;

		private bool m_stopMoving;

		public int AddBloodPercent;

		private int m_DamagePercent;

		public bool ActiveEffect;

		public int ReduceCritValue;

		public int IncreaseAngelicPoint;

		public int Delay;

		public bool DisibleActiveSkill;

		public int AddMaxBloodValue;

		public int ReboundDamage;

		public double reduceArmorValue;

		public int DamagePercent
		{
			get
			{
				return m_DamagePercent;
			}
			set
			{
				m_DamagePercent = value;
			}
		}

		public bool ActiveGuard
		{
			get
			{
				return m_activeGuard;
			}
			set
			{
				m_activeGuard = value;
			}
		}

		public bool ActivePetHit
		{
			get
			{
				return m_activePetHit;
			}
			set
			{
				m_activePetHit = value;
			}
		}

		public int AddAttackValue
		{
			get
			{
				return m_addAttackValue;
			}
			set
			{
				m_addAttackValue = value;
			}
		}

		public int AddDameValue
		{
			get
			{
				return m_addDameValue;
			}
			set
			{
				m_addDameValue = value;
			}
		}

		public int AddGuardValue
		{
			get
			{
				return m_addGuardValue;
			}
			set
			{
				m_addGuardValue = value;
			}
		}

		public int AddLuckValue
		{
			get
			{
				return m_addLuckValue;
			}
			set
			{
				m_addLuckValue = value;
			}
		}

		public int BonusAgility
		{
			get
			{
				return m_bonusAgility;
			}
			set
			{
				m_bonusAgility = value;
			}
		}

		public int BonusAttack
		{
			get
			{
				return m_bonusAttack;
			}
			set
			{
				m_bonusAttack = value;
			}
		}

		public int BonusBaseDamage
		{
			get
			{
				return m_bonusBaseDamage;
			}
			set
			{
				m_bonusBaseDamage = value;
			}
		}

		public int BonusDefend
		{
			get
			{
				return m_bonusDefend;
			}
			set
			{
				m_bonusDefend = value;
			}
		}

		public int BonusGuard
		{
			get
			{
				return m_bonusGuard;
			}
			set
			{
				m_bonusGuard = value;
			}
		}

		public int BonusLucky
		{
			get
			{
				return m_bonusLucky;
			}
			set
			{
				m_bonusLucky = value;
			}
		}

		public int BonusPoint
		{
			get
			{
				return m_bonusPoint;
			}
			set
			{
				m_bonusPoint = value;
			}
		}

		public bool CritActive
		{
			get
			{
				return m_critActive;
			}
			set
			{
				m_critActive = value;
			}
		}

		public int CritRate
		{
			get
			{
				return m_critRate;
			}
			set
			{
				m_critRate = value;
			}
		}

		public int CurrentUseSkill
		{
			get
			{
				return m_currentUseSkill;
			}
			set
			{
				m_currentUseSkill = value;
			}
		}

		public int BallType
		{
			get
			{
				return m_BallType;
			}
			set
			{
				m_BallType = value;
			}
		}

		public bool IsPetUseSkill
		{
			get
			{
				return m_isPetUseSkill;
			}
			set
			{
				m_isPetUseSkill = value;
			}
		}

		public int MaxBlood
		{
			get
			{
				return m_maxBlood;
			}
			set
			{
				m_maxBlood = value;
			}
		}

		public int PetBaseAtt
		{
			get
			{
				return m_petBaseAtt;
			}
			set
			{
				m_petBaseAtt = value;
			}
		}

		public int PetDelay
		{
			get
			{
				return m_petDelay;
			}
			set
			{
				m_petDelay = value;
			}
		}

		public int ReduceDefendValue
		{
			get
			{
				return m_reduceDefendValue;
			}
			set
			{
				m_reduceDefendValue = value;
			}
		}

		public bool StopMoving
		{
			get
			{
				return m_stopMoving;
			}
			set
			{
				m_stopMoving = value;
			}
		}
	}
}
