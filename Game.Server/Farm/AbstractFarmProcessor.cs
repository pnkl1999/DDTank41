using Game.Base.Packets;

namespace Game.Server.Farm
{
    public abstract class AbstractFarmProcessor : IFarmProcessor
    {
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
