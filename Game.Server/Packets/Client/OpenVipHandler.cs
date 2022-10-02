using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.Managers;
using System;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
	[PacketHandler(92, "场景用户离开")]
	public class OpenVipHandler : IPacketHandler
	{
		private int TotalPrice(int renewal)
		{
			ShopItemInfo itemVipInfo = ShopMgr.FindShopbyTemplateID((int)EquipType.VIPCARD);
			if (itemVipInfo == null)
				return -1;
            int result = 0;
			if (renewal == itemVipInfo.AUnit)
			{
				result = itemVipInfo.AValue1;
			}
			else
			if (renewal == itemVipInfo.BUnit)
			{
				result = itemVipInfo.BValue1;
			}
			else
			if (renewal == itemVipInfo.CUnit)
			{
				result = itemVipInfo.CValue1;
			}
			else {
				result = (int)Math.Ceiling((float)itemVipInfo.AValue1 * (float)renewal / itemVipInfo.AUnit);
			}
                    
            return result;
        }
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			string nickname = packet.ReadString();
			int renewval_days = packet.ReadInt();
			int money = TotalPrice(renewval_days);
			string msg = "Kích hoạt VIP thành công!";

			GamePlayer player = WorldMgr.GetClientByPlayerNickName(nickname);
			DailyRecordInfo dailyRecord = new DailyRecordInfo();
			dailyRecord.UserID = client.Player.PlayerCharacter.ID;
			dailyRecord.Type = 6;
			dailyRecord.Value = "VIP";
			if (client.Player.MoneyDirect(money, false, false))
			{
				DateTime now = DateTime.Now;
				int typeVIP = (int)client.Player.SetTypeVIP(renewval_days);
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{

					playerBussiness.VIPRenewal(nickname, renewval_days, typeVIP, ref now);
					if (player == null)
					{
						msg = "Người chơi " + nickname + " không tồn tại hoặc tạm vắng!";
					}
					else
					{
						if (client.Player.PlayerCharacter.NickName == nickname)
						{
							if (client.Player.PlayerCharacter.VIPLevel == 9)
							{
								msg = "Bạn đã đạt cấp VIP tối đa!";
								client.Player.SendMessage(msg);
								return 0;
							}
							else
							{
								if (client.Player.PlayerCharacter.typeVIP == 0)
								{
									client.Player.OpenVIP(renewval_days, now);
								}
								else
								{
									client.Player.ContinuousVIP(renewval_days, now);
									msg = "Gia hạn VIP thành công!";
								}
							}
							client.Player.AddExpVip(money);
							if (client.Player.PlayerCharacter.typeVIP > 0)
								client.Player.PlayerCharacter.VIPNextLevelDaysNeeded = client.Player.GetVIPNextLevelDaysNeeded(client.Player.PlayerCharacter.VIPLevel, client.Player.PlayerCharacter.VIPExp);
							client.Out.SendOpenVIP(client.Player);
						}
						else
						{
							string message2;
							if (player.PlayerCharacter.typeVIP == 0)
							{
								player.OpenVIP(renewval_days, now);
								msg = "Kích hoạt VIP cho " + nickname + " thàng công!";
								message2 = client.Player.PlayerCharacter.NickName + ", tiếp phí VIP cho bạn thành công!";
							}
							else
							{
								player.ContinuousVIP(renewval_days, now);
								msg = "Gia hạn VIP cho " + nickname + " thàng công!";
								message2 = client.Player.PlayerCharacter.NickName + ", gia hạn VIP cho bạn thành công!";
							}
							player.AddExpVip(money);
							if (player.PlayerCharacter.typeVIP > 0)
								player.PlayerCharacter.VIPNextLevelDaysNeeded = player.GetVIPNextLevelDaysNeeded(player.PlayerCharacter.VIPLevel, player.PlayerCharacter.VIPExp);
							player.Out.SendOpenVIP(player);
							player.Out.SendMessage(eMessageType.Normal, message2);
						}
					}
					client.Out.SendMessage(eMessageType.Normal, msg);
					
				}
			}
			return 0;
		}
	}
}
