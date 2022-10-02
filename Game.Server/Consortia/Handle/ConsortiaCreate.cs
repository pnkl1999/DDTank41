using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;
using System.Text;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_CREATE)]
	public class ConsortiaCreate : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID != 0)
			{
				return 0;
			}
			ConsortiaLevelInfo consortiaLevelInfo = ConsortiaExtraMgr.FindConsortiaLevelInfo(1);
			string text = packet.ReadString();
			if (!string.IsNullOrEmpty(text) && Encoding.Default.GetByteCount(text) <= 12)
			{
				bool val = false;
				int num = 0;
				int needGold = consortiaLevelInfo.NeedGold;
				int num2 = 500;
				int num3 = 5;
				string msg = "ConsortiaCreateHandler.Failed";
				ConsortiaDutyInfo dutyInfo = new ConsortiaDutyInfo();
				if (!string.IsNullOrEmpty(text) && Player.PlayerCharacter.Gold >= needGold && Player.PlayerCharacter.Grade >= num3 && Player.PlayerCharacter.Money + Player.PlayerCharacter.MoneyLock >= num2)
				{
					using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
					ConsortiaInfo consortiaInfo = new ConsortiaInfo();
					consortiaInfo.BuildDate = DateTime.Now;
					consortiaInfo.CelebCount = 0;
					consortiaInfo.ChairmanID = Player.PlayerCharacter.ID;
					consortiaInfo.ChairmanName = Player.PlayerCharacter.NickName;
					consortiaInfo.ConsortiaName = text;
					consortiaInfo.CreatorID = consortiaInfo.ChairmanID;
					consortiaInfo.CreatorName = consortiaInfo.ChairmanName;
					consortiaInfo.Description = "";
					consortiaInfo.Honor = 0;
					consortiaInfo.IP = "";
					consortiaInfo.IsExist = true;
					consortiaInfo.Level = consortiaLevelInfo.Level;
					consortiaInfo.MaxCount = consortiaLevelInfo.Count;
					consortiaInfo.Riches = consortiaLevelInfo.Riches;
					consortiaInfo.Placard = "";
					consortiaInfo.Port = 0;
					consortiaInfo.Repute = 0;
					consortiaInfo.Count = 1;
					if (consortiaBussiness.AddConsortia(consortiaInfo, ref msg, ref dutyInfo))
					{
						Player.PlayerCharacter.ConsortiaID = consortiaInfo.ConsortiaID;
						Player.PlayerCharacter.ConsortiaName = consortiaInfo.ConsortiaName;
						Player.PlayerCharacter.DutyLevel = dutyInfo.Level;
						Player.PlayerCharacter.DutyName = dutyInfo.DutyName;
						Player.PlayerCharacter.Right = dutyInfo.Right;
						Player.PlayerCharacter.ConsortiaLevel = consortiaLevelInfo.Level;
						Player.RemoveGold(needGold);
						Player.RemoveMoney(num2);
						msg = "ConsortiaCreateHandler.Success";
						val = true;
						num = consortiaInfo.ConsortiaID;
						GameServer.Instance.LoginServer.SendConsortiaCreate(num, Player.PlayerCharacter.Offer, consortiaInfo.ConsortiaName);
					}
				}
				GSPacketIn gSPacketIn = new GSPacketIn(129);
				gSPacketIn.WriteByte(1);
				gSPacketIn.WriteString(text);
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteString(text);
				gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
				gSPacketIn.WriteInt(dutyInfo.Level);
				gSPacketIn.WriteString((dutyInfo.DutyName == null) ? "" : dutyInfo.DutyName);
				gSPacketIn.WriteInt(dutyInfo.Right);
				Player.Out.SendTCP(gSPacketIn);
				return 0;
			}
			Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ConsortiaCreateHandler.Long"));
			return 1;
        }
    }
}
