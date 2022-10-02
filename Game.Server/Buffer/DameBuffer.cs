using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class DameBuffer : AbstractBuffer
    {
        public DameBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			DameBuffer dameBuffer = player.BufferList.GetOfType(typeof(DameBuffer)) as DameBuffer;
			if (dameBuffer != null)
			{
				dameBuffer.Info.ValidDate += base.Info.ValidDate;
				if (dameBuffer.Info.ValidDate > 30)
				{
					dameBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(dameBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.DameAddPlus += base.Info.Value;
			}
        }

        public override void Stop()
        {
			m_player.PlayerCharacter.DameAddPlus -= m_info.Value;
			base.Stop();
        }
    }
}
