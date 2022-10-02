using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Spells
{
    public interface ISpellHandler
    {
        void Execute(BaseGame game, Player player, ItemTemplateInfo item);
    }
}
