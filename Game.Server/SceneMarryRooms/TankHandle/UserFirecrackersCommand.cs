using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System.Linq;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(6)]
	public class UserFirecrackersCommand : IMarryCommandHandler
    {
        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom != null)
			{
				packet.ReadInt();
				ShopItemInfo shopItemInfo = ShopMgr.FindShopbyTemplatID(packet.ReadInt()).FirstOrDefault();
				if (shopItemInfo != null)
				{
					if (shopItemInfo.APrice1 == -2)
					{
						if (player.PlayerCharacter.Gold >= shopItemInfo.AValue1)
						{
							player.RemoveGold(shopItemInfo.AValue1);
							player.CurrentMarryRoom.ReturnPacketForScene(player, packet);
							player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("UserFirecrackersCommand.Successed1", shopItemInfo.AValue1));
							player.OnUsingItem(shopItemInfo.TemplateID, 1);
							return true;
						}
						player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("UserFirecrackersCommand.GoldNotEnough"));
					}
					if (shopItemInfo.APrice1 == -1)
					{
						if (player.PlayerCharacter.Money + player.PlayerCharacter.MoneyLock >= shopItemInfo.AValue1)
						{
							player.RemoveMoney(shopItemInfo.AValue1);
							player.CurrentMarryRoom.ReturnPacketForScene(player, packet);
							player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("UserFirecrackersCommand.Successed2", shopItemInfo.AValue1));
							player.OnUsingItem(shopItemInfo.TemplateID, 1);
							return true;
						}
						player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("UserFirecrackersCommand.MoneyNotEnough"));
					}
				}
			}
			return false;
        }
    }
}
