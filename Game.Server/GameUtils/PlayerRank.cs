using Bussiness;
using Bussiness.Managers;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.GameUtils
{
    public class PlayerRank
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock = new object();

        protected GamePlayer m_player;

        private List<UserRankInfo> m_rank;

        private List<UserRankInfo> m_removeRank;

        private UserRankInfo m_currentRank;

        private bool m_saveToDb;

        public GamePlayer Player => m_player;

        public UserRankInfo CurrentRank => m_currentRank;

        public PlayerRank(GamePlayer player, bool saveToDb)
        {
            m_player = player;
            m_saveToDb = saveToDb;
            m_rank = new List<UserRankInfo>();
            m_removeRank = new List<UserRankInfo>();
        }

        public virtual void LoadFromDatabase()
        {
            if (!m_saveToDb)
            {
                return;
            }
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                try
                {
                    List<UserRankInfo> singleUserRank = pb.GetSingleUserRank(Player.PlayerCharacter.ID);
                    if (singleUserRank.Count == 0)
                    {
                        CreateRank(Player.PlayerCharacter.ID);
                        //return;
                    }
                    else
                    {
                        foreach (UserRankInfo item in singleUserRank)
                        {
                            if (item.IsValidRank())
                            {
                                AddRank(item);
                            }
                            else
                            {
                                RemoveRank(item);
                            }
                        }
                    }
                }
                finally
                {
                    UserRankDateInfo userRankDateInfo = RankMgr.FindRankDate(Player.PlayerCharacter.ID);
                    if (userRankDateInfo != null && userRankDateInfo.FightPower == 1)
                    {
                        AddNewRank(602, 1);
                        AddNewRank(688, 1);
                    }
                    else if (userRankDateInfo != null && userRankDateInfo.FightPower == 2)
                    {
                        AddNewRank(689, 1);
                    }
                    else if (userRankDateInfo != null && userRankDateInfo.FightPower == 3)
                    {
                        AddNewRank(690, 1);
                    }

                    if (userRankDateInfo != null && userRankDateInfo.ConsortiaFightPower == 1)
                    {
                        AddNewRank(827, 1);
                    }
                    else if (userRankDateInfo != null && userRankDateInfo.ConsortiaFightPower == 2)
                    {
                        AddNewRank(828, 1);
                    }
                    else if (userRankDateInfo != null && userRankDateInfo.ConsortiaFightPower == 3)
                    {
                        AddNewRank(829, 1);
                    }

                    if (!m_player.PlayerCharacter.IsVIPExpire())
                    {
                        if (m_player.PlayerCharacter.VIPLevel >= 5)
                        {
                            AddNewRank(1035, 1);
                        }
                        if (m_player.PlayerCharacter.VIPLevel >= 6)
                        {
                            AddNewRank(1036, 1);
                        }
                        if (m_player.PlayerCharacter.VIPLevel >= 7)
                        {
                            AddNewRank(1037, 1);
                        }
                        if (m_player.PlayerCharacter.VIPLevel >= 8)
                        {
                            AddNewRank(1038, 1);
                        }
                    }

                    UpdateCurrentRank();
                }
            }
        }

        public void AddBaseRankProperty(ref int attack, ref int defence, ref int agility, ref int lucky)
        {
            if (m_player.PlayerCharacter.ID > 0)
            {
                foreach (var item in m_rank)
                {
                    if (item.IsValidRank())
                    {
                        attack += item.Attack;
                        defence += item.Defence;
                        agility += item.Agility;
                        lucky += item.Luck;
                        if (NewTitleMgr.FindNewTitle(item.NewTitleID) != null)
                        {
                            attack += NewTitleMgr.FindNewTitle(item.NewTitleID).Att;
                            defence += NewTitleMgr.FindNewTitle(item.NewTitleID).Def;
                            agility += NewTitleMgr.FindNewTitle(item.NewTitleID).Agi;
                            lucky += NewTitleMgr.FindNewTitle(item.NewTitleID).Luck;
                        }
                    }
                }
            }
        }

        public void SendUserRanks()
        {
            Player.Out.SendUserRanks(Player.PlayerCharacter.ID, m_rank);
        }

        public bool UpdateCurrentRank()
        {
            lock (m_lock)
            {
                m_currentRank = GetSingleRank();
            }
            return CurrentRank != null;
        }

        public void AddNewRank(int id)
        {
            AddNewRank(id, 0);
        }

        public void AddNewRank(int id, int days)
        {
            NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(id);
            if (newTitleInfo != null)
            {
                UserRankInfo rankByHonnor = GetRankByHonnor(id);
                if (rankByHonnor == null)
                {
                    UserRankInfo userRankInfo = new UserRankInfo();
                    userRankInfo.Info = newTitleInfo;
                    userRankInfo.Name = newTitleInfo.Name;
                    userRankInfo.NewTitleID = newTitleInfo.ID;
                    userRankInfo.UserID = Player.PlayerCharacter.ID;
                    userRankInfo.BeginDate = DateTime.Now;
                    userRankInfo.EndDate = DateTime.Now.AddDays(days);
                    userRankInfo.Validate = days;
                    userRankInfo.IsExit = true;
                    AddRank(userRankInfo);
                }
                else
                {
                    rankByHonnor.IsExit = true;
                    rankByHonnor.EndDate = DateTime.Now.AddDays(days);
                }
                SendUserRanks();
            }
        }

        public void AddAchievementRank(string name)
        {
            NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitleByName(name);
            if (newTitleInfo != null)
            {
                UserRankInfo singleRank = GetSingleRank(name);
                if (singleRank == null)
                {
                    UserRankInfo userRankInfo = new UserRankInfo();
                    userRankInfo.Info = newTitleInfo;
                    userRankInfo.Name = newTitleInfo.Name;
                    userRankInfo.NewTitleID = newTitleInfo.ID;
                    userRankInfo.UserID = Player.PlayerCharacter.ID;
                    userRankInfo.BeginDate = DateTime.Now;
                    userRankInfo.EndDate = DateTime.Now;
                    userRankInfo.Validate = 0;
                    userRankInfo.IsExit = true;
                    AddRank(userRankInfo);
                }
                else
                {
                    singleRank.IsExit = true;
                    singleRank.EndDate = DateTime.Now;
                }
                SendUserRanks();
            }
        }

        public void AddRank(UserRankInfo rank)
        {
            lock (m_rank)
            {
                NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(rank.NewTitleID);
                if (newTitleInfo != null)
                {
                    rank.Info = newTitleInfo;
                }
                m_rank.Add(rank);
            }
        }

        public void RemoveRank(UserRankInfo item)
        {
            bool flag = false;
            lock (m_rank)
            {
                flag = m_rank.Remove(item);
            }
            if (flag)
            {
                item.IsExit = false;
                lock (m_removeRank)
                {
                    m_removeRank.Add(item);
                }
            }
        }

        public UserRankInfo GetSingleRank()
        {
            UserRankInfo rankByHonnor = GetRankByHonnor(m_player.PlayerCharacter.honorId);
            if (rankByHonnor != null && !rankByHonnor.IsValidRank())
            {
                m_player.PlayerCharacter.honorId = 0;
                m_player.PlayerCharacter.Honor = "";
                RemoveRank(rankByHonnor);
                return null;
            }
            return rankByHonnor;
        }

        public UserRankInfo GetSingleRank(string honor)
        {
            foreach (UserRankInfo item in m_rank)
            {
                if (item.Name.Contains(honor) && item.IsValidRank())
                {
                    return item;
                }
            }
            return null;
        }

        public UserRankInfo GetRankByHonnor(int honor)
        {
            foreach (UserRankInfo item in m_rank)
            {
                if (item.NewTitleID == honor)
                {
                    return item;
                }
            }
            return null;
        }

        public void CreateRank(int UserID)
        {
            List<UserRankInfo> list = new List<UserRankInfo>();
            NewTitleInfo newTitleInfo = NewTitleMgr.FindNewTitle(614);
            if (newTitleInfo != null)
            {
                UserRankInfo userRankInfo = new UserRankInfo();
                userRankInfo.Info = newTitleInfo;
                userRankInfo.ID = 0;
                userRankInfo.UserID = UserID;
                userRankInfo.NewTitleID = newTitleInfo.ID;
                userRankInfo.Name = newTitleInfo.Name;
                userRankInfo.BeginDate = DateTime.Now;
                userRankInfo.EndDate = DateTime.Now;
                userRankInfo.Validate = 0;
                userRankInfo.IsExit = true;
                AddRank(userRankInfo);
            }
        }

        public virtual void SaveToDatabase()
        {
            if (!m_saveToDb)
            {
                return;
            }
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            lock (m_lock)
            {
                foreach (UserRankInfo item in m_rank)
                {
                    if (item?.IsDirty ?? false)
                    {
                        if (item.ID > 0)
                        {
                            playerBussiness.UpdateUserRank(item);
                        }
                        else
                        {
                            playerBussiness.AddUserRank(item);
                        }
                    }
                }
                foreach (UserRankInfo item2 in m_removeRank)
                {
                    playerBussiness.UpdateUserRank(item2);
                }
                m_removeRank.Clear();
            }
        }
    }
}
