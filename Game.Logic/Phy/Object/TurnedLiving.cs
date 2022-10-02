using System;

namespace Game.Logic.Phy.Object
{
    public class TurnedLiving : Living
    {
        public int DefaultDelay;

        public int m_psychic;

        protected int m_delay;

        private int m_dander;

        private int int_8;

        private int m_petMP;

        public int Delay
        {
			get
			{
				return m_delay;
			}
			set
			{
				m_delay = value;
			}
        }

        public int Dander
        {
			get
			{
				return m_dander;
			}
			set
			{
				m_dander = value;
			}
        }

        public int PetMP
        {
			get
			{
				return m_petMP;
			}
			set
			{
				m_petMP = value;
			}
        }

        public int PetMaxMP
        {
			get
			{
				return int_8;
			}
			set
			{
				int_8 = value;
			}
        }

        public int psychic
        {
			get
			{
				return m_psychic;
			}
			set
			{
				m_psychic = value;
			}
        }

        public void AddPetMP(int value)
        {
			if (value <= 0)
			{
				return;
			}
			if (base.IsLiving && PetMP < PetMaxMP)
			{
				m_petMP += value;
				if (m_petMP > PetMaxMP)
				{
					m_petMP = PetMaxMP;
				}
			}
			else
			{
				m_petMP = PetMaxMP;
			}
        }

        public void RemovePetMP(int value)
        {
			if (value > 0 && base.IsLiving && PetMP > 0)
			{
				m_petMP -= value;
				if (m_petMP < 0)
				{
					m_petMP = 0;
				}
			}
        }

        public TurnedLiving(int id, BaseGame game, int team, string name, string modelId, int maxBlood, int immunity, int direction)
			: base(id, game, team, name, modelId, maxBlood, immunity, direction)
        {
			m_psychic = 999;
			int_8 = 100;
			m_petMP = 10;
        }

        public override void Reset()
        {
			base.Reset();
			if (this is Player)
			{
				m_delay = GetTurnDelay();
			}
			else
			{
				m_delay = (int)Agility;
			}
        }

        public void AddDelay(int value)
        {
			if (base.Game is PVEGame)
			{
				m_delay = ((PVEGame)base.Game).MissionInfo.IncrementDelay;
			}
			else
			{
				m_delay += value;
			}
        }

        public override void PrepareSelfTurn()
        {
			DefaultDelay = m_delay;
			if (base.IsFrost || base.BlockTurn)
			{
				if (this is Player)
				{
					AddDelay(GetTurnDelay());
				}
				else
				{
					AddDelay((this as SimpleBoss).NpcInfo.Delay);
				}
			}
			base.PrepareSelfTurn();
        }

        public int GetTurnDelay()
        {
			return (int)(1600.0 - 1200.0 * Agility / (Agility + 1200.0) + Attack / 10.0);
        }

        public void AddDander(int value)
        {
			if (value > 0 && base.IsLiving)
			{
				SetDander(m_dander + value);
			}
        }

        public void SetDander(int value)
        {
			m_dander = Math.Min(value, 200);
			if (base.SyncAtTime)
			{
				m_game.SendGameUpdateDander(this);
			}
        }

        public virtual void StartGame()
        {
        }

        public virtual void Skip(int spendTime)
        {
			if (base.IsAttacking)
			{
				StopAttacking();
				m_game.CheckState(0);
			}
        }
    }
}
