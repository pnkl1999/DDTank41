using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class GPMultipleBuffer : AbstractBuffer
    {
        public GPMultipleBuffer(BufferInfo info)
			: base(info)
        {
        }

        public override void Start(GamePlayer player)
        {
			GPMultipleBuffer gPMultipleBuffer = player.BufferList.GetOfType(typeof(GPMultipleBuffer)) as GPMultipleBuffer;
			if (gPMultipleBuffer != null)
			{
				gPMultipleBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(gPMultipleBuffer);
			}
			else
			{
				base.Start(player);
				player.GPAddPlus *= base.Info.Value;
			}
        }

        public override void Stop()
        {
			if (m_player != null)
			{
				m_player.GPAddPlus /= base.Info.Value;
				base.Stop();
			}
        }
    }
}
