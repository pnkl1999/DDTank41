using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(116, "关卡准备")]
	public class MissionPrepareCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (game.GameState == eGameState.SessionPrepared || game.GameState == eGameState.GameOver)
			{
				bool flag = packet.ReadBoolean();
				if (player.Ready != flag)
				{
					player.Ready = flag;
					game.SendToAll(packet);
				}
			}
        }
    }
}
