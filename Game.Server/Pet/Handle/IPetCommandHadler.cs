using Game.Base.Packets;

namespace Game.Server.Pet.Handle
{
    public interface IPetCommandHadler
    {
        bool CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
