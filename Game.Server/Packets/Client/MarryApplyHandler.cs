using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System.Linq;

namespace Game.Server.Packets.Client
{
    [PacketHandler(247, "求婚")]
	internal class MarryApplyHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.PlayerCharacter.IsMarried)
			{
				return 1;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				return 1;
			}
			int num = packet.ReadInt();
			string loveProclamation = packet.ReadString();
			packet.ReadBoolean();
			bool flag = true;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(num);
				if (userSingleByUserID == null || userSingleByUserID.Sex == client.Player.PlayerCharacter.Sex)
				{
					return 1;
				}
				if (userSingleByUserID.IsMarried)
				{
					client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg2"));
					return 1;
				}
				ItemInfo itemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, 11103);
				if (itemByTemplateID == null)
				{
					ShopItemInfo shopItemInfo = ShopMgr.FindShopbyTemplatID(11103).FirstOrDefault();
					if (shopItemInfo == null)
					{
						client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("MarryApplyHandler.Msg6"));
						return 1;
					}
					if (!client.Player.MoneyDirect(shopItemInfo.AValue1, IsAntiMult: false, false))
					{
						return 1;
					}
					flag = false;
				}
				MarryApplyInfo info = new MarryApplyInfo
				{
					UserID = num,
					ApplyUserID = client.Player.PlayerCharacter.ID,
					ApplyUserName = client.Player.PlayerCharacter.NickName,
					ApplyType = 1,
					LoveProclamation = loveProclamation,
					ApplyResult = false
				};
				int id = 0;
				if (playerBussiness.SavePlayerMarryNotice(info, 0, ref id))
				{
					if (flag)
					{
						client.Player.RemoveItem(itemByTemplateID);
					}
					else
					{
						ShopMgr.FindShopbyTemplatID(11103).FirstOrDefault();
					}
					client.Player.Out.SendPlayerMarryApply(client.Player, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, loveProclamation, id);
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(num);
					_ = userSingleByUserID.NickName;
					client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg3"));
				}
			}
			return 0;
        }
    }
}
