using Game.Base.Packets;

namespace Game.Server.Consortia
{
    public abstract class AbstractConsortiaProcessor : GInterface3
    {
        //testtt
        public virtual void OnGameData(GamePlayer player, GSPacketIn packet)
        {
        }
    }
}
