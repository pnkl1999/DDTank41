using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler((int)ePackageType.AUCTION_UPDATE, "更新拍卖")]
	public class AuctionUpdateHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int auctionID = packet.ReadInt();
			int money = packet.ReadInt();
			bool val = false;
			int num3 = GameProperties.LimitLevel(0);

			// Chức năng của BAOLT - Lâm đừng copaste nha
			if (client.Player.isPlayerWarrior())
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, "Tài khoản không có quyền thực hiện chức năng này.");
				return 0;
			}
			if (client.Player.PlayerCharacter.Grade < num3)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, string.Format("Cần cấp {0} để thực hiện thao tác trên!.", num3));
				return 0;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(193, client.Player.PlayerCharacter.ID);
			string text = "AuctionUpdateHandler.Fail";
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				AuctionInfo auctionSingle = playerBussiness.GetAuctionSingle(auctionID);
				if (auctionSingle == null)
				{
					text = "AuctionUpdateHandler.Msg1";
				}
				else if (auctionSingle.PayType == 0 && money > client.Player.PlayerCharacter.Gold)
				{
					text = "AuctionUpdateHandler.Msg2";
				}
				else if (auctionSingle.PayType == 1 && !client.Player.MoneyDirect(money, IsAntiMult: true, true))
				{
					text = "";
				}
				else if (auctionSingle.BuyerID == 0 && auctionSingle.Price > money)
				{
					text = "AuctionUpdateHandler.Msg4";
				}
				else if (auctionSingle.BuyerID != 0 && auctionSingle.Price + auctionSingle.Rise > money && (auctionSingle.Mouthful == 0 || auctionSingle.Mouthful > money))
				{
					text = "AuctionUpdateHandler.Msg5";
				}
				else
				{
					int buyerID = auctionSingle.BuyerID;
					auctionSingle.BuyerID = client.Player.PlayerCharacter.ID;
					auctionSingle.BuyerName = client.Player.PlayerCharacter.NickName;
					auctionSingle.Price = money;
					if (auctionSingle.Mouthful != 0 && money >= auctionSingle.Mouthful)
					{
						auctionSingle.Price = auctionSingle.Mouthful;
						auctionSingle.IsExist = false;
					}
					if (playerBussiness.UpdateAuction(auctionSingle, GameProperties.Cess))
					{
						if (auctionSingle.PayType == 0)
						{
							client.Player.RemoveGold(auctionSingle.Price);
						}
						if (auctionSingle.IsExist)
						{
							text = "AuctionUpdateHandler.Msg6";
						}
						else
						{
							text = "AuctionUpdateHandler.Msg7";
							client.Out.SendMailResponse(auctionSingle.AuctioneerID, eMailRespose.Receiver);
							client.Out.SendMailResponse(auctionSingle.BuyerID, eMailRespose.Receiver);
						}
						if (buyerID != 0)
						{
							client.Out.SendMailResponse(buyerID, eMailRespose.Receiver);
						}
						val = true;
					}
				}
				client.Out.SendAuctionRefresh(auctionSingle, auctionID, auctionSingle?.IsExist ?? false, null);
				if (text != "")
				{
					client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(text));
				}
			}
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteInt(auctionID);
			client.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
