using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddEffectTurnBuffer : AbstractBuffer
    {
        public ConsortionAddEffectTurnBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddEffectTurnBuffer consortionAddEffectTurnBuffer = player.BufferList.GetOfType(typeof(ConsortionAddEffectTurnBuffer)) as ConsortionAddEffectTurnBuffer;
			if (consortionAddEffectTurnBuffer != null)
			{
				if (consortionAddEffectTurnBuffer.Info.Value != m_info.Value)
				{
					consortionAddEffectTurnBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddEffectTurnBuffer.Info.Value = m_info.Value;
					consortionAddEffectTurnBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddEffectTurnBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddEffectTurnBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddEffectTurnBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddEffectTurnBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddEffectTurnBuffer);
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
