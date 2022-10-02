using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class SaveLifeBuffer : AbstractBuffer
    {
        public SaveLifeBuffer(BufferInfo info)
			: base(info)
        {
        }

        public override void Start(GamePlayer player)
        {
			SaveLifeBuffer saveLifeBuffer = player.BufferList.GetOfType(typeof(SaveLifeBuffer)) as SaveLifeBuffer;
			if (saveLifeBuffer != null)
			{
				saveLifeBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(saveLifeBuffer);
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
