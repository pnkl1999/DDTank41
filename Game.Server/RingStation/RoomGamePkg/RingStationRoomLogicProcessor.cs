using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.RingStation.RoomGamePkg.TankHandle;
using log4net;

namespace Game.Server.RingStation.RoomGamePkg
{
    [GameProcessor(99, "礼堂逻辑")]
    public class RingStationRoomLogicProcessor : AbstractGameProcessor
    {
        private GameCommandMgr _commandMgr = new GameCommandMgr();
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public readonly int TIMEOUT = 1 * 60 * 1000;

        public override void OnGameData(RoomGame room, VirtualGamePlayer player, GSPacketIn packet)
        {
            GameCmdType type = (GameCmdType) packet.Code;
            //log.Error(string.Format(" RingStationLogic OnGameData in: {0}", type.ToString()));         
            try
            {
                IGameCommandHandler handler = _commandMgr.LoadCommandHandler((int) type);
                if (handler != null)
                {
                    handler.HandleCommand(this, player, packet);
                }
                else
                {
                    //log.Error(string.Format("IP: {0}", player.Client.TcpEndpoint));
                    Console.WriteLine("______________ERROR______________");
                    Console.WriteLine("LoadCommandHandler not found!");
                    Console.WriteLine("_______________END_______________");
                }
            }
            catch (Exception e)
            {
                log.Error(string.Format(" RingStationLogic OnGameData is Error: {0}, type: {1}", e.ToString(), type));
            }
        }

        public override void OnTick(RoomGame room)
        {
        }
    }
}