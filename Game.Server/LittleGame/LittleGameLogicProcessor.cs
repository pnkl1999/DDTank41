using Game.Base.Packets;
using Game.Server.LittleGame.Handle;
using Game.Server.Packets;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.LittleGame
{
    [LittleGameProcessor(byte.MaxValue, "温泉小游戏采用礼堂逻辑")]
	public class LittleGameLogicProcessor : AbstractLittleGameProcessor
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private LittleGameHandleMgr littleGameHandleMgr = new LittleGameHandleMgr();

        public override void OnGameData(GamePlayer player, GSPacketIn packet)
        {
			eLittleGamePackageInType eLittleGamePackageInType = (eLittleGamePackageInType)packet.ReadByte();
			//Console.WriteLine("littleGamePkg = {0}", eLittleGamePackageInType);
			try
			{
				ILittleGameCommandHandler littleGameCommandHandler = littleGameHandleMgr.LoadCommandHandler((int)eLittleGamePackageInType);
				if (littleGameCommandHandler == null)
				{
					Console.WriteLine("______________ERROR______________");
					Console.WriteLine("LittleGameLogicProcessor LittleGamePackageIn.{0} not found!", eLittleGamePackageInType);
					Console.WriteLine("_______________END_______________");
				}
				else
				{
					littleGameCommandHandler.CommandHandler(player, packet);
				}
			}
			catch (Exception ex)
			{
				Exception ex2 = ex;
				log.Error(string.Format("LittleGameLogicProcessor PackageType:{1}, OnGameData is Error: {0}", ex2.ToString(), eLittleGamePackageInType));
				log.Error($"IP: {player.Client.TcpEndpoint}");
			}
        }
    }
}
