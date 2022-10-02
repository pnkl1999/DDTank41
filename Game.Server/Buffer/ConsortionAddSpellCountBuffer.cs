using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddSpellCountBuffer : AbstractBuffer
    {
        public ConsortionAddSpellCountBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddSpellCountBuffer consortionAddSpellCountBuffer = player.BufferList.GetOfType(typeof(ConsortionAddSpellCountBuffer)) as ConsortionAddSpellCountBuffer;
			if (consortionAddSpellCountBuffer != null)
			{
				if (consortionAddSpellCountBuffer.Info.Value != m_info.Value)
				{
					consortionAddSpellCountBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddSpellCountBuffer.Info.Value = m_info.Value;
					consortionAddSpellCountBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddSpellCountBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddSpellCountBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddSpellCountBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddSpellCountBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddSpellCountBuffer);
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
