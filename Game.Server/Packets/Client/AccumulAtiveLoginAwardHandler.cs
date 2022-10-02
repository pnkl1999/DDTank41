using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ACCUMULATIVELOGIN_AWARD, "撤消征婚信息")]
	public class AccumulAtiveLoginAwardHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			//Console.WriteLine("???>>>{0}", num);
			GSPacketIn gSPacketIn = new GSPacketIn((int)ePackageType.ACCUMULATIVELOGIN_AWARD, client.Player.PlayerCharacter.ID);
			string text = $"Nhận quà đăng nhập thất bại!";
			if (client.Player.PlayerCharacter.accumulativeAwardDays < client.Player.PlayerCharacter.accumulativeLoginDays)
			{
				for (int i = client.Player.PlayerCharacter.accumulativeAwardDays; i < client.Player.PlayerCharacter.accumulativeLoginDays; i++)
				{
					int num2 = i + 1;
					List<ItemInfo> list = new List<ItemInfo>();
					list = ((num2 < 7) ? AccumulActiveLoginMgr.GetAllAccumulAtiveLoginAward(num2) : AccumulActiveLoginMgr.GetSelecedAccumulAtiveLoginAward(num));
					if (list.Count > 0)
					{
						text = $"Quà đăng nhập {num2} ngày";
						WorldEventMgr.SendItemsToMails(list, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.ZoneId, null, text);
						client.Player.PlayerCharacter.accumulativeAwardDays++;
					}
					else
					{
						client.Player.SendMessage(text);
					}
				}
			}
			gSPacketIn.WriteInt(client.Player.PlayerCharacter.accumulativeLoginDays);
			gSPacketIn.WriteInt(client.Player.PlayerCharacter.accumulativeAwardDays);
			client.Player.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
