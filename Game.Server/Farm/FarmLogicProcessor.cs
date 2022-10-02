using Game.Base.Packets;
using Game.Server.Farm.Handle;
using Game.Server.Packets;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.Farm
{
    [FarmProcessorAtribute(99, "礼堂逻辑")]
	public class FarmLogicProcessor : AbstractFarmProcessor
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private FarmHandleMgr _commandMgr;

        public FarmLogicProcessor()
        {
			_commandMgr = new FarmHandleMgr();
        }

        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
			FarmPackageType farmPackageType = (FarmPackageType)packet.ReadByte();
			Console.WriteLine("Type PKG = {0}", farmPackageType);
			try
			{
				IFarmCommandHadler farmCommandHadler = _commandMgr.LoadCommandHandler((int)farmPackageType);
				if (farmCommandHadler != null)
				{
					farmCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				log.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
        }
    }
}
