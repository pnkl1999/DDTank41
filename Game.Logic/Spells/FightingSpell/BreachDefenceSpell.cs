using Game.Logic.Actions;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Spells.FightingSpell
{
    [SpellAttibute(8)]
	public class BreachDefenceSpell : ISpellHandler
    {
        public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
        {
			if (player.IsLiving)
			{
				player.IgnoreArmor = true;
				game.AddAction(new FightAchievementAction(player, eFightAchievementType.IgnoreArmor, player.Direction, 1200));
			}
			else if (game.CurrentLiving != null && game.CurrentLiving is Player && game.CurrentLiving.Team == player.Team)
			{
				game.CurrentLiving.IgnoreArmor = true;
				game.AddAction(new FightAchievementAction(game.CurrentLiving, eFightAchievementType.IgnoreArmor, game.CurrentLiving.Direction, 1200));
			}
        }
    }
}
