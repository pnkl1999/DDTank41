using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class AgiBuffer : AbstractBuffer
    {
        public AgiBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			AgiBuffer agiBuffer = player.BufferList.GetOfType(typeof(AgiBuffer)) as AgiBuffer;
			if (agiBuffer != null)
			{
				agiBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(agiBuffer);
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
