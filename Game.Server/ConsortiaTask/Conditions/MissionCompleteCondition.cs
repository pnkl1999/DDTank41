using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Conditions
{
    /// <inheritdoc />
    public class MissionCompleteCondition : Condition
    {
        public MissionCompleteCondition(GamePlayer player, Consortia consortia) : base(player, consortia)
        {
        }

        public override void AddTrigger()
        {
            Player.MissionFullOver += Execute;
        }

        private void Execute(AbstractGame game, int missionId, bool isWin, int turnNum)
        {
            lock (ConsortiaTaskMgr.Consortiums)
            {
                var consortiaTaskConditionInfo = Consortia?.Task.Conditions.Find(c => c.Type == 4);
                //if (consortiaTaskConditionInfo == null ||
                //    consortiaTaskConditionInfo.Value >= consortiaTaskConditionInfo.Target ||
                //    missionId != consortiaTaskConditionInfo.MissionID || !isWin) return;
                if (consortiaTaskConditionInfo != null || consortiaTaskConditionInfo.Value <= consortiaTaskConditionInfo.Target || missionId == consortiaTaskConditionInfo.MissionID || isWin)
                {
                    consortiaTaskConditionInfo.Value++;
                    consortiaTaskConditionInfo.Finish++;
                    Consortia.RankTable[Player.PlayerId]++;
                    Update(consortiaTaskConditionInfo);
                }
            }
                
        }

        public override void RemoveTrigger()
        {
            Player.MissionFullOver -= Execute;
        }
    }
}
