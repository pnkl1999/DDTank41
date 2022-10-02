using Game.Base.Packets;
using Game.Server.Consortia.Handle;
using Game.Server.Packets;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.Consortia
{
    [ConsortiaProcessorAtribute(99, "礼堂逻辑")]
	public class ConsortiaLogicProcessor : AbstractConsortiaProcessor
    {
        private static readonly ILog ilog_0;

        private ConsortiaHandleMgr consortiaHandleMgr_0;

        public ConsortiaLogicProcessor()
        {
			consortiaHandleMgr_0 = new ConsortiaHandleMgr();
        }

        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
			ConsortiaPackageType consortiaPackageType = (ConsortiaPackageType)packet.ReadInt();
			try
			{
				IConsortiaCommandHadler consortiaCommandHadler = consortiaHandleMgr_0.LoadCommandHandler((int)consortiaPackageType);
				if (consortiaCommandHadler != null)
				{
					consortiaCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception arg)
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("ConsortiaLogicProcessor PackageType {0} not found! Log: {1}", consortiaPackageType, arg);
				Console.WriteLine("_______________END_______________");
			}
        }

        static ConsortiaLogicProcessor()
        {
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }
    }
}
