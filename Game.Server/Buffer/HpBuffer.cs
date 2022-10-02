using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class HpBuffer : AbstractBuffer
    {
        public HpBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			HpBuffer hpBuffer = player.BufferList.GetOfType(typeof(HpBuffer)) as HpBuffer;
			if (hpBuffer != null)
			{
				hpBuffer.Info.ValidDate += base.Info.ValidDate;
				if (hpBuffer.Info.ValidDate > 30)
				{
					hpBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(hpBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.HpAddPlus += base.Info.Value;
			}
        }

        public override void Stop()
        {
			m_player.PlayerCharacter.HpAddPlus -= m_info.Value;
			base.Stop();
        }
    }
}
