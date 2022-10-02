using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(8)]
	public class HelperPayField : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			string translation = LanguageMgr.GetTranslation("Gia hạn trợ thủ thành công!");
			int num = packet.ReadInt();
			int num2 = 0;
			PlayerFarm farm = Player.Farm;
			num2 = ((farm.payAutoTimeToMonth() != num) ? 100 : 300);
			if (Player.MoneyDirect(num2, IsAntiMult: false, false))
			{
				UserFarmInfo userFarmInfo = new UserFarmInfo();
				userFarmInfo.AutoValidDate = num;
				Player.SendMessage(eMessageType.GM_NOTICE, translation);
				Player.Out.SendHelperSwitchField(Player.PlayerCharacter, userFarmInfo);
			}
			return true;
        }
    }
}
