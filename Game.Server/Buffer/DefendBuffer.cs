using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class DefendBuffer : AbstractBuffer
    {
        public DefendBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			DefendBuffer defendBuffer = player.BufferList.GetOfType(typeof(DefendBuffer)) as DefendBuffer;
			if (defendBuffer != null)
			{
				defendBuffer.Info.ValidDate += base.Info.ValidDate;
				if (defendBuffer.Info.ValidDate > 30)
				{
					defendBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(defendBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.DefendAddPlus += base.Info.Value;
			}
        }

        public override void Stop()
        {
			m_player.PlayerCharacter.DefendAddPlus -= m_info.Value;
			base.Stop();
        }
    }
}
