using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class GuardBuffer : AbstractBuffer
    {
        public GuardBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			GuardBuffer guardBuffer = player.BufferList.GetOfType(typeof(GuardBuffer)) as GuardBuffer;
			if (guardBuffer != null)
			{
				guardBuffer.Info.ValidDate += base.Info.ValidDate;
				if (guardBuffer.Info.ValidDate > 30)
				{
					guardBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(guardBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.GuardAddPlus += base.Info.Value;
			}
        }

        public override void Stop()
        {
			m_player.PlayerCharacter.GuardAddPlus -= m_info.Value;
			base.Stop();
        }
    }
}
