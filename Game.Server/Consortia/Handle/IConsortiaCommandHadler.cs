using Game.Base.Packets;

namespace Game.Server.Consortia.Handle
{
    public interface IConsortiaCommandHadler
    {
        int CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
