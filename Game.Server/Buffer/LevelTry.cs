using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class LevelTry : AbstractBuffer
    {
        public LevelTry(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			LevelTry levelTry = player.BufferList.GetOfType(typeof(LevelTry)) as LevelTry;
			if (levelTry != null)
			{
				levelTry.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(levelTry);
				player.UpdateFightBuff(base.Info);
			}
			else
			{
				base.Start(player);
				player.FightBuffs.Add(base.Info);
			}
        }

        public override void Stop()
        {
			m_player.FightBuffs.Remove(base.Info);
			base.Stop();
        }
    }
}
