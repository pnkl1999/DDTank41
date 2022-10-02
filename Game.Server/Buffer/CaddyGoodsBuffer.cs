using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class CaddyGoodsBuffer : AbstractBuffer
    {
        public CaddyGoodsBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			CaddyGoodsBuffer caddyGoodsBuffer = player.BufferList.GetOfType(typeof(CaddyGoodsBuffer)) as CaddyGoodsBuffer;
			if (caddyGoodsBuffer != null)
			{
				caddyGoodsBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(caddyGoodsBuffer);
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
