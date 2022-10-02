using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;

namespace Bussiness.Managers
{
    public class WorldEventMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        private static ThreadSafeRandom random = new ThreadSafeRandom();

		private static Dictionary<int, LuckyStartToptenAwardInfo> m_luckyStartToptenAward;
		public static bool SendItemsToMail(List<ItemInfo> infos, int PlayerId, string Nickname, string title, string content = null)
        {
			bool flag = false;
			using PlayerBussiness bussiness = new PlayerBussiness();
			List<ItemInfo> list = new List<ItemInfo>();
			foreach (ItemInfo info in infos)
			{
				if (info.Template.MaxCount == 1)
				{
					for (int j = 0; j < info.Count; j++)
					{
						ItemInfo item = ItemInfo.CloneFromTemplate(info.Template, info);
						item.Count = 1;
						list.Add(item);
					}
				}
				else
				{
					list.Add(info);
				}
			}
			for (int i = 0; i < list.Count; i += 5)
			{
				MailInfo mail = new MailInfo
				{
					Title = title,
					Content = content,
					Gold = 0,
					IsExist = true,
					Money = 0,
					Receiver = Nickname,
					ReceiverID = PlayerId,
					Sender = "Hệ Thống",
					SenderID = 0,
					Type = 9,
					GiftToken = 0
				};
				StringBuilder builder = new StringBuilder();
				StringBuilder builder2 = new StringBuilder();
				builder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
				int num3 = i;
				if (list.Count > num3)
				{
					ItemInfo info6 = list[num3];
					if (info6.ItemID == 0)
					{
						bussiness.AddGoods(info6);
					}
					mail.Annex1 = info6.ItemID.ToString();
					mail.Annex1Name = info6.Template.Name;
					builder.Append("1、" + mail.Annex1Name + "x" + info6.Count + ";");
					builder2.Append("1、" + mail.Annex1Name + "x" + info6.Count + ";");
				}
				num3 = i + 1;
				if (list.Count > num3)
				{
					ItemInfo info5 = list[num3];
					if (info5.ItemID == 0)
					{
						bussiness.AddGoods(info5);
					}
					mail.Annex2 = info5.ItemID.ToString();
					mail.Annex2Name = info5.Template.Name;
					builder.Append("2、" + mail.Annex2Name + "x" + info5.Count + ";");
					builder2.Append("2、" + mail.Annex2Name + "x" + info5.Count + ";");
				}
				num3 = i + 2;
				if (list.Count > num3)
				{
					ItemInfo info4 = list[num3];
					if (info4.ItemID == 0)
					{
						bussiness.AddGoods(info4);
					}
					mail.Annex3 = info4.ItemID.ToString();
					mail.Annex3Name = info4.Template.Name;
					builder.Append("3、" + mail.Annex3Name + "x" + info4.Count + ";");
					builder2.Append("3、" + mail.Annex3Name + "x" + info4.Count + ";");
				}
				num3 = i + 3;
				if (list.Count > num3)
				{
					ItemInfo info3 = list[num3];
					if (info3.ItemID == 0)
					{
						bussiness.AddGoods(info3);
					}
					mail.Annex4 = info3.ItemID.ToString();
					mail.Annex4Name = info3.Template.Name;
					builder.Append("4、" + mail.Annex4Name + "x" + info3.Count + ";");
					builder2.Append("4、" + mail.Annex4Name + "x" + info3.Count + ";");
				}
				num3 = i + 4;
				if (list.Count > num3)
				{
					ItemInfo info2 = list[num3];
					if (info2.ItemID == 0)
					{
						bussiness.AddGoods(info2);
					}
					mail.Annex5 = info2.ItemID.ToString();
					mail.Annex5Name = info2.Template.Name;
					builder.Append("5、" + mail.Annex5Name + "x" + info2.Count + ";");
					builder2.Append("5、" + mail.Annex5Name + "x" + info2.Count + ";");
				}
				mail.AnnexRemark = builder.ToString();
				mail.Content = mail.Content ?? builder2.ToString();
				flag = bussiness.SendMail(mail);
			}
			return flag;
        }

        public static bool SendItemToMail(ItemInfo info, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title)
        {
			return SendItemsToMail(new List<ItemInfo>
			{
				info
			}, PlayerId, Nickname, title);
        }

        public static bool SendItemsToMails(List<ItemInfo> infos, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title)
        {
			return SendItemsToMail(infos, PlayerId, Nickname, title);
        }

        public static bool SendItemsToMails(List<ItemInfo> infos, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title, string content)
        {
			return SendItemsToMail(infos, PlayerId, Nickname, title);
        }

        public static bool SendItemToMail(ItemInfo info, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title, string sender)
        {
			return SendItemsToMail(new List<ItemInfo>
			{
				info
			}, PlayerId, Nickname, title);
        }

        public static bool SendItemsToMail(List<ItemInfo> infos, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title, int type, string sender)
        {
			return SendItemsToMail(infos, PlayerId, Nickname, title);
        }

        public static bool SendItemsToMail(List<ItemInfo> infos, int PlayerId, string Nickname, int zoneId, AreaConfigInfo areaConfig, string title, string content)
        {
			return SendItemsToMail(infos, PlayerId, Nickname, title);
        }

		public static bool LoadData(Dictionary<int, LuckyStartToptenAwardInfo> luckyStarts)
		{
			using (ActiveBussiness db = new ActiveBussiness())
			{
				LuckyStartToptenAwardInfo[] luckyStartDbs = db.GetAllLuckyStartToptenAward();
				foreach (LuckyStartToptenAwardInfo award in luckyStartDbs)
				{
					if (!luckyStarts.Keys.Contains(award.ID))
					{
						luckyStarts.Add(award.ID, award);
					}
				}
			}
			return true;
		}

		public static List<LuckyStartToptenAwardInfo> GetLuckyStartToptenAward()
		{
			List<LuckyStartToptenAwardInfo> infos = new List<LuckyStartToptenAwardInfo>();
			foreach (LuckyStartToptenAwardInfo info in m_luckyStartToptenAward.Values)
			{
				infos.Add(info);
			}
			return infos;
		}

		public static List<LuckyStartToptenAwardInfo> GetLuckyStartAwardByRank(int rank)
		{
			int type = 0;
			switch (rank)
			{
				case 1:
					type = 11;
					break;
				case 2:
					type = 12;
					break;
				case 3:
					type = 13;
					break;
				case 4:
				case 5:
					type = 14;
					break;
				case 6:
				case 7:
					type = 15;
					break;

				case 8:
				case 9:
				case 10:
					type = 16;
					break;
			}
			List<LuckyStartToptenAwardInfo> infos = new List<LuckyStartToptenAwardInfo>();
			foreach (LuckyStartToptenAwardInfo info in m_luckyStartToptenAward.Values)
			{
				if (info.Type == type)
				{
					infos.Add(info);
				}
			}
			return infos;
		}

		public static bool Init()
		{
			try
			{
				m_luckyStartToptenAward = new Dictionary<int, LuckyStartToptenAwardInfo>();
				return LoadData(m_luckyStartToptenAward);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("Init", e);
				return false;
			}
		}

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, LuckyStartToptenAwardInfo> templuckyStartToptenAward = new Dictionary<int, LuckyStartToptenAwardInfo>();
				if (LoadData(templuckyStartToptenAward))
				{
					try
					{
						m_luckyStartToptenAward = templuckyStartToptenAward;
						return true;
					}
					catch
					{ }

				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
					log.Error("ReLoad", e);
			}

			return false;
		}
	}
}
