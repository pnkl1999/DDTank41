using Game.Server.GameObjects;
using Game.Server.LittleGame;
using Game.Server.Packets;

namespace Game.Server.Commands.Handlers
{
    [ChatCommand("InfoHutGa", "Returns information about HutGa", AccessLevel.GOD)]
    public class StateLittleGame : IChatCommand
    {
        public int CommandHandler(GamePlayer Player, string[] args)
        {
            Player.Out.SendMessage(eMessageType.ALERT, $"Rose flower: {LittleGameWorldMgr.IsOpen}");
            return 1;
        }
    }
}