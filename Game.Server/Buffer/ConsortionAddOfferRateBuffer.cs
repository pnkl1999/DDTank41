using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddOfferRateBuffer : AbstractBuffer
    {
        public ConsortionAddOfferRateBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddOfferRateBuffer consortionAddOfferRateBuffer = player.BufferList.GetOfType(typeof(ConsortionAddOfferRateBuffer)) as ConsortionAddOfferRateBuffer;
			if (consortionAddOfferRateBuffer != null)
			{
				if (consortionAddOfferRateBuffer.Info.Value != m_info.Value)
				{
					consortionAddOfferRateBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddOfferRateBuffer.Info.Value = m_info.Value;
					consortionAddOfferRateBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddOfferRateBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddOfferRateBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddOfferRateBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddOfferRateBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddOfferRateBuffer);
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
