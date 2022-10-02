using Game.Base.Packets;

namespace Game.Server.SceneMarryRooms
{
    public interface IMarryProcessor
    {
        void OnGameData(MarryRoom game, GamePlayer player, GSPacketIn packet);

        void OnTick(MarryRoom room);
    }
}
