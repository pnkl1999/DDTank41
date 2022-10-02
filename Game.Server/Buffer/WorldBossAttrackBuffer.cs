using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
    public class WorldBossAttrackBuffer : AbstractBuffer
    {
        public WorldBossAttrackBuffer(BufferInfo buffer) : base(buffer) { }

        public override void Start(GamePlayer player)
        {
            WorldBossAttrackBuffer buffer = player.BufferList.GetOfType(typeof(WorldBossAttrackBuffer)) as WorldBossAttrackBuffer;
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
