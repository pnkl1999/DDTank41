using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using System.Linq;

namespace Game.Server.Packets.Client
{
    [PacketHandler(54, "购买道具")]
	public class PropBuyHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int gold = 0;
			int money = 0;
			int offer = 0;
			int gifttoken = 0;
			int medal = 0;
			int damageScore = 0;
			int petScore = 0;
			int iTemplateID = 0;
			int iCount = 0;
			int hardCurrency = 0;
			int LeagueMoney = 0;
			int honor = 0;
			int iD = packet.ReadInt();
			int num = 1;
			ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(iD);
			if (PropItemMgr.PropFightBag.ToList().Contains(shopItemInfoById.TemplateID))
			{
				if (shopItemInfoById == null)
				{
					return 0;
				}
				ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
				ShopMgr.SetItemType(shopItemInfoById, num, ref damageScore, ref petScore, ref iTemplateID, ref iCount, ref gold, ref money, ref offer, ref gifttoken, ref medal, ref hardCurrency, ref LeagueMoney, ref medal, ref honor);
				if (itemTemplateInfo.CategoryID == 10)
				{
					PlayerInfo playerCharacter = client.Player.PlayerCharacter;
					if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked && (money > 0 || offer > 0 || gifttoken > 0 || medal > 0))
					{
						client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
						return 0;
					}
					if (gold <= playerCharacter.Gold && money <= ((playerCharacter.Money >= 0) ? playerCharacter.Money : 0) && offer <= playerCharacter.Offer && gifttoken <= playerCharacter.GiftToken && medal <= playerCharacter.medal)
					{
						ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, 1, 102);
						if (shopItemInfoById.BuyType == 0)
						{
							if (1 == num)
							{
								itemInfo.ValidDate = shopItemInfoById.AUnit;
							}
							if (2 == num)
							{
								itemInfo.ValidDate = shopItemInfoById.BUnit;
							}
							if (3 == num)
							{
								itemInfo.ValidDate = shopItemInfoById.CUnit;
							}
						}
						else
						{
							if (1 == num)
							{
								itemInfo.Count = shopItemInfoById.AUnit;
							}
							if (2 == num)
							{
								itemInfo.Count = shopItemInfoById.BUnit;
							}
							if (3 == num)
							{
								itemInfo.Count = shopItemInfoById.CUnit;
							}
						}
						if (client.Player.FightBag.AddItem(itemInfo, 0))
						{
							client.Player.RemoveGold(gold);
							client.Player.RemoveMoney(money);
							client.Player.RemoveOffer(offer);
							client.Player.RemoveGiftToken(gifttoken);
							client.Player.RemoveMedal(medal);
							client.Player.RemovemyHonor(honor);
						}
					}
					else
					{
						client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("PropBuyHandler.NoMoney"));
					}
				}
			}
			return 0;
        }
    }
}
