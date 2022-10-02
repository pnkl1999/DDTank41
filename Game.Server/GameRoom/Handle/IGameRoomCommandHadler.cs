using Game.Base.Packets;

namespace Game.Server.GameRoom.Handle
{
    public interface IGameRoomCommandHadler
    {
        bool CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
