using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(213, "更新征婚信息")]
	public class MarryInfoUpdateHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.PlayerCharacter.MarryInfoID == 0)
			{
				return 1;
			}
			bool isPublishEquip = packet.ReadBoolean();
			string introduction = packet.ReadString();
			int marryInfoID = client.Player.PlayerCharacter.MarryInfoID;
			string translateId = "MarryInfoUpdateHandler.Fail";
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				MarryInfo marryInfoSingle = playerBussiness.GetMarryInfoSingle(marryInfoID);
				if (marryInfoSingle == null)
				{
					translateId = "MarryInfoUpdateHandler.Msg1";
				}
				else
				{
					marryInfoSingle.IsPublishEquip = isPublishEquip;
					marryInfoSingle.Introduction = introduction;
					marryInfoSingle.RegistTime = DateTime.Now;
					if (playerBussiness.UpdateMarryInfo(marryInfoSingle))
					{
						translateId = "MarryInfoUpdateHandler.Succeed";
					}
				}
				client.Out.SendMarryInfoRefresh(marryInfoSingle, marryInfoID, marryInfoSingle != null);
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(translateId));
			}
			return 0;
        }
    }
}
