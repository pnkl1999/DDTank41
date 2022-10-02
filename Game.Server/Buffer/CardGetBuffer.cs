using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class CardGetBuffer : AbstractBuffer
    {
        public CardGetBuffer(BufferInfo buffer)
			: base(buffer)
        {
        }

        public override void Start(GamePlayer player)
        {
			CardGetBuffer cardGetBuffer = player.BufferList.GetOfType(typeof(CardGetBuffer)) as CardGetBuffer;
			if (cardGetBuffer != null)
			{
				cardGetBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(cardGetBuffer);
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
