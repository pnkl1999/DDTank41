using Bussiness;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.GameUtils
{
    public class PlayerExtra
    {
        protected object m_lock;
        protected GamePlayer m_player;
        private UsersExtraInfo m_info;
        private Dictionary<int, EventRewardProcessInfo> m_eventInfo;
        private bool m_saveToDb;
        protected Timer _hotSpringTimer;
        protected Timer _pingTimeOnline;

        public GamePlayer Player => this.m_player;

        public UsersExtraInfo Info
        {
            get => this.m_info;
            set => this.m_info = value;
        }

        public PlayerExtra(GamePlayer player, bool saveTodb)
        {
            this.m_lock = new object();
            this.m_player = player;
            this.m_saveToDb = saveTodb;
        }

        public virtual void LoadFromDatabase()
        {
            if (!this.m_saveToDb)
                return;
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                this.m_info = playerBussiness.GetSingleUsersExtra(this.m_player.PlayerCharacter.ID);
                if (this.m_info == null)
                    this.m_info = this.CreateUserExtra(this.Player.PlayerCharacter.ID);
                this.m_eventInfo = new Dictionary<int, EventRewardProcessInfo>();
                foreach (EventRewardProcessInfo rewardProcessInfo in playerBussiness.GetUserEventProcess(this.m_player.PlayerCharacter.ID))
                {
                    if (!this.m_eventInfo.ContainsKey(rewardProcessInfo.ActiveType))
                        this.m_eventInfo.Add(rewardProcessInfo.ActiveType, rewardProcessInfo);
                }
            }
        }

        public UsersExtraInfo CreateUserExtra(int UserID)
        {
            UsersExtraInfo userExtraInfo = new UsersExtraInfo
            {
                UserID = UserID,
                LastTimeHotSpring = DateTime.Now,
                LastFreeTimeHotSpring = DateTime.Now,
                MinHotSpring = 60,
            };
            DateTime dateTime = DateTime.Now;
            dateTime = dateTime.AddDays(-1.0);
            userExtraInfo.LeftRoutteCount = GameProperties.LeftRouterMaxDay;
            userExtraInfo.LeftRoutteRate = 0.0f;
            return userExtraInfo;
        }

        public virtual void SaveToDatabase()
        {
            if (!this.m_saveToDb)
                return;
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                lock (this.m_lock)
                {
                    if (this.m_info != null && this.m_info.IsDirty)
                        playerBussiness.UpdateUserExtra(this.m_info);
                }
            }
        }

        public void BeginPingOnlineTimer()
        {
            int num = 60000;
            if (this._pingTimeOnline == null)
                this._pingTimeOnline = new Timer(new TimerCallback(this.PingTimeOnlineCheck), (object)null, num, num);
            else
                this._pingTimeOnline.Change(num, num);
        }

        public void StopPingOnlineTimer()
        {
            if (this._pingTimeOnline == null)
                return;
            this._pingTimeOnline.Dispose();
            this._pingTimeOnline = (Timer)null;
        }

        public void BeginHotSpringTimer()
        {
            int num = 60000;
            if (this._hotSpringTimer == null)
                this._hotSpringTimer = new Timer(new TimerCallback(this.HotSpringCheck), (object)null, num, num);
            else
                this._hotSpringTimer.Change(num, num);
        }

        public void StopHotSpringTimer()
        {
            if (this._hotSpringTimer == null)
                return;
            this._hotSpringTimer.Dispose();
            this._hotSpringTimer = (Timer)null;
        }

        public void StopAllTimer()
        {
            this.StopHotSpringTimer();
            this.StopPingOnlineTimer();
        }

        protected void PingTimeOnlineCheck(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                this.m_player.OnOnlineGameAdd(m_player);
                this.m_player.PlayerCharacter.CheckNewDay();
                Thread.CurrentThread.Priority = priority;
                int num = Environment.TickCount - tickCount;
            }
            catch (Exception ex)
            {
                Console.WriteLine("HotSpringCheck: " + (object)ex);
            }
        }

        protected void HotSpringCheck(object sender)
        {
            try
            {
                int tickCount = Environment.TickCount;
                ThreadPriority priority = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                if (m_player.CurrentHotSpringRoom == null)
                {
                    StopHotSpringTimer();
                }
                if (Info.MinHotSpring <= 0)
                {
                    this.m_player.SendMessage("Bạn đã hết giờ tham gia suối nước nóng.");
                    this.m_player.CurrentHotSpringRoom.RemovePlayer(this.m_player);
                }
                int getGP = HotSpringMgr.GetExpWithLevel(this.m_player.PlayerCharacter.Grade) / 10;
                int gp = 0;
                int honor = 50;
                int giftToken = 10;
                int gold = 50;
                if (getGP > 0)
                {
                    gp = getGP;
                    Info.MinHotSpring--;
                    m_player.OnPlayerSpa(1);
                    if (Info.MinHotSpring <= 5)
                    {
                        m_player.SendMessage("Bạn chỉ còn " + Info.MinHotSpring + " phút.");
                    }
                    //if (m_player.CurrentHotSpringRoom.Info.roomID > 4)
                    //{
                    //    gp = gp * 3 / 2;
                    //}
                    int vipLevel = m_player.UserVIPInfo.VIPLevel;
                    int total = 0;
                    if (vipLevel >= 3 && vipLevel <= 5)
                    {
                        total = 2;
                    }
                    else if (vipLevel > 5 && vipLevel <= 7)
                    {
                        total = 3;
                    }
                    else if (vipLevel >= 8)
                    {
                        total = 4;
                    }
                    else
                    {
                        total = 1;
                    }
                    gp = gp * total;
                    m_player.AddHonor(honor);
                    m_player.AddGiftToken(giftToken);
                    m_player.AddGold(gold);
                    if (m_player.CurrentHotSpringRoom.Info.roomID == 10)
                    {
                        if (m_player.PlayerCharacter.Grade >= 40)
                        {
                            m_player.RemoveGP(gp * vipLevel * 2);
                            m_player.SendMessage($"Bạn bị trừ {gp} kinh nghiệm. Nhận được {honor} vinh dự, {giftToken} xu khóa, {gold} vàng");
                        }
                        else
                        {
                            m_player.SendMessage($"Tính năng trừ kinh nghiệm chỉ hiệu quả cho nhân vật trên cấp 40!");
                            m_player.SendMessage($"Nhận được {honor} vinh dự, {giftToken} xu khóa, {gold} vàng");
                        }
                    }
                    else
                    {
                        m_player.AddGP(gp, false);
                        if (vipLevel >= 3)
                        {
                            m_player.SendMessage($"VIP [{vipLevel}] bạn nhận được x{total} kinh nghiêm. Số kinh nghiệm bạn nhận được là {gp} kinh nghiệm, {honor} vinh dự, {giftToken} xu khóa, {gold} vàng!");
                        }
                        else
                        {
                            m_player.SendMessage($"Bạn nhận được {gp} kinh nghiệm, {honor} vinh dự, {giftToken} xu khóa, {gold} vàng!");
                        }
                    }
                    m_player.Out.SendHotSpringUpdateTime(m_player, gp);
                    m_player.OnHotSpingExpAdd(Info.MinHotSpring, gp);
                }
                Thread.CurrentThread.Priority = priority;
                tickCount = Environment.TickCount - tickCount;
            }
            catch (Exception Err)
            {
                Console.WriteLine("HotSpringCheck: " + Err);
            }
        }

        public EventRewardProcessInfo GetEventProcess(int activeType)
        {
            lock (this.m_lock)
            {
                if (!this.m_eventInfo.ContainsKey(activeType))
                    this.m_eventInfo.Add(activeType, this.setValue(activeType));
                return this.m_eventInfo[activeType];
            }
        }

        public void UpdateEventCondition(int activeType, int value) => this.UpdateEventCondition(activeType, value, false, 0);

        public void UpdateEventCondition(int activeType, int value, bool isPlus, int awardGot)
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                EventRewardProcessInfo info = GetEventProcess(activeType);
                if (info == null)
                {
                    info = setValue(activeType);
                }
                //if (isPlus)
                //{
                //    info.Conditions += value;
                //}
                //else if (info.Conditions < value)
                //{
                //    info.Conditions = value;
                //}
                //if (awardGot != 0)
                //{
                //    info.AwardGot = awardGot;
                //}
                if (isPlus) info.Conditions += value;
                if (awardGot != 0) info.AwardGot = awardGot;
                if (info.Conditions < value) info.Conditions = value;
                DateTime now = DateTime.Now;
                DateTime endTime = DateTime.Now.AddYears(2);
                pb.UpdateUsersEventProcess(info);
                m_player.Out.SendOpenNoviceActive(0, activeType, info.Conditions, info.AwardGot, now, endTime);
            }
        }

        public void ResetNoviceEvent(NoviceActiveType activeType)
        {
            EventRewardProcessInfo eventProcess = this.GetEventProcess((int)activeType);
            eventProcess.AwardGot = 0;
            eventProcess.Conditions = 0;
            using (PlayerBussiness pb = new PlayerBussiness())
                pb.UpdateUsersEventProcess(eventProcess);

        }

        public bool CheckNoviceActiveOpen(NoviceActiveType activeType)
        {
            switch (activeType)
            {
                case NoviceActiveType.GRADE_UP_ACTIVE:
                    return true;
                case NoviceActiveType.RECHANGE_MONEY_ACTIVE:
                    return true;
                case NoviceActiveType.STRENGTHEN_WEAPON_ACTIVE:
                    return true;
                case NoviceActiveType.UPGRADE_VIP_ACTIVE:
                    return true;
                case NoviceActiveType.UPDATE_FIGHTPOWER:
                    return true;
                case NoviceActiveType.USE_MONEY_ACTIVE:
                    return true;
                case NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK:
                    return true;
                case NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK:
                    return true;
                default:
                    return false;
            }
        }

        public string GetNoviceActivityName(NoviceActiveType activeType)
        {
            string format = "Unknown";
            switch (activeType)
            {
                case NoviceActiveType.GRADE_UP_ACTIVE:
                    format = "Tăng cấp nhận thưởng";
                    break;
                case NoviceActiveType.STRENGTHEN_WEAPON_ACTIVE:
                    format = "Cường hóa tặng quà";
                    break;
                case NoviceActiveType.USE_MONEY_ACTIVE:
                    format = "Tiêu phí thưởng mỗi ngày";
                    break;
                case NoviceActiveType.RECHANGE_MONEY_ACTIVE:
                    format = "Nạp thưởng mỗi ngày";
                    break;
                case NoviceActiveType.UPGRADE_VIP_ACTIVE:
                    format = "Tăng vip nhận quà";
                    break;
                case NoviceActiveType.UPDATE_FIGHTPOWER:
                    format = "Quà lực chiến";
                    break;
                case NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK:
                    format = "Tiêu xu thưởng hằng tuần";
                    break;
                case NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK:
                    format = "Nạp xu thưởng hằng tuần";
                    break;
            }
            return string.Format(format);
        }

        private EventRewardProcessInfo setValue(int activeType) => new EventRewardProcessInfo()
        {
            UserID = this.m_player.PlayerCharacter.ID,
            ActiveType = activeType,
            Conditions = 0,
            AwardGot = 0
        };
    }
}
