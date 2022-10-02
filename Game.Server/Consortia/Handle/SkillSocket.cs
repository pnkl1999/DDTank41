using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.SKILL_SOCKET)]
	public class SkillSocket : IConsortiaCommandHadler
	{
		public int CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				Player.Disconnect();
				return 0;
			}
			if (DateTime.Compare(Player.LastRequestTime.AddSeconds(2.0), DateTime.Now) > 0)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("GoSlow"));
				return 0;
			}
			Player.LastRequestTime = DateTime.Now;
			packet.ReadBoolean();
			int id = packet.ReadInt();
			int count = packet.ReadInt();
			int isMetal = packet.ReadInt();
			if (count < 0)
			{
				count = 1;
			}
			ConsortiaBuffTempInfo buffInfo = ConsortiaExtraMgr.FindConsortiaBuffInfo(id);
			if (buffInfo == null)
			{
				Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg1"));
				return 0;
			}
			bool isContinues = false;
			int needMoneyOrRiches;
			ConsortiaInfo myConsortia = ConsortiaMgr.FindConsortiaInfo(Player.PlayerCharacter.ConsortiaID);
			if (isMetal == 1)
			{
				needMoneyOrRiches = count * buffInfo.riches;
				if (Player.PlayerCharacter.Riches >= needMoneyOrRiches)
				{
					isContinues = true;
				}
			}
			else
			{
				needMoneyOrRiches = count * buffInfo.metal;
				if (Player.GetMedalNum() >= needMoneyOrRiches)
				{
					isContinues = true;
				}
			}
			int validate = 1440 * count;
			
			if (myConsortia != null && isContinues)
			{
				if (buffInfo.level <= myConsortia.Level)
				{
					if (isMetal == 1)
					{
						if (buffInfo.type == 1)
						{
							using (ConsortiaBussiness db = new ConsortiaBussiness())
                            {
								int riches = needMoneyOrRiches;
								db.ConsortiaRichRemove(Player.PlayerCharacter.ConsortiaID, ref riches);
							}
						}
						else
						{
							Player.RemoveRichesOffer(needMoneyOrRiches);
						}
					}
					else
					{
						Player.RemoveMedal(needMoneyOrRiches);
					}
					ConsortiaMgr.AddBuffConsortia(Player, buffInfo, Player.PlayerCharacter.ConsortiaID, id, validate);
					Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg4"));
				}
				else
				{
					Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg5"));
				}
			}
			else
			{
				Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg6"));
			}
			return 0;
		}
	}
}