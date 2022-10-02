using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Conditions
{
    public class UseItemCondition : Condition
    {
        private readonly int _templateId;

        public UseItemCondition(GamePlayer player, Consortia consortia, int templateId) : base(player, consortia)
        {
            this._templateId = templateId;
        }

        public override void AddTrigger()
        {
            Player.AfterUsingItem += Execute;
        }

        public override void RemoveTrigger()
        {
            Player.AfterUsingItem -= Execute;
        }

        private void Execute(int templateId, int count)
        {
            lock (ConsortiaTaskMgr.Consortiums)
            {
                //if (Consortia == null) return;
                if (Consortia != null)
                {
                    if (templateId == this._templateId)
                    {
                        var consortiaTaskConditionInfo = Consortia?.Task.Conditions.Find(c => c.Type == 3);
                        if (consortiaTaskConditionInfo != null && consortiaTaskConditionInfo.Value <= consortiaTaskConditionInfo.Target)
                        {
                            consortiaTaskConditionInfo.Value += count;
                            consortiaTaskConditionInfo.Finish += count;
                            Consortia.RankTable[Player.PlayerId] += count;
                            Update(consortiaTaskConditionInfo);
                        }
                    }
                }
            }
        }
    }
}
