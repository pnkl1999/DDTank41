using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Conditions
{
    public class PvPBattleCondition : Condition
    {
        public PvPBattleCondition(GamePlayer player, Consortia consortia) : base(player, consortia)
        {
        }

        public override void AddTrigger()
        {
            Player.GameOver += Execute;
        }

        private void Execute(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple)
        {
            lock (ConsortiaTaskMgr.Consortiums)
            {
                if (game.RoomType == eRoomType.Match)
                {
                    var consortiaTaskConditionInfo = Consortia?.Task.Conditions.Find(c => c.Type == 1);
                    if (consortiaTaskConditionInfo != null)
                    {
                        if (consortiaTaskConditionInfo.MustWin && isWin)
                        {
                            consortiaTaskConditionInfo.Value++;
                            consortiaTaskConditionInfo.Finish++;
                            Consortia.RankTable[Player.PlayerId]++;
                            Update(consortiaTaskConditionInfo);
                        }
                        else if (!consortiaTaskConditionInfo.MustWin)
                        {
                            consortiaTaskConditionInfo.Value++;
                            consortiaTaskConditionInfo.Finish++;
                            Consortia.RankTable[Player.PlayerId]++;
                            Update(consortiaTaskConditionInfo);
                        }
                    }
                    else
                    {
                        return;
                    }
                }
                else
                {
                    return;
                }
            }

        }

        public override void RemoveTrigger()
        {
            Player.GameOver -= Execute;
        }
    }
}
