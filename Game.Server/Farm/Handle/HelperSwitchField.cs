using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(9)]
	public class HelperSwitchField : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			string msg = LanguageMgr.GetTranslation("Kích hoạt trợ thủ thất bại!");
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			int seedTime = packet.ReadInt();
			int num2 = packet.ReadInt();
			int getCount = packet.ReadInt();
			int num3 = packet.ReadInt();
			int num4 = packet.ReadInt();
			bool flag2 = false;
			if (flag)
			{
				if (Player.MoneyDirect(num4, IsAntiMult: false, false) && num3 == -1)
				{
					flag2 = true;
				}
				else if (Player.PlayerCharacter.GiftToken < num4 || num3 != -2)
				{
					msg = ((num3 != -1) ? LanguageMgr.GetTranslation("Xu khóa không đủ!") : LanguageMgr.GetTranslation("Xu không đủ!"));
				}
				else
				{
					Player.RemoveGiftToken(num4);
					flag2 = true;
				}
			}
			else
			{
				msg = LanguageMgr.GetTranslation("Hủy trợ thủ thành công!");
				Player.Farm.CropHelperSwitchField(isStopFarmHelper: true);
			}
			if (flag2)
			{
				msg = LanguageMgr.GetTranslation("Kích hoạt trợ thủ thành công!");
				Player.Farm.HelperSwitchField(flag, num, seedTime, num2, getCount);
				Player.FarmBag.RemoveTemplate(num, num2);
			}
			Player.SendMessage(eMessageType.GM_NOTICE, msg);
			return true;
        }
    }
}
