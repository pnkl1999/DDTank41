using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
	[GameCommand((byte)eTankCmdType.LOAD, "游戏加载进度")]
	public class LoadCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
            player.LoadingProcess = packet.ReadInt();
            GSPacketIn pkg = new GSPacketIn((short)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.LOAD);
            if (game.GameState == eGameState.Loading)
            {
                if (player.LoadingProcess >= 100)
                {
                    game.CheckState(0);
                }
                pkg.WriteInt(player.LoadingProcess);
                pkg.WriteInt(player.PlayerDetail.ZoneId);//zoneID
                pkg.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
                game.SendToAll(pkg);
            }
        }
    }
}
