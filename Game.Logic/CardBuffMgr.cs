using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Logic.Game.Logic
{
    public class CardBuffMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, CardInfo> m_cards = new Dictionary<int, CardInfo>();

        private static Dictionary<int, List<CardGroupInfo>> m_cardGroups = new Dictionary<int, List<CardGroupInfo>>();

        private static Dictionary<int, List<CardBuffInfo>> m_cardBuffs = new Dictionary<int, List<CardBuffInfo>>();

        public static bool ReLoad()
        {
			try
			{
				CardGroupInfo[] tempCardGroup = LoadCardGroupDb();
				Dictionary<int, List<CardGroupInfo>> tempCardGroups = LoadCardGroups(tempCardGroup);
				if (tempCardGroup.Length != 0)
				{
					Interlocked.Exchange(ref m_cardGroups, tempCardGroups);
				}
				Dictionary<int, CardInfo> tempCards = LoadFromDatabase();
				if (tempCards.Values.Count > 0)
				{
					Interlocked.Exchange(ref m_cards, tempCards);
				}
				CardBuffInfo[] tempCardBuff = LoadCardBuffDb();
				Dictionary<int, List<CardBuffInfo>> tempCardBuffs = LoadCardBuffs(tempCardBuff);
				if (tempCardBuff.Length != 0)
				{
					Interlocked.Exchange(ref m_cardBuffs, tempCardBuffs);
				}
				//Console.WriteLine("report CardInfo:{0}, CardBuffInfo:{1}, CardGroupInfo:{2}", m_cards.Count, m_cardBuffs.Count, m_cardGroups.Count);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoad CardGroup", e);
				}
				return false;
			}
			return true;
        }

        public static bool Init()
        {
			return ReLoad();
        }

        public static CardBuffInfo[] LoadCardBuffDb()
        {
			using ProduceBussiness pb = new ProduceBussiness();
			return pb.GetAllCardBuff();
        }

        public static Dictionary<int, List<CardBuffInfo>> LoadCardBuffs(CardBuffInfo[] cardBuffs)
        {
			Dictionary<int, List<CardBuffInfo>> infos = new Dictionary<int, List<CardBuffInfo>>();
			foreach (CardBuffInfo info in cardBuffs)
			{
				if (!infos.Keys.Contains(info.CardID))
				{
					IEnumerable<CardBuffInfo> temp = cardBuffs.Where((CardBuffInfo s) => s.CardID == info.CardID);
					infos.Add(info.CardID, temp.ToList());
				}
			}
			return infos;
        }

        public static List<CardBuffInfo> FindCardBuffs(int id)
        {
			if (m_cardBuffs.ContainsKey(id))
			{
				List<CardBuffInfo> items = new List<CardBuffInfo>();
				foreach (CardBuffInfo card in m_cardBuffs[id])
				{
					if (card.Condition > 0)
					{
						items.Add(card);
					}
				}
				return items.OrderByDescending((CardBuffInfo a) => a.Condition).ToList();
			}
			return null;
        }

        private static Dictionary<int, CardInfo> LoadFromDatabase()
        {
			Dictionary<int, CardInfo> list = new Dictionary<int, CardInfo>();
			using (ProduceBussiness db = new ProduceBussiness())
			{
				CardInfo[] cardInfos = db.GetAllCard();
				CardInfo[] array = cardInfos;
				foreach (CardInfo info in array)
				{
					if (!list.ContainsKey(info.ID))
					{
						list.Add(info.ID, info);
					}
				}
			}
			return list;
        }

        public static Dictionary<int, List<CardGroupInfo>> GetAllCard()
        {
			return m_cardGroups;
        }

        public static CardInfo FindCard(int id)
        {
			if (m_cards.Count == 0)
			{
				Init();
			}
			if (m_cards.ContainsKey(id))
			{
				return m_cards[id];
			}
			return null;
        }

        public static CardGroupInfo[] LoadCardGroupDb()
        {
			using ProduceBussiness pb = new ProduceBussiness();
			return pb.GetAllCardGroup();
        }

        public static Dictionary<int, List<CardGroupInfo>> LoadCardGroups(CardGroupInfo[] cardGroups)
        {
			Dictionary<int, List<CardGroupInfo>> infos = new Dictionary<int, List<CardGroupInfo>>();
			foreach (CardGroupInfo info in cardGroups)
			{
				if (!infos.Keys.Contains(info.CardID))
				{
					IEnumerable<CardGroupInfo> temp = cardGroups.Where((CardGroupInfo s) => s.CardID == info.CardID);
					infos.Add(info.CardID, temp.ToList());
				}
			}
			return infos;
        }

        public static List<CardGroupInfo> FindCardGroups(int id)
        {
			if (m_cardGroups.ContainsKey(id))
			{
				return m_cardGroups[id];
			}
			return null;
        }
    }
}
