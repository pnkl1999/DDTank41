using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class WorldBossAddDamageBuffer : AbstractBuffer
    {
        public WorldBossAddDamageBuffer(BufferInfo buffer) : base(buffer) { }

        public override void Start(GamePlayer player)
        {
            WorldBossAddDamageBuffer buffer = player.BufferList.GetOfType(typeof(WorldBossAddDamageBuffer)) as WorldBossAddDamageBuffer;
            if (buffer != null)
            {
                buffer.Info.ValidDate = Info.ValidDate;
                player.BufferList.UpdateBuffer(buffer);
                player.UpdateFightBuff(Info);
            }
            else
            {
                base.Start(player);
                player.FightBuffs.Add(Info);
            }
        }

        public override void Stop()
        {
            m_player.FightBuffs.Remove(Info);
            base.Stop();
        }
    }
}
