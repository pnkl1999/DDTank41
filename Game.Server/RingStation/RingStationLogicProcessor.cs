using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.RingStation.Handle;
using log4net;

namespace Game.Server.RingStation
{
    [RingStationProcessorAtribute(40, "礼堂逻辑")]
    public class RingStationLogicProcessor : AbstractRingStationProcessor
    {
        public RingStationLogicProcessor()
        {
            _commandMgr = new RingStationHandleMgr();
        }

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private RingStationHandleMgr _commandMgr;

        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
            RingStationPackageType type = (RingStationPackageType) packet.ReadByte();
            try
            {
                IRingStationCommandHadler commandHandler = _commandMgr.LoadCommandHandler((int) type);
                if (commandHandler != null)
                {
                    commandHandler.CommandHandler(player, packet);
                    //Console.WriteLine("RingStationLogicProcessor PackageType {0}", type);
                }
                else
                {
                    //log.Error(string.Format("IP: {0}", player.Client.TcpEndpoint));
                    Console.WriteLine("______________ERROR______________");
                    Console.WriteLine("LoadCommandHandler not found!");
                    Console.WriteLine("_______________END_______________");
                }
            }
            catch
            {
                //log.Error(string.Format("IP:{1}, OnGameData is Error: {0}", e.ToString(), player.Client.TcpEndpoint));
                //log.Error(string.Format("IP: {0}", player.Client.TcpEndpoint));
                Console.WriteLine("______________ERROR______________");
                Console.WriteLine("RingStationLogicProcessor PackageType {0} not found!", type);
                Console.WriteLine("_______________END_______________");
            }
        }
    }
}