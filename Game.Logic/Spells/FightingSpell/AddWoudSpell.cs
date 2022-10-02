using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Spells.FightingSpell
{
    [SpellAttibute(13)]
	public class AddWoudSpell : ISpellHandler
    {
        public void Execute(BaseGame game, Player player, ItemTemplateInfo item)
        {
			player.CurrentDamagePlus += (float)item.Property2 / 100f;
        }
    }
}
