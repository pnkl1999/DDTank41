using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Xml.Linq;

namespace Center.Server
{
    public class WorldMgr
    {
        private static object _syncStop = new object();

        public static DateTime begin_time;

        public static string[] bossResourceId = new string[4]
		{
			"1",
			"2",
			"2",
			"4"
		};

        public static int current_blood = int.MaxValue;

        public static int currentPVE_ID;

        public static DateTime end_time;

        public static int fight_time;

        public static bool fightOver;

        public static bool IsLeagueOpen;

        public static bool isGoldTimesOpen;

        public static DateTime LeagueOpenTime;

        public static DateTime GoldTimeOpen;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<string, RankingPersonInfo> m_rankList;

        public static readonly int MAX_BLOOD = int.MaxValue;

        public static string[] name = new string[4]
		{
			"Chefão",
			"Chefe do Mundo",
			"WorldBoss",
			"Capitão do Futebol"
		};

        public static List<string> NotceList = new List<string>();

        public static int[] Pve_Id = new int[4]
		{
			1243,
			30001,
			30002,
			30004
		};

        public static bool roomClose;

        private static readonly int worldbossTime = 60;

        public static bool worldOpen;

        private static string SystemNoticeFile=> ConfigurationManager.AppSettings["SystemNoticePath"];

        public static bool CheckName(string NickName)
        {
			return m_rankList.Keys.Contains(NickName);
        }

        public static RankingPersonInfo GetSingleRank(string name)
        {
			return m_rankList[name];
        }

        public static bool LoadNotice(string path)
        {
			string str = path + SystemNoticeFile;
			if (!File.Exists(str))
			{
				log.Error("SystemNotice file : " + str + " not found !");
			}
			else
			{
				try
				{
					foreach (XElement element in XDocument.Load(str).Root.Nodes())
					{
						try
						{
							int.Parse(element.Attribute("id").Value);
							string item = element.Attribute("notice").Value;
							NotceList.Add(item);
						}
						catch (Exception exception)
						{
							log.Error("BattleMgr setup error:", exception);
						}
					}
				}
				catch (Exception exception2)
				{
					log.Error("BattleMgr setup error:", exception2);
				}
			}
			log.InfoFormat("Total {0} syterm notice loaded.", NotceList.Count);
			return true;
        }

        public static void ReduceBlood(int value)
        {
			if (current_blood > 0)
			{
				current_blood -= value;
			}
        }

        public static List<RankingPersonInfo> SelectTopTen()
        {
			List<RankingPersonInfo> list = new List<RankingPersonInfo>();
			IOrderedEnumerable<KeyValuePair<string, RankingPersonInfo>> enumerable = m_rankList.OrderByDescending((KeyValuePair<string, RankingPersonInfo> pair) => pair.Value.Damage);
			foreach (KeyValuePair<string, RankingPersonInfo> pair2 in enumerable)
			{
				if (list.Count == 10)
				{
					return list;
				}
				list.Add(pair2.Value);
			}
			return list;
        }

        public static void SetupWorldBoss(int id)
        {
			current_blood = MAX_BLOOD;
			begin_time = DateTime.Now;
			end_time = begin_time.AddDays(1.0);
			fight_time = worldbossTime - begin_time.Minute;
			fightOver = false;
			roomClose = false;
			currentPVE_ID = id;
			worldOpen = true;
        }

        public static bool Start()
        {
			try
			{
				m_rankList = new Dictionary<string, RankingPersonInfo>();
				current_blood = MAX_BLOOD;
				begin_time = DateTime.Now;
				LeagueOpenTime = DateTime.Now;
				GoldTimeOpen = DateTime.Now;
				end_time = begin_time.AddDays(1.0);
				fightOver = true;
				roomClose = true;
				worldOpen = false;
				IsLeagueOpen = false;
				return LoadNotice("");
			}
			catch (Exception exception)
			{
				log.ErrorFormat("Load server list from db failed:{0}", exception);
				return false;
			}
        }

        public static void UpdateFightTime()
        {
			if (!fightOver)
			{
				fight_time = worldbossTime - begin_time.Minute;
			}
        }

        public static void UpdateRank(int damage, int honor, string nickName)
        {
			if (m_rankList.Keys.Contains(nickName))
			{
				m_rankList[nickName].Damage += damage;
				m_rankList[nickName].Honor += honor;
				return;
			}
			RankingPersonInfo info = new RankingPersonInfo
			{
				ID = m_rankList.Count + 1,
				Name = nickName,
				Damage = damage,
				Honor = honor
			};
			m_rankList.Add(nickName, info);
        }

        public static void WorldBossClearRank()
        {
			m_rankList.Clear();
        }

        public static void WorldBossClose()
        {
			worldOpen = false;
        }

        public static void WorldBossFightOver()
        {
			fightOver = true;
        }

        public static void WorldBossRoomClose()
        {
			roomClose = true;
        }
    }
}
