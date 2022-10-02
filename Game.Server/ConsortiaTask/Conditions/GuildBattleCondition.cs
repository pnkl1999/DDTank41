using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Conditions
{
    public class GuildBattleCondition : Condition
    {
        public GuildBattleCondition(GamePlayer player, Consortia consortia) : base(player, consortia)
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
                //if (game.GameType != eGameType.Guild) return;
                if (game.GameType == eGameType.Guild)
                {
                    var consortiaTaskConditionInfo = Consortia?.Task.Conditions.Find(c => c.Type == 2);
                    //if (Player.CurrentRoom.Host != Player || consortiaTaskConditionInfo == null) return;
                    if (Player.CurrentRoom.Host == Player || consortiaTaskConditionInfo != null)
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