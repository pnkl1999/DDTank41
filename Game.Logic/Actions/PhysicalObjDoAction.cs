using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class PhysicalObjDoAction : BaseAction
    {
        private PhysicalObj m_obj;

        private string m_action;

        public PhysicalObjDoAction(PhysicalObj obj, string action, int delay, int movieTime)
			: base(delay, movieTime)
        {
			m_obj = obj;
			m_action = action;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			m_obj.CurrentAction = m_action;
			game.SendPhysicalObjPlayAction(m_obj);
			Finish(tick);
        }
    }
}
