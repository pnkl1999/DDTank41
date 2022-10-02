using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddPropertyBuffer : AbstractBuffer
    {
        public ConsortionAddPropertyBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddPropertyBuffer consortionAddPropertyBuffer = player.BufferList.GetOfType(typeof(ConsortionAddPropertyBuffer)) as ConsortionAddPropertyBuffer;
			if (consortionAddPropertyBuffer != null)
			{
				if (consortionAddPropertyBuffer.Info.Value != m_info.Value)
				{
					consortionAddPropertyBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddPropertyBuffer.Info.Value = m_info.Value;
					consortionAddPropertyBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddPropertyBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddPropertyBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddPropertyBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddPropertyBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddPropertyBuffer);
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
