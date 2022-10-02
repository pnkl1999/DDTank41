using Game.Logic;

namespace Game.Server.Achievement
{
    public class FightWithWeaponCondition : BaseUserRecord
    {
        public FightWithWeaponCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GameOver += player_GameOver;
        }

        private void player_GameOver(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple)
        {
			if ((game.GameType == eGameType.Free || game.GameType == eGameType.Guild || game.GameType == eGameType.ALL) && m_player.MainWeapon != null && isWin)
			{
				int templateID = m_player.MainWeapon.TemplateID;
				if ((templateID == 7023 || templateID == 70231 || templateID == 70232 || templateID == 70233 || templateID == 70234) && m_type == 64)
				{
					m_player.AchievementInventory.UpdateUserAchievement(64, 1);
				}
				if ((templateID == 7016 || templateID == 70161 || templateID == 70162 || templateID == 70163 || templateID == 70164) && m_type == 65)
				{
					m_player.AchievementInventory.UpdateUserAchievement(65, 1);
				}
				if ((templateID == 7017 || templateID == 70171 || templateID == 70172 || templateID == 70173 || templateID == 70174) && m_type == 66)
				{
					m_player.AchievementInventory.UpdateUserAchievement(66, 1);
				}
				if ((templateID == 7015 || templateID == 70151 || templateID == 70152 || templateID == 70153 || templateID == 70154) && m_type == 67)
				{
					m_player.AchievementInventory.UpdateUserAchievement(67, 1);
				}
				if ((templateID == 7019 || templateID == 70191 || templateID == 70192 || templateID == 70193 || templateID == 70194) && m_type == 68)
				{
					m_player.AchievementInventory.UpdateUserAchievement(68, 1);
				}
				if ((templateID == 7022 || templateID == 70221 || templateID == 70222 || templateID == 70223 || templateID == 70224) && m_type == 69)
				{
					m_player.AchievementInventory.UpdateUserAchievement(69, 1);
				}
				if ((templateID == 7020 || templateID == 70201 || templateID == 70202 || templateID == 70203 || templateID == 70204) && m_type == 70)
				{
					m_player.AchievementInventory.UpdateUserAchievement(70, 1);
				}
				if ((templateID == 7021 || templateID == 70211 || templateID == 70212 || templateID == 70213 || templateID == 70214) && m_type == 71)
				{
					m_player.AchievementInventory.UpdateUserAchievement(71, 1);
				}
				if ((templateID == 7018 || templateID == 70181 || templateID == 70182 || templateID == 70183 || templateID == 70184) && m_type == 72)
				{
					m_player.AchievementInventory.UpdateUserAchievement(72, 1);
				}
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GameOver -= player_GameOver;
        }
    }
}
