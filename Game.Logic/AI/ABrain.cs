namespace Game.Logic.AI
{
    public abstract class ABrain
    {
        protected Living m_body;

        protected BaseGame m_game;

        public Living Body
        {
			get
			{
				return m_body;
			}
			set
			{
				m_body = value;
			}
        }

        public BaseGame Game
        {
			get
			{
				return m_game;
			}
			set
			{
				m_game = value;
			}
        }

        public virtual void Dispose()
        {
        }

        public virtual void OnAfterTakedBomb()
        {
        }

        public virtual void OnAfterTakedFrozen()
        {
        }
        public virtual void OnBeforeTakedBomb()
        {

        }

        public virtual void OnBeginNewTurn()
        {
        }

        public virtual void OnBeginSelfTurn()
        {
        }

        public virtual void OnCreated()
        {
        }

        public virtual void OnDie()
        {
        }
        public virtual void Die()
        {
        }

        public virtual void OnDiedSay()
        {
        }

        public virtual void OnKillPlayerSay()
        {
        }

        public virtual void OnShootedSay(int delay)
        {
        }

        public virtual void OnShootedSay()
        {
        }

        public virtual void OnStartAttacking()
        {
        }

        public virtual void OnStopAttacking()
        {
        }

        public virtual void OnDiedEvent()
        {
        }

        public virtual void OnAfterTakeDamage(Living source)
        {
        }

        public virtual void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
        }

        public virtual void OnHeal(int blood)
        {
        }
        public virtual void OnDieByBomb()
        {

        }
    }
}
