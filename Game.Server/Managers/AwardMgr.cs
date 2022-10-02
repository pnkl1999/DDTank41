using Bussiness;
using Bussiness.Managers;
using Game.Server.Buffer;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;

namespace Game.Server.Managers
{
    public class AwardMgr
    {
        private static Dictionary<int, DailyAwardInfo> _dailyAward;

        private static bool _dailyAwardState;

        private static Dictionary<int, SearchGoodsTempInfo> _searchGoodsTemp;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        public static bool DailyAwardState
        {
			get
			{
				return _dailyAwardState;
			}
			set
			{
				_dailyAwardState = value;
			}
        }

        public static bool AddEggAward(GamePlayer player)
        {
			if (DateTime.Now.Date != player.PlayerCharacter.LastGetEgg.Date)
			{
				player.PlayerCharacter.LastGetEgg = DateTime.Now;
			}
			return false;
        }

        public static bool AddDailyAward(GamePlayer player)
        {
			if (DateTime.Now.Date != player.PlayerCharacter.LastAward.Date)
			{
				player.PlayerCharacter.DayLoginCount++;
				player.PlayerCharacter.LastAward = DateTime.Now;
				DailyAwardInfo[] allAwardInfo = GetAllAwardInfo();
				DailyAwardInfo[] array = allAwardInfo;
				foreach (DailyAwardInfo dailyAwardInfo in array)
				{
					if (dailyAwardInfo.Type == 0)
					{
						ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(dailyAwardInfo.TemplateID);
						if (itemTemplateInfo != null)
						{
							BufferList.CreateBufferMinutes(itemTemplateInfo, dailyAwardInfo.ValidDate).Start(player);
							return true;
						}
					}
				}
			}
			return false;
        }

        public static bool AddSignAwards(GamePlayer player, int DailyLog)
        {
			GetAllAwardInfo();
			DailyAwardInfo[] singleDailyAward = new ProduceBussiness().GetSingleDailyAward(DailyLog);
			new StringBuilder();
			string value = string.Empty;
			bool flag = false;
			int templateId = 0;
			int num = 1;
			int validDate = 0;
			bool isBinds = true;
			bool result = false;
			DailyAwardInfo[] array = singleDailyAward;
			foreach (DailyAwardInfo dailyAwardInfo in array)
			{
				flag = true;
				if (dailyAwardInfo.AwardDays == DailyLog && dailyAwardInfo.Type == 7)
				{
					player.AddGiftToken(dailyAwardInfo.Count);
					result = true;
				}
				switch (DailyLog)
				{
				case 6:
					if (dailyAwardInfo.AwardDays == DailyLog && dailyAwardInfo.Type != 7)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						isBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				case 3:
					if (dailyAwardInfo.AwardDays == DailyLog && dailyAwardInfo.Type != 7)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						isBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				case 18:
					if (dailyAwardInfo.AwardDays == DailyLog && dailyAwardInfo.Type != 7)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						isBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				case 12:
					if (dailyAwardInfo.AwardDays == DailyLog && dailyAwardInfo.Type != 7)
					{
						templateId = dailyAwardInfo.TemplateID;
						num = dailyAwardInfo.Count;
						validDate = dailyAwardInfo.ValidDate;
						isBinds = dailyAwardInfo.IsBinds;
						result = true;
					}
					break;
				}
				ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
				if (itemTemplateInfo == null)
				{
					continue;
				}
				int num2 = num;
				for (int j = 0; j < num2; j += itemTemplateInfo.MaxCount)
				{
					int count = ((j + itemTemplateInfo.MaxCount > num2) ? (num2 - j) : itemTemplateInfo.MaxCount);
					ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, count, 113);
					itemInfo.ValidDate = validDate;
					itemInfo.IsBinds = isBinds;
					if (!player.AddTemplate(itemInfo, itemInfo.Template.BagType, itemInfo.Count, eGameView.CaddyTypeGet))
					{
						flag = true;
						using PlayerBussiness playerBussiness = new PlayerBussiness();
						itemInfo.UserID = 0;
						playerBussiness.AddGoods(itemInfo);
						MailInfo mailInfo = new MailInfo();
						mailInfo.Annex1 = itemInfo.ItemID.ToString();
						mailInfo.Content = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Content", itemInfo.Template.Name);
						mailInfo.Gold = 0;
						mailInfo.Money = 0;
						mailInfo.Receiver = player.PlayerCharacter.NickName;
						mailInfo.ReceiverID = player.PlayerCharacter.ID;
						mailInfo.Sender = mailInfo.Receiver;
						mailInfo.SenderID = mailInfo.ReceiverID;
						mailInfo.Title = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Title", itemInfo.Template.Name);
						mailInfo.Type = 15;
						playerBussiness.SendMail(mailInfo);
						value = LanguageMgr.GetTranslation("AwardMgr.AddDailyAward.Mail");
					}
				}
			}
			if (flag && !string.IsNullOrEmpty(value))
			{
				player.Out.SendMailResponse(player.PlayerCharacter.ID, eMailRespose.Receiver);
			}
			return result;
        }

        public static DailyAwardInfo[] GetAllAwardInfo()
        {
			DailyAwardInfo[] array = null;
			m_lock.AcquireReaderLock(10000);
			try
			{
				array = _dailyAward.Values.ToArray();
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new DailyAwardInfo[0];
        }

        public static SearchGoodsTempInfo GetSearchGoodsTempInfo(int starId)
        {
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_searchGoodsTemp.ContainsKey(starId))
				{
					return _searchGoodsTemp[starId];
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_dailyAward = new Dictionary<int, DailyAwardInfo>();
				_searchGoodsTemp = new Dictionary<int, SearchGoodsTempInfo>();
				_dailyAwardState = false;
				return LoadDailyAward(_dailyAward, _searchGoodsTemp);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("AwardMgr", exception);
				}
				return false;
			}
        }

        private static bool LoadDailyAward(Dictionary<int, DailyAwardInfo> awards, Dictionary<int, SearchGoodsTempInfo> searchGoodsTemp)
        {
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				DailyAwardInfo[] allDailyAward = produceBussiness.GetAllDailyAward();
				DailyAwardInfo[] array = allDailyAward;
				foreach (DailyAwardInfo dailyAwardInfo in array)
				{
					if (!awards.ContainsKey(dailyAwardInfo.ID))
					{
						awards.Add(dailyAwardInfo.ID, dailyAwardInfo);
					}
				}
				SearchGoodsTempInfo[] allSearchGoodsTemp = produceBussiness.GetAllSearchGoodsTemp();
				SearchGoodsTempInfo[] array2 = allSearchGoodsTemp;
				foreach (SearchGoodsTempInfo searchGoodsTempInfo in array2)
				{
					if (!searchGoodsTemp.ContainsKey(searchGoodsTempInfo.StarID))
					{
						searchGoodsTemp.Add(searchGoodsTempInfo.StarID, searchGoodsTempInfo);
					}
				}
			}
			return true;
        }

        public static int MaxStar()
        {
			return _searchGoodsTemp.Count;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, DailyAwardInfo> dictionary = new Dictionary<int, DailyAwardInfo>();
				Dictionary<int, SearchGoodsTempInfo> searchGoodsTemp = new Dictionary<int, SearchGoodsTempInfo>();
				if (LoadDailyAward(dictionary, searchGoodsTemp))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_dailyAward = dictionary;
						_searchGoodsTemp = searchGoodsTemp;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("AwardMgr", exception);
				}
			}
			return false;
        }
    }
}
