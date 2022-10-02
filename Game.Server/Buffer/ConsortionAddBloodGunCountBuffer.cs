using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class ConsortionAddBloodGunCountBuffer : AbstractBuffer
    {
        public ConsortionAddBloodGunCountBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			ConsortionAddBloodGunCountBuffer consortionAddBloodGunCountBuffer = player.BufferList.GetOfType(typeof(ConsortionAddBloodGunCountBuffer)) as ConsortionAddBloodGunCountBuffer;
			if (consortionAddBloodGunCountBuffer != null)
			{
				if (consortionAddBloodGunCountBuffer.Info.Value != m_info.Value)
                {
					consortionAddBloodGunCountBuffer.Info.ValidDate = m_info.ValidDate;
					consortionAddBloodGunCountBuffer.Info.Value = m_info.Value;
					consortionAddBloodGunCountBuffer.Info.TemplateID = m_info.TemplateID;
					consortionAddBloodGunCountBuffer.Info.Data = m_info.Data;
					player.BufferList.UpdateBuffer(consortionAddBloodGunCountBuffer);
					player.UpdateFightBuff(base.Info);
					return;
				}
				consortionAddBloodGunCountBuffer.Info.ValidDate += m_info.ValidDate;
				consortionAddBloodGunCountBuffer.Info.TemplateID = m_info.TemplateID;
				player.BufferList.UpdateBuffer(consortionAddBloodGunCountBuffer);
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
