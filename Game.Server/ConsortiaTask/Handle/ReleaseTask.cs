using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ConsortiaTask.Handle
{
    [ConsortiaTask((byte)ConsortiaTaskType.RELEASE_TASK)]
    public class ReleaseTask : IConsortiaTaskCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            int level = packet.ReadInt();
            // ConsortiaTaskMgr.Out.SendReleaseTaskTest(Player);
            ConsortiaBussiness cb = new ConsortiaBussiness();
            ConsortiaInfo consortiaInfo = cb.GetConsortiaSingle(Player.PlayerCharacter.ConsortiaID);
            if (consortiaInfo == null) return 0;

            int costtask = ConsortiaTaskMgr.GetMissionRichesWithLevel(consortiaInfo.Level);
            if (consortiaInfo.Riches < costtask)
            {
                Player.SendMessage(LanguageMgr.GetTranslation("ConsortiaBussiness.Riches.Msg3"));
                return 0;
            }
            string msg = "";
            if (!cb.UpdateConsortiaRiches(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, costtask, ref msg))
            {
                Player.SendMessage(LanguageMgr.GetTranslation("ConsortiaBussiness.Riches.Msg3"));
                return 0;
            }
            if (ConsortiaTaskMgr.CreateTask(Player, level <= 0 ? 1 : level))
            {
                var consortia = ConsortiaTaskMgr.Consortiums.Find(c => c.ID == Player.PlayerCharacter.ConsortiaID);
                if (consortia.Task.BeginTime.AddMinutes(consortia.Task.Time) > DateTime.Now)
                    ConsortiaTaskMgr.Out.SendTaskInfo(Player, consortia);
                else
                    ConsortiaTaskMgr.Out.SendTaskInfo(Player);
            }
            return 0;
        }
    }
}
