using Game.Server.GameObjects;
using Game.Server.LittleGame;
using Game.Server.Packets;

namespace Game.Server.Commands.Handlers
{
    [ChatCommand("Open", "Opens up the HutGa!", AccessLevel.GOD)]
    public class StartLittleGame : IChatCommand
    {
        public int CommandHandler(GamePlayer Player, string[] args)
        {
            LittleGameWorldMgr.OpenLittleGame(Player);
            Player.Out.SendMessage(eMessageType.ALERT, $"HutGa has been successfully opened!");
            return 1;
        }
    }
}