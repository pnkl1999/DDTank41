using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class AttackBuffer : AbstractBuffer
    {
        public AttackBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			AttackBuffer attackBuffer = player.BufferList.GetOfType(typeof(AttackBuffer)) as AttackBuffer;
			if (attackBuffer != null)
			{
				attackBuffer.Info.ValidDate += base.Info.ValidDate;
				if (attackBuffer.Info.ValidDate > 30)
				{
					attackBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(attackBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.AttackAddPlus += base.Info.Value;
			}
        }

        public override void Stop()
        {
			m_player.PlayerCharacter.AttackAddPlus -= m_info.Value;
			base.Stop();
        }
    }
}
