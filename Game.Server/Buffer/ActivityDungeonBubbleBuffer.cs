using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ActivityDungeonBubbleBuffer : AbstractBuffer
    {
        public ActivityDungeonBubbleBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ActivityDungeonBubbleBuffer activityDungeonBubbleBuffer = player.BufferList.GetOfType(typeof(ActivityDungeonBubbleBuffer)) as ActivityDungeonBubbleBuffer;
			if (activityDungeonBubbleBuffer != null)
			{
				activityDungeonBubbleBuffer.Info.ValidDate = base.Info.ValidDate;
				player.BufferList.UpdateBuffer(activityDungeonBubbleBuffer);
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
