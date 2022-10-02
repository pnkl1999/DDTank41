using Game.Base.Packets;

namespace Game.Server.Pet
{
    public abstract class AbstractPetProcessor : IPetProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
