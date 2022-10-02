namespace Game.Logic.Actions
{
    public class PlayBackgroundSoundAction : BaseAction
    {
        private bool m_isPlay;

        public PlayBackgroundSoundAction(bool isPlay, int delay)
			: base(delay, 1000)
        {
			m_isPlay = isPlay;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			((PVEGame)game).SendPlayBackgroundSound(m_isPlay);
			Finish(tick);
        }
    }
}
