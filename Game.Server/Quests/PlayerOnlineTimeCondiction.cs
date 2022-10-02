//using SqlDataProvider.Data;

//namespace Game.Server.Quests
//{
//    public class PlayerOnlineTimeCondiction : BaseCondition
//    {
//        public PlayerOnlineTimeCondiction(BaseQuest quest, QuestConditionInfo info, int value)
//			: base(quest, info, value)
//        {
//        }

//        public override void AddTrigger(GamePlayer player)
//        {
//			player.OnlineGameAdd += OnlineGame;
//        }

//        public void OnlineGame()
//        {
//			if (base.Value > 0)
//			{
//				base.Value--;
//			}
//        }

//        public override void RemoveTrigger(GamePlayer player)
//        {
//			player.OnlineGameAdd -= OnlineGame;
//        }

//        public override bool IsCompleted(GamePlayer player)
//        {
//			return base.Value <= 0;
//        }
//    }
//}
