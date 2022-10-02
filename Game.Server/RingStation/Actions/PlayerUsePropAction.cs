namespace Game.Server.RingStation.Action
{
    public class PlayerUsePropAction : BaseAction
    {
        private int m_prop;

        public PlayerUsePropAction(int prop, int delay) : base(delay, 0)
        {
            m_prop = prop;
        }

        protected override void ExecuteImp(VirtualGamePlayer player, long tick)
        {
            player.SendUseProp(m_prop);
            Finish(tick);
        }
    }
}