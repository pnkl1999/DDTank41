using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Spells.FightingSpell
{
    [SpellAttibute(9)]
	public class NoHoleSpell : ISpellHandler
    {
        public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
        {
			if (player.IsLiving)
			{
				new NoHoleEffect(item.Property3).Start(player);
			}
			else if (game.CurrentLiving != null && game.CurrentLiving is Player && game.CurrentLiving.Team == player.Team)
			{
				new NoHoleEffect(item.Property3).Start(game.CurrentLiving);
			}
        }
    }
}
