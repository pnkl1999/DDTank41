using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ReHealthBuffer : AbstractBuffer
    {
        public ReHealthBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ReHealthBuffer reHealthBuffer = player.BufferList.GetOfType(typeof(ReHealthBuffer)) as ReHealthBuffer;
			if (reHealthBuffer != null)
			{
				reHealthBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(reHealthBuffer);
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
