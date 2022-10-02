namespace Game.Logic.Actions
{
    public class LockFocusAction : BaseAction
    {
        private bool m_isLock;

        public LockFocusAction(bool isLock, int delay, int finishTime)
			: base(delay, finishTime)
        {
			m_isLock = isLock;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			game.SendLockFocus(m_isLock);
			Finish(tick);
        }
    }
}
