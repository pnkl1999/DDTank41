using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.RingStation.Battle;

namespace Game.Server.RingStation
{
    public class ProxyRingStationGame : AbstractGame
    {
        private RingStationFightConnector m_fightServer;

        public ProxyRingStationGame(int id, RingStationFightConnector fightServer, eRoomType roomType,
            eGameType gameType, int timeType) : base(id, roomType, gameType, timeType)
        {
            m_fightServer = fightServer;
            m_fightServer.Disconnected += new ClientEventHandle(m_fightingServer_Disconnected);
        }

        private void m_fightingServer_Disconnected(BaseClient client)
        {
            Stop();
        }

        public override void ProcessData(GSPacketIn pkg)
        {
            m_fightServer.SendToGame(base.Id, pkg);
        }
    }
}