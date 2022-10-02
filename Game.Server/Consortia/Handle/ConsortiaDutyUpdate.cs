using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System.Text;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_DUTY_UPDATE)]
	public class ConsortiaDutyUpdate : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			int dutyID = packet.ReadInt();
			int num = packet.ReadByte();
			string msg = "ConsortiaDutyUpdateHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				ConsortiaDutyInfo consortiaDutyInfo = new ConsortiaDutyInfo();
				consortiaDutyInfo.ConsortiaID = Player.PlayerCharacter.ConsortiaID;
				consortiaDutyInfo.DutyID = dutyID;
				consortiaDutyInfo.IsExist = true;
				consortiaDutyInfo.DutyName = "";
				switch (num)
				{
				case 1:
					return 1;
				case 2:
					consortiaDutyInfo.DutyName = packet.ReadString();
					if (!string.IsNullOrEmpty(consortiaDutyInfo.DutyName) && Encoding.Default.GetByteCount(consortiaDutyInfo.DutyName) <= 10)
					{
						consortiaDutyInfo.Right = packet.ReadInt();
						break;
					}
					Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ConsortiaDutyUpdateHandler.Long"));
					return 1;
				}
				if (consortiaBussiness.UpdateConsortiaDuty(consortiaDutyInfo, Player.PlayerCharacter.ID, num, ref msg))
				{
					_ = consortiaDutyInfo.DutyID;
					GameServer.Instance.LoginServer.SendConsortiaDuty(consortiaDutyInfo, num, Player.PlayerCharacter.ConsortiaID);
				}
			}
			return 0;
        }
    }
}
