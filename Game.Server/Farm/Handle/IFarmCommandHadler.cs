using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    public interface IFarmCommandHadler
    {
        bool CommandHandler(GamePlayer Player, GSPacketIn packet);
    }
}
