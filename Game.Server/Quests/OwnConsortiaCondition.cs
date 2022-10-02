using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class OwnConsortiaCondition : BaseCondition
    {
        public OwnConsortiaCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GuildChanged += player_OwnConsortia;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			bool result = false;
			int num = 0;
			using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
			ConsortiaInfo consortiaSingle = consortiaBussiness.GetConsortiaSingle(player.PlayerCharacter.ConsortiaID);
			switch (m_info.Para1)
			{
			case 0:
				num = consortiaSingle.Count;
				break;
			case 1:
				num = player.PlayerCharacter.RichesOffer + player.PlayerCharacter.RichesRob;
				break;
			case 2:
				num = consortiaSingle.SmithLevel;
				break;
			case 3:
				num = consortiaSingle.ShopLevel;
				break;
			case 4:
				num = consortiaSingle.StoreLevel;
				break;
			}
			if (num >= m_info.Para2)
			{
				base.Value = 0;
				result = true;
			}
			return result;
        }

        private void player_OwnConsortia()
        {
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GuildChanged -= player_OwnConsortia;
        }
    }
}
