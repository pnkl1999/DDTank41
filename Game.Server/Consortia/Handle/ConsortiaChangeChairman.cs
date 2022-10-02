using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE)]
	public class ConsortiaChangeChairman : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			string text = packet.ReadString();
			bool val = false;
			string msg = "ConsortiaChangeChairmanHandler.Failed";
			if (string.IsNullOrEmpty(text))
			{
				msg = "ConsortiaChangeChairmanHandler.NoName";
			}
			else if (text == Player.PlayerCharacter.NickName)
			{
				msg = "ConsortiaChangeChairmanHandler.Self";
			}
			else
			{
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				string tempUserName = "";
				int tempUserID = 0;
				ConsortiaDutyInfo info = new ConsortiaDutyInfo();
				if (consortiaBussiness.UpdateConsortiaChairman(text, Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg, ref info, ref tempUserID, ref tempUserName))
				{
					ConsortiaDutyInfo consortiaDutyInfo = new ConsortiaDutyInfo();
					consortiaDutyInfo.Level = Player.PlayerCharacter.DutyLevel;
					consortiaDutyInfo.DutyName = Player.PlayerCharacter.DutyName;
					consortiaDutyInfo.Right = Player.PlayerCharacter.Right;
					msg = "ConsortiaChangeChairmanHandler.Success1";
					val = true;
					GameServer.Instance.LoginServer.SendConsortiaDuty(consortiaDutyInfo, 9, Player.PlayerCharacter.ConsortiaID, tempUserID, tempUserName, 0, "");
					GameServer.Instance.LoginServer.SendConsortiaDuty(info, 8, Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, 0, "");
				}
			}
			string translation = LanguageMgr.GetTranslation(msg);
			if (msg == "ConsortiaChangeChairmanHandler.Success1")
			{
				_ = translation + text + LanguageMgr.GetTranslation("ConsortiaChangeChairmanHandler.Success2");
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(19);
			gSPacketIn.WriteString(text);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
