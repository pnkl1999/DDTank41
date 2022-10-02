using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class ConsortiaInfo : DataObject
    {
        private int _badgeID;

        private DateTime _buildDate;

        private int _celebCount;

        private int _consortiaID;

        private string _consortiaName;

        private int _count;

        private int _creatorID;

        private string _creatorName;

        private int _chairmanID;

        private string _chairmanName;

        private byte _chairmanTypeVIP;

        private int _chairmanVIPLevel;

        private DateTime _deductDate;

        private string _description;

        private int _extendAvailableNum;

        private int _fightPower;

        private int _honor;

        private string _ip;

        private bool _isExist;

        private int _level;

        private int _maxCount;

        private string _placard;

        private int _port;

        private int _repute;

        private int _riches;

        private Dictionary<string, RankingPersonInfo> m_rankList;

        public long MaxBlood;

        public long TotalAllMemberDame;

        public int AddDayHonor { get; set; }

        public int AddDayRiches { get; set; }

        public int AddWeekHonor { get; set; }

        public int AddWeekRiches { get; set; }

        public string BadgeBuyTime { get; set; }

        public int BadgeID
        {
			get
			{
				return _badgeID;
			}
			set
			{
				_badgeID = value;
				_isDirty = true;
			}
        }

        public string BadgeName { get; set; }

        public int BadgeType { get; set; }

        public int bossState { get; set; }

        public DateTime BuildDate
        {
			get
			{
				return _buildDate;
			}
			set
			{
				_buildDate = value;
				_isDirty = true;
			}
        }

        public int callBossLevel { get; set; }

        public int CelebCount
        {
			get
			{
				return _celebCount;
			}
			set
			{
				_celebCount = value;
				_isDirty = true;
			}
        }

        public int ConsortiaID
        {
			get
			{
				return _consortiaID;
			}
			set
			{
				_consortiaID = value;
				_isDirty = true;
			}
        }

        public string ConsortiaName
        {
			get
			{
				return _consortiaName;
			}
			set
			{
				_consortiaName = value;
				_isDirty = true;
			}
        }

        public int Count
        {
			get
			{
				return _count;
			}
			set
			{
				_count = value;
				_isDirty = true;
			}
        }

        public int CreatorID
        {
			get
			{
				return _creatorID;
			}
			set
			{
				_creatorID = value;
				_isDirty = true;
			}
        }

        public string CreatorName
        {
			get
			{
				return _creatorName;
			}
			set
			{
				_creatorName = value;
				_isDirty = true;
			}
        }

        public int ChairmanID
        {
			get
			{
				return _chairmanID;
			}
			set
			{
				_chairmanID = value;
				_isDirty = true;
			}
        }

        public string ChairmanName
        {
			get
			{
				return _chairmanName;
			}
			set
			{
				_chairmanName = value;
				_isDirty = true;
			}
        }

        public byte ChairmanTypeVIP
        {
			get
			{
				return _chairmanTypeVIP;
			}
			set
			{
				_chairmanTypeVIP = value;
				_isDirty = true;
			}
        }

        public int ChairmanVIPLevel
        {
			get
			{
				return _chairmanVIPLevel;
			}
			set
			{
				_chairmanVIPLevel = value;
				_isDirty = true;
			}
        }

        public DateTime DeductDate
        {
			get
			{
				return _deductDate;
			}
			set
			{
				_deductDate = value;
				_isDirty = true;
			}
        }

        public string Description
        {
			get
			{
				return _description;
			}
			set
			{
				_description = value;
				_isDirty = true;
			}
        }

        public DateTime endTime { get; set; }

        public int extendAvailableNum
        {
			get
			{
				return _extendAvailableNum;
			}
			set
			{
				_extendAvailableNum = value;
				_isDirty = true;
			}
        }

        public int FightPower
        {
			get
			{
				return _fightPower;
			}
			set
			{
				_fightPower = value;
				_isDirty = true;
			}
        }

        public int Honor
        {
			get
			{
				return _honor;
			}
			set
			{
				_honor = value;
				_isDirty = true;
			}
        }

        public string IP
        {
			get
			{
				return _ip;
			}
			set
			{
				_ip = value;
				_isDirty = true;
			}
        }

        public bool IsBossDie { get; set; }

        public bool IsExist
        {
			get
			{
				return _isExist;
			}
			set
			{
				_isExist = value;
				_isDirty = true;
			}
        }

        public bool IsSendAward { get; set; }

        public bool IsVoting { get; set; }

        public int LastDayRiches { get; set; }

        public DateTime LastOpenBoss { get; set; }

        public int Level
        {
			get
			{
				return _level;
			}
			set
			{
				_level = value;
				_isDirty = true;
			}
        }

        public int MaxCount
        {
			get
			{
				return _maxCount;
			}
			set
			{
				_maxCount = value;
				_isDirty = true;
			}
        }

        public bool OpenApply { get; set; }

        public string Placard
        {
			get
			{
				return _placard;
			}
			set
			{
				_placard = value;
				_isDirty = true;
			}
        }

        public int Port
        {
			get
			{
				return _port;
			}
			set
			{
				_port = value;
				_isDirty = true;
			}
        }

        public Dictionary<string, RankingPersonInfo> RankList
        {
			get
			{
				return m_rankList;
			}
			set
			{
				m_rankList = value;
			}
        }

        public int Repute
        {
			get
			{
				return _repute;
			}
			set
			{
				_repute = value;
				_isDirty = true;
			}
        }

        public int Riches
        {
			get
			{
				return _riches;
			}
			set
			{
				_riches = value;
				_isDirty = true;
			}
        }

        public bool SendToClient { get; set; }

        public int ShopLevel { get; set; }

        public int SkillLevel { get; set; }

        public int SmithLevel { get; set; }

        public int StoreLevel { get; set; }

        public int ValidDate { get; set; }

        public int VoteRemainDay { get; set; }

        public DateTime DateOpenTask { get; set; }
    }
}
