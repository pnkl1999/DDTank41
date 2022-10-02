using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.ConsortiaTask
{
    public interface IConsortiaTaskProcessor
    {
        void OnGameData(GamePlayer player, GSPacketIn packet);
    }
}
