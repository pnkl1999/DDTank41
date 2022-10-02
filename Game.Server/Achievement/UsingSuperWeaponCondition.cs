using System.Linq;

namespace Game.Server.Achievement
{
    public class UsingSuperWeaponCondition : BaseUserRecord
    {
        public UsingSuperWeaponCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterUsingItem += player_AfterUsingItem;
        }

        private void player_AfterUsingItem(int templateID, int count)
        {
			if (new string[70]
			{
				"70151",
				"70152",
				"70153",
				"70154",
				"70161",
				"70162",
				"70163",
				"70164",
				"70171",
				"70172",
				"70173",
				"70174",
				"70181",
				"70182",
				"70183",
				"70184",
				"70191",
				"70192",
				"70193",
				"70194",
				"70201",
				"70202",
				"70203",
				"70204",
				"70211",
				"70212",
				"70213",
				"70214",
				"70221",
				"70222",
				"70223",
				"70224",
				"70231",
				"70232",
				"70233",
				"70234",
				"70461",
				"70462",
				"70463",
				"70464",
				"70471",
				"70472",
				"70473",
				"70474",
				"70481",
				"70482",
				"70483",
				"70484",
				"70691",
				"70692",
				"70693",
				"70694",
				"71001",
				"71002",
				"71003",
				"71004",
				"7015",
				"7016",
				"7017",
				"7018",
				"7019",
				"7020",
				"7021",
				"7022",
				"7023",
				"7046",
				"7047",
				"7048",
				"7069",
				"7100"
			}.Contains(templateID.ToString()))
			{
				m_player.AchievementInventory.UpdateUserAchievement(m_type, 1);
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AfterUsingItem -= player_AfterUsingItem;
        }
    }
}
