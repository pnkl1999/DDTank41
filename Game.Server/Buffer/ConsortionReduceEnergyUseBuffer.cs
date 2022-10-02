using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionReduceEnergyUseBuffer : AbstractBuffer
    {
        public ConsortionReduceEnergyUseBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionReduceEnergyUseBuffer consortionReduceEnergyUseBuffer = player.BufferList.GetOfType(typeof(ConsortionReduceEnergyUseBuffer)) as ConsortionReduceEnergyUseBuffer;
			if (consortionReduceEnergyUseBuffer != null)
			{
				if (consortionReduceEnergyUseBuffer.Info.Value != m_info.Value)
				{
					consortionReduceEnergyUseBuffer.Info.ValidDate = m_info.ValidDate;
					consortionReduceEnergyUseBuffer.Info.Value = m_info.Value;
					consortionReduceEnergyUseBuffer.Info.TemplateID = m_info.TemplateID;
					consortionReduceEnergyUseBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionReduceEnergyUseBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionReduceEnergyUseBuffer.Info.ValidDate += m_info.ValidDate;
				consortionReduceEnergyUseBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionReduceEnergyUseBuffer);
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
