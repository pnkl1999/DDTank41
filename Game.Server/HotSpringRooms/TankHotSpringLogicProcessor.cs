using Bussiness;
using Game.Base.Packets;
using Game.Server.HotSpringRooms.TankHandle;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.HotSpringRooms
{
    [HotSpringProcessor(9, "礼堂逻辑")]
	public class TankHotSpringLogicProcessor : AbstractHotSpringProcessor
    {
        private HotSpringCommandMgr cmd = new HotSpringCommandMgr();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public readonly int TIMEOUT = 60000;

        public override void OnGameData(HotSpringRoom room, GamePlayer player, GSPacketIn packet)
        {
			HotSpringCmdType code = (HotSpringCmdType)packet.ReadByte();
			try
			{
				IHotSpringCommandHandler hotSpringCommandHandler = cmd.LoadCommandHandler((int)code);
				if (hotSpringCommandHandler != null)
				{
					hotSpringCommandHandler.HandleCommand(this, player, packet);
				}
				else
				{
					log.Error("IP: " + player.Client.TcpEndpoint);
				}
			}
			catch (Exception ex)
			{
				log.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
        }

        public override void OnTick(HotSpringRoom room)
        {
        }
    }
}
