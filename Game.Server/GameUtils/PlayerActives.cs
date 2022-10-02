using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.LittleGame;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Server.GameUtils
{
    public class PlayerActives
    {
        private ThreadSafeRandom rand = new ThreadSafeRandom();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected object m_lock;

        protected Timer _labyrinthTimer;

        protected GamePlayer m_player;

        private bool bool_0;

        private int int_0;

        private int[] m_openCardPrice;

        private int[] m_eagleEyePrice;

        private int m_freeOpenCardCount;

        private int m_freeEyeCount;

        private int m_flushPrice;

        private int m_freeFlushTime;

        private int m_freeRefreshBoxCount;

        private readonly int ChikenBoxCount = 18;

        private ActiveSystemInfo m_activeInfo;

        private NewChickenBoxItemInfo[] m_ChickenBoxRewards;

        private List<NewChickenBoxItemInfo> m_RemoveChickenBoxRewards;

        public readonly int coinTemplateID = 201193;

        private readonly int LuckyStartBoxCount = 14;

        private readonly int flushCoins = 15;//Xu tích lũy 1 cái

        private readonly int defaultCoins = 500;//Xu mặc định

        public GamePlayer Player => m_player;

        public NewChickenBoxItemInfo[] ChickenBoxRewards
        {
            get
            {
                return m_ChickenBoxRewards;
            }
            set
            {
                m_ChickenBoxRewards = value;
            }
        }

        public ActiveSystemInfo Info
        {
            get
            {
                return m_activeInfo;
            }
            set
            {
                m_activeInfo = value;
            }
        }

        public int flushPrice
        {
            get
            {
                return m_flushPrice;
            }
            set
            {
                m_flushPrice = value;
            }
        }

        public int freeEyeCount
        {
            get
            {
                return m_freeEyeCount;
            }
            set
            {
                m_freeEyeCount = value;
            }
        }

        public int freeOpenCardCount
        {
            get
            {
                return m_freeOpenCardCount;
            }
            set
            {
                m_freeOpenCardCount = value;
            }
        }

        public int freeFlushTime
        {
            get
            {
                return m_freeFlushTime;
            }
            set
            {
                m_freeFlushTime = value;
            }
        }

        public int freeRefreshBoxCount
        {
            get
            {
                return m_freeRefreshBoxCount;
            }
            set
            {
                freeRefreshBoxCount = value;
            }
        }

        public int[] openCardPrice
        {
            get
            {
                return m_openCardPrice;
            }
            set
            {
                m_openCardPrice = value;
            }
        }

        public int[] eagleEyePrice
        {
            get
            {
                return m_eagleEyePrice;
            }
            set
            {
                m_eagleEyePrice = value;
            }
        }

        public PlayerActives(GamePlayer player, bool saveTodb)
        {
            m_lock = new object();
            int_0 = GameProperties.WarriorFamRaidTimeRemain;
            m_player = player;
            bool_0 = saveTodb;
            m_openCardPrice = GameProperties.ConvertStringArrayToIntArray("NewChickenOpenCardPrice");
            m_eagleEyePrice = GameProperties.ConvertStringArrayToIntArray("NewChickenEagleEyePrice");
            m_flushPrice = GameProperties.NewChickenFlushPrice;
            m_freeFlushTime = 120;
            m_freeRefreshBoxCount = 0;
            m_freeOpenCardCount = 0;
            m_freeEyeCount = 0;
            m_RemoveChickenBoxRewards = new List<NewChickenBoxItemInfo>();
            SetupLuckyStart();
        }

        private void method_0()
        {
            int num = 1000;
            if (_labyrinthTimer == null)
            {
                _labyrinthTimer = new Timer(LabyrinthCheck, null, num, num);
            }
            else
            {
                _labyrinthTimer.Change(num, num);
            }
        }

        protected void LabyrinthCheck(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                UpdateLabyrinthTime();
                Thread.CurrentThread.Priority = priority;
                _ = Environment.TickCount;
            }
            catch (Exception ex)
            {
                Console.WriteLine("LabyrinthCheck: " + ex);
            }
        }

        public void StopLabyrinthTimer()
        {
            if (_labyrinthTimer != null)
            {
                _labyrinthTimer.Change(-1, -1);
                _labyrinthTimer.Dispose();
                _labyrinthTimer = null;
            }
        }

        public void UpdateLabyrinthTime()
        {
            UserLabyrinthInfo labyrinth = Player.Labyrinth;
            labyrinth.isCleanOut = true;
            labyrinth.isInGame = true;
            if (labyrinth.remainTime > 0 && labyrinth.currentRemainTime > 0)
            {
                labyrinth.remainTime--;
                labyrinth.currentRemainTime--;
                int_0--;
            }
            if (int_0 == 0)
            {
                method_1();
                int_0 = 120;
                labyrinth.currentFloor++;
                if (labyrinth.currentFloor > labyrinth.myProgress)
                {
                    labyrinth.currentFloor = labyrinth.myProgress;
                    labyrinth.isCleanOut = false;
                    labyrinth.isInGame = false;
                    labyrinth.completeChallenge = false;
                    labyrinth.remainTime = 0;
                    labyrinth.currentRemainTime = 0;
                    labyrinth.cleanOutAllTime = 0;
                    StopLabyrinthTimer();
                }
            }
            Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
        }

        public void CleantOutLabyrinth()
        {
            method_0();
        }

        private void method_1()
        {
            int num = m_player.Labyrinth.currentFloor - 1;
            int num2 = m_player.CreateExps()[num];
            string text = m_player.labyrinthGolds[num];
            int num3 = int.Parse(text.Split('|')[0]);
            int num4 = int.Parse(text.Split('|')[1]);
            if (m_player.PropBag.GetItemByTemplateID(0, 11916) == null || !m_player.RemoveTemplate(11916, 1))
            {
                m_player.Labyrinth.isDoubleAward = false;
            }
            if (m_player.Labyrinth.isDoubleAward)
            {
                num2 *= 2;
                num3 *= 2;
                num4 *= 2;
            }
            m_player.Labyrinth.accumulateExp += num2;
            List<ItemInfo> list = new List<ItemInfo>();
            if (method_2())
            {
                list = m_player.CopyDrop(2, 40002);
                m_player.AddTemplate(list, num3, eGameView.dungeonTypeGet);
                m_player.AddHardCurrency(num4);
            }
            m_player.AddGP(num2, false);
            method_3(m_player.Labyrinth.currentFloor, num2, num4, list);
        }

        private bool method_2()
        {
            bool result = false;
            for (int i = 0; i <= m_player.Labyrinth.myProgress; i += 2)
            {
                if (i == m_player.Labyrinth.currentFloor)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        private void method_3(int int_1, int int_2, int int_3, List<ItemInfo> ht0VOBWhZvOfbkW24XT)
        {
            if (ht0VOBWhZvOfbkW24XT == null)
            {
                ht0VOBWhZvOfbkW24XT = new List<ItemInfo>();
            }
            GSPacketIn gSPacketIn = new GSPacketIn(131, m_player.PlayerId);
            gSPacketIn.WriteByte(7);
            gSPacketIn.WriteInt(int_1);
            gSPacketIn.WriteInt(int_2);
            gSPacketIn.WriteInt(ht0VOBWhZvOfbkW24XT.Count);
            foreach (ItemInfo item in ht0VOBWhZvOfbkW24XT)
            {
                gSPacketIn.WriteInt(item.TemplateID);
                gSPacketIn.WriteInt(item.Count);
            }
            gSPacketIn.WriteInt(int_3);
            m_player.SendTCP(gSPacketIn);
        }

        public void StopCleantOutLabyrinth()
        {
            UserLabyrinthInfo labyrinth = Player.Labyrinth;
            labyrinth.isCleanOut = false;
            Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
            StopLabyrinthTimer();
        }

        public void SpeededUpCleantOutLabyrinth()
        {
            UserLabyrinthInfo labyrinth = Player.Labyrinth;
            labyrinth.isCleanOut = false;
            labyrinth.isInGame = false;
            labyrinth.completeChallenge = false;
            labyrinth.remainTime = 0;
            labyrinth.currentRemainTime = 0;
            labyrinth.cleanOutAllTime = 0;
            for (int i = labyrinth.currentFloor; i <= labyrinth.myProgress; i++)
            {
                method_1();
                labyrinth.currentFloor++;
            }
            labyrinth.currentFloor = labyrinth.myProgress;
            Player.Out.SendLabyrinthUpdataInfo(Player.PlayerId, labyrinth);
            StopLabyrinthTimer();
        }

        public void EnterChickenBox()
        {
            if (m_ChickenBoxRewards == null)
            {
                LoadChickenBox();
            }
        }

        public void LoadChickenBox()
        {
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            m_ChickenBoxRewards = playerBussiness.GetSingleNewChickenBox(Player.PlayerCharacter.ID);
            if (m_ChickenBoxRewards.Length == 0)
            {
                PayFlushView();
            }
        }

        public bool UpdateChickenBoxAward(NewChickenBoxItemInfo box)
        {
            for (int i = 0; i < m_ChickenBoxRewards.Length; i++)
            {
                if (m_ChickenBoxRewards[i].Position == box.Position)
                {
                    m_ChickenBoxRewards[i] = box;
                    return true;
                }
            }
            return false;
        }

        public NewChickenBoxItemInfo ViewAward(int pos)
        {
            NewChickenBoxItemInfo[] chickenBoxRewards = m_ChickenBoxRewards;
            foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in chickenBoxRewards)
            {
                if (newChickenBoxItemInfo.Position == pos && !newChickenBoxItemInfo.IsSeeded)
                {
                    return newChickenBoxItemInfo;
                }
            }
            return null;
        }

        public NewChickenBoxItemInfo GetAward(int pos)
        {
            NewChickenBoxItemInfo[] chickenBoxRewards = m_ChickenBoxRewards;
            foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in chickenBoxRewards)
            {
                if (newChickenBoxItemInfo.Position == pos && !newChickenBoxItemInfo.IsSelected)
                {
                    return newChickenBoxItemInfo;
                }
            }
            return null;
        }

        public void RandomPosition()
        {
            List<int> list = new List<int>();
            for (int i = 0; i < m_ChickenBoxRewards.Length; i++)
            {
                list.Add(m_ChickenBoxRewards[i].Position);
            }
            rand.Shuffer(m_ChickenBoxRewards);
            for (int j = 0; j < list.Count; j++)
            {
                m_ChickenBoxRewards[j].Position = list[j];
            }
        }

        public NewChickenBoxItemInfo[] CreateChickenBoxAward(int count, eEventType DataId)
        {
            List<NewChickenBoxItemInfo> list = new List<NewChickenBoxItemInfo>();
            Dictionary<int, NewChickenBoxItemInfo> dictionary = new Dictionary<int, NewChickenBoxItemInfo>();
            int num = 0;
            int num2 = 0;
            while (list.Count < count)
            {
                List<NewChickenBoxItemInfo> newChickenBoxAward = EventAwardMgr.GetNewChickenBoxAward(DataId);
                if (newChickenBoxAward.Count > 0)
                {
                    NewChickenBoxItemInfo newChickenBoxItemInfo = newChickenBoxAward[0];
                    if (!dictionary.Keys.Contains(newChickenBoxItemInfo.TemplateID))
                    {
                        dictionary.Add(newChickenBoxItemInfo.TemplateID, newChickenBoxItemInfo);
                        newChickenBoxItemInfo.Position = num;
                        list.Add(newChickenBoxItemInfo);
                        num++;
                    }
                }
                num2++;
            }
            return list.ToArray();
        }

        public NewChickenBoxItemInfo[] CreateLuckyStartAward(int count, eEventType DataId)
        {
            List<NewChickenBoxItemInfo> infos = new List<NewChickenBoxItemInfo>();
            Dictionary<int, NewChickenBoxItemInfo> temp = new Dictionary<int, NewChickenBoxItemInfo>();
            int position = 0;
            for (int i = 0; infos.Count < count; i++)
            {
                List<NewChickenBoxItemInfo> list = EventAwardMgr.GetLuckyStartAward(DataId);
                if (list.Count > 0)
                {
                    NewChickenBoxItemInfo item = list[0];
                    if (!temp.Keys.Contains(item.TemplateID))
                    {
                        temp.Add(item.TemplateID, item);
                        item.Position = position;
                        infos.Add(item);
                        position++;
                    }
                }
            }
            return infos.ToArray();
        }

        public void RemoveChickenBoxRewards()
        {
            for (int i = 0; i < m_ChickenBoxRewards.Length; i++)
            {
                NewChickenBoxItemInfo newChickenBoxItemInfo = m_ChickenBoxRewards[i];
                if (newChickenBoxItemInfo != null && newChickenBoxItemInfo.ID > 0)
                {
                    newChickenBoxItemInfo.Position = -1;
                    m_RemoveChickenBoxRewards.Add(newChickenBoxItemInfo);
                }
            }
        }

        public void PayFlushView()
        {
            m_activeInfo.lastFlushTime = DateTime.Now;
            m_activeInfo.isShowAll = true;
            m_activeInfo.canOpenCounts = 5;
            m_activeInfo.canEagleEyeCounts = 5;
            RemoveChickenBoxRewards();
            m_ChickenBoxRewards = CreateChickenBoxAward(ChikenBoxCount, eEventType.CHICKEN_BOX);
            for (int i = 0; i < m_ChickenBoxRewards.Length; i++)
            {
                m_ChickenBoxRewards[i].UserID = Player.PlayerCharacter.ID;
            }
        }

        public bool IsFreeFlushTime()
        {
            DateTime lastFlushTime = Info.lastFlushTime;
            DateTime d = lastFlushTime.AddMinutes(freeFlushTime);
            TimeSpan timeSpan = DateTime.Now - Info.lastFlushTime;
            double num = (d - lastFlushTime).TotalMinutes - timeSpan.TotalMinutes;
            return num > 0.0;
        }

        public void SendChickenBoxItemList()
        {
            GSPacketIn gSPacketIn = new GSPacketIn(87);
            gSPacketIn.WriteInt(3);
            gSPacketIn.WriteDateTime(Info.lastFlushTime);
            gSPacketIn.WriteInt(freeFlushTime);
            gSPacketIn.WriteInt(freeRefreshBoxCount);
            gSPacketIn.WriteInt(freeEyeCount);
            gSPacketIn.WriteInt(freeOpenCardCount);
            gSPacketIn.WriteBoolean(Info.isShowAll);
            gSPacketIn.WriteInt(ChickenBoxRewards.Length);
            NewChickenBoxItemInfo[] chickenBoxRewards = ChickenBoxRewards;
            foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in chickenBoxRewards)
            {
                gSPacketIn.WriteInt(newChickenBoxItemInfo.TemplateID);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.StrengthenLevel);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.Count);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.ValidDate);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.AttackCompose);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.DefendCompose);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.AgilityCompose);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.LuckCompose);
                gSPacketIn.WriteInt(newChickenBoxItemInfo.Position);
                gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsSelected);
                gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsSeeded);
                gSPacketIn.WriteBoolean(newChickenBoxItemInfo.IsBinds);
            }
            m_player.SendTCP(gSPacketIn);
        }

        public bool IsChickenBoxOpen()
        {
            Convert.ToDateTime(GameProperties.NewChickenBeginTime);
            DateTime dateTime = Convert.ToDateTime(GameProperties.NewChickenEndTime);
            return DateTime.Now.Date < dateTime.Date;
        }

        public void SendEvent()
        {
            if (IsChickenBoxOpen())
            {
                m_player.Out.SendChickenBoxOpen(m_player.PlayerId, flushPrice, openCardPrice, eagleEyePrice);
            }
            if (IsLuckStarActivityOpen())
            {
                m_player.Out.SendLuckStarOpen(m_player.PlayerId);
            }
        }

        public void CreateActiveSystemInfo(int UserID, string name)
        {
            lock (m_lock)
            {
                m_activeInfo = new ActiveSystemInfo();
                m_activeInfo.ID = 0;
                m_activeInfo.UserID = UserID;
                m_activeInfo.canEagleEyeCounts = 5;
                m_activeInfo.canOpenCounts = 5;
                m_activeInfo.isShowAll = true;
                m_activeInfo.lastFlushTime = DateTime.Now;
                m_activeInfo.ChickActiveData = "0";
                m_activeInfo.LuckystarCoins = defaultCoins;
                m_activeInfo.ActiveMoney = 0;
            }
        }

        public virtual void LoadFromDatabase()
        {
            if (!bool_0)
            {
                return;
            }
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            m_activeInfo = playerBussiness.GetSingleActiveSystem(Player.PlayerCharacter.ID);
            if (m_activeInfo == null)
            {
                CreateActiveSystemInfo(Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName);
            }
        }

        public virtual void SaveToDatabase()
        {
            if (!bool_0)
            {
                return;
            }
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            if (m_activeInfo != null && m_activeInfo.IsDirty)
            {
                if (m_activeInfo.ID > 0)
                {
                    playerBussiness.UpdateActiveSystem(m_activeInfo);
                }
                else
                {
                    playerBussiness.AddActiveSystem(m_activeInfo);
                }
            }
            if (m_ChickenBoxRewards != null)
            {
                NewChickenBoxItemInfo[] chickenBoxRewards = m_ChickenBoxRewards;
                foreach (NewChickenBoxItemInfo newChickenBoxItemInfo in chickenBoxRewards)
                {
                    if (newChickenBoxItemInfo?.IsDirty ?? false)
                    {
                        if (newChickenBoxItemInfo.ID > 0)
                        {
                            playerBussiness.UpdateNewChickenBox(newChickenBoxItemInfo);
                        }
                        else
                        {
                            playerBussiness.AddNewChickenBox(newChickenBoxItemInfo);
                        }
                    }
                }
            }
            if (m_RemoveChickenBoxRewards.Count <= 0)
            {
                return;
            }
            foreach (NewChickenBoxItemInfo removeChickenBoxReward in m_RemoveChickenBoxRewards)
            {
                playerBussiness.UpdateNewChickenBox(removeChickenBoxReward);
            }
        }

        public void SendLittleGameActived()
        {
            GSPacketIn gSPacketIn = new GSPacketIn(80);
            gSPacketIn.WriteBoolean(LittleGameWorldMgr.IsOpen);
            m_player.SendTCP(gSPacketIn);
        }

        #region Code Ga Hanh
        public string DefaultChickActiveData()
        {
            return "0,0," + DateTime.Now + "," + DateTime.Now.ToShortDateString() + "," + DateTime.Now.ToShortDateString() + "," + DateTime.Now.ToShortDateString() + ",0";
        }

        public UserChickActiveInfo GetChickActiveData()
        {
            UserChickActiveInfo userChick = null;
            // get data
            if (m_activeInfo.ChickActiveData == "0")
                m_activeInfo.ChickActiveData = DefaultChickActiveData();

            string[] chickDataArr = m_activeInfo.ChickActiveData.Split(',');

            if (chickDataArr.Length > 0)
            {
                userChick = new UserChickActiveInfo();
                userChick.IsKeyOpened = int.Parse(chickDataArr[0]);
                userChick.KeyOpenedType = int.Parse(chickDataArr[1]);
                userChick.KeyOpenedTime = DateTime.Parse(chickDataArr[2]);
                userChick.EveryDay = DateTime.Parse(chickDataArr[3]);
                userChick.Weekly = DateTime.Parse(chickDataArr[4]);
                userChick.AfterThreeDays = DateTime.Parse(chickDataArr[5]);
                userChick.CurrentLvAward = int.Parse(chickDataArr[6]);
            }

            return userChick;
        }

        public bool SaveChickActiveData(UserChickActiveInfo data)
        {
            if (data != null)
            {
                string[] chickDataArr = new string[] { data.IsKeyOpened.ToString(), data.KeyOpenedType.ToString(), data.KeyOpenedTime.ToString(), data.EveryDay.ToShortDateString(), data.Weekly.ToShortDateString(), data.AfterThreeDays.ToShortDateString(), data.CurrentLvAward.ToString() };
                // covert to string
                m_activeInfo.ChickActiveData = string.Join(",", chickDataArr);
                return true;
            }
            return false;
        }
        public void SendUpdateChickActivation()
        {
            UserChickActiveInfo chickInfo = GetChickActiveData();
            if (chickInfo != null)
            {
                GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ACTIVITY_PACKAGE);
                pkg.WriteInt((int)ChickActivationType.CHICKACTIVATION);
                pkg.WriteInt((int)ChickActivationType.CHICKACTIVATION_UPDATE);
                pkg.WriteInt(chickInfo.IsKeyOpened);
                pkg.WriteInt(1);
                pkg.WriteDateTime(chickInfo.KeyOpenedTime);
                pkg.WriteInt(chickInfo.KeyOpenedType);

                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Monday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Tuesday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Wednesday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Thursday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Friday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Saturday) ? 0 : 1);
                pkg.WriteInt((chickInfo.EveryDay.Day < DateTime.Now.Day && DateTime.Now.DayOfWeek == DayOfWeek.Sunday) ? 0 : 1);
                pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                pkg.WriteInt((chickInfo.AfterThreeDays.Day < DateTime.Now.Day && chickInfo.OnThreeDay(DateTime.Now)) ? 0 : 1);
                pkg.WriteInt((chickInfo.Weekly < chickInfo.StartOfWeek(DateTime.Now, DayOfWeek.Saturday) && DateTime.Now.DayOfWeek == DayOfWeek.Saturday) ? 0 : 1);
                pkg.WriteInt(chickInfo.CurrentLvAward);
                m_player.SendTCP(pkg);
            }
        }
        #endregion

        #region Ngôi sao
        private DateTime m_luckyBegindate;
        public DateTime LuckyBegindate
        {
            get { return m_luckyBegindate; }
            set { m_luckyBegindate = value; }
        }
        private DateTime m_luckyEnddate;
        public DateTime LuckyEnddate
        {
            get { return m_luckyEnddate; }
            set { m_luckyEnddate = value; }
        }
        private int m_minUseNum;
        public int minUseNum
        {
            get { return m_minUseNum; }
            set { m_minUseNum = value; }
        }
        private NewChickenBoxItemInfo[] m_LuckyStartRewards;
        private NewChickenBoxItemInfo m_award;
        public NewChickenBoxItemInfo Award
        {
            get { return m_award; }
            set { m_award = value; }
        }
        public DateTime LuckyStartStartTurn;
        public bool IsLuckStarActivityOpen()
        {
            DateTime end = Convert.ToDateTime(GameProperties.LuckStarActivityEndDate);
            return DateTime.Now.Date < end.Date;
        }
        private void SetupLuckyStart()
        {
            m_luckyBegindate = DateTime.Parse(GameProperties.LuckStarActivityBeginDate);
            m_luckyEnddate = DateTime.Parse(GameProperties.LuckStarActivityEndDate);
            m_minUseNum = GameProperties.MinUseNum;
            LuckyStartStartTurn = DateTime.Now;
        }
        public void CreateLuckyStartAward()
        {
            m_LuckyStartRewards = CreateLuckyStartAward(LuckyStartBoxCount, eEventType.LUCKY_STAR);
            NewChickenBoxItemInfo splItem = new NewChickenBoxItemInfo();
            splItem.TemplateID = coinTemplateID;
            splItem.StrengthenLevel = 0;
            splItem.Count = 1;
            splItem.IsBinds = true;
            splItem.Quality = 1;
            m_LuckyStartRewards[0] = splItem;
            ThreadSafeRandom.ShufferStatic(m_LuckyStartRewards);
        }
        public void ChangeLuckyStartAwardPlace()
        {
            ThreadSafeRandom.ShufferStatic(m_LuckyStartRewards);
        }

        public void SendLuckStarRewardRank()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.AWARD_RANK);
            List<LuckyStartToptenAwardInfo> infos = WorldEventMgr.GetLuckyStartToptenAward();
            pkg.WriteInt(infos.Count);
            foreach (LuckyStartToptenAwardInfo info in infos)
            {
                pkg.WriteInt(info.TemplateID);//_loc_8 = _loc_2.readInt();
                pkg.WriteInt(info.StrengthenLevel);//_loc_9.StrengthenLevel = _loc_2.readInt();
                pkg.WriteInt(info.Count); //_loc_9.Count = _loc_2.readInt();
                pkg.WriteInt(info.Validate);//_loc_9.ValidDate = _loc_2.readInt();
                pkg.WriteInt(info.AttackCompose);//_loc_9.AttackCompose = _loc_2.readInt();
                pkg.WriteInt(info.DefendCompose);//_loc_9.DefendCompose = _loc_2.readInt();
                pkg.WriteInt(info.AgilityCompose);//_loc_9.AgilityCompose = _loc_2.readInt();
                pkg.WriteInt(info.LuckCompose);//_loc_9.LuckCompose = _loc_2.readInt();
                pkg.WriteBoolean(info.IsBinds);//_loc_9.IsBinds = _loc_2.readBoolean();
                pkg.WriteInt(info.Type);//_loc_9.Quality = _loc_2.readInt();
            }
            m_player.SendTCP(pkg);
        }

        public void SendLuckStarAllGoodsInfo()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.ALL_GOODS_INFO);
            pkg.WriteInt(m_activeInfo.LuckystarCoins);//_model.coins = _loc_2.readInt();
            pkg.WriteDateTime(LuckyBegindate);
            pkg.WriteDateTime(LuckyEnddate);//_model.setActivityDate(_loc_2.readDate(), _loc_2.readDate());
            pkg.WriteInt(minUseNum);//_model.minUseNum = _loc_2.readInt();
            int _loc_3 = m_LuckyStartRewards.Length;
            int _loc_5 = 0;
            pkg.WriteInt(_loc_3);
            while (_loc_5 < _loc_3)
            {
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].TemplateID);
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].StrengthenLevel);//_loc_9.StrengthenLevel = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].Count); //_loc_9.Count = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].ValidDate);//_loc_9.ValidDate = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].AttackCompose);//_loc_9.AttackCompose = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].DefendCompose);//_loc_9.DefendCompose = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].AgilityCompose);//_loc_9.AgilityCompose = _loc_2.readInt();
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].LuckCompose);//_loc_9.LuckCompose = _loc_2.readInt();
                pkg.WriteBoolean(m_LuckyStartRewards[_loc_5].IsBinds);//_loc_9.IsBinds = _loc_2.readBoolean();  
                pkg.WriteInt(m_LuckyStartRewards[_loc_5].Quality);
                _loc_5++;
            }
            m_player.SendTCP(pkg);
        }

        public void SendLuckStarRewardRecord()
        {
            List<LuckStarRewardRecordInfo> infos = ActiveSystemMgr.RecordList;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.REWARD_RECORD);
            pkg.WriteInt(infos.Count);
            foreach (LuckStarRewardRecordInfo info in infos)
            {
                pkg.WriteInt(info.TemplateID);//_loc_8 = _loc_2.readInt();
                pkg.WriteInt(info.Count); //_loc_9.Count = _loc_2.readInt();
                pkg.WriteString(info.nickName);//nickName
            }
            m_player.SendTCP(pkg);
        }

        private void GetAward()
        {
            int ind = rand.Next(m_LuckyStartRewards.Length - 1);
            NewChickenBoxItemInfo itemAward = m_LuckyStartRewards[ind];

            int maxRandom = 0;
            foreach (var item in m_LuckyStartRewards)
            {
                item.StartRandom = maxRandom;
                maxRandom += item.Random;
                item.EndRandom = maxRandom;
            }

            int randomValue = rand.Next(maxRandom);

            foreach (var item in m_LuckyStartRewards)
            {
                if(randomValue >= item.StartRandom && item.EndRandom > randomValue)
                {
                    itemAward = item;
                    break;
                }
            }

            if (itemAward.TemplateID == coinTemplateID && rand.Next(100) > 3)
            {
                List<NewChickenBoxItemInfo> temps = new List<NewChickenBoxItemInfo>();
                foreach (NewChickenBoxItemInfo item in m_LuckyStartRewards)
                {
                    if (item.TemplateID != coinTemplateID)
                    {
                        temps.Add(item);
                    }
                }

                maxRandom = 0;
                foreach (var item in temps)
                {
                    item.StartRandom = maxRandom;
                    maxRandom += item.Random;
                    item.EndRandom = maxRandom;
                }

                randomValue = rand.Next(maxRandom);

                foreach (var item in temps)
                {
                    if (randomValue >= item.StartRandom && item.EndRandom > randomValue)
                    {
                        itemAward = item;
                        break;
                    }
                }
                //ind = rand.Next(temps.Count - 1);
                //itemAward = temps[ind];
            }


            //if (itemAward.TemplateID == coinTemplateID && rand.Next(100) > 3 && rand.Next(100))
            //{
            //    List<NewChickenBoxItemInfo> temps = new List<NewChickenBoxItemInfo>();
            //    foreach (NewChickenBoxItemInfo item in m_LuckyStartRewards)
            //    {
            //        if (item.TemplateID != coinTemplateID)
            //        {
            //            temps.Add(item);
            //        }
            //    }
            //    ind = rand.Next(temps.Count - 1);
            //    itemAward = temps[ind];
            //}

            lock (m_lock)
            {
                m_award = itemAward;
            }
        }

        public void SendLuckStarTurnGoodsInfo()
        {
            GetAward();
            m_activeInfo.LuckystarCoins += flushCoins;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.GOODS_INFO);
            pkg.WriteInt(m_activeInfo.LuckystarCoins);//_model.coins = _loc_2.readInt();
            pkg.WriteInt(Award.TemplateID);
            pkg.WriteInt(Award.StrengthenLevel);//_loc_9.StrengthenLevel = _loc_2.readInt();
            pkg.WriteInt(Award.Count); //_loc_9.Count = _loc_2.readInt();
            pkg.WriteInt(Award.ValidDate);//_loc_9.ValidDate = _loc_2.readInt();
            pkg.WriteInt(Award.AttackCompose);//_loc_9.AttackCompose = _loc_2.readInt();
            pkg.WriteInt(Award.DefendCompose);//_loc_9.DefendCompose = _loc_2.readInt();
            pkg.WriteInt(Award.AgilityCompose);//_loc_9.AgilityCompose = _loc_2.readInt();
            pkg.WriteInt(Award.LuckCompose);//_loc_9.LuckCompose = _loc_2.readInt();
            pkg.WriteBoolean(Award.IsBinds);//_loc_9.IsBinds = _loc_2.readBoolean();              
            m_player.SendTCP(pkg);
            if (Award.TemplateID == coinTemplateID)
            {
                if (GameProperties.IsActiveMoney)
                {
                    m_player.AddActiveMoney(m_activeInfo.LuckystarCoins);
                }
                else
                {
                    m_player.LogAddMoney(AddMoneyType.LuckyStar, AddMoneyType.LuckyStar_Add, m_player.PlayerCharacter.ID, m_activeInfo.LuckystarCoins, m_player.PlayerCharacter.Money);
                    m_player.AddMoney(m_activeInfo.LuckystarCoins);
                }
                m_activeInfo.LuckystarCoins = defaultCoins;
            }
            ActiveSystemMgr.UpdateLuckStarRewardRecord(m_player.PlayerCharacter.ID, m_player.PlayerCharacter.NickName, Award.TemplateID, Award.Count, m_player.PlayerCharacter.typeVIP);
        }

        public void SendUpdateReward()
        {
            if (Award.TemplateID == coinTemplateID)
                return;
            GSPacketIn pkg = new GSPacketIn((byte)Game.Server.Packets.ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.PLAY_REWARD_INFO);
            pkg.WriteInt(Award.TemplateID);
            pkg.WriteInt(Award.Count); //_loc_9.Count = _loc_2.readInt();
            pkg.WriteString(m_player.PlayerCharacter.NickName);
            m_player.SendTCP(pkg);
        }

        public GSPacketIn SendLuckStarClose()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, m_player.PlayerId);
            pkg.WriteInt((int)NewChickenBoxPackageType.ACTIVITY_END);
            m_player.SendTCP(pkg);
            return pkg;
        }
        #endregion
    }
}
