using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Server.ConsortiaTask;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Commands.Handlers
{
    [ChatCommand("CompleteTask", "Completes the current guild quest!", AccessLevel.GOD)]
    public class FinishConsortiaTask : IChatCommand
    {
        public int CommandHandler(GamePlayer Player, string[] args)
        {
            var consortia = ConsortiaTaskMgr.Consortiums.Find(c => c.ID == Player.PlayerCharacter.ConsortiaID);
            foreach (var condition in consortia.Task.Conditions)
            {
                condition.Value = condition.Finish = condition.Target;
                condition.OnComplete(consortia, condition);
                consortia.RankTable[Player.PlayerId] = consortia.Task.Points;
                ConsortiaTaskMgr.Out.SendTaskUpdate(Player, condition);
            }
            return 0;
        }
    }
}