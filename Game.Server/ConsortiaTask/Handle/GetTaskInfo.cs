using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ConsortiaTask.Handle
{
    [ConsortiaTask((byte)ConsortiaTaskType.GET_TASKINFO)]
    public class GetTaskInfo : IConsortiaTaskCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            //ConsortiaTaskMgr.Out.SendTaskInfoTest(Player);
            var consortia = ConsortiaTaskMgr.Consortiums.Find(c => c.ID == Player.PlayerCharacter.ConsortiaID);
            if (consortia != null && consortia.Task.BeginTime.AddMinutes(consortia.Task.Time) > DateTime.Now)
                ConsortiaTaskMgr.Out.SendTaskInfo(Player, consortia);
            else
                ConsortiaTaskMgr.Out.SendTaskInfo(Player);
            return 0;
        }
    }
}
