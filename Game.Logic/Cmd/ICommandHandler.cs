using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    public interface ICommandHandler
    {
        void HandleCommand(BaseGame game, Player player, GSPacketIn packet);
    }
}
