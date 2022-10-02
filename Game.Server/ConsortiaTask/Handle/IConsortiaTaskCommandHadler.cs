using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask.Handle
{
    public interface IConsortiaTaskCommandHadler
    {
        int CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
