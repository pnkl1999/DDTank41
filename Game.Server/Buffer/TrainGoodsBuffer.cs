using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class TrainGoodsBuffer : AbstractBuffer
    {
        public TrainGoodsBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			TrainGoodsBuffer trainGoodsBuffer = player.BufferList.GetOfType(typeof(TrainGoodsBuffer)) as TrainGoodsBuffer;
			if (trainGoodsBuffer != null)
			{
				trainGoodsBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(trainGoodsBuffer);
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
