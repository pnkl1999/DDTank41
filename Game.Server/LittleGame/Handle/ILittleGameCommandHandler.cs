using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    public interface ILittleGameCommandHandler
    {
        int CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
