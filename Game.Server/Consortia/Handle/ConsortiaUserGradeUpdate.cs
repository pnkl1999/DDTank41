using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE)]
	public class ConsortiaUserGradeUpdate : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			int num = packet.ReadInt();
			bool flag = packet.ReadBoolean();
			bool val = false;
			string msg = "ConsortiaUserGradeUpdateHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				string tempUserName = "";
				ConsortiaDutyInfo info = new ConsortiaDutyInfo();
				if (consortiaBussiness.UpdateConsortiaUserGrade(num, Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, flag, ref msg, ref info, ref tempUserName))
				{
					msg = "ConsortiaUserGradeUpdateHandler.Success";
					val = true;
					GameServer.Instance.LoginServer.SendConsortiaDuty(info, flag ? 6 : 7, Player.PlayerCharacter.ConsortiaID, num, tempUserName, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName);
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(18);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteBoolean(flag);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
