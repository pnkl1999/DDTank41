using Game.Server.GameObjects;
using Game.Server.LittleGame;
using Game.Server.LittleGame.Handle;
using Game.Server.Packets;

namespace Game.Server.Commands.Handlers
{
    [ChatCommand("Close", "Closes the HutGa!", AccessLevel.GOD)]
    public class CloseLittleGame : IChatCommand
    {
        public int CommandHandler(GamePlayer Player, string[] args)
        {
            LittleGameWorldMgr.CloseLittleGame(Player);
            Player.Out.SendMessage(eMessageType.ALERT, $"HutGa has been successfully closed");
            return 1;
        }
    }
}