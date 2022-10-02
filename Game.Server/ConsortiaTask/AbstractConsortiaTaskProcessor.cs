using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask
{
    public abstract class AbstractConsortiaTaskProcessor : IConsortiaTaskProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
