using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ActivityDungeonNetBuffer : AbstractBuffer
    {
        public ActivityDungeonNetBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ActivityDungeonNetBuffer activityDungeonNetBuffer = player.BufferList.GetOfType(typeof(ActivityDungeonNetBuffer)) as ActivityDungeonNetBuffer;
			if (activityDungeonNetBuffer != null)
			{
				activityDungeonNetBuffer.Info.ValidDate = base.Info.ValidDate;
				player.BufferList.UpdateBuffer(activityDungeonNetBuffer);
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
