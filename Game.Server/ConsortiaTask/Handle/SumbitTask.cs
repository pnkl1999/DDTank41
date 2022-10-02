using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Handle
{
    [ConsortiaTask((byte)ConsortiaTaskType.SUMBIT_TASK)]
    public class SumbitTask : IConsortiaTaskCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            ConsortiaTaskMgr.Out.SendSumbitTask(Player, true);
            return 0;
        }
    }
}
