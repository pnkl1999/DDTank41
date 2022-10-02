using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddDamageBuffer : AbstractBuffer
    {
        public ConsortionAddDamageBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddDamageBuffer consortionAddDamageBuffer = player.BufferList.GetOfType(typeof(ConsortionAddDamageBuffer)) as ConsortionAddDamageBuffer;
			if (consortionAddDamageBuffer != null)
			{
				if (consortionAddDamageBuffer.Info.Value != m_info.Value)
				{
					consortionAddDamageBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddDamageBuffer.Info.Value = m_info.Value;
					consortionAddDamageBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddDamageBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddDamageBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddDamageBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddDamageBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddDamageBuffer);
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
