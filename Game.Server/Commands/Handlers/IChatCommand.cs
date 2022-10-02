using Game.Server.GameObjects;

namespace Game.Server.Commands.Handlers
{
    public interface IChatCommand 
    {
        int CommandHandler(GamePlayer Player, string[] args);
    }
}
