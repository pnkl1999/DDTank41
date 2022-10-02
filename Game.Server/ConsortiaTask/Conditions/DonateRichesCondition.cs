using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Conditions
{
    public class DonateRichesCondition : Condition
    {
        public DonateRichesCondition(GamePlayer player, Consortia consortia) : base(player, consortia)
        {
        }

        public override void AddTrigger()
        {
            Player.Riches += Execute;
        }

        private void Execute(int value, int type)
        {
            lock (ConsortiaTaskMgr.Consortiums)
            {
                //if (type == 0) return;
                if (type != 0)
                {
                    var consortiaTaskConditionInfo = Consortia?.Task.Conditions.Find(c => c.Type == 5);
                    //if (consortiaTaskConditionInfo == null) return;
                    if (consortiaTaskConditionInfo != null)
                    {
                        if ((consortiaTaskConditionInfo.Value + value >= consortiaTaskConditionInfo.Target))//nếu value cần lớn hơn target
                        {
                            value = consortiaTaskConditionInfo.Target - consortiaTaskConditionInfo.Value;
                        }

                        if (consortiaTaskConditionInfo.Target >= consortiaTaskConditionInfo.Value && value > 0)
                        {
                            consortiaTaskConditionInfo.Value += value;
                            consortiaTaskConditionInfo.Finish += value;
                            Consortia.RankTable[Player.PlayerId] += value;
                            Update(consortiaTaskConditionInfo);
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
        }

        public override void RemoveTrigger()
        {
            Player.Riches -= Execute;
        }
    }
}