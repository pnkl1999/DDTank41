using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Handle
{
    [ConsortiaTask((byte)ConsortiaTaskType.RESET_TASK)]
    public class ResetTask : IConsortiaTaskCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            bool isBand = packet.ReadBoolean();
            if (Player.PlayerCharacter.Money >= 500)
            {
                if (Player.RemoveMoney(500) > 0)
                {
                    ConsortiaTaskMgr.ResetTask(Player, isBand);
                    Consortia consortia = ConsortiaTaskMgr.Consortiums.Find(c => c.ID == Player.PlayerCharacter.ConsortiaID);
                    if (consortia.Task.BeginTime.AddMinutes(consortia.Task.Time) > DateTime.Now)
                        ConsortiaTaskMgr.Out.SendTaskInfo(Player, consortia);
                    else
                        ConsortiaTaskMgr.Out.SendTaskInfo(Player);
                }
                else
                {
                    Player.SendMessage("Làm mới nhiệm vụ thất bại.");
                }

            } else
            {
                Player.SendMessage("Không đủ xu để làm mới nhiệm vụ.");
            }
            
            return 0;
        }
    }
}