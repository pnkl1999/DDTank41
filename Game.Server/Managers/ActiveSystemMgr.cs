using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using log4net.Util;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;
using Game.Server.GameObjects;

namespace Game.Server.Managers
{
    public class ActiveSystemMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Random rand;
        private static List<LuckStarRewardRecordInfo> m_recordList = new List<LuckStarRewardRecordInfo>();

        private static bool m_IsLeagueOpen;
        public static bool IsLeagueOpen
        {
            get { return m_IsLeagueOpen; }
            set { m_IsLeagueOpen = value; }
        }

        public static List<LuckStarRewardRecordInfo> RecordList
        {
            get { return m_recordList; }
        }

        private static int m_luckStarCountDown;
        public static bool Init()
        {
            try
            {
                rand = new Random();
                m_IsLeagueOpen = false;
                m_luckStarCountDown = Math.Abs((60 - DateTime.Now.Minute) - 30);
                return true;
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ActiveSystemMgr", e);
                return false;
            }
        }

        //LuckStarRewardRecord
        public static void UpdateLuckStarRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
        {
            AddRewardRecord(PlayerID, nickName, TemplateID, Count, isVip);
            GameServer.Instance.LoginServer.SendLuckStarRewardRecord(PlayerID, nickName, TemplateID, Count, isVip);
        }
        public static void AddRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
        {
            if (m_recordList.Count > 10)
                m_recordList.Clear();

            LuckStarRewardRecordInfo record = new LuckStarRewardRecordInfo();
            record.PlayerID = PlayerID;
            record.nickName = nickName;
            record.useStarNum = 1;
            record.TemplateID = TemplateID;
            record.Count = Count;
            record.isVip = isVip;
            m_recordList.Add(record);
        }

        public static void UpdateIsLeagueOpen(bool open)
        {
            m_IsLeagueOpen = open;

            GamePlayer[] players = WorldMgr.GetAllPlayers();
            foreach (GamePlayer p in players)
            {
                if (p != null && p.PlayerCharacter.ID > 0)
                {
                    if (open)
                    {
                        p.Out.SendLeagueNotice(p.PlayerCharacter.ID, p.BattleData.MatchInfo.restCount, p.BattleData.maxCount, 1);
                    }
                    else
                    {
                        p.Out.SendLeagueNotice(p.PlayerCharacter.ID, p.BattleData.MatchInfo.restCount, p.BattleData.maxCount, 2);
                    }
                }
            }
        }
    }
}
