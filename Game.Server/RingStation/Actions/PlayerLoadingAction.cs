using System;

namespace Game.Server.RingStation.Action
{
    public class PlayerLoadingAction : BaseAction
    {
        private int m_loading;

        public PlayerLoadingAction(int state, int delay) : base(delay, 0)
        {
            m_loading = state;
        }

        protected override void ExecuteImp(VirtualGamePlayer player, long tick)
        {
            if (m_loading > 1000 || player.CurRoom.IsAutoBot)
            {
                m_loading = 1000;
            }

            player.SendLoadingComplete(m_loading);
            if (m_loading < 1000)
            {
                Random random = new Random();
                player.AddAction(new PlayerLoadingAction(m_loading + random.Next(200, 400), 10000));
            }

            Finish(tick);
        }
    }
}