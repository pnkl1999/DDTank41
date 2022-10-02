using Bussiness;
using Bussiness.Managers;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Managers
{
    public class AcademyMgr
    {
        public static readonly int LEVEL_GAP;

        public static readonly int TARGET_PLAYER_MIN_LEVEL;

        public static readonly int ACADEMY_LEVEL_MIN;

        public static readonly int ACADEMY_LEVEL_MAX;

        public static readonly int RECOMMEND_MAX_NUM;

        public static readonly int NONE_STATE;

        public static readonly int APPRENTICE_STATE;

        public static readonly int MASTER_STATE;

        public static readonly int MASTER_FULL_STATE;

        public static object m_object;

        private static List<AcademyRequestInfo> Requests;

        public static bool Init()
        {
			Requests = new List<AcademyRequestInfo>();
			return true;
        }

        public static void AddRequest(AcademyRequestInfo request)
        {
			lock (Requests)
			{
				Requests.Add(request);
			}
        }

        public static AcademyRequestInfo GetRequest(int senderid, int receiveid)
        {
			AcademyRequestInfo result = null;
			lock (Requests)
			{
				foreach (AcademyRequestInfo request in Requests)
				{
					if (request.SenderID == senderid && request.ReceiderID == receiveid)
					{
						return request;
					}
				}
				return result;
			}
        }

        public static void RemoveRequest(AcademyRequestInfo request)
        {
			lock (Requests)
			{
				Requests.Remove(request);
			}
        }

        public static void RemoveOldRequest()
        {
			List<AcademyRequestInfo> list = new List<AcademyRequestInfo>();
			lock (Requests)
			{
				foreach (AcademyRequestInfo request in Requests)
				{
					if (request.CreateTime.AddHours(1.0) < DateTime.Now)
					{
						list.Add(request);
					}
				}
			}
			if (list.Count <= 0)
			{
				return;
			}
			foreach (AcademyRequestInfo item in list)
			{
				RemoveRequest(item);
			}
        }

        public static bool FireApprentice(GamePlayer player, int uid, bool isSilent)
        {
			bool flag = false;
			lock (m_object)
			{
				if (flag = player.PlayerCharacter.RemoveMasterOrApprentices(uid))
				{
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						GamePlayer playerById = WorldMgr.GetPlayerById(uid);
						PlayerInfo playerInfo = ((playerById == null) ? playerBussiness.GetUserSingleByUserID(uid) : playerById.PlayerCharacter);
						if (playerInfo == null)
						{
							return flag;
						}
						playerInfo.RemoveMasterOrApprentices(playerInfo.masterID);
						playerInfo.masterID = 0;
						playerBussiness.UpdateAcademyPlayer(playerInfo);
						if (playerById == null)
						{
							return flag;
						}
						if (!isSilent)
						{
							playerById.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprenticeShipMsg.Apprentice", player.PlayerCharacter.NickName), isAlert: true);
						}
						playerById.Out.SendAcademyAppState(playerInfo, uid);
						return flag;
					}
				}
				return flag;
			}
        }

        public static bool FireMaster(GamePlayer player, bool isComplete)
        {
			bool flag = false;
			lock (m_object)
			{
				if (flag = player.PlayerCharacter.RemoveMasterOrApprentices(player.PlayerCharacter.masterID))
				{
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						GamePlayer playerById = WorldMgr.GetPlayerById(player.PlayerCharacter.masterID);
						PlayerInfo playerInfo = ((playerById == null) ? playerBussiness.GetUserSingleByUserID(player.PlayerCharacter.masterID) : playerById.PlayerCharacter);
						if (playerInfo == null)
						{
							return flag;
						}
						if (isComplete)
						{
							playerInfo.graduatesCount++;
						}
						playerInfo.RemoveMasterOrApprentices(player.PlayerId);
						playerBussiness.UpdateAcademyPlayer(playerInfo);
						if (playerById != null)
						{
							if (!isComplete)
							{
								playerById.Out.SendAcademySystemNotice(LanguageMgr.GetTranslation("Game.Server.AppSystem.BreakApprenticeShipMsg.Master", player.PlayerCharacter.NickName), isAlert: true);
							}
							playerById.Out.SendAcademyAppState(playerInfo, player.PlayerCharacter.ID);
						}
						player.PlayerCharacter.masterID = 0;
						return flag;
					}
				}
				return flag;
			}
        }

        public static bool AddApprentice(GamePlayer master, GamePlayer app)
        {
			bool flag = false;
			lock (m_object)
			{
				if (flag = master.PlayerCharacter.AddMasterOrApprentices(app.PlayerCharacter.ID, app.PlayerCharacter.NickName) && app.PlayerCharacter.masterID == 0)
				{
					app.PlayerCharacter.masterID = master.PlayerCharacter.ID;
					app.PlayerCharacter.AddMasterOrApprentices(master.PlayerCharacter.ID, master.PlayerCharacter.NickName);
					app.Out.SendAcademyAppState(app.PlayerCharacter, -1);
					master.Out.SendAcademyAppState(master.PlayerCharacter, -1);
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						playerBussiness.UpdateAcademyPlayer(app.PlayerCharacter);
						playerBussiness.UpdateAcademyPlayer(master.PlayerCharacter);
					}
					app.OnAcademyEvent(master, 0);
					master.OnAcademyEvent(app, 1);
					return flag;
				}
				return flag;
			}
        }

        public static void UpdateAwardApp(GamePlayer player, int oldLevel)
        {
			Dictionary<int, int> dictionary = GameProperties.AcademyApprenticeAwardArr();
			Dictionary<int, int> dictionary2 = GameProperties.AcademyMasterAwardArr();
			int masterID = player.PlayerCharacter.masterID;
			string translation = LanguageMgr.GetTranslation("Game.Server.Managers.AcademyMgr.TitleGraduated");
			GamePlayer playerById = WorldMgr.GetPlayerById(masterID);
			for (int i = oldLevel + 1; i <= player.PlayerCharacter.Grade; i++)
			{
				if (dictionary.ContainsKey(i))
				{
					ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(dictionary[i]), 1, 103);
					itemInfo.IsBinds = true;
					WorldEventMgr.SendItemToMail(itemInfo, player.PlayerCharacter.ID, player.PlayerCharacter.NickName, player.ZoneId, null, LanguageMgr.GetTranslation("Game.Server.AppSystem.GraduateBox.Success", i));
				}
				if (dictionary2.ContainsKey(i))
				{
					ItemInfo itemInfo2 = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(dictionary2[i]), 1, 103);
					itemInfo2.IsBinds = true;
					WorldEventMgr.SendItemToMail(itemInfo2, masterID, player.PlayerCharacter.MasterOrApprenticesArr[masterID], player.ZoneId, null, LanguageMgr.GetTranslation("Game.Server.AppSystem.TakeAppBox.Success", player.PlayerCharacter.NickName, i));
				}
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				if (playerById != null)
				{
					playerById.SendMailToUser(playerBussiness, LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeLevelUp.mailTitle", player.PlayerCharacter.NickName, i), LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeLevelUp.mailTitle", player.PlayerCharacter.NickName, i), eMailType.ItemOverdue);
					continue;
				}
				MailInfo mailInfo = new MailInfo();
				mailInfo.Content = LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeLevelUp.mailTitle", player.PlayerCharacter.NickName, i);
				mailInfo.Title = LanguageMgr.GetTranslation("Game.Server.AppSystem.ApprenticeLevelUp.mailTitle", player.PlayerCharacter.NickName, i);
				mailInfo.Gold = 0;
				mailInfo.IsExist = true;
				mailInfo.Money = 0;
				mailInfo.GiftToken = 0;
				mailInfo.Receiver = player.PlayerCharacter.MasterOrApprenticesArr[masterID];
				mailInfo.ReceiverID = masterID;
				mailInfo.Sender = player.PlayerCharacter.MasterOrApprenticesArr[masterID];
				mailInfo.SenderID = masterID;
				mailInfo.Type = 9;
				MailInfo mailInfo2 = mailInfo;
				mailInfo2.Annex1 = "";
				mailInfo2.Annex1Name = "";
				playerBussiness.SendMail(mailInfo2);
			}
			if (player.PlayerCharacter.Grade < ACADEMY_LEVEL_MIN)
			{
				return;
			}
			PlayerInfo playerInfo = null;
			if (playerById != null)
			{
				playerById.Out.SendAcademyGradute(player, 1);
				playerInfo = playerById.PlayerCharacter;
			}
			else
			{
				using PlayerBussiness playerBussiness2 = new PlayerBussiness();
				playerInfo = playerBussiness2.GetUserSingleByUserID(masterID);
			}
			string[] array = GameProperties.AcademyAppAwardComplete.Split(',')[player.PlayerCharacter.Sex ? 1 : 0].Split('|');
			List<ItemInfo> list = new List<ItemInfo>();
			string[] array2 = array;
			for (int j = 0; j < array2.Length; j++)
			{
				ItemInfo itemInfo3 = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(int.Parse(array2[j])), 1, 103);
				itemInfo3.ValidDate = 365;
				itemInfo3.IsBinds = true;
				list.Add(itemInfo3);
			}
			WorldEventMgr.SendItemsToMails(list, player.PlayerCharacter.ID, player.PlayerCharacter.NickName, player.ZoneId, null, LanguageMgr.GetTranslation("Game.Server.AppSystem.GraduateBox.Success"));
			string[] array3 = GameProperties.AcademyMasAwardComplete.Split(',')[playerInfo.Sex ? 1 : 0].Split('|');
			list.Clear();
			array2 = array3;
			for (int k = 0; k < array2.Length; k++)
			{
				ItemInfo itemInfo4 = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(int.Parse(array2[k])), 1, 103);
				itemInfo4.ValidDate = 3;
				itemInfo4.IsBinds = true;
				list.Add(itemInfo4);
			}
			WorldEventMgr.SendItemsToMail(list, playerInfo.ID, playerInfo.NickName, LanguageMgr.GetTranslation("Game.Server.AppSystem.GraduateBoxForMaster.MailTitle", player.PlayerCharacter.NickName), LanguageMgr.GetTranslation("Game.Server.AppSystem.GraduateBoxForMaster.MailContert"));
			FireMaster(player, isComplete: true);
			using (PlayerBussiness playerBussiness3 = new PlayerBussiness())
			{
				playerBussiness3.UpdateAcademyPlayer(player.PlayerCharacter);
			}
			player.Out.SendAcademyAppState(player.PlayerCharacter, masterID);
			player.Out.SendAcademyGradute(player, 0);
			player.Rank.AddAchievementRank(translation);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			for (int l = 0; l < allPlayers.Length; l++)
			{
				allPlayers[l].SendMessage(LanguageMgr.GetTranslation("Game.Server.AppSystem.MasterGainHonour.content", playerInfo.NickName, player.PlayerCharacter.NickName, translation));
			}
        }

        public static bool CheckCanApp(int levelApp)
        {
			if (levelApp >= TARGET_PLAYER_MIN_LEVEL)
			{
				return levelApp <= ACADEMY_LEVEL_MAX;
			}
			return false;
        }

        public static bool CheckCanMaster(int levelMaster)
        {
			return levelMaster >= ACADEMY_LEVEL_MIN;
        }

        static AcademyMgr()
        {
			LEVEL_GAP = 5;
			TARGET_PLAYER_MIN_LEVEL = 6;
			ACADEMY_LEVEL_MIN = 20;
			ACADEMY_LEVEL_MAX = 16;
			RECOMMEND_MAX_NUM = 3;
			NONE_STATE = 0;
			APPRENTICE_STATE = 1;
			MASTER_STATE = 2;
			MASTER_FULL_STATE = 3;
			m_object = new object();
        }
    }
}
