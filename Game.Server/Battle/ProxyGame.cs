using Game.Base;
using Game.Base.Packets;
using Game.Logic;

namespace Game.Server.Battle
{
    public class ProxyGame : AbstractGame
    {
        private FightServerConnector fightServerConnector_0;

        public ProxyGame(int id, FightServerConnector fightServer, eRoomType roomType, eGameType gameType, int timeType)
			: base(id, roomType, gameType, timeType)
        {
			fightServerConnector_0 = fightServer;
			fightServerConnector_0.Disconnected += method_0;
        }

        private void method_0(BaseClient baseClient_0)
        {
			Stop();
        }

        public override void ProcessData(GSPacketIn pkg)
        {
			fightServerConnector_0.SendToGame(base.Id, pkg);
        }
    }
}
