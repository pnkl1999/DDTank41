using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class PropsBuffer : AbstractBuffer
    {
        public PropsBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			PropsBuffer propsBuffer = player.BufferList.GetOfType(typeof(PropsBuffer)) as PropsBuffer;
			if (propsBuffer != null)
			{
				propsBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(propsBuffer);
			}
			else
			{
				base.Start(player);
				player.CanUseProp = true;
			}
        }

        public override void Stop()
        {
			m_player.CanUseProp = false;
			base.Stop();
        }
    }
}
