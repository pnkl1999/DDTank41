using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddMaxBloodBuffer : AbstractBuffer
    {
        public ConsortionAddMaxBloodBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddMaxBloodBuffer consortionAddMaxBloodBuffer = player.BufferList.GetOfType(typeof(ConsortionAddMaxBloodBuffer)) as ConsortionAddMaxBloodBuffer;
			if (consortionAddMaxBloodBuffer != null)
			{
				if (consortionAddMaxBloodBuffer.Info.Value != m_info.Value)
				{
					consortionAddMaxBloodBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddMaxBloodBuffer.Info.Value = m_info.Value;
					consortionAddMaxBloodBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddMaxBloodBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddMaxBloodBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddMaxBloodBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddMaxBloodBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddMaxBloodBuffer);
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
