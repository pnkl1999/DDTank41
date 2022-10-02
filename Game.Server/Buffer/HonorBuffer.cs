using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class HonorBuffer : AbstractBuffer
    {
        public HonorBuffer(BufferInfo info)
			: base(info)
        {
        }

        public override void Start(GamePlayer player)
        {
			HonorBuffer honorBuffer = player.BufferList.GetOfType(typeof(HonorBuffer)) as HonorBuffer;
			if (honorBuffer != null)
			{
				honorBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(honorBuffer);
			}
			else
			{
				base.Start(player);
			}
        }

        public override void Stop()
        {
			base.Stop();
        }
    }
}
