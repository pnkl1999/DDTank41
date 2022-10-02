namespace Game.Server.RingStation.Action
{
    public class PlayerBuffStuntAction : BaseAction
    {
        private int m_type;

        public PlayerBuffStuntAction(int type, int delay) : base(delay, 0)
        {
            m_type = type;
        }

        protected override void ExecuteImp(VirtualGamePlayer player, long tick)
        {
            player.sendGameCMDStunt(m_type);
            Finish(tick);
        }
    }
}