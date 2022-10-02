using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(149, "使用道具")]
	public class GameTrusteeshipCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			bool trusteeshipState = packet.ReadBoolean();
			GSPacketIn pkg = new GSPacketIn(91);
			pkg.WriteByte(149);
			pkg.Parameter2 = player.Id;
			pkg.WriteInt(game.PlayerCount);
			Player[] allPlayers = game.GetAllPlayers();
			foreach (Player p in allPlayers)
			{
				pkg.WriteInt(p.Id);
				pkg.WriteBoolean(val: false);
			}
			player.PlayerDetail.SendTCP(pkg);
        }
    }
}
