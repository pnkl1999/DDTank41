using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddPercentGoldOrGPBuffer : AbstractBuffer
    {
        public ConsortionAddPercentGoldOrGPBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddPercentGoldOrGPBuffer consortionAddPercentGoldOrGPBuffer = player.BufferList.GetOfType(typeof(ConsortionAddPercentGoldOrGPBuffer)) as ConsortionAddPercentGoldOrGPBuffer;
			if (consortionAddPercentGoldOrGPBuffer != null)
			{
				if (consortionAddPercentGoldOrGPBuffer.Info.Value != m_info.Value)
				{
					consortionAddPercentGoldOrGPBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddPercentGoldOrGPBuffer.Info.Value = m_info.Value;
					consortionAddPercentGoldOrGPBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddPercentGoldOrGPBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddPercentGoldOrGPBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddPercentGoldOrGPBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddPercentGoldOrGPBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddPercentGoldOrGPBuffer);
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
