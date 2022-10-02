using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(15, "New User Answer Question")]
	public class UserAnswerHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			byte b = packet.ReadByte();
			int num = packet.ReadInt();
			bool flag = false;
			if (b == 1)
			{
				flag = packet.ReadBoolean();
			}
			if (b == 1)
			{
				List<ItemInfo> info = null;
				if (DropInventory.AnswerDrop(num, ref info))
				{
					int gold = 0;
					int money = 0;
					int giftToken = 0;
					int medal = 0;
					int honor = 0;
					int hardCurrency = 0;
					int token = 0;
					int dragonToken = 0;
					int magicStonePoint = 0;
					foreach (ItemInfo item in info)
					{
						ShopMgr.FindSpecialItemInfo(item, ref gold, ref money, ref giftToken, ref medal, ref honor, ref hardCurrency, ref token, ref dragonToken, ref magicStonePoint);
						if (item != null)
						{
							client.Player.AddTemplate(item, item.Template.BagType, item.Count, eGameView.CaddyTypeGet);
						}
						client.Player.AddGold(gold);
						client.Player.AddMoney(money);
						client.Player.AddGiftToken(giftToken);
					}
				}
				if (flag)
				{
					client.Player.PlayerCharacter.openFunction((Step)num);
				}
			}
			if (b == 2)
			{
				client.Player.PlayerCharacter.openFunction((Step)num);
			}
			client.Player.UpdateAnswerSite(num);
			return 1;
        }
    }
}
