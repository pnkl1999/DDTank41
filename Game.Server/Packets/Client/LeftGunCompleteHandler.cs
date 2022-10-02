using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler(130, "物品炼化")]
	public class LeftGunCompleteHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.Extra.Info.LeftRoutteRate > 0f)
			{
				int num = (int)(client.Player.Extra.Info.LeftRoutteRate * 100f);
				WorldMgr.SendSysTipNotice(LanguageMgr.GetTranslation("GameServer.LeftRotter.Notice.Msg", client.Player.PlayerCharacter.NickName, num));
			}
			return 0;
        }
    }
}
