using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddCriticalBuffer : AbstractBuffer
    {
        public ConsortionAddCriticalBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddCriticalBuffer consortionAddCriticalBuffer = player.BufferList.GetOfType(typeof(ConsortionAddCriticalBuffer)) as ConsortionAddCriticalBuffer;
			if (consortionAddCriticalBuffer != null)
			{
				if (consortionAddCriticalBuffer.Info.Value != m_info.Value)
				{
					consortionAddCriticalBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddCriticalBuffer.Info.Value = m_info.Value;
					consortionAddCriticalBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddCriticalBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddCriticalBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddCriticalBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddCriticalBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddCriticalBuffer);
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
