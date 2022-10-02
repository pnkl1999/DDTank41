using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddEnergyBuffer : AbstractBuffer
    {
        public ConsortionAddEnergyBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddEnergyBuffer consortionAddEnergyBuffer = player.BufferList.GetOfType(typeof(ConsortionAddEnergyBuffer)) as ConsortionAddEnergyBuffer;
			if (consortionAddEnergyBuffer != null)
			{
				if (consortionAddEnergyBuffer.Info.Value != m_info.Value)
				{
					consortionAddEnergyBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddEnergyBuffer.Info.Value = m_info.Value;
					consortionAddEnergyBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddEnergyBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddEnergyBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddEnergyBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddEnergyBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddEnergyBuffer);
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
