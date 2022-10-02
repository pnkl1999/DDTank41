using Game.Base.Packets;
using Game.Logic.Phy.Object;
using log4net;
using System.Reflection;

namespace Game.Logic.Cmd
{
    [GameCommand(25, "希望成为队长")]
	public class UpdatePlayStep : ICommandHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			packet.ReadInt();
			packet.ReadString();
        }
    }
}
