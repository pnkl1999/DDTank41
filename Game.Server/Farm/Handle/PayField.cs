using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Packets;
using System.Collections.Generic;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(6)]
	public class PayField : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			string translation = LanguageMgr.GetTranslation("Mở rộng thành công!");
			List<int> list = new List<int>();
			int num = packet.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int item = packet.ReadInt();
				list.Add(item);
			}
			int num2 = packet.ReadInt();
			int num3 = 0;
			PlayerFarm farm = Player.Farm;
			num3 = ((farm.payFieldTimeToMonth() != num2) ? (num * farm.payFieldMoneyToWeek()) : (num * farm.payFieldMoneyToMonth()));
			if (Player.MoneyDirect(num3, IsAntiMult: false, false))
			{
				farm.PayField(list, num2);
				Player.SendMessage(eMessageType.GM_NOTICE, translation);
			}
			return true;
        }
    }
}
