using Bussiness;
using Game.Base.Packets;
using Game.Server.ConsortiaTask.Handle;
using Game.Server.GameObjects;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.ConsortiaTask
{
    [ConsortiaTaskProcessor(22, "礼堂逻辑")]
    public class ConsortiaTaskLogicProcessor : AbstractConsortiaTaskProcessor
    {
        private readonly static ILog log;
        private ConsortiaTaskHandleMgr consortiaTaskHandleMgr;
        public ConsortiaTaskLogicProcessor()
        {
            this.consortiaTaskHandleMgr = new ConsortiaTaskHandleMgr();
        }
        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
            ConsortiaTaskType consortiaPackageType = (ConsortiaTaskType)packet.ReadInt();
            if (GameProperties.DebugMode)
                Console.WriteLine("ConsortiaTaskType = " + consortiaPackageType);
            try
            {
                IConsortiaTaskCommandHadler consortiaCommandHadler = this.consortiaTaskHandleMgr.LoadCommandHandler((int)consortiaPackageType);
                if (consortiaCommandHadler == null)
                {
                    Console.WriteLine("______________ERROR______________");
                    Console.WriteLine("LoadCommandHandler not found!");
                    Console.WriteLine("_______________END_______________");
                }
                else
                {
                    consortiaCommandHadler.CommandHandler(player, packet);
                }
            }
            catch (Exception)
            {
                Console.WriteLine("______________ERROR______________");
                Console.WriteLine("ConsortiaTaskLogicProcessor PackageType {0} not found!", consortiaPackageType);
                Console.WriteLine("_______________END_______________");
            }
        }
    }
}
