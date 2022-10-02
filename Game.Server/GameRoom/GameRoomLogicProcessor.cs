using Game.Base.Packets;
using Game.Server.GameRoom.Handle;
using Game.Server.Packets;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.GameRoom
{
    [GameRoomProcessorAtribute(40, "礼堂逻辑")]
	public class GameRoomLogicProcessor : AbstractGameRoomProcessor
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private GameRoomHandleMgr _commandMgr;

        public GameRoomLogicProcessor()
        {
			_commandMgr = new GameRoomHandleMgr();
        }

        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
			eRoomPackageType eRoomPackageType = (eRoomPackageType)packet.ReadInt();
			//Console.WriteLine("GameRoomPkg = {0}", eRoomPackageType);
			try
			{
				IGameRoomCommandHadler gameRoomCommandHadler = _commandMgr.LoadCommandHandler((int)eRoomPackageType);
				if (gameRoomCommandHadler != null)
				{
					gameRoomCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("GameRoomLogicProcessor PackageType {0} not found!", eRoomPackageType);
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				log.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
        }
    }
}
