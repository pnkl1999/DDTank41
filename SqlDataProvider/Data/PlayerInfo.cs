using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class PlayerInfo : DataObject
    {
        private int _agility;

        private int _antiAddiction;

        private DateTime _antiDate;

        private int _attack;

        private int _badLuckNumber;

        private bool _canTakeVipReward;

        private string _colors;

        private int _consortiaID;

        private string _consortiaName;

        private bool _consortiaRename;

        private string _checkCode;

        private int _checkCount;

        private DateTime _checkDate;

        private int _checkError;

        private int _dayLoginCount;

        private int _defence;

        private int _escape;

        private DateTime? _expendDate;

        private int _fightPower;

        private int _gold;

        private int _gp;

        private int _grade;

        private int _giftGp;

        private int _giftLevel;

        private int _GiftToken;

        private int _hide;

        private PlayerInfoHistory _history;

        private string _honor;

        private int _hp;

        private int _id;

        private int _inviter;

        private bool _isConsortia;

        private bool _isCreatedMarryRoom;

        private int _IsFirst;

        private bool _isGotRing;

        private bool _isLocked = true;

        private bool _isMarried;

        private bool _isOldPlayer;

        private bool _isOldPlayerHasValidEquitAtLogin;

        private bool _isShowConsortia;

        private DateTime _LastAuncherAward;

        private DateTime _LastAward;

        private int _lastLuckNum;

        private DateTime _lastLuckyNumDate;

        private DateTime _LastVIPPackTime;

        private DateTime _LastWeekly;

        private int _LastWeeklyVersion;

        private int _luck;

        private int _luckyNum;

        private int _marryInfoID;

        private int _medal;

        private int _money;

        private int _MoneyPlus;

        private string _nickName;

        private int _nimbus;

        private int _offer;

        private int _optionOnOff;

        private string _password;

        private string _PasswordTwo;

        private int _petScore;

        private byte[] _QuestSite;

        private string _PvePermission;

        private bool _rename;

        private int _repute;

        private int _richesOffer;

        private int _richesRob;

        private int _score;

        private int _selfMarryRoomID;

        private bool _sex;

        //private bool _isViewer;

        private string _skin;

        private int _spouseID;

        private string _spouseName;

        private int _state;

        private string _style;

        private Dictionary<string, object> _tempInfo = new Dictionary<string, object>();

        private TexpInfo _texp;

        private DateTime _newDay;

        private int _total;

        private byte _typeVIP;

        private string _userName;

        private int _VIPExp;

        private DateTime _VIPExpireDay;

        private int _VIPLevel;

        private int _VIPNextLevelDaysNeeded;

        private int _VIPOfflineDays;

        private int _VIPOnlineDays;

        private byte[] _weaklessGuildProgress;

        private string _weaklessGuildProgressStr;

        private int _win;

        public int AgiAddPlus;

        public int AttackAddPlus;

        public int DameAddPlus;

        public int DefendAddPlus;

        public int GuardAddPlus;

        public int HpAddPlus;

        public int LuckAddPlus;

        private int m_AchievementPoint;

        private int m_AddDayAchievementPoint;

        private DateTime m_AddGPLastDate;

        private int m_AddWeekAchievementPoint;

        private int m_AlreadyGetBox;

        private int m_AnswerSite;

        private int m_BanChat;

        private DateTime m_BanChatEndDate;

        private int m_bossguildid;

        private DateTime m_BoxGetDate;

        private int m_BoxProgression;

        private int m_ChatCount;

        private int m_FailedPasswordAttemptCount;

        private string m_fightlabPermission;

        private int m_gameActiveHide;

        private string m_gameActiveStyle;

        private int m_getBoxLevel;

        private bool m_IsInSpaPubGoldToday;

        private bool m_IsInSpaPubMoneyToday;

        private bool m_IsOpenGift;

        private DateTime m_lastDate;

        private DateTime m_lastDateSecond;

        private DateTime m_LastSpaDate;

        private int m_GetBoxLevel;

        private bool m_IsRecharged;

        private bool m_IsGetAward;

        private int m_OnlineTime;

        private string m_PasswordQuest1;

        private string m_PasswordQuest2;

        private string m_Rank;

        private int m_SpaPubGoldRoomLimit;

        private int m_SpaPubMoneyRoomLimit;

        private DateTime m_VIPlastDate;

        public int ReduceDamePlus;

        public int StrengthEnchance;

        public int _AddWeekLeagueScore;

        public int _WeekLeagueRanking;

        public int m_apprenticeshipState;

        public int m_masterID;

        public string m_masterOrApprentices;

        public int m_graduatesCount;

        public string m_honourOfMaster;

        public DateTime m_freezesDate;

        private int int_15;

        private int int_65;

        private int int_62;

        private int int_63;

        private int int_64;

        private int int_55;

        private int int_56;

        private int m_moneyLock;

        private DateTime dateTime_6;

        private DateTime m_LastGetEgg;

        private bool _isFistGetPet;

        private DateTime m_LastRefreshPet;

        public string tempStyle;

        private int _accumulativeLoginDays;

        private int _accumulativeAwardDays;

        private int _honorId;

		private int _necklaceExp;

		private int _necklaceExpAdd;

		//public int GoldenAddAttack { get; set; }

		//public int GoldenReduceDamage { get; set; }

		public DateTime LastRefreshPet
        {
			get
			{
				return m_LastRefreshPet;
			}
			set
			{
				m_LastRefreshPet = value;
				_isDirty = true;
			}
        }

        public bool IsFistGetPet
        {
			get
			{
				return _isFistGetPet;
			}
			set
			{
				_isFistGetPet = value;
				_isDirty = true;
			}
        }

        public DateTime LastGetEgg
        {
			get
			{
				return m_LastGetEgg;
			}
			set
			{
				m_LastGetEgg = value;
				_isDirty = true;
			}
        }

        public int _badgeID { get; set; }

        public int AchievementPoint
        {
			get
			{
				return m_AchievementPoint;
			}
			set
			{
				m_AchievementPoint = value;
			}
        }

        public int AddDayAchievementPoint
        {
			get
			{
				return m_AddDayAchievementPoint;
			}
			set
			{
				m_AddDayAchievementPoint = value;
			}
        }

        public int AddDayGP { get; set; }

        public int AddDayGiftGp { get; set; }

        public int AddDayOffer { get; set; }

        public DateTime AddGPLastDate
        {
			get
			{
				return m_AddGPLastDate;
			}
			set
			{
				m_AddGPLastDate = value;
			}
        }

        public int AddWeekAchievementPoint
        {
			get
			{
				return m_AddWeekAchievementPoint;
			}
			set
			{
				m_AddWeekAchievementPoint = value;
			}
        }

        public int AddWeekGP { get; set; }

        public int AddWeekGiftGp { get; set; }

        public int AddWeekOffer { get; set; }

        public int Agility
        {
			get
			{
				return _agility;
			}
			set
			{
				_agility = value;
				_isDirty = true;
			}
        }

        public int AlreadyGetBox
        {
			get
			{
				return m_AlreadyGetBox;
			}
			set
			{
				m_AlreadyGetBox = value;
			}
        }

        public int AnswerSite
        {
			get
			{
				return m_AnswerSite;
			}
			set
			{
				m_AnswerSite = value;
			}
        }

        public int AntiAddiction
        {
			get
			{
				TimeSpan span = DateTime.Now - _antiDate;
				return _antiAddiction + (int)span.TotalMinutes;
			}
			set
			{
				_antiAddiction = value;
				_antiDate = DateTime.Now;
			}
        }

        public DateTime AntiDate
        {
			get
			{
				return _antiDate;
			}
			set
			{
				_antiDate = value;
			}
        }

        public int Attack
        {
			get
			{
				return _attack;
			}
			set
			{
				_attack = value;
				_isDirty = true;
			}
        }

        public int badgeID
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

        public int badLuckNumber
        {
			get
			{
				return _badLuckNumber;
			}
			set
			{
				_badLuckNumber = value;
			}
        }

        public int BanChat
        {
			get
			{
				return m_BanChat;
			}
			set
			{
				m_BanChat = value;
			}
        }

        public DateTime BanChatEndDate
        {
			get
			{
				return m_BanChatEndDate;
			}
			set
			{
				m_BanChatEndDate = value;
			}
        }

        public int BossGuildID
        {
			get
			{
				return m_bossguildid;
			}
			set
			{
				m_bossguildid = value;
			}
        }

        public DateTime BoxGetDate
        {
			get
			{
				return m_BoxGetDate;
			}
			set
			{
				m_BoxGetDate = value;
			}
        }

        public bool CanTakeVipReward
        {
			get
			{
				return _canTakeVipReward;
			}
			set
			{
				_canTakeVipReward = value;
				_isDirty = true;
			}
        }

        public string Colors
        {
			get
			{
				return _colors;
			}
			set
			{
				_colors = value;
				_isDirty = true;
			}
        }

        public int ConsortiaGiftGp { get; set; }

        public int ConsortiaHonor { get; set; }

        public int ConsortiaID
        {
			get
			{
				return _consortiaID;
			}
			set
			{
				if (_consortiaID == 0 || value == 0)
				{
					_richesRob = 0;
					_richesOffer = 0;
				}
				_consortiaID = value;
			}
        }

        public int ConsortiaLevel { get; set; }

        public string ConsortiaName
        {
			get
			{
				return _consortiaName;
			}
			set
			{
				_consortiaName = value;
			}
        }

        public bool ConsortiaRename
        {
			get
			{
				return _consortiaRename;
			}
			set
			{
				if (_consortiaRename != value)
				{
					_consortiaRename = value;
					_isDirty = true;
				}
			}
        }

        public int ConsortiaRepute { get; set; }

        public int ConsortiaRiches { get; set; }

        public string ChairmanName { get; set; }

        public int ChatCount
        {
			get
			{
				return m_ChatCount;
			}
			set
			{
				m_ChatCount = value;
			}
        }

        public string CheckCode
        {
			get
			{
				return _checkCode;
			}
			set
			{
				_checkDate = DateTime.Now;
				_checkCode = value;
				string.IsNullOrEmpty(_checkCode);
			}
        }

        public int CheckCount
        {
			get
			{
				return _checkCount;
			}
			set
			{
				_checkCount = value;
				_isDirty = true;
			}
        }

        public DateTime CheckDate=> _checkDate;

        public int CheckError
        {
			get
			{
				return _checkError;
			}
			set
			{
				_checkError = value;
			}
        }

        public int DayLoginCount
        {
			get
			{
				return _dayLoginCount;
			}
			set
			{
				_dayLoginCount = value;
				_isDirty = true;
			}
        }

        public int Defence
        {
			get
			{
				return _defence;
			}
			set
			{
				_defence = value;
				_isDirty = true;
			}
        }

        public int DutyLevel { get; set; }

        public string DutyName { get; set; }

        public int Escape
        {
			get
			{
				return _escape;
			}
			set
			{
				_escape = value;
				_isDirty = true;
			}
        }

        public DateTime? ExpendDate
        {
			get
			{
				return _expendDate;
			}
			set
			{
				_expendDate = value;
				_isDirty = true;
			}
        }

        public int FailedPasswordAttemptCount
        {
			get
			{
				return m_FailedPasswordAttemptCount;
			}
			set
			{
				m_FailedPasswordAttemptCount = value;
			}
        }

        public string FightLabPermission
        {
			get
			{
				return m_fightlabPermission;
			}
			set
			{
				m_fightlabPermission = value;
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
				if (_fightPower != value)
				{
					_fightPower = value;
					_isDirty = true;
				}
			}
        }

        public int GameActiveHide
        {
			get
			{
				return m_gameActiveHide;
			}
			set
			{
				m_gameActiveHide = value;
			}
        }

        public string GameActiveStyle
        {
			get
			{
				return m_gameActiveStyle;
			}
			set
			{
				m_gameActiveStyle = value;
			}
        }

        public int Gold
        {
			get
			{
				return _gold;
			}
			set
			{
				_gold = value;
				_isDirty = true;
			}
        }

        public int GP
        {
			get
			{
				return _gp;
			}
			set
			{
				_gp = value;
				_isDirty = true;
			}
        }

        public int Grade
        {
			get
			{
				return _grade;
			}
			set
			{
				_grade = value;
				_isDirty = true;
			}
        }

        public int GiftGp
        {
			get
			{
				return _giftGp;
			}
			set
			{
				_giftGp = value;
				_isDirty = true;
			}
        }

        public int GiftLevel
        {
			get
			{
				return _giftLevel;
			}
			set
			{
				_giftLevel = value;
				_isDirty = true;
			}
        }

        public int GiftToken
        {
			get
			{
				return _GiftToken;
			}
			set
			{
				_GiftToken = value;
			}
        }

        public bool HasBagPassword=> !string.IsNullOrEmpty(_PasswordTwo);

        public int Hide
        {
			get
			{
				return _hide;
			}
			set
			{
				_hide = value;
				_isDirty = true;
			}
        }

        public PlayerInfoHistory History
        {
			get
			{
				return _history;
			}
			set
			{
				_history = value;
			}
        }

        public string Honor
        {
			get
			{
				return _honor;
			}
			set
			{
				_honor = value;
			}
        }

        public int hp
        {
			get
			{
				return _hp;
			}
			set
			{
				_hp = value;
				_isDirty = true;
			}
        }

        public int ID
        {
			get
			{
				return _id;
			}
			set
			{
				_id = value;
				_isDirty = true;
			}
        }

        public int Inviter
        {
			get
			{
				return _inviter;
			}
			set
			{
				_inviter = value;
			}
        }

        public bool IsAutoBot { get; set; }

        public bool IsBanChat { get; set; }

        public bool IsConsortia
        {
			get
			{
				return _isConsortia;
			}
			set
			{
				_isConsortia = value;
			}
        }

        public bool IsCreatedMarryRoom
        {
			get
			{
				return _isCreatedMarryRoom;
			}
			set
			{
				if (_isCreatedMarryRoom != value)
				{
					_isCreatedMarryRoom = value;
					_isDirty = true;
				}
			}
        }

        public int IsFirst
        {
			get
			{
				return _IsFirst;
			}
			set
			{
				_IsFirst = value;
			}
        }

        public bool IsGotRing
        {
			get
			{
				return _isGotRing;
			}
			set
			{
				if (_isGotRing != value)
				{
					_isGotRing = value;
					_isDirty = true;
				}
			}
        }

        public bool IsInSpaPubGoldToday
        {
			get
			{
				return m_IsInSpaPubGoldToday;
			}
			set
			{
				m_IsInSpaPubGoldToday = value;
			}
        }

        public bool IsInSpaPubMoneyToday
        {
			get
			{
				return m_IsInSpaPubMoneyToday;
			}
			set
			{
				m_IsInSpaPubMoneyToday = value;
			}
        }

        public bool IsLocked
        {
			get
			{
				return _isLocked;
			}
			set
			{
				_isLocked = value;
			}
        }

        public bool IsMarried
        {
			get
			{
				return _isMarried;
			}
			set
			{
				_isMarried = value;
				_isDirty = true;
			}
        }

        public bool IsOldPlayer
        {
			get
			{
				return _isOldPlayer;
			}
			set
			{
				_isOldPlayer = value;
				_isDirty = true;
			}
        }

        public bool isOldPlayerHasValidEquitAtLogin
        {
			get
			{
				return _isOldPlayerHasValidEquitAtLogin;
			}
			set
			{
				_isOldPlayerHasValidEquitAtLogin = value;
			}
        }

        public bool IsOpenGift
        {
			get
			{
				return m_IsOpenGift;
			}
			set
			{
				m_IsOpenGift = value;
			}
        }

        public bool IsShowConsortia
        {
			get
			{
				return _isShowConsortia;
			}
			set
			{
				_isShowConsortia = value;
			}
        }

        public DateTime LastAuncherAward
        {
			get
			{
				return _LastAuncherAward;
			}
			set
			{
				_LastAuncherAward = value;
			}
        }

        public DateTime LastAward
        {
			get
			{
				return _LastAward;
			}
			set
			{
				_LastAward = value;
			}
        }

        public DateTime LastDate
        {
			get
			{
				return m_lastDate;
			}
			set
			{
				m_lastDate = value;
			}
        }

        public DateTime LastDateSecond
        {
			get
			{
				return m_lastDateSecond;
			}
			set
			{
				m_lastDateSecond = value;
			}
        }

        public int lastLuckNum
        {
			get
			{
				return _lastLuckNum;
			}
			set
			{
				_lastLuckNum = value;
			}
        }

        public DateTime lastLuckyNumDate
        {
			get
			{
				return _lastLuckyNumDate;
			}
			set
			{
				_lastLuckyNumDate = value;
			}
        }

        public DateTime LastSpaDate
        {
			get
			{
				return m_LastSpaDate;
			}
			set
			{
				m_LastSpaDate = value;
			}
        }

        public DateTime LastVIPPackTime
        {
			get
			{
				return _LastVIPPackTime;
			}
			set
			{
				_LastVIPPackTime = value;
				_isDirty = true;
			}
        }

        public DateTime LastWeekly
        {
			get
			{
				return _LastWeekly;
			}
			set
			{
				_LastWeekly = value;
			}
        }

        public int LastWeeklyVersion
        {
			get
			{
				return _LastWeeklyVersion;
			}
			set
			{
				_LastWeeklyVersion = value;
			}
        }

        public int Luck
        {
			get
			{
				return _luck;
			}
			set
			{
				_luck = value;
				_isDirty = true;
			}
        }

        public int luckyNum
        {
			get
			{
				return _luckyNum;
			}
			set
			{
				_luckyNum = value;
			}
        }

        public int MarryInfoID
        {
			get
			{
				return _marryInfoID;
			}
			set
			{
				if (_marryInfoID != value)
				{
					_marryInfoID = value;
					_isDirty = true;
				}
			}
        }

        public int medal
        {
			get
			{
				return _medal;
			}
			set
			{
				_medal = value;
				_isDirty = true;
			}
        }

        public int Money
        {
			get
			{
				return _money;
			}
			set
			{
				_money = value;
				_isDirty = true;
			}
        }

        public int MoneyPlus
        {
			get
			{
				return _MoneyPlus;
			}
			set
			{
				_MoneyPlus = value;
			}
        }

        public string NickName
        {
			get
			{
				return _nickName;
			}
			set
			{
				_nickName = value;
				_isDirty = true;
			}
        }

        public int Nimbus
        {
			get
			{
				return _nimbus;
			}
			set
			{
				if (_nimbus != value)
				{
					_nimbus = value;
					_isDirty = true;
				}
			}
        }

        public int Offer
        {
			get
			{
				return _offer;
			}
			set
			{
				_offer = value;
				_isDirty = true;
			}
        }

        public int OnlineTime
        {
			get
			{
				return m_OnlineTime;
			}
			set
			{
				m_OnlineTime = value;
			}
        }

        public int OptionOnOff
        {
			get
			{
				return _optionOnOff;
			}
			set
			{
				_optionOnOff = value;
			}
        }

        public string Password
        {
			get
			{
				return _password;
			}
			set
			{
				_password = value;
				_isDirty = true;
			}
        }

        public string PasswordQuest1
        {
			get
			{
				return m_PasswordQuest1;
			}
			set
			{
				m_PasswordQuest1 = value;
			}
        }

        public string PasswordQuest2
        {
			get
			{
				return m_PasswordQuest2;
			}
			set
			{
				m_PasswordQuest2 = value;
			}
        }

        public string PasswordTwo
        {
			get
			{
				return _PasswordTwo;
			}
			set
			{
				_PasswordTwo = value;
				_isDirty = true;
			}
        }

        public int petScore
        {
			get
			{
				return _petScore;
			}
			set
			{
				_petScore = value;
			}
        }

        public byte[] QuestSite
        {
			get
			{
				return _QuestSite;
			}
			set
			{
				_QuestSite = value;
			}
        }

        public string PvePermission
        {
			get
			{
				return _PvePermission;
			}
			set
			{
				_PvePermission = value;
			}
        }

        public string Rank
        {
			get
			{
				return m_Rank;
			}
			set
			{
				m_Rank = value;
			}
        }

        public int BoxProgression
        {
			get
			{
				return m_BoxProgression;
			}
			set
			{
				m_BoxProgression = value;
			}
        }

        public int GetBoxLevel
        {
			get
			{
				return m_GetBoxLevel;
			}
			set
			{
				m_GetBoxLevel = value;
			}
        }

        public bool IsRecharged
        {
			get
			{
				return m_IsRecharged;
			}
			set
			{
				m_IsRecharged = value;
			}
        }

        public bool IsGetAward
        {
			get
			{
				return m_IsGetAward;
			}
			set
			{
				m_IsGetAward = value;
			}
        }

        public bool Rename
        {
			get
			{
				return _rename;
			}
			set
			{
				if (_rename != value)
				{
					_rename = value;
					_isDirty = true;
				}
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

        public int ReputeOffer { get; set; }

        public int Riches=> RichesRob + RichesOffer;

        public int RichesOffer
        {
			get
			{
				return _richesOffer;
			}
			set
			{
				_richesOffer = value;
				_isDirty = true;
			}
        }

        public int RichesRob
        {
			get
			{
				return _richesRob;
			}
			set
			{
				_richesRob = value;
				_isDirty = true;
			}
        }

        public int Right { get; set; }

        public int RoomId { get; set; }

        public int Score
        {
			get
			{
				return _score;
			}
			set
			{
				_score = value;
			}
        }

        public int SelfMarryRoomID
        {
			get
			{
				return _selfMarryRoomID;
			}
			set
			{
				if (_selfMarryRoomID != value)
				{
					_selfMarryRoomID = value;
					_isDirty = true;
				}
			}
        }

        public bool Sex
        {
			get
			{
				return _sex;
			}
			set
			{
				_sex = value;
				_isDirty = true;
			}
        }

   //     public bool isViewer
   //     {
			//get
			//{
			//	return _isViewer;
			//}
			//set
			//{
			//	_isViewer = value;
			//}
   //     }

        public int ShopLevel { get; set; }

        public int SkillLevel { get; set; }

        public string Skin
        {
			get
			{
				return _skin;
			}
			set
			{
				_skin = value;
				_isDirty = true;
			}
        }

        public int SmithLevel { get; set; }

        public int SpaPubGoldRoomLimit
        {
			get
			{
				return m_SpaPubGoldRoomLimit;
			}
			set
			{
				m_SpaPubGoldRoomLimit = value;
			}
        }

        public int SpaPubMoneyRoomLimit
        {
			get
			{
				return m_SpaPubMoneyRoomLimit;
			}
			set
			{
				m_SpaPubMoneyRoomLimit = value;
			}
        }

        public int MoneyLock
        {
			get
			{
				return m_moneyLock;
			}
			set
			{
				m_moneyLock = value;
				_isDirty = true;
			}
        }

        public int SpouseID
        {
			get
			{
				return _spouseID;
			}
			set
			{
				if (_spouseID != value)
				{
					_spouseID = value;
					_isDirty = true;
				}
			}
        }

        public string SpouseName
        {
			get
			{
				return _spouseName;
			}
			set
			{
				if (_spouseName != value)
				{
					_spouseName = value;
					_isDirty = true;
				}
			}
        }

        public int State
        {
			get
			{
				return _state;
			}
			set
			{
				_state = value;
				_isDirty = true;
			}
        }

        public int StoreLevel { get; set; }

        public string Style
        {
			get
			{
				return _style;
			}
			set
			{
				_style = value;
				_isDirty = true;
			}
        }

		private int _damageScores;

		public int damageScores
		{
			get { return _damageScores; }
			set { _damageScores = value; }
		}

		public Dictionary<string, object> TempInfo=> _tempInfo;

        public TexpInfo Texp
        {
			get
			{
				return _texp;
			}
			set
			{
				_texp = value;
				_isDirty = true;
			}
        }

        public DateTime NewDay
        {
			get
			{
				return _newDay;
			}
			set
			{
				_newDay = value;
			}
        }

        public int Total
        {
			get
			{
				return _total;
			}
			set
			{
				_total = value;
				_isDirty = true;
			}
        }

        public byte typeVIP
        {
			get
			{
				return _typeVIP;
			}
			set
			{
				if (_typeVIP != value)
				{
					_typeVIP = value;
					_isDirty = true;
				}
			}
        }

        public string UserName
        {
			get
			{
				return _userName;
			}
			set
			{
				_userName = value;
				_isDirty = true;
			}
        }

        public int VIPExp
        {
			get
			{
				return _VIPExp;
			}
			set
			{
				if (_VIPExp != value)
				{
					_VIPExp = value;
					_isDirty = true;
				}
			}
        }

        public DateTime VIPExpireDay
        {
			get
			{
				return _VIPExpireDay;
			}
			set
			{
				_VIPExpireDay = value;
				_isDirty = true;
			}
        }

        public DateTime VIPLastDate
        {
			get
			{
				return m_VIPlastDate;
			}
			set
			{
				m_VIPlastDate = value;
			}
        }

        public int VIPLevel
        {
			get
			{
				return _VIPLevel;
			}
			set
			{
				if (_VIPLevel != value)
				{
					_VIPLevel = value;
					_isDirty = true;
				}
			}
        }

        public int VIPNextLevelDaysNeeded
        {
			get
			{
				return _VIPNextLevelDaysNeeded;
			}
			set
			{
				_VIPNextLevelDaysNeeded = value;
				_isDirty = true;
			}
        }

        public int VIPOfflineDays
        {
			get
			{
				return _VIPOfflineDays;
			}
			set
			{
				_VIPOfflineDays = value;
			}
        }

        public int VIPOnlineDays
        {
			get
			{
				return _VIPOnlineDays;
			}
			set
			{
				_VIPOnlineDays = value;
			}
        }

        public byte[] weaklessGuildProgress
        {
			get
			{
				return _weaklessGuildProgress;
			}
			set
			{
				_weaklessGuildProgress = value;
				_isDirty = true;
			}
        }

        public string WeaklessGuildProgressStr
        {
			get
			{
				return _weaklessGuildProgressStr;
			}
			set
			{
				_weaklessGuildProgressStr = value;
				_isDirty = true;
			}
        }

        public int Win
        {
			get
			{
				return _win;
			}
			set
			{
				_win = value;
				_isDirty = true;
			}
        }

        public int AddWeekLeagueScore
        {
			get
			{
				return _AddWeekLeagueScore;
			}
			set
			{
				_AddWeekLeagueScore = value;
				_isDirty = true;
			}
        }

        public int WeekLeagueRanking
        {
			get
			{
				return _WeekLeagueRanking;
			}
			set
			{
				_WeekLeagueRanking = value;
				_isDirty = true;
			}
        }

        public int apprenticeshipState
        {
			get
			{
				return m_apprenticeshipState;
			}
			set
			{
				m_apprenticeshipState = value;
				_isDirty = true;
			}
        }

        public int masterID
        {
			get
			{
				return m_masterID;
			}
			set
			{
				m_masterID = value;
				_isDirty = true;
			}
        }

        public string masterOrApprentices
        {
			get
			{
				return m_masterOrApprentices;
			}
			set
			{
				m_masterOrApprentices = value;
				_isDirty = true;
				updateMasterOrApprenticesArr(value);
			}
        }

        public int graduatesCount
        {
			get
			{
				return m_graduatesCount;
			}
			set
			{
				m_graduatesCount = value;
				_isDirty = true;
			}
        }

        public string honourOfMaster
        {
			get
			{
				return m_honourOfMaster;
			}
			set
			{
				m_honourOfMaster = value;
				_isDirty = true;
			}
        }

        public DateTime freezesDate
        {
			get
			{
				return m_freezesDate;
			}
			set
			{
				m_freezesDate = value;
				_isDirty = true;
			}
        }

        private Dictionary<int, string> _masterOrApprenticesArr { get; set; }

        public Dictionary<int, string> MasterOrApprenticesArr=> _masterOrApprenticesArr;

        public int charmGP
        {
			get
			{
				return int_65;
			}
			set
			{
				int_65 = value;
				_isDirty = true;
			}
        }

        public DateTime ShopFinallyGottenTime
        {
			get
			{
				return dateTime_6;
			}
			set
			{
				dateTime_6 = value;
				_isDirty = true;
			}
        }

        public int evolutionGrade
        {
			get
			{
				return int_62;
			}
			set
			{
				int_62 = value;
			}
        }

        public int evolutionExp
        {
			get
			{
				return int_63;
			}
			set
			{
				int_63 = value;
			}
        }

        public int hardCurrency
        {
			get
			{
				return int_64;
			}
			set
			{
				int_64 = value;
			}
        }

        public int EliteScore
        {
			get
			{
				return int_55;
			}
			set
			{
				int_55 = value;
				_isDirty = true;
			}
        }

        public int UseOffer
        {
			get
			{
				return int_15;
			}
			set
			{
				int_15 = value;
				_isDirty = true;
			}
        }

        public int EliteRank
        {
			get
			{
				return int_56;
			}
			set
			{
				int_56 = value;
			}
        }

        public int accumulativeLoginDays
        {
			get
			{
				return _accumulativeLoginDays;
			}
			set
			{
				_accumulativeLoginDays = value;
				_isDirty = true;
			}
        }

        public int accumulativeAwardDays
        {
			get
			{
				return _accumulativeAwardDays;
			}
			set
			{
				_accumulativeAwardDays = value;
				_isDirty = true;
			}
        }

        public int honorId
        {
			get
			{
				return _honorId;
			}
			set
			{
				_honorId = value;
				_isDirty = true;
			}
        }

		private int _totemId;
		public int totemId
		{
			get
			{
				return _totemId;
			}
			set
			{
				_totemId = value;
				_isDirty = true;
				if (_totemId <= 10000)
				{
					_totemId = 0;
				}
			}
		}

		private int _myHonor;
		public int myHonor
		{
			get
			{
				return _myHonor;
			}
			set
			{
				_myHonor = value;
			}
		}
		private int _maxBuyHonor;
		public int MaxBuyHonor
		{
			get
			{
				return _maxBuyHonor;
			}
			set
			{
				_maxBuyHonor = value;
				_isDirty = true;
			}
		}

		public int necklaceExp
		{
			get
			{
				return _necklaceExp;
			}
			set
			{
				_necklaceExp = value;
				_isDirty = true;
			}
		}

		public int necklaceExpAdd
		{
			get
			{
				return _necklaceExpAdd;
			}
			set
			{
				_necklaceExpAdd = value;
				_isDirty = true;
			}
		}


		public bool bit(int param1)
        {
			param1--;
			int index = param1 / 8;
			int num2 = param1 % 8;
			return (_weaklessGuildProgress[index] & (1 << num2)) != 0;
        }

        public void ClearConsortia()
        {
			ConsortiaID = 0;
			ConsortiaName = "";
			RichesOffer = 0;
			ConsortiaRepute = 0;
			ConsortiaLevel = 0;
			StoreLevel = 0;
			ShopLevel = 0;
			SmithLevel = 0;
			ConsortiaHonor = 0;
			RichesOffer = 0;
			RichesRob = 0;
			DutyLevel = 0;
			DutyName = "";
			Right = 0;
			AddDayGP = 0;
			AddWeekGP = 0;
			AddDayOffer = 0;
			AddWeekOffer = 0;
			ConsortiaRiches = 0;
        }

        public void CheckLevelFunction()
        {
			int grade = Grade;
			if (grade > 1)
			{
				openFunction(Step.GAME_ROOM_OPEN);
				openFunction(Step.CHANNEL_OPEN);
			}
			if (grade > 2)
			{
				openFunction(Step.SHOP_OPEN);
				openFunction(Step.STORE_OPEN);
				openFunction(Step.BAG_OPEN);
				openFunction(Step.MAIL_OPEN);
				openFunction(Step.SIGN_OPEN);
			}
			if (grade > 3)
			{
				openFunction(Step.HP_PROP_OPEN);
			}
			if (grade > 4)
			{
				openFunction(Step.GAME_ROOM_SHOW_OPEN);
				openFunction(Step.CIVIL_OPEN);
				openFunction(Step.IM_OPEN);
				openFunction(Step.GUILD_PROP_OPEN);
			}
			if (grade > 5)
			{
				openFunction(Step.BEAT_ROBOT);
				openFunction(Step.MASTER_ROOM_OPEN);
				openFunction(Step.POP_ANGLE);
			}
			if (grade > 6)
			{
				openFunction(Step.MASTER_ROOM_SHOW);
				openFunction(Step.CONSORTIA_OPEN);
				openFunction(Step.HIDE_PROP_OPEN);
				openFunction(Step.PLANE_PROP_OPEN);
			}
			if (grade > 7)
			{
				openFunction(Step.CONSORTIA_SHOW);
				openFunction(Step.DUNGEON_OPEN);
				openFunction(Step.FROZE_PROP_OPEN);
			}
			if (grade > 8)
			{
				openFunction(Step.DUNGEON_SHOW);
				openFunction(Step.BEAT_LIVING_LEFT);
			}
			if (grade > 9)
			{
				openFunction(Step.CHURCH_OPEN);
			}
			if (grade > 11)
			{
				openFunction(Step.CHURCH_SHOW);
				openFunction(Step.TOFF_LIST_OPEN);
			}
			if (grade > 12)
			{
				openFunction(Step.TOFF_LIST_SHOW);
				openFunction(Step.HOT_WELL_OPEN);
			}
			if (grade > 13)
			{
				openFunction(Step.HOT_WELL_SHOW);
				openFunction(Step.AUCTION_OPEN);
			}
			if (grade > 14)
			{
				openFunction(Step.AUCTION_SHOW);
				openFunction(Step.CAMPAIGN_LAB_OPEN);
			}
        }

        public bool IsLastVIPPackTime()
        {
			return _LastVIPPackTime < DateTime.Now.Date;
        }

        public bool CheckNewDay()
        {
			return _newDay.Date < DateTime.Now.Date;
        }

        public bool IsVIPExpire()
        {
			return _VIPExpireDay.Date < DateTime.Now.Date;
        }

        public bool IsWeakGuildFinish(int id)
        {
			if (id >= 1)
			{
				return bit(id);
			}
			return false;
        }

        public void openFunction(Step step)
        {
			Step num4 = step - 1;
			int index = (int)num4 / 8;
			int num3 = (int)num4 % 8;
			byte[] weaklessGuildProgress = this.weaklessGuildProgress;
			if (weaklessGuildProgress.Length != 0)
			{
				weaklessGuildProgress[index] = (byte)(weaklessGuildProgress[index] | (1 << num3));
				this.weaklessGuildProgress = weaklessGuildProgress;
			}
        }

        public int GetVIPNextLevelDaysNeeded(int viplevel, int vipexp)
        {
			if (viplevel != 0 && vipexp > 0 && viplevel <= 8)
			{
				return (Array.ConvertAll("0,100,250,550,1250,2200,3100,4100,5650".Split(','), int.Parse)[viplevel] - vipexp) / 10;
			}
			return 0;
        }

        public void updateMasterOrApprenticesArr(string val)
        {
			if (_masterOrApprenticesArr == null)
			{
				_masterOrApprenticesArr = new Dictionary<int, string>();
			}
			lock (_masterOrApprenticesArr)
			{
				_masterOrApprenticesArr.Clear();
				if (val == null || !(val != ""))
				{
					return;
				}
				try
				{
					char[] chArray1 = new char[1]
					{
						','
					};
					string[] array = val.Split(chArray1);
					string[] array2 = array;
					foreach (string str2 in array2)
					{
						char[] chArray2 = new char[1]
						{
							'|'
						};
						string[] strArray = str2.Split(chArray2);
						_masterOrApprenticesArr.Add(int.Parse(strArray[0]), strArray[1]);
					}
				}
				catch
				{
				}
			}
        }

        public void ConvertMasterOrApprentices()
        {
			List<string> stringList = new List<string>();
			lock (_masterOrApprenticesArr)
			{
				if (_masterOrApprenticesArr.Count == 0)
				{
					apprenticeshipState = 0;
				}
				else if (_masterOrApprenticesArr.Count >= 3)
				{
					apprenticeshipState = 3;
				}
				else if (_masterOrApprenticesArr.Count > 0 && masterID != 0)
				{
					apprenticeshipState = 1;
				}
				else if (_masterOrApprenticesArr.Count > 0 && masterID == 0)
				{
					apprenticeshipState = 2;
				}
				foreach (KeyValuePair<int, string> keyValuePair in _masterOrApprenticesArr)
				{
					stringList.Add(keyValuePair.Key + "|" + keyValuePair.Value);
				}
			}
			m_masterOrApprentices = string.Join(",", stringList);
			_isDirty = true;
        }

        public bool AddMasterOrApprentices(int id, string nickname)
        {
			bool flag = false;
			if (!MasterOrApprenticesArr.ContainsKey(id))
			{
				MasterOrApprenticesArr.Add(id, nickname);
				ConvertMasterOrApprentices();
				flag = true;
			}
			return flag;
        }

        public bool RemoveMasterOrApprentices(int id)
        {
			bool flag = false;
			if (MasterOrApprenticesArr.ContainsKey(id))
			{
				MasterOrApprenticesArr.Remove(id);
				ConvertMasterOrApprentices();
				flag = true;
			}
			return flag;
        }
	}
}
