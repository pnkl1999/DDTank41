using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Spells.FightingSpell
{
    [SpellAttibute(12)]
	public class ShootStraightSpell : ISpellHandler
    {
        public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
        {
			if (player.IsLiving)
			{
				player.ControlBall = true;
				player.CurrentShootMinus *= 0.5f;
			}
			else if (game.CurrentLiving != null && game.CurrentLiving is Player && game.CurrentLiving.Team == player.Team)
			{
				game.CurrentLiving.ControlBall = true;
				game.CurrentLiving.CurrentShootMinus *= 0.5f;
			}
        }
    }
}
