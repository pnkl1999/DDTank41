using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server;
using Game.Server.Achievement;
using Game.Server.Buffer;
using Game.Server.Consortia;
using Game.Server.ConsortiaTask;
using Game.Server.Event;
using Game.Server.Farm;
using Game.Server.GameRoom;
using Game.Server.GameUtils;
using Game.Server.HotSpringRooms;
using Game.Server.LittleGame;
using Game.Server.LittleGame.Data;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Pet;
using Game.Server.Quests;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using Game.Server.Statics;
using Game.Server.WorldBoss;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;

public class GamePlayer : IGamePlayer
{
    public delegate void PlayerOwnSpaEventHandle(int onlineTimeSpa);

    public delegate void PlayerAddItemEventHandel(string type, int value);

    public delegate void GameKillDropEventHandel(AbstractGame game, int type, int npcId, bool playResult);

    public delegate void PlayerAchievementFinish(AchievementData info);

    public delegate void PlayerAdoptPetEventHandle();

    public delegate void PlayerCropPrimaryEventHandle();

    public delegate void PlayerEnterHotSpring(GamePlayer player);

    public delegate void PlayerEventHandle(GamePlayer player);

    public delegate void PlayerFightAddOffer(int offer);

    public delegate void PlayerFightOneBloodIsWin(eRoomType roomType, bool isWin);

    public delegate void PlayerGameKillBossEventHandel(AbstractGame game, NpcInfo npc, int damage);

    public delegate void PlayerGameKillEventHandel(AbstractGame game, int type, int id, bool isLiving, int demage, bool isSpanArea);

    public delegate void PlayerGoldCollection(int value);

    public delegate void PlayerGiftTokenCollection(int value);

    public delegate void PlayerHotSpingExpAdd(int minutes, int exp);

    public delegate void PlayerOnlineAdd(GamePlayer player);

    public delegate void PlayerLoginEventHandle();

    public delegate void PlayerItemComposeEventHandle(int composeType);

    public delegate void PlayerMoneyChargeHandle(int money);

    public delegate void PlayerItemFusionEventHandle(int fusionType);

    public delegate void PlayerItemInsertEventHandle();

    public delegate void PlayerItemMeltEventHandle(int categoryID);

    public delegate void PlayerItemPropertyEventHandle(int templateID, int count);

    public delegate void PlayerItemStrengthenEventHandle(int categoryID, int level);

    public delegate void PlayerMissionFullOverEventHandle(AbstractGame game, int missionId, bool isWin, int turnNum);

    public delegate void PlayerMissionOverEventHandle(AbstractGame game, int missionId, bool isWin);

    public delegate void PlayerMissionTurnOverEventHandle(AbstractGame game, int missionId, int turnNum);

    public delegate void PlayerNewGearEventHandle(ItemInfo item);

    public delegate void PlayerNewGearEventHandle2(ItemInfo item);

    public delegate void PlayerOwnConsortiaEventHandle();

    public delegate void PlayerAchievementQuestHandle();

    public delegate void PlayerPropertisChange(PlayerInfo player);

    public delegate void PlayerSeedFoodPetEventHandle();

    public delegate void PlayerShopEventHandle(int money, int gold, int offer, int gifttoken, int petScore, int medal, int damageScores, string payGoods);

    public delegate void PlayerUnknowQuestConditionEventHandle();

    public delegate void PlayerUpLevelPetEventHandle();

    public delegate void PlayerUseBugle(int value);

    public delegate void PlayerUserToemGemstoneEventHandle();

    public delegate void PlayerVIPUpgrade(int level, int exp);

    public delegate void PlayerQuestFinishEventHandel(BaseQuest baseQuest);

    public delegate void PlayerPropertyChangedEventHandel(PlayerInfo character);

    public delegate void PlayerMarryTeamEventHandle(AbstractGame game, bool isWin, int gainXp, int countPlayersTeam);

    public delegate void PlayerGameOverCountTeamEventHandle(AbstractGame game, bool isWin, int gainXp, int countPlayersTeam);

    public delegate void PlayerMarryEventHandel();

    public delegate void PlayerDispatchesEventHandel();

    public delegate void PlayerGameOverEventHandle(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple);

    public delegate void PlayerGameOverEvent2v2Handle(bool isWin);

    public delegate void PlayerAcademyEventHandle(GamePlayer friendly, int type);

    public delegate void PlayerEquipCardEventHandle();

    public ItemInfo LastTakeCardItem;

    private Dictionary<int, int> _friends;

    public DateTime BossBoxStartTime;

    public bool BlockReceiveMoney;

    public DateTime LastOpenHole;

    public int canTakeOut;

    public Dictionary<int, CardInfoOld> Card = new Dictionary<int, CardInfoOld>();

    public CardInfoOld[] CardsTakeOut = new CardInfoOld[9];

    public int CurrentRoomIndex;

    public int CurrentRoomTeam;

    public int FightPower;

    public double GuildRichAddPlus = 1.0;

    public int Hot_Direction;

    public int Hot_X;

    public int Hot_Y;

    public int HotMap;

    private HotSpringRoom hotSpringRoom_0;

    public bool IsInChristmasRoom;

    public bool IsInWorldBossRoom;

    public bool isPowerFullUsed;

    public bool KickProtect;

    public DateTime WaitingProcessor;

    #region Consortia Task
    protected ConsortiaTaskLogicProcessor m_consortiaTaskProcessor;
    public ConsortiaTaskProcessor ConsortiaTask { get; private set; }
    public delegate void DonateRiches(int value, int type);
    public event DonateRiches Riches;
    public void OnDonateRiches(int value, int type)
    {
        Riches?.Invoke(value, type);
    }
    #endregion

    public readonly string[] labyrinthGolds = new string[40]
    {
        "0|0",
        "2|2",
        "0|0",
        "2|2",
        "0|0",
        "2|3",
        "0|0",
        "3|3",
        "0|0",
        "3|4",
        "0|0",
        "3|4",
        "0|0",
        "4|5",
        "0|0",
        "4|5",
        "0|0",
        "4|6",
        "0|0",
        "5|6",
        "0|0",
        "5|7",
        "0|0",
        "5|7",
        "0|0",
        "6|8",
        "0|0",
        "6|8",
        "0|0",
        "6|10",
        "0|0",
        "8|10",
        "0|0",
        "8|11",
        "0|0",
        "8|11",
        "0|0",
        "10|12",
        "0|0",
        "10|12"
    };

    public DateTime LastAttachMail;

    public DateTime LastChatTime;

    public DateTime LastDrillUpTime;

    public DateTime LastEnterWorldBoss;

    public DateTime LastFigUpTime;

    public DateTime LastOpenCard;

    public DateTime LastOpenChristmasPackage;

    public DateTime LastOpenGrowthPackage;

    public DateTime LastOpenPack;

    public DateTime LastOpenYearMonterPackage;

    public List<ItemInfo> LotteryAwardList;

    private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

    private string m_account;

    private AchievementInventory m_achievementInventory;

    private EventInventory m_eventLiveInventory;

    private PlayerBattle m_battle;

    private BufferList m_bufferList;

    private PlayerInventory m_caddyBag;

    private CardInventory m_cardBag;

    protected GameClient m_client;

    private PlayerInventory m_ConsortiaBag;

    private PlayerInventory m_BankBag;

    private UTF8Encoding m_converter;

    private MarryRoom m_currentMarryRoom;

    private BaseRoom m_currentRoom;

    private ItemInfo m_currentSecondWeapon;

    private int m_changed;

    private PlayerInfo m_character;

    private PlayerEquipInventory m_equipBag;

    private List<int> m_equipEffect;

    private PlayerExtra m_extra;

    private PlayerInventory m_fightBag;

    private List<BufferInfo> m_fightBuffInfo;

    private PlayerInventory m_food;

    protected BaseGame m_game;

    private ItemInfo m_healstone;

    private int m_immunity = 255;

    private bool m_isAASInfo;

    private bool m_isMinor;

    private ItemInfo m_MainWeapon;

    private UsersPetInfo m_pet;

    private PlayerInventory m_petEgg;

    private long m_pingTime;

    private int m_playerId;

    private PlayerProperty m_playerProp;

    protected Player m_players;

    private ePlayerState m_playerState;

    private PlayerInventory m_propBag;

    private char[] m_pvepermissions;

    private QuestInventory m_questInventory;

    private PlayerRank m_rank;

    private bool m_showPP;

    private PlayerInventory m_storeBag;

    private PlayerInventory m_tempBag;

    private Dictionary<string, object> m_tempProperties = new Dictionary<string, object>();

    public bool m_toemview;

    public DateTime BoxBeginTime;

    private Dictionary<int, UserDrillInfo> m_userDrills;

    public int MarryMap;

    public int HoGiap;

    private List<UserGemStone> m_GemStone;

    private static char[] permissionChars = new char[4]
    {
        '1',
        '3',
        '7',
        'F'
    };

    public long PingStart;

    public byte States;

    private static readonly int[] StyleIndex = new int[15]
    {
        1,
        2,
        3,
        4,
        5,
        6,
        11,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
    };

    public int takeoutCount;

    public int winningStreak;

    public int WorldBossMap;

    public int X;

    public int Y;

    private char[] m_fightlabpermissions;

    private static char[] fightlabpermissionChars = new char[4]
    {
        '0',
        '1',
        '2',
        '3'
    };

    public int missionPlayed;

    public int playersKilled;

    protected ConsortiaLogicProcessor m_consortiaProcessor;

    protected GameRoomLogicProcessor m_gameroomProcessor = new GameRoomLogicProcessor();

    protected GameRoomProcessor m_gameRoom;

    private ConsortiaProcessor consortiaProcessor_0;

    protected PetLogicProcessor m_petProcessor;

    private PetProcessor petProcessor_0;

    private PetInventory m_petBag;

    public DateTime LastMovePlaceItem;

    public Dictionary<int, int[]> CardResetTempProp;

    private UserLabyrinthInfo userLabyrinthInfo;

    public int TakeCardPlace;

    public int TakeCardTemplateID;

    public int TakeCardCount;

    private PlayerActives m_playerActive;

    private int int_6;

    public static List<Suit_TemplateInfo> DS_Template_Suit_info = Load_Template_Suit_info();

    protected FarmLogicProcessor m_farmProcessor = new FarmLogicProcessor();

    public List<int> CardBuff { get; set; }

    public PlayerInventory FarmBag { get; }

    public PlayerInventory Vegetable { get; }

    public FarmProcessor FarmHandler { get; private set; }

    public PlayerLittleGameInfo LittleGameInfo
    {
        get;
    }

    public LittleGameProcessor LittleGame { get; private set; }

    protected LittleGameLogicProcessor m_LittleGameProcessor;

    public GameRoomProcessor GameRoom => m_gameRoom;

    public double GPApprenticeOnline
    {
        get
        {
            if (m_character.MasterOrApprenticesArr.Count > 0)
            {
                foreach (KeyValuePair<int, string> item in m_character.MasterOrApprenticesArr)
                {
                    if (WorldMgr.GetPlayerById(item.Key) != null)
                    {
                        return 0.05;
                    }
                }
            }
            return 0.0;
        }
        set
        {
        }
    }

    public double GPApprenticeTeam
    {
        get
        {
            if (CurrentRoom != null)
            {
                foreach (GamePlayer player in CurrentRoom.GetPlayers())
                {
                    if (player != this && player.PlayerCharacter.MasterOrApprenticesArr.ContainsKey(PlayerId))
                    {
                        return 0.1;
                    }
                }
            }
            return 0.0;
        }
        set
        {
        }
    }

    public double GPSpouseTeam
    {
        get
        {
            if (CurrentRoom != null)
            {
                foreach (GamePlayer player in CurrentRoom.GetPlayers())
                {
                    if (player != this && player.PlayerCharacter.SpouseID == PlayerId)
                    {
                        return 0.05;
                    }
                }
            }
            return 0.0;
        }
        set
        {
        }
    }

    public PetProcessor PetHandler => petProcessor_0;

    public PlayerActives Actives => m_playerActive;

    public ConsortiaProcessor Consortia => consortiaProcessor_0;

    public UserLabyrinthInfo Labyrinth
    {
        get
        {
            return userLabyrinthInfo;
        }
        set
        {
            userLabyrinthInfo = value;
        }
    }

    public string Account => m_account;

    public AchievementInventory AchievementInventory => m_achievementInventory;

    public EventInventory EventLiveInventory => m_eventLiveInventory;

    public long AllWorldDameBoss { get; set; }

    public PlayerBattle BattleData => m_battle;

    public bool bool_1 { get; set; }

    public bool Boolean_0
    {
        get
        {
            return bool_1;
        }
        set
        {
            bool_1 = value;
        }
    }

    public BufferList BufferList => m_bufferList;

    public PlayerInventory CaddyBag => m_caddyBag;

    public bool CanUseProp { get; set; }

    public double GPAddPlus { get; set; }

    public double OfferAddPlus { get; set; }

    public bool CanX2Exp { get; set; }

    public bool CanX3Exp { get; set; }

    public CardInventory CardBag => m_cardBag;

    public GameClient Client => m_client;

    public PlayerInventory ConsortiaBag => m_ConsortiaBag;

    public PlayerInventory BankBag => m_BankBag;

    public HotSpringRoom CurrentHotSpringRoom
    {
        get
        {
            return hotSpringRoom_0;
        }
        set
        {
            hotSpringRoom_0 = value;
        }
    }

    public MarryRoom CurrentMarryRoom
    {
        get
        {
            return m_currentMarryRoom;
        }
        set
        {
            m_currentMarryRoom = value;
        }
    }

    public BaseRoom CurrentRoom
    {
        get
        {
            return m_currentRoom;
        }
        set
        {
            BaseRoom baseRoom = Interlocked.Exchange(ref m_currentRoom, value);
            if (baseRoom != null)
            {
                RoomMgr.ExitRoom(baseRoom, this);
            }
        }
    }

    public PlayerEquipInventory EquipBag => m_equipBag;

    public List<int> EquipEffect
    {
        get
        {
            return m_equipEffect;
        }
        set
        {
            m_equipEffect = value;
        }
    }

    public PlayerExtra Extra => m_extra;

    public PlayerInventory FightBag => m_fightBag;

    public List<BufferInfo> FightBuffs
    {
        get
        {
            return m_fightBuffInfo;
        }
        set
        {
            m_fightBuffInfo = value;
        }
    }

    public PlayerInventory Food => m_food;

    public Dictionary<int, int> Friends => _friends;

    public BaseGame game
    {
        get
        {
            return m_game;
        }
        set
        {
            m_game = value;
        }
    }

    public int GameId
    {
        get
        {
            return int_6;
        }
        set
        {
            int_6 = value;
        }
    }

    public int GamePlayerId { get; set; }

    public int TempGameId { get; set; }

    public ItemInfo Healstone
    {
        get
        {
            if (m_healstone == null)
            {
                return null;
            }
            return m_healstone;
        }
    }

    public int Immunity
    {
        get
        {
            return m_immunity;
        }
        set
        {
            m_immunity = value;
        }
    }

    public bool IsAASInfo
    {
        get
        {
            return m_isAASInfo;
        }
        set
        {
            m_isAASInfo = value;
        }
    }

    public virtual bool IsActive => m_client.IsConnected;

    public bool IsInMarryRoom => m_currentMarryRoom != null;

    public bool IsMinor
    {
        get
        {
            return m_isMinor;
        }
        set
        {
            m_isMinor = value;
        }
    }

    public List<UserGemStone> GemStone
    {
        get
        {
            return this.m_GemStone;
        }
        set
        {
            this.m_GemStone = value;
        }
    }

    public int Level
    {
        get
        {
            return m_character.Grade;
        }
        set
        {
            if (value != m_character.Grade)
            {
                int grade = m_character.Grade;
                DailyRecordInfo info = new DailyRecordInfo
                {
                    UserID = m_character.ID,
                    Type = 2,
                    Value = $"{m_character.Grade},{value}"
                };
                new PlayerBussiness().AddDailyRecord(info);
                Extra.UpdateEventCondition((int)NoviceActiveType.GRADE_UP_ACTIVE, value);
                m_character.Grade = value;
                if (value == 6)
                {
                    ItemInfo cloneItem = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(112098), 1, 104);
                    AddTemplate(cloneItem);
                }
                if (value == 8)
                {
                    PlayerCharacter.WeaklessGuildProgressStr = "////b7D/ht8WDQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                }
                if (m_character.masterID != 0 && grade < m_character.Grade)
                {
                    AcademyMgr.UpdateAwardApp(this, grade);
                }
                OnLevelUp(value);
                OnPropertiesChanged();
            }
        }
    }

    public int LevelPlusBlood => LevelMgr.LevelPlusBlood(PlayerCharacter.Grade);

    public ItemInfo MainWeapon => m_MainWeapon;

    public UserMatchInfo MatchInfo => m_battle.MatchInfo;

    public virtual IPacketLib Out => m_client.Out;

    public UsersPetInfo Pet => m_pet;

    public long PingTime
    {
        get
        {
            return m_pingTime;
        }
        set
        {
            m_pingTime = value;
            GSPacketIn pkg = Out.SendNetWork(PlayerCharacter.ID, m_pingTime);
            if (m_currentRoom != null)
            {
                m_currentRoom.SendToAll(pkg, this);
            }
        }
    }

    public PlayerInfo PlayerCharacter => m_character;

    public PetInventory PetBag => m_petBag;

    public PlayerFarm Farm { get; }

    public int PlayerId => m_playerId;

    public PlayerProperty PlayerProp => m_playerProp;

    public Player Players => m_players;

    public ePlayerState PlayerState
    {
        get
        {
            return m_playerState;
        }
        set
        {
            m_playerState = value;
        }
    }

    public string ProcessLabyrinthAward { get; set; }

    public PlayerInventory PropBag => m_propBag;

    public QuestInventory QuestInventory => m_questInventory;

    public PlayerRank Rank => m_rank;

    public ItemInfo SecondWeapon
    {
        get
        {
            if (m_currentSecondWeapon == null)
            {
                return null;
            }
            return m_currentSecondWeapon;
        }
    }

    public int ServerID { get; set; }

    public bool IsAccountLimit { get; set; }

    public bool ShowPP
    {
        get
        {
            return m_showPP;
        }
        set
        {
            m_showPP = value;
        }
    }

    public PlayerInventory StoreBag => m_storeBag;

    public PlayerInventory TempBag => m_tempBag;

    public Dictionary<string, object> TempProperties => m_tempProperties;

    public bool Toemview
    {
        get
        {
            return m_toemview;
        }
        set
        {
            m_toemview = value;
        }
    }

    public Dictionary<int, UserDrillInfo> UserDrills
    {
        get
        {
            return m_userDrills;
        }
        set
        {
            m_userDrills = value;
        }
    }

    public PlayerInfo UserVIPInfo => m_character;

    public long WorldbossBood { get; set; }

    public int ZoneId => GameServer.Instance.Configuration.ServerID;

    public string ZoneName => GameServer.Instance.Configuration.ServerName;

    public int Lottery { get; internal set; }

    public List<ItemBoxInfo> LotteryItems { get; internal set; }

    public int LotteryID { get; internal set; }

    public DateTime LastRequestTime { get; internal set; }

    public int CurrentEnemyId { get; set; }

    public double BaseAgility { get; set; }

    public double BaseDamage { get; set; }

    private bool m_isViewer;

    public bool IsViewer
    {
        get { return m_isViewer; }
        set { m_isViewer = value; }
    }

    public List<int> ViFarms { get; private set; }

    public event PlayerAchievementFinish AchievementFinishEvent;

    public event PlayerAdoptPetEventHandle AdoptPetEvent;

    public event PlayerGameKillBossEventHandel AfterKillingBoss;

    public event PlayerGameKillEventHandel AfterKillingLiving;

    public event PlayerItemPropertyEventHandle AfterUsingItem;

    public event PlayerCropPrimaryEventHandle CropPrimaryEvent;

    public event PlayerEnterHotSpring EnterHotSpringEvent;

    public event PlayerVIPUpgrade Event_0;

    public event PlayerFightAddOffer FightAddOfferEvent;

    public event PlayerFightOneBloodIsWin FightOneBloodIsWin;

    public event GameKillDropEventHandel GameKillDrop;

    public event PlayerOwnConsortiaEventHandle GuildChanged;

    public event PlayerHotSpingExpAdd HotSpingExpAdd;

    public event PlayerOnlineAdd OnlineGameAdd;

    public event PlayerLoginEventHandle PlayerLogin;

    public event PlayerItemComposeEventHandle ItemCompose;

    public event PlayerItemFusionEventHandle ItemFusion;

    public event PlayerItemInsertEventHandle ItemInsert;

    public event PlayerItemMeltEventHandle ItemMelt;

    public event PlayerItemStrengthenEventHandle ItemStrengthen;

    public event PlayerMoneyChargeHandle MoneyCharge;

    public event PlayerAchievementQuestHandle AchievementQuest;

    public event PlayerEventHandle LevelUp;

    public event PlayerMissionOverEventHandle MissionOver;

    public event PlayerMissionTurnOverEventHandle MissionTurnOver;

    public event PlayerNewGearEventHandle NewGearEvent;

    public event PlayerSeedFoodPetEventHandle SeedFoodPetEvent;

    public event PlayerShopEventHandle Paid;

    public event PlayerUnknowQuestConditionEventHandle UnknowQuestConditionEvent;

    public event PlayerUpLevelPetEventHandle UpLevelPetEvent;

    public event PlayerEventHandle UseBuffer;

    public event PlayerUserToemGemstoneEventHandle UserToemGemstonetEvent;

    public event PlayerPropertyChangedEventHandel PlayerPropertyChanged;

    public event PlayerAddItemEventHandel PlayerAddItem;

    public event PlayerOwnSpaEventHandle PlayerSpa;

    public event PlayerPropertisChange PropertiesChange;

    public event PlayerMissionFullOverEventHandle MissionFullOver;

    public event PlayerQuestFinishEventHandel PlayerQuestFinish;

    public event PlayerGameOverCountTeamEventHandle GameOverCountTeam;

    public event PlayerMarryTeamEventHandle GameMarryTeam;

    public event PlayerUseBugle UseBugle;

    public event PlayerMarryEventHandel PlayerMarry;

    public event PlayerDispatchesEventHandel PlayerDispatches;

    public event PlayerGameOverEventHandle GameOver;

    public event PlayerGameOverEvent2v2Handle GameOver2v2;

    public event PlayerAcademyEventHandle AcademyEvent;

    public event PlayerEquipCardEventHandle EquipCardEvent;

    private PlayerAvatarCollection m_avatarcollect;

    public PlayerAvatarCollection AvatarCollect
    {
        get
        {
            return this.m_avatarcollect;
        }
    }

    private long _timecheckhack;
    public long TimeCheckHack
    {
        get
        {
            return this._timecheckhack;
        }
        set
        {
            this._timecheckhack = value;
        }
    }
    private void SetupProcessor()
    {
        FarmHandler = new FarmProcessor(m_farmProcessor);
        m_gameRoom = new GameRoomProcessor(m_gameroomProcessor);
        ConsortiaTask = new ConsortiaTaskProcessor(m_consortiaTaskProcessor);
        WorldBoss = new WorldBossProcessor(_worldBossProcessor);
        LittleGame = new LittleGameProcessor(m_LittleGameProcessor);
    }

    private int count_addmoney;
    public int CountAddMoney
    {
        get
        {
            return this.count_addmoney;
        }
        set
        {
            this.count_addmoney = value;
        }
    }
    private int count_addgp;
    public int CountAddGP
    {
        get
        {
            return this.count_addgp;
        }
        set
        {
            this.count_addgp = value;
        }
    }
    private int count_function;
    public int CountFunction
    {
        get
        {
            return this.count_function;
        }
        set
        {
            this.count_function = value;
        }
    }
    private int count_function2;
    public int CountFunction2
    {
        get
        {
            return this.count_function2;
        }
        set
        {
            this.count_function2 = value;
        }
    }
    private Random count_random;

    public GamePlayer(int playerId, string account, GameClient client, PlayerInfo info)
    {
        m_playerId = playerId;
        m_account = account;
        m_client = client;
        m_character = info;
        m_equipBag = new PlayerEquipInventory(this);
        m_propBag = new PlayerInventory(this, saveTodb: true, 96, 1, 0, autoStack: true);
        m_ConsortiaBag = new PlayerInventory(this, saveTodb: true, 100, 11, 0, autoStack: true);
        m_BankBag = new PlayerInventory(this, saveTodb: true, 198, 51, 0, autoStack: true);
        m_storeBag = new PlayerInventory(this, saveTodb: true, 20, 12, 0, autoStack: true);
        m_fightBag = new PlayerInventory(this, saveTodb: false, 3, 3, 0, autoStack: false);
        m_tempBag = new PlayerInventory(this, saveTodb: false, 60, 4, 0, autoStack: true);
        m_caddyBag = new PlayerInventory(this, saveTodb: false, 30, 5, 0, autoStack: true);
        FarmBag = new PlayerInventory(this, saveTodb: true, 30, 13, 0, autoStack: true);
        Vegetable = new PlayerInventory(this, saveTodb: true, 30, 14, 0, autoStack: true);
        m_food = new PlayerInventory(this, saveTodb: true, 30, 34, 0, autoStack: true);
        m_petEgg = new PlayerInventory(this, saveTodb: true, 30, 35, 0, autoStack: true);
        m_cardBag = new CardInventory(this, saveTodb: true, 100, 5);
        Farm = new PlayerFarm(this, saveTodb: true, 30, 0);
        m_petBag = new PetInventory(this, saveTodb: true, 20, 8, 0);
        m_rank = new PlayerRank(this, saveToDb: true);
        m_playerProp = new PlayerProperty(this);
        m_battle = new PlayerBattle(this, saveTodb: true);
        m_extra = new PlayerExtra(this, saveTodb: true);
        m_playerActive = new PlayerActives(this, saveTodb: true);
        m_questInventory = new QuestInventory(this);
        m_achievementInventory = new AchievementInventory(this);
        m_eventLiveInventory = new EventInventory(this);
        m_bufferList = new BufferList(this);
        m_fightBuffInfo = new List<BufferInfo>();
        m_equipEffect = new List<int>();
        m_userDrills = new Dictionary<int, UserDrillInfo>();
        CardBuff = new List<int>();
        GPAddPlus = 1.0;
        OfferAddPlus = 1.0;
        m_toemview = true;
        X = 646;
        Y = 1241;
        MarryMap = 0;
        LastChatTime = DateTime.Today;
        LastFigUpTime = DateTime.Today;
        LastDrillUpTime = DateTime.Today;
        LastOpenPack = DateTime.Today;
        LastMovePlaceItem = DateTime.Today;
        m_showPP = false;
        m_converter = new UTF8Encoding();
        BossBoxStartTime = DateTime.Now;
        ResetLottery();
        IsAccountLimit = false;
        CardResetTempProp = new Dictionary<int, int[]>();
        userLabyrinthInfo = null;
        m_consortiaProcessor = new ConsortiaLogicProcessor();
        m_petProcessor = new PetLogicProcessor();
        BlockReceiveMoney = false;
        LastOpenHole = DateTime.Now;
        LastTakeCardItem = null;
        m_consortiaTaskProcessor = new ConsortiaTaskLogicProcessor();
        _worldBossProcessor = new WorldBossLogicProcessor();
        LittleGameInfo = new PlayerLittleGameInfo
        {
            Actions = new TriggeredQueue<string, GamePlayer>(this),
            X = 275,
            Y = 30
        };
        m_LittleGameProcessor = new LittleGameLogicProcessor();
        m_character.CheckCode = "baodeptrai";
        m_isViewer = false;
        this._timecheckhack = (long)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
        this.count_addmoney = 0;
        this.count_addgp = 0;
        this.count_function = 0;
        this.count_function2 = 0;
        this.count_random = new Random();
        this.m_GemStone = new List<UserGemStone>();
        this.m_avatarcollect = new PlayerAvatarCollection(this, true);
    }

    public bool isPassCheckCode()
    {
        int checkmoney = this.count_random.Next(10, 15);//7, 9); //30 ~ 40 trận sẽ hiện mã captcha
        int checkgp = this.count_random.Next(30, 40);
        int checkfunction = this.count_random.Next(7, 10);
        int checkfunction2 = this.count_random.Next(40, 60);
        bool result = this.m_character.CheckCount == 0 && this.count_addmoney < checkmoney && this.count_addgp < checkgp && this.count_function < checkfunction && this.count_function2 < checkfunction2;
        //Console.WriteLine($"Check: {result}");
        return result;
        //return true;
    }

    public void resetPassCode()
    {
        this.CountAddMoney = 0;
        this.CountAddGP = 0;
        this.CountFunction = 0;
        this.CountFunction2 = 0;
    }

    public bool ShowCheckCode()
    {
        this.m_character.CheckCount = 1;
        GSPacketIn gSPacketIn = new GSPacketIn(200);
        if (Client.Player.PlayerCharacter.CheckError < 1)
        {
            gSPacketIn.WriteByte(1);
        }
        else
        {
            gSPacketIn.WriteByte(2);
        }
        gSPacketIn.WriteBoolean(val: true);
        gSPacketIn.WriteByte(1);
        gSPacketIn.WriteString("hi");
        Client.Player.PlayerCharacter.CheckCode = CheckCode.GenerateCheckCode();
        gSPacketIn.Write(CheckCode.CreateImage(Client.Player.PlayerCharacter.CheckCode));
        this.SendTCP(gSPacketIn);
        return true;
    }

    public bool isPlayerWarrior()
    {
        return this.m_extra.Info.coupleBossBoxNum == 9;
    }

    public void UpdatePublicPlayer(string tempStyle = "")
    {
        PlayerCharacter.tempStyle = tempStyle;
        GSPacketIn pkg = Out.SendUpdatePublicPlayer(PlayerCharacter, MatchInfo, Extra.Info);
        if (m_currentRoom != null)
        {
            m_currentRoom.SendToAll(pkg, this);
        }
    }

    public int AddAchievementPoint(int value)
    {
        if (value > 0)
        {
            m_character.AchievementPoint += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public void SendUpdatePublicPlayer()
    {
        Out.SendUpdatePublicPlayer(PlayerCharacter, MatchInfo, Extra.Info);
    }

    public void AddExpVip(int value)
    {
        List<int> exp = GameProperties.VIPExp();
        m_character.VIPExp += value;
        for (int i = 0; i < exp.Count; i++)
        {
            int vipExp = m_character.VIPExp;
            int level = m_character.VIPLevel;
            if (level == 9)
            {
                m_character.VIPExp = exp[8];
                break;
            }
            if (level < 9 && canUpLv(vipExp, level))
            {
                m_character.VIPLevel++;
                if (m_character.VIPLevel >= 7 && PetBag != null)
                {
                    PetBag.UpdatePetFiveKillSlot(m_character.VIPLevel);
                }
                DailyRecordInfo info = new DailyRecordInfo
                {
                    UserID = PlayerCharacter.ID,
                    Type = 28,
                    Value = m_character.VIPLevel.ToString()
                };
                new PlayerBussiness().AddDailyRecord(info);
            }
        }
        Extra.UpdateEventCondition((int)NoviceActiveType.UPGRADE_VIP_ACTIVE, PlayerCharacter.VIPLevel);
        if (m_character.IsVIPExpire())
        {
            Out.SendOpenVIP(this);
        }
    }

    public bool RemoveExpVip(int value)
    {
        bool result = false;
        List<int> list = GameProperties.VIPExp();
        if (m_character.VIPExp >= value)
        {
            m_character.VIPExp -= value;
            result = true;
        }
        else if (m_character.VIPExp < value && m_character.VIPExp > 0)
        {
            m_character.VIPExp = 0;
            result = true;
        }
        for (int i = 0; i < list.Count; i++)
        {
            int vIPExp = m_character.VIPExp;
            int vIPLevel = m_character.VIPLevel;

            if (vIPLevel > 9 && canDownLv(vIPExp, vIPLevel))
            {
                m_character.VIPLevel--;
                DailyRecordInfo info = new DailyRecordInfo
                {
                    UserID = PlayerCharacter.ID,
                    Type = 28,
                    Value = m_character.VIPLevel.ToString()
                };
                new PlayerBussiness().AddDailyRecord(info);

            }
        }
        return result;
    }

    public int AddGold(int value)
    {
        if (value > 0)
        {
            m_character.Gold += value;
            if (m_character.Gold == int.MinValue)
            {
                m_character.Gold = int.MaxValue;
                SendMessage("Vàng đã đạt giới hạn!");
            }
            OnPlayerAddItem("Gold", value);
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }
    public int AddGP(int gp)
    {
        // Chức năng của BAOLT - Lâm đừng copaste nha
        if (this.isPlayerWarrior())
            return 0;
        if (gp >= 0)
        {
            if (AntiAddictionMgr.ISASSon)
            {
                gp = (int)((double)gp * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
            }
            gp = (int)((float)gp * RateMgr.GetRate(eRateType.Experience_Rate));
            if (GPAddPlus > 0.0)
            {
                gp = (int)((double)gp * GPAddPlus);
            }
            m_character.GP += gp;
            if (m_character.GP < 1)
            {
                m_character.GP = 1;
            }
            Level = LevelMgr.GetLevel(m_character.GP);
            int maxLevel = LevelMgr.MaxLevel;
            LevelInfo levelInfo = LevelMgr.FindLevel(maxLevel);
            if (Level == maxLevel && levelInfo != null)
            {
                m_character.GP = levelInfo.GP;
                int num = gp / 100;
                if (num > 0)
                {
                    AddOffer(num);
                    SendHideMessage(string.Format("Đã đạt đến cấp độ tối đa, kinh nghiệm nhận được sẽ được quy đổi thành công trạng.", num));
                }
            }
            this.count_addgp++;
            UpdateFightPower();
            OnPropertiesChanged();
            return gp;
        }
        return 0;
    }
    public int AddGP(int gp, bool x2)
    {
        // Chức năng của BAOLT - Lâm đừng copaste nha
        if (this.isPlayerWarrior())
            return 0;
        if (gp >= 0)
        {
            if (AntiAddictionMgr.ISASSon)
            {
                gp = (int)((double)gp * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
            }
            gp = (int)((float)gp * RateMgr.GetRate(eRateType.Experience_Rate));
            if (GPAddPlus > 0.0 && x2)
            {
                gp = (int)((double)gp * GPAddPlus);
            }
            m_character.GP += gp;
            if (m_character.GP < 1)
            {
                m_character.GP = 1;
            }
            Level = LevelMgr.GetLevel(m_character.GP);
            int maxLevel = LevelMgr.MaxLevel;
            LevelInfo levelInfo = LevelMgr.FindLevel(maxLevel);
            if (Level == maxLevel && levelInfo != null)
            {
                m_character.GP = levelInfo.GP;
                int num = gp / 100;
                if (num > 0)
                {
                    AddOffer(num);
                    SendHideMessage(string.Format("Đã đạt đến cấp độ tối đa, kinh nghiệm nhận được sẽ được quy đổi thành công trạng.", num));
                }
            }
            //this.count_addgp++;
            UpdateFightPower();
            OnPropertiesChanged();
            return gp;
        }
        return 0;
    }

    public void AddGift(eGiftType type)
    {
        List<ItemInfo> list = new List<ItemInfo>();
        bool testActive = GameProperties.TestActive;
        switch (type)
        {
            case eGiftType.MONEY:
                if (testActive)
                {
                    AddMoney(GameProperties.FreeMoney);
                }
                break;
            case eGiftType.SMALL_EXP:
                {
                    string[] array2 = GameProperties.FreeExp.Split('|');
                    ItemTemplateInfo itemTemplateInfo2 = ItemMgr.FindItemTemplate(Convert.ToInt32(array2[0]));
                    if (itemTemplateInfo2 != null)
                    {
                        list.Add(ItemInfo.CreateFromTemplate(itemTemplateInfo2, Convert.ToInt32(array2[1]), 102));
                    }
                    break;
                }
            case eGiftType.BIG_EXP:
                {
                    string[] array3 = GameProperties.BigExp.Split('|');
                    ItemTemplateInfo itemTemplateInfo3 = ItemMgr.FindItemTemplate(Convert.ToInt32(array3[0]));
                    if (itemTemplateInfo3 != null && testActive)
                    {
                        list.Add(ItemInfo.CreateFromTemplate(itemTemplateInfo3, Convert.ToInt32(array3[1]), 102));
                    }
                    break;
                }
            case eGiftType.PET_EXP:
                {
                    string[] array = GameProperties.PetExp.Split('|');
                    ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(Convert.ToInt32(array[0]));
                    if (itemTemplateInfo != null && testActive)
                    {
                        list.Add(ItemInfo.CreateFromTemplate(itemTemplateInfo, Convert.ToInt32(array[1]), 102));
                    }
                    break;
                }
        }
        foreach (ItemInfo item in list)
        {
            item.IsBinds = true;
            AddTemplate(item, item.Template.BagType, item.Count, eGameView.dungeonTypeGet);
        }
    }

    public int AddGiftToken(int value)
    {
        if (value > 0)
        {
            m_character.GiftToken += value;
            OnPlayerAddItem("GiftToken", value);
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    //public bool AddItem(ItemInfo item)
    //{
    //    AbstractInventory itemInventory = GetItemInventory(item.Template);
    //    return itemInventory.AddItem(item, itemInventory.BeginSlot);
    //}

    public bool AddItem(ItemInfo item)
    {
        if (item.Template.BagType == (int)eBageType.EquipBag)
        {
            return m_equipBag.AddItem(item);
        }
        AbstractInventory bg = GetItemInventory(item.Template);
        return bg.AddItem(item, bg.BeginSlot);
    }

    public int AddLeagueMoney(int value)
    {
        if (value > 0)
        {
            m_battle.MatchInfo.dailyScore += value;
            m_battle.MatchInfo.weeklyScore += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int RemoveLeagueMoney(int value)
    {
        if (value > 0)
        {
            m_battle.MatchInfo.dailyScore -= value;
            m_battle.MatchInfo.weeklyScore -= value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public void AddLog(string type, string content)
    {
        using PlayerBussiness playerBussiness = new PlayerBussiness();
        playerBussiness.AddUserLogEvent(PlayerCharacter.ID, PlayerCharacter.UserName, PlayerCharacter.NickName, type, content);
    }

    public int AddMoney(int value)
    {
        return AddMoney(value, igroneAll: true);
    }

    public int AddMoney(int value, bool igroneAll)
    {
        if (value > 0)
        {
            if (!igroneAll && BlockReceiveMoney)
            {
                SendMessage("Vì bạn đăng nhập quá số tài khoản cho phép nên không nhận được thưởng.");
                //m_character.Money += (int)Math.Round((double)value * 0.3);
                //OnPropertiesChanged();
                return 0;
            }
            m_character.Money += value;
            this.count_addmoney++;
            AddLog("AddMoney", "Tài khoản " + m_character.UserName + "nhận " + value + "xu vào tài khoản" + m_character.NickName);
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddBadLuckCaddy(int value)
    {
        if (value > 0)
        {
            m_character.badLuckNumber += value;
            if (m_character.badLuckNumber == int.MinValue)
            {
                m_character.badLuckNumber = int.MaxValue;
                SendMessage("Limite de gemas excedido.");
            }
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddOffer(int value)
    {
        return AddOffer(value, IsRate: true);
    }

    public int RefreshLeagueGetReward(int awardGot, int Score)
    {
        if (awardGot > 0)
        {
            MatchInfo.leagueItemsGet = awardGot;
            MatchInfo.weeklyScore -= Score;
            OnPropertiesChanged();
            return awardGot;
        }
        return 0;
    }

    public int AddOffer(int value, bool IsRate)
    {
        if (value > 0)
        {
            if (AntiAddictionMgr.ISASSon)
            {
                value = (int)((double)value * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
            }
            if (IsRate)
            {
                value *= (((int)OfferAddPlus == 0) ? 1 : ((int)OfferAddPlus));
            }
            m_character.Offer += value;
            OnFightAddOffer(value);
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddPetScore(int value)
    {
        if (value > 0)
        {
            m_character.petScore += value;
            if (m_character.petScore == int.MinValue)
            {
                m_character.petScore = int.MaxValue;
                SendMessage("Vượt quá giới hạn petScore");
            }
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public void AddPrestige(bool isWin, eRoomType roomType)
    {
        if (m_character.Grade >= 20)
        {
            BattleData.AddPrestige(isWin);
            OnPropertiesChanged();
        }
        else
        {
            SendMessage("Cấp nhỏ hơn 20 không thể nhận lệnh bài!");
        }
    }

    //public void AddPrestige(bool isWin)
    //{
    //    BattleData.AddPrestige(isWin);
    //}

    public void UpdateRestCount()
    {
        BattleData.Update();
    }

    public int AddRichesOffer(int value)
    {
        if (value > 0)
        {
            m_character.RichesOffer += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddRobRiches(int value)
    {
        if (value > 0)
        {
            if (AntiAddictionMgr.ISASSon)
            {
                value = (int)((double)value * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
            }
            m_character.RichesRob += value;
            OnPlayerAddItem("RichesRob", value);
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddScore(int value)
    {
        if (value > 0)
        {
            m_character.Score += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public bool AddTemplate(ItemInfo cloneItem)
    {
        return AddTemplate(cloneItem, cloneItem.Template.BagType, cloneItem.Count, eGameView.OtherTypeGet);
    }

    public bool AddTemplate(List<ItemInfo> infos)
    {
        return AddTemplate(infos, eGameView.OtherTypeGet);
    }

    public bool AddTemplate(ItemInfo cloneItem, string name)
    {
        return AddTemplate(cloneItem, cloneItem.Template.BagType, cloneItem.Count, eGameView.OtherTypeGet, name);
    }

    public bool AddTemplate(List<ItemInfo> infos, eGameView typeGet)
    {
        if (infos != null)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            foreach (ItemInfo info in infos)
            {
                info.IsBinds = true;
                if (!StackItemToAnother(info) && !AddItem(info))
                {
                    list.Add(info);
                }
            }
            BagFullSendToMail(list);
            return true;
        }
        return false;
    }

    public bool AddTemplate(List<ItemInfo> infos, int count, eGameView gameView)
    {
        if (infos != null)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            foreach (ItemInfo info in infos)
            {
                info.IsBinds = true;
                info.Count = count;
                if (!StackItemToAnother(info) && !AddItem(info))
                {
                    list.Add(info);
                }
            }
            BagFullSendToMail(list);
            return true;
        }
        return false;
    }

    public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView)
    {
        if (eBageType.FightBag == bagType)
        {
            return FightBag.AddItem(cloneItem);
        }
        return AddTemplate(cloneItem, bagType, count, gameView, "no");
    }

    public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView, string Name)
    {
        if (cloneItem != null)
        {
            SpecialItemBoxInfo specialValue = new SpecialItemBoxInfo();
            List<ItemInfo> itemOverDue = new List<ItemInfo>();
            AddLog("AddTemplate: ", "ItemInfo: " + cloneItem.Name + "," + cloneItem.ItemID + "," + cloneItem.TemplateID + "|eBageType: " + bagType + "|Count: " + count + "|eGameView: " + gameView + "|Name: " + Name);
            cloneItem.Count = count;
            if (!StackItemToAnother(cloneItem) && !AddItem(cloneItem))
            {
                itemOverDue.Add(cloneItem);
            }
            BagFullSendToMail(itemOverDue);
            if (Name != "no")
            {
                SendItemNotice(cloneItem, (int)gameView, Name);
                SendMessage(LanguageMgr.GetTranslation("AddTemplate.Notice", cloneItem.Template == null ? "null" : cloneItem.Template.Name, cloneItem.Count));
            }
            return true;
        }
        return false;
    }

    public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, bool backToMail)
    {
        PlayerInventory inventory = GetInventory(bagType);
        if (inventory != null && !cloneItem.Template.IsSpecial())
        {
            if (inventory.AddTemplate(cloneItem, count))
            {
                if (CurrentRoom != null && CurrentRoom.IsPlaying)
                {
                    SendItemNotice(cloneItem);
                }
                return true;
            }
            if (backToMail && cloneItem.Template.CategoryID != 10)
            {
                SendItemsToMail(cloneItem, LanguageMgr.GetTranslation("GamePlayer.Msg18"), LanguageMgr.GetTranslation("GamePlayer.Msg18"), eMailType.BuyItem);
            }
        }
        return false;
    }

    public bool RemoveTemplateInShop(int templateid, int count)
    {
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateid);
        if (itemTemplateInfo != null)
        {
            PlayerInventory itemInventory = GetItemInventory(itemTemplateInfo);
            if (itemInventory != null)
            {
                return itemInventory.RemoveTemplate(templateid, count);
            }
        }
        return false;
    }

    public int GetTemplateCount(int templateId)
    {
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
        if (itemTemplateInfo != null)
        {
            PlayerInventory itemInventory = GetItemInventory(itemTemplateInfo);
            if (itemInventory != null)
            {
                return itemInventory.GetItemCount(templateId);
            }
        }
        return 0;
    }

    private void SendItemNotice(ItemInfo item)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(14);
        gSPacketIn.WriteString(PlayerCharacter.NickName);
        gSPacketIn.WriteInt(1);
        gSPacketIn.WriteInt(item.TemplateID);
        gSPacketIn.WriteBoolean(item.IsBinds);
        gSPacketIn.WriteInt(1);
        if (item.Template.Quality >= 3 && item.Template.Quality < 5)
        {
            if (CurrentRoom != null)
            {
                CurrentRoom.SendToTeam(gSPacketIn, CurrentRoomTeam, this);
            }
        }
        else
        {
            if (item.Template.Quality < 5)
            {
                return;
            }
            GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
            GamePlayer[] gamePlayers = WorldMgr.GetAllPlayers();
            foreach (GamePlayer player in gamePlayers)
            {
                if (player != this)
                {
                    player.Out.SendTCP(gSPacketIn);
                }
            }
        }
    }

    public void ApertureEquip(int level)
    {
        EquipShowImp(0, (level < 5) ? 1 : ((level < 7) ? 2 : 3));
    }

    public void BagFullSendToMail(List<ItemInfo> infos)
    {
        if (infos.Count > 0)
        {
            bool flag = false;
            using (new PlayerBussiness())
            {
                flag = SendItemsToMail(infos, "Administrator", "Administrator 1", eMailType.BuyItem);
            }
            if (flag)
            {
                Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
            }
        }
    }

    public void BeginAllChanges()
    {
        BeginChanges();
        m_bufferList.BeginChanges();
        m_equipBag.BeginChanges();
        m_propBag.BeginChanges();
        FarmBag.BeginChanges();
        Vegetable.BeginChanges();
    }

    public void BeginChanges()
    {
        Interlocked.Increment(ref m_changed);
    }

    public void RemoveLotteryItems(int templateId, int count)
    {
        foreach (ItemBoxInfo lotteryItem in LotteryItems)
        {
            if (lotteryItem.TemplateId == templateId && lotteryItem.ItemCount == count)
            {
                LotteryItems.Remove(lotteryItem);
                break;
            }
        }
    }

    public bool CanEquip(ItemTemplateInfo item)
    {
        bool flag = true;
        string message = "";
        if (!item.CanEquip)
        {
            flag = false;
            message = LanguageMgr.GetTranslation("Game.Server.GameObjects.NoEquip");
        }
        else if (m_character.Grade < item.NeedLevel)
        {
            flag = false;
            message = LanguageMgr.GetTranslation("Game.Server.GameObjects.CanLevel");
        }
        if (!flag)
        {
            Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, message);
        }
        return flag;
    }

    public int GetVIPNextLevelDaysNeeded(int viplevel, int vipexp)
    {
        if (viplevel != 0 && vipexp > 0 && viplevel <= 8)
        {
            List<int> list = GameProperties.VIPExp();
            ShopItemInfo itemVipInfo = ShopMgr.FindShopbyTemplateID((int)Game.Server.Packets.EquipType.VIPCARD);
            int adddaily = (int)(itemVipInfo.AValue1 / itemVipInfo.AUnit) * 2;

            float result = 0;
            float vipExpCompared = (float)list[viplevel] - (float)vipexp;//so sánh exp hiện tại với vipexp kế tiếp, listIndex start 0 -> 8 tương đương vipLevel 1 -> 9

            if (PlayerCharacter.typeVIP == 2)
            {
                result = vipExpCompared / adddaily;
            }
            else if (PlayerCharacter.typeVIP == 1)
            {
                result = vipExpCompared / adddaily;
            }

            if (result < 0)
            {
                log.Info("GetVIPNextLevelDaysNeeded bug: compared vipexp > nextVipExp by VipLevel! CharacterID :" + m_character.ID);
            }

            OnVIPUpgrade(m_character.VIPLevel, m_character.VIPExp);
            return (int)Math.Ceiling(result > 0 ? result : 0);
        }
        OnVIPUpgrade(m_character.VIPLevel, m_character.VIPExp);
        return 0;
    }

    public bool canUpLv(int exp, int _curLv)
    {
        List<int> list = GameProperties.VIPExp();
        if (exp >= list[0] && _curLv == 0)
        {
            return true;
        }
        if (exp >= list[1] && _curLv == 1)
        {
            return true;
        }
        if (exp >= list[2] && _curLv == 2)
        {
            return true;
        }
        if (exp >= list[3] && _curLv == 3)
        {
            return true;
        }
        if (exp >= list[4] && _curLv == 4)
        {
            return true;
        }
        if (exp >= list[5] && _curLv == 5)
        {
            return true;
        }
        if (exp >= list[6] && _curLv == 6)
        {
            return true;
        }
        if (exp >= list[7] && _curLv == 7)
        {
            return true;
        }
        if (exp >= list[8] && _curLv == 8)
        {
            return true;
        }
        return false;
    }

    public bool canDownLv(int exp, int _curLv)
    {
        List<int> list = GameProperties.VIPExp();
        if (_curLv == 0 || _curLv == 9)
        {
            return false;
        }
        if (exp < list[1] && _curLv == 1)
        {
            return true;
        }
        if (exp < list[2] && _curLv == 2)
        {
            return true;
        }
        if (exp < list[3] && _curLv == 3)
        {
            return true;
        }
        if (exp < list[4] && _curLv == 4)
        {
            return true;
        }
        if (exp < list[5] && _curLv == 5)
        {
            return true;
        }
        if (exp < list[6] && _curLv == 6)
        {
            return true;
        }
        if (exp < list[7] && _curLv == 7)
        {
            return true;
        }
        if (exp < list[8] && _curLv == 8)
        {
            return true;
        }
        return false;
    }

    public void ClearCaddyBag()
    {
        List<ItemInfo> list = new List<ItemInfo>();
        for (int i = 0; i < CaddyBag.Capalility; i++)
        {
            ItemInfo itemAt = CaddyBag.GetItemAt(i);
            if (itemAt != null)
            {
                ItemInfo itemInfo = ItemInfo.CloneFromTemplate(itemAt.Template, itemAt);
                itemInfo.Count = 1;
                list.Add(itemInfo);
            }
        }
        CaddyBag.ClearBag();
        AddTemplate(list);

    }

    public int GetMedalNum()
    {
        int itemCount = PropBag.GetItemCount(11408);
        int num = 0;
        if (m_character.IsConsortia)
        {
            num = ConsortiaBag.GetItemCount(11408);
        }
        int itemCount2 = BankBag.GetItemCount(11408);
        return itemCount + num + itemCount2;
    }

    public bool SendEventLiveRewards(EventLiveInfo eventLiveInfo)
    {
        List<EventLiveGoods> eventGoods = EventLiveMgr.GetEventGoods(eventLiveInfo);
        new List<ItemInfo>();
        foreach (EventLiveGoods item in eventGoods)
        {
            if (item.TemplateID != -100 && item.TemplateID != -200)
            {
                ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(item.TemplateID);
                if (itemTemplateInfo != null)
                {
                    int num = (PlayerCharacter.Sex ? 1 : 2);
                    if (itemTemplateInfo.NeedSex != 0 && itemTemplateInfo.NeedSex != num)
                    {
                        continue;
                    }
                    int count = item.Count;
                    for (int i = 0; i < count; i += itemTemplateInfo.MaxCount)
                    {
                        int count2 = ((i + itemTemplateInfo.MaxCount > count) ? (count - i) : itemTemplateInfo.MaxCount);
                        ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, count2, 120);
                        if (itemInfo != null)
                        {
                            itemInfo.StrengthenLevel = item.StrengthenLevel;
                            itemInfo.AttackCompose = item.AttackCompose;
                            itemInfo.DefendCompose = item.DefendCompose;
                            itemInfo.AgilityCompose = item.AgilityCompose;
                            itemInfo.LuckCompose = item.LuckCompose;
                            itemInfo.IsBinds = item.IsBind;
                            itemInfo.ValidDate = item.ValidDate;
                            SendItemToMail(itemInfo, LanguageMgr.GetTranslation("Game.Server.GameObjects.SendEventLiveRewards.Content", eventLiveInfo.Description), LanguageMgr.GetTranslation("Game.Server.GameObjects.SendEventLiveRewards.Title"), eMailType.Manage);
                        }
                    }
                }
            }
            if (item.TemplateID == -100)
            {
                AddGold(item.Count);
            }
            if (item.TemplateID == -200)
            {
                AddMoney(item.Count);
            }
            if (item.TemplateID == -300)
            {
                AddGiftToken(item.Count);
            }
            if (item.TemplateID == -800)
            {
                AddHonor(item.Count);
            }
        }
        return true;
    }

    public void ClearConsortia(bool isclear)
    {
        string sender = LanguageMgr.GetTranslation("Game.Server.GameUtils.ConsortiaBag.Sender");
        string title = LanguageMgr.GetTranslation("Game.Server.GameUtils.ConsortiaBag.Title");
        if (isclear) PlayerCharacter.ClearConsortia();
        if (PlayerCharacter.ConsortiaID != 0 || ConsortiaBag.GetItems().Count <= 0) return;
        List<ItemInfo> listitem = new List<ItemInfo>();
        foreach (ItemInfo item in ConsortiaBag.GetItems())
        {
            if (item.IsValidItem())
            {
                listitem.Add(item.Clone());
            }
        }
        OnPropertiesChanged();
        QuestInventory.ClearConsortiaQuest();
        //ConsortiaBag.ClearBag();
        //ConsortiaBag.SaveToDatabase();
        //SendItemsToMail(listitem, sender, title, eMailType.StoreCanel);
        ConsortiaBag.SendAllItemsToMail(sender, title, eMailType.StoreCanel);
    }

    public bool ClearFightBag()
    {
        FightBag.ClearBag();
        return true;
    }

    public void ClearFightBuffOneMatch()
    {
        List<BufferInfo> list = new List<BufferInfo>();
        foreach (BufferInfo fightBuff in FightBuffs)
        {
            if (fightBuff != null)
            {
                switch (fightBuff.Type)
                {
                    case (int)BuffType.WorldBossHP:
                    case (int)BuffType.WorldBossHP_MoneyBuff:
                    case (int)BuffType.WorldBossAttrack:
                    case (int)BuffType.WorldBossAttrack_MoneyBuff:
                    case (int)BuffType.WorldBossMetalSlug:
                    case (int)BuffType.WorldBossAncientBlessings:
                    case (int)BuffType.WorldBossAddDamage:
                        list.Add(fightBuff);
                        break;
                }
            }
        }
        foreach (BufferInfo item in list)
        {
            FightBuffs.Remove(item);
        }
        list.Clear();
    }

    public void ClearFootballCard()
    {
        for (int i = 0; i < CardsTakeOut.Length; i++)
        {
            CardsTakeOut[i] = null;
        }
    }

    public void ClearStoreBag()
    {
        for (int i = 0; i < this.StoreBag.Capalility; i++)
        {
            ItemInfo itemAt = this.StoreBag.GetItemAt(i);
            if (itemAt != null)
            {
                if (itemAt.Template.BagType == eBageType.PropBag)
                {
                    int place = this.PropBag.FindFirstEmptySlot();
                    if (this.PropBag.AddItemTo(itemAt, place))
                    {
                        this.StoreBag.TakeOutItem(itemAt);
                    }
                }
                else
                {
                    int place = this.EquipBag.FindFirstEmptySlot(31);
                    if (place > 0)
                    {
                        if (this.EquipBag.AddItemTo(itemAt, place))
                            this.StoreBag.TakeOutItem(itemAt);
                    }
                }
            }
        }
        List<ItemInfo> items = this.StoreBag.GetItems();
        if (items.Count > 0)
        {
            this.StoreBag.SendAllItemsToMail("Hệ thống", "Vật phẩm trả về từ Tiệm rèn.", eMailType.StoreCanel);
        }
    }

    public bool ClearTempBag()
    {
        TempBag.ClearBag();
        //TempBag.SaveToDatabase();
        return true;
    }

    public void CommitAllChanges()
    {
        CommitChanges();
        m_bufferList.CommitChanges();
        m_equipBag.CommitChanges();
        m_propBag.CommitChanges();
        FarmBag.CommitChanges();
        Vegetable.CommitChanges();
    }

    public void CommitChanges()
    {
        Interlocked.Decrement(ref m_changed);
        OnPropertiesChanged();
    }

    public int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int count)
    {
        return ConsortiaMgr.ConsortiaFight(consortiaWin, consortiaLose, players, roomType, gameClass, totalKillHealth, count);
    }

    public void ContinousVIP(int days)
    {
        DateTime now = DateTime.Now;
        DateTime dateTime2 = (m_character.VIPExpireDay = ((!(m_character.VIPExpireDay < DateTime.Now)) ? m_character.VIPExpireDay.AddDays(days) : DateTime.Now.AddDays(days)));
        DateTime dateTime3 = dateTime2;
        now = dateTime3;
        m_character.typeVIP = SetTypeVIP(days);
    }

    public string ConverterPvePermission(char[] chArray)
    {
        string text = "";
        for (int i = 0; i < chArray.Length; i++)
        {
            text += chArray[i];
        }
        return text;
    }

    public List<ItemInfo> CopyDrop(int SessionId, int m_missionInfoId)
    {
        List<ItemInfo> info = null;
        DropInventory.CopyDrop(m_missionInfoId, SessionId, ref info);
        return info;
    }

    public void ChargeToUser()
    {
        using PlayerBussiness playerBussiness = new PlayerBussiness();
        int money = 0;
        string translation = LanguageMgr.GetTranslation("ChargeToUser.Title");
        if (!playerBussiness.ChargeToUser(m_character.UserName, ref money, m_character.NickName))
        {
            return;
        }
        string translation2 = LanguageMgr.GetTranslation("ChargeToUser.Content", money);
        if (money <= 0)
        {
            return;
        }
        OnPropertiesChange();
        SendMailToUser(playerBussiness, translation2, translation, eMailType.Manage);
        AddMoney(money);
        OnMoneyCharge(money);
        if (money >= 50000)
        {
            if (m_character.Sex == true)
            {
                SendMessage(LanguageMgr.GetTranslation($"Phú ông [{m_character.NickName}] đã đổi thành công {money} xu vào game. Nhanh trí inbox xin xỏ nào!!!"));
            }
            else
            {
                SendMessage(LanguageMgr.GetTranslation($"Phú bà [{m_character.NickName}] đã đổi thành công {money} xu vào game. Nhanh trí inbox xin xỏ nào!!!"));
            }
        }
        Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
        if (Extra.CheckNoviceActiveOpen(NoviceActiveType.RECHANGE_MONEY_ACTIVE))
        {
            Extra.UpdateEventCondition((int)NoviceActiveType.RECHANGE_MONEY_ACTIVE, money, isPlus: true, 0);
        }
        if (Extra.CheckNoviceActiveOpen(NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK))
        {
            Extra.UpdateEventCondition((int)NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK, money, isPlus: true, 0);
        }
        if (!PlayerCharacter.IsRecharged)
        {
            PlayerCharacter.IsRecharged = true;
            Out.SendUpdateFirstRecharge(PlayerCharacter.IsRecharged, PlayerCharacter.IsGetAward);
        }
        if (Extra.Info.LeftRoutteRate > 0f)
        {
            int MoneyRate = (int)((float)(money * Extra.Info.LeftRoutteRate) / 100);//50000 + (50000 * 2)/100
            if (MoneyRate > 0)
            {
                SendMoneyMailToUser(LanguageMgr.GetTranslation("GameServer.LeftRotterMail.Title"), LanguageMgr.GetTranslation("GameServer.LeftRotterMail.Content", MoneyRate), MoneyRate, eMailType.BuyItem);
            }
            Extra.Info.LeftRoutteRate = 0f;
            Out.SendLeftRouleteOpen(Extra.Info);
        }
        this.SaveIntoDatabase();
    }

    public void ChecVipkExpireDay()
    {
        if (m_character.IsVIPExpire())
        {
            m_character.CanTakeVipReward = false;
            m_character.typeVIP = 0;
        }
        else if (m_character.IsLastVIPPackTime())
        {
            m_character.CanTakeVipReward = true;
        }
        else
        {
            m_character.CanTakeVipReward = false;
        }
    }

    public bool DeletePropItem(int place)
    {
        FightBag.RemoveItemAt(place);
        return true;
    }

    public virtual void Disconnect()
    {
        m_client.Disconnect();
    }

    public bool EquipItem(ItemInfo item, int place)
    {
        if (!item.CanEquip() || item.BagType != m_equipBag.BagType)
        {
            return false;
        }
        int num = m_equipBag.FindItemEpuipSlot(item.Template);
        if ((uint)(num - 9) <= 1u && place switch
        {
            10 => 0,
            9 => 0,
            _ => 1,
        } == 0)
        {
            num = place;
        }
        else if ((num == 7 || num == 8) && (place == 7 || place == 8))
        {
            num = place;
        }
        return m_equipBag.MoveItem(item.Place, num, item.Count);
    }

    private void EquipShowImp(int categoryID, int para)
    {
        UpdateHide(m_character.Hide + (int)(Math.Pow(10.0, categoryID) * (double)(para - m_character.Hide / (int)Math.Pow(10.0, categoryID) % 10)));
    }

    public bool FindEmptySlot(eBageType bagType)
    {
        PlayerInventory inventory = GetInventory(bagType);
        inventory.FindFirstEmptySlot();
        return inventory.FindFirstEmptySlot() > 0;
    }

    public void FriendsAdd(int playerID, int relation)
    {
        if (!_friends.ContainsKey(playerID))
        {
            _friends.Add(playerID, relation);
        }
        else
        {
            _friends[playerID] = relation;
        }
    }

    public void FriendsRemove(int playerID)
    {
        if (_friends.ContainsKey(playerID))
        {
            _friends.Remove(playerID);
        }
    }

    public double GetBaseAgility()
    {
        return 1.0 - (double)m_character.Agility * 0.001;
    }

    public double GetBaseAttack()
    {
        int num = 0;
        int num2 = 0;
        double DamageAvatar = 0.0;
        foreach (UsersCardInfo card in CardBag.GetCards(0, 4))
        {
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(card.TemplateID);
            if (itemTemplateInfo != null)
            {
                num2 += itemTemplateInfo.Property4 + card.Damage;
            }
        }
        UserRankInfo singleRank = Rank.GetSingleRank(PlayerCharacter.Honor);
        if (singleRank != null && singleRank.IsValidRank())
        {
            num2 += singleRank.Damage;
        }
        int baseattack = num + num2;
        ItemInfo itemAt = m_equipBag.GetItemAt(6);
        if (itemAt != null)
        {
            double num3 = itemAt.Template.Property7;
            int num4 = (itemAt.isGold ? 1 : 0);
            double para = itemAt.StrengthenLevel + num4;
            baseattack += (int)(getHertAddition(num3, para) + num3);
            if (itemAt.Hole1 > 0)
            {
                BaseAttack(itemAt.Hole1, ref baseattack);
            }
            if (itemAt.Hole2 > 0)
            {
                BaseAttack(itemAt.Hole2, ref baseattack);
            }
            if (itemAt.Hole3 > 0)
            {
                BaseAttack(itemAt.Hole3, ref baseattack);
            }
            if (itemAt.Hole4 > 0)
            {
                BaseAttack(itemAt.Hole4, ref baseattack);
            }
            if (itemAt.Hole5 > 0)
            {
                BaseAttack(itemAt.Hole5, ref baseattack);
            }
            if (itemAt.Hole6 > 0)
            {
                BaseAttack(itemAt.Hole6, ref baseattack);
            }
        }
        ItemInfo itemAt2 = m_equipBag.GetItemAt(0);
        ItemInfo itemAt3 = m_equipBag.GetItemAt(4);
        if (itemAt2 != null)
        {
            if (itemAt2.Hole1 > 0)
            {
                BaseAttack(itemAt2.Hole1, ref baseattack);
            }
            if (itemAt2.Hole2 > 0)
            {
                BaseAttack(itemAt2.Hole2, ref baseattack);
            }
            if (itemAt2.Hole3 > 0)
            {
                BaseAttack(itemAt2.Hole3, ref baseattack);
            }
            if (itemAt2.Hole4 > 0)
            {
                BaseAttack(itemAt2.Hole4, ref baseattack);
            }
            if (itemAt2.Hole5 > 0)
            {
                BaseAttack(itemAt2.Hole5, ref baseattack);
            }
            if (itemAt2.Hole6 > 0)
            {
                BaseAttack(itemAt2.Hole6, ref baseattack);
            }
        }
        if (itemAt3 != null)
        {
            if (itemAt3.Hole1 > 0)
            {
                BaseAttack(itemAt3.Hole1, ref baseattack);
            }
            if (itemAt3.Hole2 > 0)
            {
                BaseAttack(itemAt3.Hole2, ref baseattack);
            }
            if (itemAt3.Hole3 > 0)
            {
                BaseAttack(itemAt3.Hole3, ref baseattack);
            }
            if (itemAt3.Hole4 > 0)
            {
                BaseAttack(itemAt3.Hole4, ref baseattack);
            }
            if (itemAt3.Hole5 > 0)
            {
                BaseAttack(itemAt3.Hole5, ref baseattack);
            }
            if (itemAt3.Hole6 > 0)
            {
                BaseAttack(itemAt3.Hole6, ref baseattack);
            }
        }
        List<UserAvatarCollectionInfo> avatarPropertyActived = this.AvatarCollect.GetAvatarPropertyActived();
        if (avatarPropertyActived.Count > 0)
        {
            foreach (UserAvatarCollectionInfo current3 in avatarPropertyActived)
            {
                ClothPropertyTemplateInfo clothProperty = current3.ClothProperty;
                if (clothProperty != null)
                {
                    int num8 = ClothGroupTemplateInfoMgr.CountClothGroupWithID(current3.AvatarID);
                    if (current3.Items.Count >= num8 / 2 && current3.Items.Count < num8)
                    {
                        DamageAvatar += (double)clothProperty.Damage;
                    }
                    else if (current3.Items.Count == num8)
                    {
                        DamageAvatar += (double)(clothProperty.Damage * 2);
                    }
                }
            }
        }
        this.PlayerProp.UpadateBaseProp(true, "Damage", "Avatar", DamageAvatar);
        baseattack += TotemMgr.GetTotemProp(m_character.totemId, "dam");
        return baseattack + DamageAvatar;
    }

    public void BaseAttack(int template, ref int baseattack)
    {
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(template);
        if (itemTemplateInfo != null && itemTemplateInfo.CategoryID == 11 && itemTemplateInfo.Property1 == 31 && itemTemplateInfo.Property2 == 3)
        {
            baseattack += itemTemplateInfo.Property7;
        }
    }

    public double GetBaseBlood()
    {
        ItemInfo info = EquipBag.GetItemAt(12);
        if (info != null)
        {
            //return (100.0 + (double)itemAt.Template.Property1) / 100.0;
            return (100.0 + (double)info.Template.Property1 + (double)PlayerCharacter.necklaceExpAdd) / 100.0;
        }
        return 1.0;
    }

    public double GetBaseDefence()
    {
        int defence = 0;
        int num = 0;
        double GuardAvatar = 0.0;
        foreach (UsersCardInfo card in CardBag.GetCards(0, 4))
        {
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(card.TemplateID);
            if (itemTemplateInfo != null)
            {
                num += itemTemplateInfo.Property5 + card.Guard;
            }
        }
        UserRankInfo singleRank = Rank.GetSingleRank(PlayerCharacter.Honor);
        if (singleRank != null && singleRank.IsValidRank())
        {
            num += singleRank.Guard;
        }
        PlayerProp.UpadateBaseProp(isSelf: true, "Armor", "Pet", HoGiap);
        ItemInfo itemAt = m_equipBag.GetItemAt(6);
        ItemInfo itemAt2 = m_equipBag.GetItemAt(0);
        ItemInfo itemAt3 = m_equipBag.GetItemAt(4);
        if (itemAt2 != null)
        {
            double num2 = itemAt2.Template.Property7;
            int num3 = (itemAt2.isGold ? 1 : 0);
            double para = itemAt2.StrengthenLevel + num3;
            defence += (int)(getHertAddition(num2, para) + num2);
            AddProperty(itemAt2, ref defence);
        }
        if (itemAt3 != null)
        {
            double num4 = itemAt3.Template.Property7;
            int num5 = (itemAt3.isGold ? 1 : 0);
            double para2 = itemAt3.StrengthenLevel + num5;
            defence += (int)(getHertAddition(num4, para2) + num4);
            AddProperty(itemAt3, ref defence);
        }
        if (itemAt != null)
        {
            AddProperty(itemAt, ref defence);
        }
        defence += num;
        List<UserAvatarCollectionInfo> avatarPropertyActived = this.AvatarCollect.GetAvatarPropertyActived();
        if (avatarPropertyActived.Count > 0)
        {
            foreach (UserAvatarCollectionInfo current2 in avatarPropertyActived)
            {
                ClothPropertyTemplateInfo clothProperty = current2.ClothProperty;
                if (clothProperty != null)
                {
                    int num14 = ClothGroupTemplateInfoMgr.CountClothGroupWithID(current2.AvatarID);
                    if (current2.Items.Count >= num14 / 2 && current2.Items.Count < num14)
                    {
                        GuardAvatar += (double)clothProperty.Guard;
                    }
                    else if (current2.Items.Count == num14)
                    {
                        GuardAvatar += (double)(clothProperty.Guard * 2);
                    }
                }
            }
        }
        this.PlayerProp.UpadateBaseProp(true, "Armor", "Avatar", GuardAvatar);
        defence += TotemMgr.GetTotemProp(m_character.totemId, "gua");
        return defence + GuardAvatar + HoGiap;
    }

    public void AddProperty(ItemInfo item, ref int defence)
    {
        if (item.Hole1 > 0)
        {
            BaseDefence(item.Hole1, ref defence);
        }
        if (item.Hole2 > 0)
        {
            BaseDefence(item.Hole2, ref defence);
        }
        if (item.Hole3 > 0)
        {
            BaseDefence(item.Hole3, ref defence);
        }
        if (item.Hole4 > 0)
        {
            BaseDefence(item.Hole4, ref defence);
        }
        if (item.Hole5 > 0)
        {
            BaseDefence(item.Hole5, ref defence);
        }
        if (item.Hole6 > 0)
        {
            BaseDefence(item.Hole6, ref defence);
        }
    }

    public void BaseDefence(int template, ref int defence)
    {
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(template);
        if (itemTemplateInfo != null && itemTemplateInfo.CategoryID == 11 && itemTemplateInfo.Property1 == 31 && itemTemplateInfo.Property2 == 3)
        {
            defence += itemTemplateInfo.Property8;
        }
    }

    public void PVEFightMessage(string translation, ItemInfo itemInfo, int areaID)
    {
        if (translation != null)
        {
            GSPacketIn packet = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, (itemInfo.ItemID == 0) ? 1 : itemInfo.ItemID, itemInfo.TemplateID, "");
            GameServer.Instance.LoginServer.SendPacket(packet);
        }
    }

    public void PVEFightNotice(string msg)
    {
        if (msg != null)
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            for (int i = 0; i < allPlayers.Length; i++)
            {
                allPlayers[i].Out.SendMessage(eMessageType.ChatNormal, msg);
            }
        }
    }

    public void PVERewardNotice(string msg, int itemID, int templateID)
    {
        if (msg != null)
        {
            GSPacketIn packet = WorldMgr.SendSysNotice(eMessageType.ChatNormal, msg, itemID, templateID, null);
            GameServer.Instance.LoginServer.SendPacket(packet);
        }
    }

    public void PVPFightMessage(string translation, ItemInfo itemInfo, int areaID)
    {
        if (translation != null)
        {
            GSPacketIn packet = WorldMgr.SendSysNotice(eMessageType.ChatNormal, translation, (itemInfo.ItemID == 0) ? 1 : itemInfo.ItemID, itemInfo.TemplateID, "");
            GameServer.Instance.LoginServer.SendPacket(packet);
        }
    }

    public double getHertAddition(double para1, double para2)
    {
        return Math.Round(para1 * Math.Pow(1.1, para2) - para1);
    }

    public PlayerInventory GetInventory(eBageType bageType)
    {
        switch (bageType)
        {
            case eBageType.CaddyBag:
                return m_caddyBag;
            case eBageType.Consortia:
                return m_ConsortiaBag;
            case eBageType.FarmBag:
                return FarmBag;
            case eBageType.Vegetable:
                return Vegetable;
            case eBageType.EquipBag:
                return m_equipBag;
            case eBageType.FightBag:
                return m_fightBag;
            case eBageType.Food:
                return m_food;
            case eBageType.PetEgg:
                return m_petEgg;
            case eBageType.PropBag:
                return m_propBag;
            case eBageType.Store:
                return m_storeBag;
            case eBageType.TempBag:
                return m_tempBag;
            case eBageType.BankBag:
                return m_BankBag;
            default:
                log.Error($"Did not support this type bag: {bageType} PlayerID: {PlayerCharacter.ID} Nickname: {PlayerCharacter.NickName}");
                return null;
        }
    }

    public string GetInventoryName(eBageType bageType)
    {
        return bageType switch
        {
            eBageType.EquipBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.Equip"),
            eBageType.PropBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.Prop"),
            eBageType.FightBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.FightBag"),
            eBageType.BeadBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.BeadBag"),
            eBageType.FarmBag => LanguageMgr.GetTranslation("Game.Server.GameObjects.FarmBag"),
            _ => bageType.ToString(),
        };
    }

    public ItemInfo GetItemAt(eBageType bagType, int place)
    {
        return GetInventory(bagType)?.GetItemAt(place);
    }

    public ItemInfo GetItemByTemplateID(int templateID)
    {
        ItemInfo itemByTemplateID = GetInventory(eBageType.EquipBag).GetItemByTemplateID(31, templateID);
        if (itemByTemplateID == null)
        {
            itemByTemplateID = GetInventory(eBageType.PropBag).GetItemByTemplateID(0, templateID);
        }
        if (itemByTemplateID == null)
        {
            itemByTemplateID = GetInventory(eBageType.Consortia).GetItemByTemplateID(0, templateID);
        }
        if (itemByTemplateID == null)
        {
            itemByTemplateID = GetInventory(eBageType.BankBag).GetItemByTemplateID(0, templateID);
        }
        return itemByTemplateID;
    }

    public int GetItemCount(int templateId)
    {
        return m_propBag.GetItemCount(templateId) + m_equipBag.GetItemCount(templateId) + m_ConsortiaBag.GetItemCount(templateId) + m_BankBag.GetItemCount(templateId);
    }

    public PlayerInventory GetItemInventory(ItemTemplateInfo template)
    {
        return GetInventory(template.BagType);
    }

    public void HideEquip(int categoryID, bool hide)
    {
        if (categoryID >= 0 && categoryID < 10)
        {
            EquipShowImp(categoryID, (!hide) ? 1 : 2);
        }
    }

    public char[] InitPvePermission()
    {
        char[] array = new char[50];
        for (int i = 0; i < array.Length; i++)
        {
            array[i] = '1';
        }
        return array;
    }

    public bool IsBlackFriend(int playerID)
    {
        if (_friends != null)
        {
            if (_friends.ContainsKey(playerID))
            {
                return _friends[playerID] == 1;
            }
            return false;
        }
        return true;
    }

    public bool IsConsortia()
    {
        return ConsortiaMgr.FindConsortiaInfo(PlayerCharacter.ConsortiaID) != null;
    }

    public bool IsLimitCount(int count)
    {
        if (GameProperties.IsLimitCount && count > GameProperties.LimitCount)
        {
            SendMessage($"O limite de {GameProperties.LimitCount} foi alcançado.");
            return true;
        }
        return false;
    }

    public bool IsLimitMoney(int count)
    {
        if (GameProperties.IsLimitMoney && count > GameProperties.LimitMoney)
        {
            SendMessage($"O limite de {GameProperties.LimitMoney} foi alcançado de cupons.");
            return true;
        }
        return false;
    }

    public bool IsPveEpicPermission(int copyId)
    {
        string text = "1-2-3-4-5-6-7-8-9-10-11-12-13";
        if (text.Length > 0)
        {
            string[] array = text.Split('-');
            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] == copyId.ToString())
                {
                    return true;
                }
            }
        }
        return false;
    }

    public bool UsePayBuff(BuffType type)
    {
        bool result = false;
        AbstractBuffer ofType = BufferList.GetOfType(type);
        if (ofType?.Check() ?? false)
        {
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(ofType.Info.TemplateID);
            if (itemTemplateInfo != null)
            {
                if (itemTemplateInfo.Property3 > 0 && ofType.Info.ValidCount > 0)
                {
                    ofType.Info.ValidCount--;
                    BufferList.UpdateBuffer(ofType);
                    result = true;
                }
                else if (itemTemplateInfo.Property3 == 0)
                {
                    result = true;
                }
            }
        }
        return result;
    }

    public bool IsPvePermission(int copyId, eHardLevel hardLevel)
    {
        if (copyId <= m_pvepermissions.Length && copyId > 0)
        {
            return m_pvepermissions[copyId - 1] >= permissionChars[(int)hardLevel];
        }
        return true;
    }

    public void OnPropertiesChange()
    {
        if (this.PropertiesChange != null)
        {
            this.PropertiesChange(PlayerCharacter);
        }
    }

    public void LastVIPPackTime()
    {
        m_character.LastVIPPackTime = DateTime.Now;
        m_character.CanTakeVipReward = false;
    }

    public virtual bool LoadFromDatabase()
    {
        bool result = false;
        using PlayerBussiness playerBussiness = new PlayerBussiness();
        PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(m_character.ID);
        if (userSingleByUserID == null)
        {
            Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.Forbid"));
            Client.Disconnect();
            result = false;
        }
        else
        {
            this.TimeCheckHack = (long)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            m_character = userSingleByUserID;
            m_battle.LoadFromDatabase();
            m_battle.UpdateLeagueGrade();
            m_character.Texp = playerBussiness.GetUserTexpInfoSingle(m_character.ID);
            if (m_character.Texp.IsValidadteTexp())
            {
                m_character.Texp.texpCount = 0;
            }
            int[] updatedSlots = new int[3]
            {
                0,
                1,
                2
            };
            Out.SendUpdateInventorySlot(FightBag, updatedSlots);
            UpdateWeaklessGuildProgress();
            UpdateItemForUser(1);
            ChecVipkExpireDay();
            UpdateLevel();
            UpdatePet(m_petBag.GetPetIsEquip());
            if (m_character.CheckNewDay())
            {
                this.QuestInventory.Restart();
                this.QuestInventory.LoadFromDatabase(this.PlayerCharacter.ID);
                OnPlayerLogin();
                m_character.NewDay = DateTime.Now;
                m_character.BoxGetDate = DateTime.Now;
                //m_character.damageScores = 0;
                m_character.Score = 0;
                m_battle.Reset();
                m_extra.Info.MinHotSpring = 60;
                m_extra.Info.LastFreeTimeHotSpring = DateTime.Now;
                m_extra.Info.FreeSendMailCount = 0;
                m_extra.Info.LeftRoutteCount = GameProperties.LeftRouterMaxDay;
                m_extra.Info.LeftRoutteRate = 0f;
                Extra.ResetNoviceEvent(NoviceActiveType.RECHANGE_MONEY_ACTIVE);
                Extra.ResetNoviceEvent(NoviceActiveType.USE_MONEY_ACTIVE);
                if (DateTime.Now.DayOfWeek == DayOfWeek.Monday)
                {
                    Extra.ResetNoviceEvent(NoviceActiveType.RECHANGE_MONEY_ACTIVE_OFWEEK);
                    Extra.ResetNoviceEvent(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK);
                }
                m_character.MaxBuyHonor = 0;
                Farm.ResetFarmProp();
                AccumulativeUpdate();
                this.ChangeDailyExpVip();
            }
            if (this.m_character.Grade > 19)
            {
                this.LoadGemStone(playerBussiness);
            }
            m_pvepermissions = (string.IsNullOrEmpty(m_character.PvePermission) ? InitPvePermission() : m_character.PvePermission.ToCharArray());
            //Console.WriteLine(ConverterPvePermission(m_pvepermissions));
            m_fightlabpermissions = (string.IsNullOrEmpty(m_character.FightLabPermission) ? InitFightLabPermission() : m_character.FightLabPermission.ToCharArray());
            this.LoadPvePermission();
            //Console.WriteLine(ConverterPvePermission(m_pvepermissions));
            this._friends = new Dictionary<int, int>();
            this._friends = playerBussiness.GetFriendsIDAll(m_character.ID);
            ViFarms = new List<int>();
            this.m_character.State = 1;
            this.ClearStoreBag();
            this.ClearCaddyBag();

            PlayerCharacter.VIPNextLevelDaysNeeded = GetVIPNextLevelDaysNeeded(PlayerCharacter.VIPLevel, PlayerCharacter.VIPExp);
            if (m_character.totemId > TotemMgr.MaxTotem())
            {
                m_character.totemId = TotemMgr.MaxTotem();
            }
            playerBussiness.UpdateUserTexpInfo(m_character.Texp);
            playerBussiness.UpdatePlayer(m_character);
            playerBussiness.UpdateUserMatchInfo(MatchInfo);
            this.LoadMedals();
            this.LoadRepute();//bjnboo
            this.SaveIntoDatabase();
            this.SavePlayerInfo();
            result = true;
        }
        return result;
    }

    public void ResetDailyQuest() //baolt delete dailyquest
    {
        PlayerBussiness quests = new PlayerBussiness();
        QuestDataInfo[] DailyQuests = quests.GetUserQuest(this.m_character.ID);
        foreach (QuestDataInfo eachDailyQuest in DailyQuests)
        {
            QuestInfo qInfo = QuestMgr.GetSingleQuest(eachDailyQuest.QuestID);
            if (qInfo != null && eachDailyQuest.IsComplete && eachDailyQuest.CompletedDate.Date.AddDays((double)qInfo.RepeatInterval).Date <= DateTime.Now.Date)
            {
                switch (qInfo.QuestID)
                {
                    case 2:
                        quests.DeleteQuestUser(this.m_character.ID, eachDailyQuest.QuestID);
                        break;
                    case 3:
                        if (qInfo.CanRepeat)
                        {
                            quests.DeleteQuestUser(this.m_character.ID, eachDailyQuest.QuestID);
                        }
                        break;
                    default:
                        break;

                }

            }
        }
    }

    public bool ChangeDailyExpVip()
    {
        ShopItemInfo itemVipInfo = ShopMgr.FindShopbyTemplateID((int)Game.Server.Packets.EquipType.VIPCARD);
        if (this.m_character.VIPLevel >= 9)
            return false;
        if (itemVipInfo == null)
            return false;
        int result = (int)(itemVipInfo.AValue1 / itemVipInfo.AUnit);
        if (this.m_character.typeVIP > 0)
        {
            AddExpVip(result * 2);
            this.Out.SendOpenVIP(this);
            this.m_character.VIPNextLevelDaysNeeded = this.GetVIPNextLevelDaysNeeded(this.m_character.VIPLevel, this.m_character.VIPExp);
            this.SendMessage($"Trong thời hạn VIP, bạn nhận được {result * 2} exp VIP mỗi ngày.");
        }
        else
        {
            if (RemoveExpVip(result))
                this.SendMessage($"VIP hết hạn, bạn bị trừ {result} exp VIP mỗi ngày.");
        }
        return true;
    }

    public int[] FightLabPermissionInt()
    {
        int[] array = new int[50];
        for (int i = 0; i < 50; i++)
        {
            array[i] = m_fightlabpermissions[i];
        }
        return array;
    }

    public char[] InitFightLabPermission()
    {
        char[] array = new char[50];
        for (int i = 0; i < 50; i++)
        {
            if (i == 0)
            {
                array[i] = '1';
            }
            else
            {
                array[i] = '0';
            }
        }
        return array;
    }

    public bool SetFightLabPermission(int copyId, eHardLevel hardLevel, int missionId)
    {
        switch (copyId)
        {
            case 1000:
                copyId = 5;
                break;
            case 1001:
                copyId = 6;
                break;
            case 1002:
                copyId = 7;
                break;
            case 1003:
                copyId = 8;
                break;
            case 1004:
                copyId = 9;
                break;
        }
        if (copyId > m_fightlabpermissions.Length || copyId <= 0)
        {
            return true;
        }
        int num = (copyId - 5) * 2;
        if (m_fightlabpermissions[num] != fightlabpermissionChars[(int)(hardLevel + 1)])
        {
            return true;
        }
        if (m_fightlabpermissions[num + 1] <= '2' && m_fightlabpermissions[num] - m_fightlabpermissions[num + 1] == 1)
        {
            m_fightlabpermissions[num + 1] = m_fightlabpermissions[num];
            string text = "";
            int gold = 0;
            int money = 0;
            int giftToken = 0;
            int gp = 0;
            List<ItemInfo> info = new List<ItemInfo>();
            if (DropInventory.FightLabUserDrop(missionId, ref info) && info != null)
            {
                bool flag = false;
                text = LanguageMgr.GetTranslation("Phần thưởng từ phòng tập") + ": ";
                foreach (ItemInfo item in info)
                {
                    text = text + LanguageMgr.GetTranslation("Game.Server.Quests.FinishQuest.RewardProp", item.Template.Name, item.Count) + " ";
                    if (info.Count > 0 && PropBag.GetEmptyCount() < 1)
                    {
                        if (item.TemplateID != 11107 && item.TemplateID != -100 && item.TemplateID != -200 && item.TemplateID != -300)
                        {
                            string translation = LanguageMgr.GetTranslation("Game.Server.GameUtils.Content2");
                            string translation2 = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title2");
                            if (SendItemsToMail(new List<ItemInfo>
                            {
                                item
                            }, translation, translation2, eMailType.ItemOverdue))
                            {
                                Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
                            }
                            flag = true;
                        }
                    }
                    else if (!PropBag.StackItemToAnother(item) && item.TemplateID != 11107 && item.TemplateID != -100 && item.TemplateID != -200 && item.TemplateID != -300)
                    {
                        PropBag.AddItem(item);
                    }
                    ItemInfo.FindSpecialItemInfo(item, ref gold, ref money, ref giftToken, ref gp);
                }
                AddGold(gold);
                AddMoney(money);
                AddGiftToken(giftToken);
                AddGP(gp, false);
                if (flag)
                {
                    text += LanguageMgr.GetTranslation("Game.Server.GameUtils.Title2");
                }
                Out.SendMessage(eMessageType.GM_NOTICE, text);
            }
        }
        if (copyId == 5 && hardLevel == eHardLevel.Normal)
        {
            if (m_fightlabpermissions[2] == '0')
            {
                m_fightlabpermissions[2] = '1';
            }
            if (m_fightlabpermissions[4] == '0')
            {
                m_fightlabpermissions[4] = '1';
            }
            if (m_fightlabpermissions[6] == '0')
            {
                m_fightlabpermissions[6] = '1';
            }
        }
        if ((copyId == 7 || copyId == 8) && hardLevel == eHardLevel.Hard && m_fightlabpermissions[8] == '0')
        {
            m_fightlabpermissions[8] = '1';
        }
        if (hardLevel < eHardLevel.Hard && m_fightlabpermissions[num] < fightlabpermissionChars[(int)(hardLevel + 2)])
        {
            m_fightlabpermissions[num] = fightlabpermissionChars[(int)(hardLevel + 2)];
        }
        m_character.FightLabPermission = new string(m_fightlabpermissions).ToString();
        OnPropertiesChanged();
        return true;
    }

    public bool IsFightLabPermission(int copyId, eHardLevel hardLevel)
    {
        if (copyId > m_fightlabpermissions.Length || copyId <= 0)
        {
            return true;
        }
        int num = (copyId - 5) * 2;
        return m_fightlabpermissions[num] >= fightlabpermissionChars[(int)(hardLevel + 1)];
    }

    public eHardLevel GetMaxFightLabPermission(int copyId)
    {
        if (copyId > m_fightlabpermissions.Length)
        {
            return eHardLevel.Simple;
        }
        return m_fightlabpermissions[copyId - 5] switch
        {
            '3' => eHardLevel.Hard,
            '2' => eHardLevel.Normal,
            _ => eHardLevel.Simple,
        };
    }

    public void LoadMedals()
    {
        m_character.medal = GetMedalNum();
        this.SavePlayerInfo();
    }
    public void LoadRepute()
    {
        PlayerBussiness db = new PlayerBussiness();
        m_character.Repute = db.GetXepHang(m_character.ID);
        this.SavePlayerInfo();
    }

    public void LoadMarryMessage()
    {
        using PlayerBussiness playerBussiness = new PlayerBussiness();
        MarryApplyInfo[] playerMarryApply = playerBussiness.GetPlayerMarryApply(PlayerCharacter.ID);
        if (playerMarryApply == null)
        {
            return;
        }
        MarryApplyInfo[] array = playerMarryApply;
        MarryApplyInfo[] array2 = array;
        MarryApplyInfo[] array3 = array2;
        foreach (MarryApplyInfo marryApplyInfo in array3)
        {
            switch (marryApplyInfo.ApplyType)
            {
                case 1:
                    Out.SendPlayerMarryApply(this, marryApplyInfo.ApplyUserID, marryApplyInfo.ApplyUserName, marryApplyInfo.LoveProclamation, marryApplyInfo.ID);
                    break;
                case 2:
                    Out.SendMarryApplyReply(this, marryApplyInfo.ApplyUserID, marryApplyInfo.ApplyUserName, marryApplyInfo.ApplyResult, isApplicant: true, marryApplyInfo.ID);
                    if (!marryApplyInfo.ApplyResult)
                    {
                        Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
                    }
                    break;
                case 3:
                    Out.SendPlayerDivorceApply(this, result: true, isProposer: false);
                    break;
            }
        }
    }

    public void LoadMarryProp()
    {
        using PlayerBussiness playerBussiness = new PlayerBussiness();
        MarryProp marryProp = playerBussiness.GetMarryProp(PlayerCharacter.ID);
        PlayerCharacter.IsMarried = marryProp.IsMarried;
        PlayerCharacter.SpouseID = marryProp.SpouseID;
        PlayerCharacter.SpouseName = marryProp.SpouseName;
        PlayerCharacter.IsCreatedMarryRoom = marryProp.IsCreatedMarryRoom;
        PlayerCharacter.SelfMarryRoomID = marryProp.SelfMarryRoomID;
        PlayerCharacter.IsGotRing = marryProp.IsGotRing;
        Out.SendMarryProp(this, marryProp);
    }

    public void LoadPvePermission()
    {
        PveInfo[] pveInfo = PveInfoMgr.GetPveInfo();
        PveInfo[] array = pveInfo;
        PveInfo[] array2 = array;
        foreach (PveInfo pveInfo2 in array2)
        {
            if (m_character.Grade > pveInfo2.LevelLimits)
            {
                eHardLevel level = (pveInfo2.ID == 1 || pveInfo2.ID == 2 || pveInfo2.ID == 7 || pveInfo2.ID == 12 || pveInfo2.ID == 13) ? eHardLevel.Easy : eHardLevel.Normal;
                bool flag = SetPvePermission(pveInfo2.ID, level);
                //if (flag)
                //{
                //    flag = SetPvePermission(pveInfo2.ID, eHardLevel.Normal);
                //}
                //if (flag)
                //{
                //    flag = SetPvePermission(pveInfo2.ID, eHardLevel.Hard);
                //}
            }
        }
    }

    public void LogAddMoney(AddMoneyType masterType, AddMoneyType sonType, int userId, int moneys, int SpareMoney)
    {
    }

    public bool Login()
    {
        if (WorldMgr.AddPlayer(m_character.ID, this))
        {
            try
            {
                if (LoadFromDatabase())
                {
                    if (PlayerCharacter.BoxGetDate.ToShortDateString() != DateTime.Now.ToShortDateString())
                    {
                        PlayerCharacter.AlreadyGetBox = 0;
                        PlayerCharacter.BoxProgression = 0;
                    }
                    Out.SendLoginSuccess();
                    if (LittleGameWorldMgr.IsOpen)
                    {
                        Actives.SendLittleGameActived();
                    }
                    Out.SendUpdatePublicPlayer(PlayerCharacter, MatchInfo, Extra.Info);
                    Out.SendWeaklessGuildProgress(PlayerCharacter);
                    ProcessConsortiaAndPet();
                    Out.SendDateTime();
                    Out.SendDailyAward(this);
                    LoadMarryMessage();
                    if (!m_showPP)
                    {
                        m_playerProp.ViewCurrent();
                        m_showPP = true;
                    }
                    _ = PlayerCharacter.ID;
                    Rank.SendUserRanks();
                    if (this.m_character.honorId != 0)
                        this.UpdateHonor(this.m_character.honorId);
                    Farm.LoadFarmLand();
                    Out.SendOpenVIP(this);
                    EquipBag.UpdatePlayerProperties();
                    PetBag.UpdateEatPets();
                    SetupProcessor();
                    Actives.SendEvent();
                    Out.SendEnthrallLight();
                    this.Out.SendAvatarCollect(this.AvatarCollect);
                    this.AvatarCollect.ScanAvatarVaildDate();
                    Out.SendEdictumVersion();
                    m_playerState = ePlayerState.Manual;
                    Out.SendBufferList(this, m_bufferList.GetAllBufferByTemplate());
                    Out.SendUpdateAchievementData(AchievementInventory.GetSuccessAchievement());
                    BoxBeginTime = DateTime.Now;
                    this.TimeCheckHack = (long)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                    OpenAllNoviceActive();
                    if (this.PlayerCharacter.Grade >= 30)
                    {
                        this.Out.SendPlayerFigSpiritinit(this.PlayerCharacter.ID, this.GemStone);
                    }
                    WorldMgr.IsAccountLimit(this);
                    Out.SendUpdateFirstRecharge(PlayerCharacter.IsRecharged, PlayerCharacter.IsGetAward);
                    ChargeToUser();
                    ConsortiaTaskMgr.AddPlayer(this);
                    Out.SendOpenWorldBoss(X, Y);
                    if (DateTime.Parse(GameProperties.LeftRouterEndDate) > DateTime.Now)
                    {
                        Out.SendLeftRouleteOpen(Extra.Info);
                    }
                    Extra.BeginPingOnlineTimer();
                    if (ActiveSystemMgr.IsLeagueOpen)
                    {
                        Out.SendLeagueNotice(m_character.ID, BattleData.MatchInfo.restCount, BattleData.maxCount, 1);
                        SendMessage(eMessageType.GM_NOTICE, "Chiến thần đã bắt đầu, mau vào phòng game chiến đấu nào!");
                    }
                    else
                    {
                        Out.SendLeagueNotice(m_character.ID, BattleData.MatchInfo.restCount, BattleData.maxCount, 2);
                        //SendMessage(eMessageType.GM_NOTICE, "Chiến thần đã kết thúc, hẹn gặp lại bạn lần sau!");
                    }
                    //if (RankMgr.IsTopLeague(m_character.ID))
                    //{
                    //    SendMessage(eMessageType.GM_NOTICE, "Quà Chiến Thần!");
                    //}
                    //else
                    //{
                    //    SendMessage(eMessageType.GM_NOTICE, "Không Có Quà Chiến Thần!");
                    //}
                    Out.SendGuildMemberWeekOpenClose(Extra.Info);
                    Out.SendNecklaceStrength(PlayerCharacter);
                    return true;
                }
                WorldMgr.RemovePlayer(m_character.ID);
            }
            catch (Exception exception)
            {
                log.Error("Error Login!", exception);
            }
            return false;
        }
        return false;
    }

    private void ProcessConsortiaAndPet()
    {
        consortiaProcessor_0 = new ConsortiaProcessor(m_consortiaProcessor);
        petProcessor_0 = new PetProcessor(m_petProcessor);
    }


    public bool MoneyDirect(int value, bool IsAntiMult, bool NoviceActive)
    {
        return MoneyDirect(MoneyType.Money, value, IsAntiMult, NoviceActive);
    }

    public bool MoneyDirect(MoneyType type, int value, bool IsAntiMult, bool NoviceActive)
    {
        if (value >= 0 && value <= int.MaxValue)
        {
            if (type == MoneyType.Money)
            {
                if (PlayerCharacter.Money + PlayerCharacter.MoneyLock >= value)
                {
                    RemoveMoney(value, IsAntiMult, NoviceActive);
                    AddLog("RemoveMoney", "Tài khoản " + m_character.UserName + "sử dụng " + value + "xu ở tài khoản" + m_character.NickName);
                    UpdateProperties();
                    return true;
                }
                SendInsufficientMoney(0);
            }
            else
            {
                if (PlayerCharacter.GiftToken >= value)
                {
                    RemoveGiftToken(value);
                    AddLog("RemoveGiftToken", "Tài khoản " + m_character.UserName + "sử dụng " + value + "lễ kim ở tài khoản" + m_character.NickName);
                    UpdateProperties();
                    return true;
                }
                SendMessage("Không đủ lễ kim.");
            }
        }
        return false;
    }

    public void OnAchievementFinish(AchievementData info)
    {
        if (this.AchievementFinishEvent != null)
        {
            this.AchievementFinishEvent(info);
        }
    }

    public void OnAdoptPetEvent()
    {
        if (this.AdoptPetEvent != null)
        {
            this.AdoptPetEvent();
        }
    }

    public void OnCropPrimaryEvent()
    {
        if (this.CropPrimaryEvent != null)
        {
            this.CropPrimaryEvent();
        }
    }

    public void OnEnterHotSpring()
    {
        if (this.EnterHotSpringEvent != null)
        {
            this.EnterHotSpringEvent(this);
        }
    }

    public void OnFightAddOffer(int offer)
    {
        if (this.FightAddOfferEvent != null)
        {
            this.FightAddOfferEvent(offer);
        }
    }

    public void OnGuildChanged()
    {
        if (this.GuildChanged != null)
        {
            this.GuildChanged();
        }
    }

    public void OnHotSpingExpAdd(int minutes, int exp)
    {
        if (this.HotSpingExpAdd != null)
        {
            this.HotSpingExpAdd(minutes, exp);
        }
    }

    public void OnOnlineGameAdd(GamePlayer player)
    {
        if (this.OnlineGameAdd != null)
        {
            this.OnlineGameAdd(player);
        }
    }

    public void OnItemCompose(int composeType)
    {
        if (this.ItemCompose != null)
        {
            this.ItemCompose(composeType);
        }
    }

    public void OnItemFusion(int fusionType)
    {
        if (this.ItemFusion != null)
        {
            this.ItemFusion(fusionType);
        }
    }

    public void OnItemInsert()
    {
        if (this.ItemInsert != null)
        {
            this.ItemInsert();
        }
    }

    public void OnItemMelt(int categoryID)
    {
        if (this.ItemMelt != null)
        {
            this.ItemMelt(categoryID);
        }
    }

    public void OnItemStrengthen(int categoryID, int level)
    {
        if (this.ItemStrengthen != null)
        {
            this.ItemStrengthen(categoryID, level);
        }
    }

    public void OnMoneyCharge(int money)
    {
        if (this.MoneyCharge != null)
        {
            this.MoneyCharge(money);
        }
    }

    public void OnAchievementQuest()
    {
        if (this.AchievementQuest != null)
        {
            this.AchievementQuest();
        }
    }

    public void OnKillingBoss(AbstractGame game, NpcInfo npc, int damage)
    {
        if (this.AfterKillingBoss != null)
        {
            this.AfterKillingBoss(game, npc, damage);
        }
    }

    public void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int damage)
    {
        if (this.AfterKillingLiving != null)
        {
            this.AfterKillingLiving(game, type, id, isLiving, damage, isSpanArea: false);
        }
        if (!(this.GameKillDrop == null || isLiving))
        {
            this.GameKillDrop(game, type, id, isLiving);
        }
        if (!isLiving)
        {
            if (id == 1243)
            {
                m_rank.AddNewRank(1000, 3);
                GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice($"Người chơi [{m_character.NickName}] đích thân tiêu diệt Boss thế giới nhận được danh hiêu [CHÚA TỂ RỒNG]."));
            }
            else if (id == 30004)
            {
                m_rank.AddNewRank(1001, 3);
                GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice($"Người chơi [{m_character.NickName}] đích thân tiêu diệt Boss thế giới nhận được danh hiêu [VUA BÓNG ĐÁ]."));
            }
        }
    }

    public void OnLevelUp(int grade)
    {
        if (this.LevelUp != null)
        {
            this.LevelUp(this);
        }
    }

    public void OnMissionOver(AbstractGame game, bool isWin, int missionId, int turnNum)
    {
        if (this.MissionOver != null)
        {
            this.MissionOver(game, missionId, isWin);
        }
        if (this.MissionTurnOver != null && isWin)
        {
            this.MissionTurnOver(game, missionId, turnNum);
        }
        if (this.MissionFullOver != null)
        {
            this.MissionFullOver(game, missionId, isWin, turnNum);
        }
    }

    public void OnNewGearEvent(ItemInfo item)
    {
        if (this.NewGearEvent != null)
        {
            this.NewGearEvent(item);
        }
    }

    public void OnSeedFoodPetEvent()
    {
        if (this.SeedFoodPetEvent != null)
        {
            this.SeedFoodPetEvent();
        }
    }

    public void OnPaid(int money, int gold, int offer, int gifttoken, int petScore, int medal, int damageScores, string payGoods)
    {
        if (this.Paid != null)
        {
            this.Paid(money, gold, offer, gifttoken, petScore, medal, damageScores, payGoods);
        }
    }

    protected void OnPropertiesChanged()
    {
        UpdateProperties();
        OnPlayerPropertyChanged(m_character);
    }

    public void OnUnknowQuestConditionEvent()
    {
        if (this.UnknowQuestConditionEvent != null)
        {
            this.UnknowQuestConditionEvent();
        }
    }

    public void OnUpLevelPetEvent()
    {
        if (this.UpLevelPetEvent != null)
        {
            this.UpLevelPetEvent();
        }
    }

    public void OnUseBuffer()
    {
        if (this.UseBuffer != null)
        {
            this.UseBuffer(this);
        }
    }

    public void OnUserToemGemstoneEvent()
    {
        if (this.UserToemGemstonetEvent != null)
        {
            this.UserToemGemstonetEvent();
        }
    }

    public void OnUsingItem(int templateID, int count)
    {
        if (this.AfterUsingItem != null)
        {
            this.AfterUsingItem(templateID, count);
        }
    }

    public void OpenVIP(int days)
    {
        DateTime vIPExpireDay = DateTime.Now.AddDays(days);
        m_character.typeVIP = SetTypeVIP(days);
        m_character.VIPLevel = 1;
        m_character.VIPExp = 0;
        m_character.VIPExpireDay = vIPExpireDay;
        m_character.VIPLastDate = DateTime.Now;
        m_character.VIPNextLevelDaysNeeded = 0;
        m_character.CanTakeVipReward = true;
    }

    public void OpenVIP(int days, DateTime ExpireDayOut)
    {
        m_character.typeVIP = SetTypeVIP(days);
        m_character.VIPExpireDay = ExpireDayOut;
        m_character.VIPLastDate = DateTime.Now;
        m_character.VIPNextLevelDaysNeeded = 10;
        m_character.CanTakeVipReward = true;
        if (Extra.CheckNoviceActiveOpen(NoviceActiveType.UPGRADE_VIP_ACTIVE))
        {
            Extra.UpdateEventCondition((int)NoviceActiveType.UPGRADE_VIP_ACTIVE, PlayerCharacter.VIPLevel);
        }
    }

    public void ContinuousVIP(int days, DateTime ExpireDayOut)
    {
        int vIPLevel = m_character.VIPLevel;
        if (vIPLevel < 6 && days == 180)
        {
            m_character.VIPExpireDay = ExpireDayOut;
            m_character.typeVIP = SetTypeVIP(days);
        }
        else if (vIPLevel < 4 && days == 90)
        {
            m_character.VIPExpireDay = ExpireDayOut;
            m_character.typeVIP = SetTypeVIP(days);
        }
        else
        {
            m_character.VIPExpireDay = ExpireDayOut;
            m_character.typeVIP = SetTypeVIP(days);
        }
        if (Extra.CheckNoviceActiveOpen(NoviceActiveType.UPGRADE_VIP_ACTIVE))
        {
            Extra.UpdateEventCondition((int)NoviceActiveType.UPGRADE_VIP_ACTIVE, PlayerCharacter.VIPLevel);
        }
    }

    public byte SetTypeVIP(int days)
    {
        byte result = 1;
        if (m_character.typeVIP == 2)
        {
            result = 2;
        }
        else if (days / 31 >= 3)
        {
            result = 2;
        }
        return result;
    }

    public void ResetLottery()
    {
        Lottery = -1;
        LotteryID = 0;
        LotteryItems = new List<ItemBoxInfo>();
        LotteryAwardList = new List<ItemInfo>();
    }

    public virtual bool Quit()
    {
        try
        {
            try
            {
                if (Level == 1)
                {
                    ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(7008), 1, 105);
                    itemInfo.ValidDate = 365;
                    EquipBag.AddItemTo(itemInfo, 6);
                }
                if (CurrentRoom != null)
                {
                    CurrentRoom.RemovePlayerUnsafe(this);
                    CurrentRoom = null;
                }
                else
                {
                    RoomMgr.WaitingRoom.RemovePlayer(this);
                }
                if (CurrentMarryRoom != null)
                {
                    CurrentMarryRoom.RemovePlayer(this);
                    CurrentMarryRoom = null;
                }
                if (CurrentHotSpringRoom != null)
                {
                    CurrentHotSpringRoom.RemovePlayer(this);
                    CurrentHotSpringRoom = null;
                }
                if (LotteryAwardList.Count > 0 && Lottery != -1)
                {
                    SendItemsToMail(LotteryAwardList, "", LanguageMgr.GetTranslation("Game.Server.Lottery.Oversea.MailTitle"), eMailType.BuyItem);
                    ResetLottery();
                }
                ConsortiaTaskMgr.RemovePlayer(this);
                if (LittleGameInfo.ID != 0)
                {
                    LittleGameWorldMgr.RemovePlayer(this);
                }
                RoomMgr.WorldBossRoom.RemovePlayer(this);
                Extra.StopAllTimer();
            }
            catch (Exception exception)
            {
                log.Error("Player exit Game Error!", exception);
            }
            m_character.State = 0;
            SaveIntoDatabase();
        }
        catch (Exception exception2)
        {
            log.Error("Player exit Error!!!", exception2);
        }
        finally
        {
            WorldMgr.RemovePlayer(m_character.ID);
        }
        return true;
    }

    public bool RemoveAt(eBageType bagType, int place)
    {
        return GetInventory(bagType)?.RemoveItemAt(place) ?? false;
    }

    public bool RemoveCountFromStack(ItemInfo item, int count)
    {
        if (item.BagType == m_propBag.BagType)
        {
            return m_propBag.RemoveCountFromStack(item, count);
        }
        if (item.BagType == m_ConsortiaBag.BagType)
        {
            return m_ConsortiaBag.RemoveCountFromStack(item, count);
        }
        if (item.BagType == m_BankBag.BagType)
        {
            return m_BankBag.RemoveCountFromStack(item, count);
        }
        return m_equipBag.RemoveCountFromStack(item, count);
    }

    public int RemoveGold(int value)
    {
        if (value > 0 && value <= m_character.Gold)
        {
            m_character.Gold -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveGP(int gp)
    {
        if (gp > 0)
        {
            m_character.GP -= gp;
            if (m_character.GP < 1)
            {
                m_character.GP = 1;
            }
            int level = LevelMgr.GetLevel(m_character.GP);
            if (Level > level)
            {
                m_character.GP += gp;
            }
            UpdateProperties();
            UpdateLevel();
            return gp;
        }
        return 0;
    }

    public int RemoveGiftToken(int value)
    {
        if (value > 0 && value <= m_character.GiftToken)
        {
            m_character.GiftToken -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public bool RemoveHealstone()
    {
        ItemInfo itemAt = m_equipBag.GetItemAt(18);
        if (itemAt != null && itemAt.Count > 0)
        {
            return m_equipBag.RemoveCountFromStack(itemAt, 1);
        }
        return false;
    }

    public bool RemoveItem(ItemInfo item)
    {
        if (item.BagType == FarmBag.BagType)
        {
            return FarmBag.RemoveItem(item);
        }
        if (item.BagType == m_propBag.BagType)
        {
            return m_propBag.RemoveItem(item);
        }
        if (item.BagType == m_fightBag.BagType)
        {
            return m_fightBag.RemoveItem(item);
        }

        if (item.BagType == m_ConsortiaBag.BagType)
        {
            return m_ConsortiaBag.RemoveItem(item);
        }

        if (item.BagType == m_BankBag.BagType)
        {
            return m_BankBag.RemoveItem(item);
        }

        if (item.BagType == m_storeBag.BagType)
        {
            return m_storeBag.RemoveItem(item);
        }

        if (item.BagType == m_caddyBag.BagType)
        {
            return m_caddyBag.RemoveItem(item);
        }

        //eBageType.Consortia => m_ConsortiaBag,
        //eBageType.BankBag => m_BankBag,
        //eBageType.Store => m_storeBag,

        return m_equipBag.RemoveItem(item);
    }

    public int AddMedal(int value)
    {
        if (value > 0)
        {
            ItemInfo itemByTemplateID = GetInventory(eBageType.PropBag).GetItemByTemplateID(1, 11408);
            if (itemByTemplateID != null)
            {
                PropBag.AddCountToStack(itemByTemplateID, value);
                PropBag.UpdateItem(itemByTemplateID);
            }
            else
            {
                PropBag.AddTemplate(ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11408), value, 104), value);
            }
            m_character.medal = GetMedalNum();
            OnPropertiesChanged();
            UpdateProperties();
            UpdateChangedPlaces();
            return value;
        }
        return 0;
    }

    public int RemoveMedal(int value)
    {
        if (value > 0 && value <= m_character.medal)
        {
            RemoveTemplate(11408, value);
            m_character.medal = GetMedalNum();
            OnPropertiesChanged();
            UpdateProperties();
            UpdateChangedPlaces();
            return value;
        }
        return 0;
    }

    public int RemoveMoneyNoviceActive(int value)
    {
        if (value > 0 && value <= m_character.MoneyLock)
        {
            m_character.MoneyLock -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        if (value > 0 && value <= m_character.Money)
        {
            m_character.Money -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveMoney(int value)
    {
        if (value > 0 && value <= m_character.MoneyLock)
        {
            m_character.MoneyLock -= value;
            if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE))
            {
                Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE, value, isPlus: true, 0);
            }
            if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK))
            {
                Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK, value, isPlus: true, 0);
            }
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        if (value > 0 && value <= m_character.Money)
        {
            m_character.Money -= value;
            if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE))
            {
                Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE, value, isPlus: true, 0);
            }
            if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK))
            {
                Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK, value, isPlus: true, 0);
            }
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveMoney(int value, bool IsAntiMult, bool isNoviceActive)
    {
        if (value > 0 && value <= m_character.MoneyLock && !IsAntiMult)
        {
            m_character.MoneyLock -= value;
            if (!isNoviceActive)
            {
                if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE))
                {
                    Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE, value, isPlus: true, 0);
                }
                if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK))
                {
                    Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK, value, isPlus: true, 0);
                }
            }
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        if (value > 0 && value <= m_character.Money)
        {
            m_character.Money -= value;
            if (!isNoviceActive)
            {
                if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE))
                {
                    Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE, value, isPlus: true, 0);
                }
                if (Extra.CheckNoviceActiveOpen(NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK))
                {
                    Extra.UpdateEventCondition((int)NoviceActiveType.USE_MONEY_ACTIVE_OFWEEK, value, isPlus: true, 0);
                }
            }
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveOffer(int value)
    {
        if (value > 0)
        {
            if (value >= m_character.Offer)
            {
                value = m_character.Offer;
            }
            m_character.Offer -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveRichesOffer(int value)
    {
        if (value > 0)
        {
            if (value >= m_character.RichesOffer)
            {
                value = m_character.RichesOffer;
            }
            m_character.RichesOffer -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    public int RemoveConsortiaRiches(int value)
    {
        if (value > 0)
        {
            if (value >= m_character.ConsortiaRiches)
            {
                value = m_character.ConsortiaRiches;
            }
            m_character.ConsortiaRiches -= value;
            OnPropertiesChanged();
            UpdateProperties();
            OnGuildChanged();
            return value;
        }
        return 0;
    }

    public int RemovePetScore(int value)
    {
        if (value > 0 && value <= m_character.petScore)
        {
            m_character.petScore -= value;
            OnPropertiesChanged();
            UpdateProperties();
            return value;
        }
        return 0;
    }

    //public int RemoveScore(int value)
    //{
    //    if (value > 0 && value <= m_character.Score)
    //    {
    //        m_character.Score -= value;
    //        OnPropertiesChanged();
    //        UpdateProperties();
    //        return value;
    //    }
    //    return 0;
    //}

    public int RemoveScore(int value)
    {
        if (value > 0 && PlayerCharacter.Score >= value)
        {
            PlayerCharacter.Score -= value;
            if (PlayerCharacter.Score <= int.MinValue)
            {
                PlayerCharacter.Score = int.MaxValue;

            }
            if (PlayerCharacter.Score <= 0)
            {
                PlayerCharacter.Score = 0;

            }
            OnPropertiesChanged();
            return value;
        }

        return 0;
    }

    public bool RemoveTempate(eBageType bagType, ItemTemplateInfo template, int count)
    {
        return GetInventory(bagType)?.RemoveTemplate(template.TemplateID, count) ?? false;
    }

    public bool RemoveTemplate(ItemTemplateInfo template, int count)
    {
        return GetItemInventory(template)?.RemoveTemplate(template.TemplateID, count) ?? false;
    }

    public bool RemoveTemplate(int templateId, int count)
    {
        int mainItem = m_equipBag.GetItemCount(templateId);
        int propItem = m_propBag.GetItemCount(templateId);
        int consortiaItem = m_ConsortiaBag.GetItemCount(templateId);
        int bankItem = m_BankBag.GetItemCount(templateId);
        int tempCount = mainItem + propItem + consortiaItem + bankItem;
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateId);
        if (templateId == 11408 && count <= propItem + consortiaItem + bankItem)
        {
            m_character.medal -= count;
            UpdateProperties();
        }
        if (itemTemplateInfo != null && tempCount >= count)
        {
            if (mainItem > 0 && count > 0 && RemoveTempate(eBageType.EquipBag, itemTemplateInfo, (mainItem > count) ? count : mainItem))
            {
                count = ((count >= mainItem) ? (count - mainItem) : 0);
            }
            if (propItem > 0 && count > 0 && RemoveTempate(eBageType.PropBag, itemTemplateInfo, (propItem > count) ? count : propItem))
            {
                count = ((count >= propItem) ? (count - propItem) : 0);
            }
            if (consortiaItem > 0 && count > 0 && RemoveTempate(eBageType.Consortia, itemTemplateInfo, (consortiaItem > count) ? count : consortiaItem))
            {
                count = ((count >= consortiaItem) ? (count - consortiaItem) : 0);
            }
            if (bankItem > 0 && count > 0 && RemoveTempate(eBageType.BankBag, itemTemplateInfo, (bankItem > count) ? count : bankItem))
            {
                count = ((count >= bankItem) ? (count - bankItem) : 0);
            }
            if (count == 0)
            {
                return true;
            }
            if (log.IsErrorEnabled)
            {
                log.Error($"Item Remover Error：PlayerId {m_playerId} Remover TemplateId{templateId} Is Not Zero!");
            }
        }
        return false;
    }

    public UserLabyrinthInfo LoadLabyrinth(int sType)
    {
        if (userLabyrinthInfo == null)
        {
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            userLabyrinthInfo = playerBussiness.GetSingleLabyrinth(PlayerCharacter.ID);
            if (userLabyrinthInfo == null)
            {
                userLabyrinthInfo = new UserLabyrinthInfo();
                userLabyrinthInfo.UserID = PlayerCharacter.ID;
                userLabyrinthInfo.sType = sType;
                userLabyrinthInfo.myProgress = 0;
                userLabyrinthInfo.myRanking = 0;
                userLabyrinthInfo.completeChallenge = true;
                userLabyrinthInfo.isDoubleAward = false;
                userLabyrinthInfo.currentFloor = 1;
                userLabyrinthInfo.accumulateExp = 0;
                userLabyrinthInfo.remainTime = 0;
                userLabyrinthInfo.currentRemainTime = 0;
                userLabyrinthInfo.cleanOutAllTime = 0;
                userLabyrinthInfo.cleanOutGold = 50;
                userLabyrinthInfo.tryAgainComplete = true;
                userLabyrinthInfo.isInGame = false;
                userLabyrinthInfo.isCleanOut = false;
                userLabyrinthInfo.serverMultiplyingPower = false;
                userLabyrinthInfo.LastDate = DateTime.Now;
                userLabyrinthInfo.ProcessAward = InitProcessAward();
                playerBussiness.AddUserLabyrinth(userLabyrinthInfo);
            }
            else
            {
                ProcessLabyrinthAward = userLabyrinthInfo.ProcessAward;
                userLabyrinthInfo.sType = sType;
            }
        }
        return Labyrinth;
    }

    public string InitProcessAward()
    {
        string[] array = new string[99];
        for (int i = 0; i < array.Length; i++)
        {
            array[i] = i.ToString();
        }
        ProcessLabyrinthAward = string.Join("-", array);
        return ProcessLabyrinthAward;
    }

    public string CompleteGetAward(int floor)
    {
        string[] array = new string[floor];
        for (int i = 0; i < floor; i++)
        {
            array[i] = "i";
        }
        string[] array2 = userLabyrinthInfo.ProcessAward.Split('-');
        string text = string.Join("-", array);
        for (int j = floor; j < array2.Length; j++)
        {
            text = text + "-" + array2[j];
        }
        return text;
    }

    public bool isDoubleAward()
    {
        if (userLabyrinthInfo == null)
        {
            return false;
        }
        return userLabyrinthInfo.isDoubleAward;
    }

    public void OutLabyrinth(bool isWin)
    {
        if (!isWin && userLabyrinthInfo != null && userLabyrinthInfo.currentFloor > 1)
        {
            SendLabyrinthTryAgain();
        }
        ResetLabyrinth();
    }

    public void SendLabyrinthTryAgain()
    {
        GSPacketIn gSPacketIn = new GSPacketIn(131, PlayerId);
        gSPacketIn.WriteByte(9);
        gSPacketIn.WriteInt(LabyrinthTryAgainMoney());
        SendTCP(gSPacketIn);
    }

    public int LabyrinthTryAgainMoney()
    {
        for (int i = 0; i < Labyrinth.myProgress; i += 2)
        {
            if (Labyrinth.currentFloor == i)
            {
                return GameProperties.WarriorFamRaidPriceBig;
            }
        }
        return GameProperties.WarriorFamRaidPriceSmall;
    }

    public void ResetLabyrinth()
    {
        if (userLabyrinthInfo != null)
        {
            userLabyrinthInfo.isInGame = false;
            userLabyrinthInfo.completeChallenge = false;
            userLabyrinthInfo.ProcessAward = InitProcessAward();
        }
    }

    public void CalculatorClearnOutLabyrinth()
    {
        if (userLabyrinthInfo != null)
        {
            int num = 0;
            for (int i = userLabyrinthInfo.currentFloor; i <= userLabyrinthInfo.myProgress; i++)
            {
                num += 2;
            }
            int num2 = num * 60;
            userLabyrinthInfo.remainTime = num2;
            userLabyrinthInfo.currentRemainTime = num2;
            userLabyrinthInfo.cleanOutAllTime = num2;
        }
    }

    public int[] CreateExps()
    {
        int[] array = new int[99];
        int num = 660;
        for (int i = 0; i < array.Length; i++)
        {
            array[i] = num;
            num += 690;
        }
        return array;
    }

    public void UpdateLabyrinth(int floor, int m_missionInfoId, bool bigAward)
    {
        int[] array = CreateExps();
        int num = ((floor - 1 > array.Length) ? (array.Length - 1) : (floor - 1));
        int num2 = ((num >= 0) ? num : 0);
        int num3 = array[num2];
        string text = labyrinthGolds[num2];
        int num4 = int.Parse(text.Split('|')[0]);
        int num5 = int.Parse(text.Split('|')[1]);
        if (userLabyrinthInfo != null)
        {
            floor++;
            ProcessLabyrinthAward = CompleteGetAward(floor);
            userLabyrinthInfo.ProcessAward = ProcessLabyrinthAward;
            if (PropBag.GetItemByTemplateID(0, 11916) == null || !RemoveTemplate(11916, 1))
            {
                userLabyrinthInfo.isDoubleAward = false;
            }
            if (userLabyrinthInfo.isDoubleAward)
            {
                num3 *= 2;
                num4 *= 2;
                num5 *= 2;
            }
            if (floor > userLabyrinthInfo.myProgress)
            {
                userLabyrinthInfo.myProgress = floor;
            }
            if (floor > userLabyrinthInfo.currentFloor)
            {
                userLabyrinthInfo.currentFloor = floor;
            }
            userLabyrinthInfo.accumulateExp += num3;
            string text2 = LanguageMgr.GetTranslation("UpdateLabyrinth.Exp", num3);
            AddGP(num3, false);
            if (bigAward)
            {
                List<ItemInfo> list = CopyDrop(2, 40002);
                if (list != null)
                {
                    foreach (ItemInfo item in list)
                    {
                        item.IsBinds = true;
                        AddTemplate(item, item.Template.BagType, num4, backToMail: true);
                        text2 += $", {item.Template.Name} x{num4}";
                    }
                }
                AddHardCurrency(num5);
                text2 = text2 + LanguageMgr.GetTranslation("UpdateLabyrinth.GoldLaby") + num5;
            }
            SendHideMessage(text2);
        }
        Out.SendLabyrinthUpdataInfo(userLabyrinthInfo.UserID, userLabyrinthInfo);
    }



    public int AddHardCurrency(int value)
    {
        if (value > 0)
        {
            PlayerCharacter.hardCurrency += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public virtual bool SaveIntoDatabase()
    {
        try
        {
            if (m_character == null || m_character.ID <= 0) return false;
            if (m_character.IsDirty)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    pb.UpdatePlayer(this.m_character);
                    if (this.userLabyrinthInfo != null)
                        pb.UpdateLabyrinthInfo(this.userLabyrinthInfo);
                    foreach (UserGemStone g in this.m_GemStone)
                        pb.UpdateGemStoneInfo(g);
                }
            }
            EquipBag.SaveToDatabase();
            PropBag.SaveToDatabase();
            ConsortiaBag.SaveToDatabase();
            BankBag.SaveToDatabase();
            CardBag.SaveToDatabase();
            StoreBag.SaveToDatabase();
            Rank.SaveToDatabase();
            QuestInventory.SaveToDatabase();
            AchievementInventory.SaveToDatabase();
            BufferList.SaveToDatabase();
            BattleData.SaveToDatabase();
            Extra.SaveToDatabase();
            PetBag.SaveToDatabase(saveAdopt: true);
            FarmBag.SaveToDatabase();
            Farm.SaveToDatabase();
            Actives.SaveToDatabase();
            this.AvatarCollect.SaveToDatabase();
            try
            {
                if (DateTime.Compare(this.m_character.CheckDate.AddMinutes(20.0), DateTime.Now) > 0 && this.m_character.CheckCode != "baodeptrai")
                {
                    this.m_character.CheckCode = "baodeptrai";
                    this.Disconnect();
                }
                long thetimenow = (long)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                if ((thetimenow - this._timecheckhack) > (90 * 60 - 10))
                {
                    this.SavePlayerInfo();
                    WorldMgr.SendSysNotice("[BUG TRACKER SYSTEM] [" + ZoneName + "] Phát hiện người chơi [" + PlayerCharacter.NickName + "] sử dụng ngưng đọng thời gian, hệ thống tự động khoá 1 giờ.");
                    AddLog("Speed Mod", "Mod flash detect | cache not cleaned");
                    using (ManageBussiness mnbusiness = new ManageBussiness())
                    {
                        mnbusiness.ForbidPlayerByUserID(PlayerCharacter.ID, DateTime.Now.AddHours(1), true, "Lách check speed");
                    }
                    this.Disconnect();
                }
            }
            catch (Exception e)
            {
                log.Error("Error Checking hack: " + m_character.NickName + "!", e);
            }
            return true;
        }
        catch (Exception exception)
        {
            log.Error("Error saving player " + m_character.NickName + "!", exception);
            return false;
        }
    }

    public bool SaveNewItems()
    {
        try
        {
            EquipBag.SaveToDatabase();
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    public bool SaveNewsItemIntoDatabase()
    {
        try
        {
            EquipBag.SaveNewsItemIntoDatabas();
            PropBag.SaveNewsItemIntoDatabas();
            return true;
        }
        catch (Exception exception)
        {
            log.Error("Error saving Save Bag Into Database " + m_character.NickName + "!", exception);
            return false;
        }
    }

    public bool SavePlayerInfo()
    {
        try
        {
            if (m_character == null && m_character.ID <= 0) return false;
            if (this.m_character.IsDirty)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                    pb.UpdatePlayer(this.m_character);
            }
            return true;
        }
        catch (Exception exception)
        {
            log.Error("Error saving player info of " + m_character.UserName + "!", exception);
            return false;
        }
    }

    public void SendConsortiaBossInfo(ConsortiaInfo info)
    {
        RankingPersonInfo rankingPersonInfo = null;
        List<RankingPersonInfo> list = new List<RankingPersonInfo>();
        foreach (RankingPersonInfo value in info.RankList.Values)
        {
            if (value.Name == PlayerCharacter.NickName)
            {
                rankingPersonInfo = value;
            }
            else
            {
                list.Add(value);
            }
        }
        GSPacketIn gSPacketIn = new GSPacketIn(129, PlayerCharacter.ID);
        gSPacketIn.WriteByte(30);
        gSPacketIn.WriteByte((byte)info.bossState);
        gSPacketIn.WriteBoolean(rankingPersonInfo != null);
        if (rankingPersonInfo != null)
        {
            gSPacketIn.WriteInt(rankingPersonInfo.ID);
            gSPacketIn.WriteInt(rankingPersonInfo.TotalDamage);
            gSPacketIn.WriteInt(rankingPersonInfo.Honor);
            gSPacketIn.WriteInt(rankingPersonInfo.Damage);
        }
        gSPacketIn.WriteByte((byte)list.Count);
        foreach (RankingPersonInfo item in list)
        {
            gSPacketIn.WriteString(item.Name);
            gSPacketIn.WriteInt(item.ID);
            gSPacketIn.WriteInt(item.TotalDamage);
            gSPacketIn.WriteInt(item.Honor);
            gSPacketIn.WriteInt(item.Damage);
        }
        gSPacketIn.WriteByte((byte)info.extendAvailableNum);
        gSPacketIn.WriteDateTime(info.endTime);
        gSPacketIn.WriteInt(info.callBossLevel);
        SendTCP(gSPacketIn);
    }

    public void SendConsortiaBossOpenClose(int type)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(129, PlayerCharacter.ID);
        gSPacketIn.WriteByte(31);
        gSPacketIn.WriteByte((byte)type);
        SendTCP(gSPacketIn);
    }

    public void SendConsortiaFight(int consortiaID, int riches, string msg)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(158);
        gSPacketIn.WriteInt(consortiaID);
        gSPacketIn.WriteInt(riches);
        gSPacketIn.WriteString(msg);
        GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
    }

    public void SendHideMessage(string msg)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(3);
        gSPacketIn.WriteInt(3);
        gSPacketIn.WriteString(msg);
        SendTCP(gSPacketIn);
    }

    public void SendInsufficientMoney(int type)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(88, PlayerId);
        gSPacketIn.WriteByte((byte)type);
        gSPacketIn.WriteBoolean(val: false);
        SendTCP(gSPacketIn);
    }

    public void SendItemNotice(ItemInfo info, int typeGet, string Name)
    {
        if (info == null)
        {
            return;
        }
        int num = 0;
        switch (typeGet)
        {
            case 0:
            case 1:
                num = 2;
                break;
            case 2:
            case 3:
            case 4:
                num = 1;
                break;
            default:
                num = 3;
                break;
        }
        GSPacketIn gSPacketIn = new GSPacketIn(14);
        gSPacketIn.WriteString(PlayerCharacter.NickName);
        gSPacketIn.WriteInt(typeGet);
        gSPacketIn.WriteInt(info.TemplateID);
        gSPacketIn.WriteBoolean(info.IsBinds);
        gSPacketIn.WriteInt(num);
        if (num == 3)
        {
            gSPacketIn.WriteString(Name);
        }
        if (info.IsTips)
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            for (int i = 0; i < allPlayers.Length; i++)
            {
                allPlayers[i].Out.SendTCP(gSPacketIn);
            }
        }
    }

    public bool SendItemsToMail(ItemInfo item, string content, string title, eMailType type)
    {
        return SendItemsToMail(new List<ItemInfo>
        {
            item
        }, content, title, type);
    }

    public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type)
    {
        using PlayerBussiness pb = new PlayerBussiness();
        List<ItemInfo> list = new List<ItemInfo>();
        foreach (ItemInfo item in items)
        {
            if (item.Template.MaxCount == 1)
            {
                for (int i = 0; i < item.Count; i++)
                {
                    ItemInfo itemInfo = ItemInfo.CloneFromTemplate(item.Template, item);
                    itemInfo.Count = 1;
                    list.Add(itemInfo);
                }
            }
            else
            {
                list.Add(item);
            }
        }
        return SendItemsToMail(list, content, title, type, pb);
    }

    public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type, PlayerBussiness pb)
    {
        bool result = true;
        for (int i = 0; i < items.Count; i += 5)
        {
            MailInfo mailInfo = new MailInfo
            {
                Title = ((title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title")),
                Gold = 0,
                IsExist = true,
                Money = 0,
                Receiver = PlayerCharacter.NickName,
                ReceiverID = PlayerId,
                Sender = PlayerCharacter.NickName,
                SenderID = PlayerId,
                Type = (int)type,
                GiftToken = 0
            };
            List<ItemInfo> list = new List<ItemInfo>();
            StringBuilder stringBuilder = new StringBuilder();
            StringBuilder stringBuilder2 = new StringBuilder();
            stringBuilder.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
            content = ((content != null) ? LanguageMgr.GetTranslation(content) : "");
            int num = i;
            if (items.Count > num)
            {
                ItemInfo itemInfo = items[num];
                if (itemInfo.ItemID == 0)
                {
                    pb.AddGoods(itemInfo);
                }
                else
                {
                    list.Add(itemInfo);
                }
                if (title == null)
                {
                    mailInfo.Title = itemInfo.Template.Name;
                }
                mailInfo.Annex1 = itemInfo.ItemID.ToString();
                mailInfo.Annex1Name = itemInfo.Template.Name;
                stringBuilder.Append("1、" + mailInfo.Annex1Name + "x" + itemInfo.Count + ";");
                stringBuilder2.Append("1、" + mailInfo.Annex1Name + "x" + itemInfo.Count + ";");
            }
            num = i + 1;
            if (items.Count > num)
            {
                ItemInfo itemInfo2 = items[num];
                if (itemInfo2.ItemID == 0)
                {
                    pb.AddGoods(itemInfo2);
                }
                else
                {
                    list.Add(itemInfo2);
                }
                mailInfo.Annex2 = itemInfo2.ItemID.ToString();
                mailInfo.Annex2Name = itemInfo2.Template.Name;
                stringBuilder.Append("2、" + mailInfo.Annex2Name + "x" + itemInfo2.Count + ";");
                stringBuilder2.Append("2、" + mailInfo.Annex2Name + "x" + itemInfo2.Count + ";");
            }
            num = i + 2;
            if (items.Count > num)
            {
                ItemInfo itemInfo3 = items[num];
                if (itemInfo3.ItemID == 0)
                {
                    pb.AddGoods(itemInfo3);
                }
                else
                {
                    list.Add(itemInfo3);
                }
                mailInfo.Annex3 = itemInfo3.ItemID.ToString();
                mailInfo.Annex3Name = itemInfo3.Template.Name;
                stringBuilder.Append("3、" + mailInfo.Annex3Name + "x" + itemInfo3.Count + ";");
                stringBuilder2.Append("3、" + mailInfo.Annex3Name + "x" + itemInfo3.Count + ";");
            }
            num = i + 3;
            if (items.Count > num)
            {
                ItemInfo itemInfo4 = items[num];
                if (itemInfo4.ItemID == 0)
                {
                    pb.AddGoods(itemInfo4);
                }
                else
                {
                    list.Add(itemInfo4);
                }
                mailInfo.Annex4 = itemInfo4.ItemID.ToString();
                mailInfo.Annex4Name = itemInfo4.Template.Name;
                stringBuilder.Append("4、" + mailInfo.Annex4Name + "x" + itemInfo4.Count + ";");
                stringBuilder2.Append("4、" + mailInfo.Annex4Name + "x" + itemInfo4.Count + ";");
            }
            num = i + 4;
            if (items.Count > num)
            {
                ItemInfo itemInfo5 = items[num];
                if (itemInfo5.ItemID == 0)
                {
                    pb.AddGoods(itemInfo5);
                }
                else
                {
                    list.Add(itemInfo5);
                }
                mailInfo.Annex5 = itemInfo5.ItemID.ToString();
                mailInfo.Annex5Name = itemInfo5.Template.Name;
                stringBuilder.Append("5、" + mailInfo.Annex5Name + "x" + itemInfo5.Count + ";");
                stringBuilder2.Append("5、" + mailInfo.Annex5Name + "x" + itemInfo5.Count + ";");
            }
            mailInfo.AnnexRemark = stringBuilder.ToString();
            if (content == null && stringBuilder2.ToString() == null)
            {
                mailInfo.Content = LanguageMgr.GetTranslation("Game.Server.GameUtils.Content");
            }
            else if (content != "")
            {
                mailInfo.Content = content;
            }
            else
            {
                mailInfo.Content = stringBuilder2.ToString();
            }
            if (pb.SendMail(mailInfo))
            {
                foreach (ItemInfo item in list)
                {
                    TakeOutItem(item);
                }
            }
            else
            {
                result = false;
            }
        }
        return result;
    }

    public void ViFarmsAdd(int playerID)
    {
        if (!ViFarms.Contains(playerID))
        {
            ViFarms.Add(playerID);
        }
    }

    public void ViFarmsRemove(int playerID)
    {
        if (ViFarms.Contains(playerID))
        {
            ViFarms.Remove(playerID);
        }
    }

    public bool SendItemToMail(int templateID, string content, string title)
    {
        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(templateID);
        if (itemTemplateInfo == null)
        {
            return false;
        }
        if (content == "")
        {
            content = itemTemplateInfo.Name + "x1";
        }
        ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, 1, 104);
        itemInfo.IsBinds = true;
        return SendItemToMail(itemInfo, content, title, eMailType.Active);
    }

    public bool SendItemToMail(ItemInfo item, string content, string title, eMailType type)
    {
        using PlayerBussiness pb = new PlayerBussiness();
        return SendItemToMail(item, pb, content, title, type);
    }

    public bool SendItemToMail(ItemInfo item, PlayerBussiness pb, string content, string title, eMailType type)
    {
        int originalBagType = item.BagType;
        bool saveToDb = true;
        MailInfo mailInfo = new MailInfo
        {
            Content = ((content != null) ? content : LanguageMgr.GetTranslation("Game.Server.GameUtils.Content")),
            Title = ((title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title")),
            Gold = 0,
            IsExist = true,
            Money = 0,
            GiftToken = 0,
            Receiver = PlayerCharacter.NickName,
            ReceiverID = PlayerCharacter.ID,
            Sender = PlayerCharacter.NickName,
            SenderID = PlayerCharacter.ID,
            Type = (int)type
        };
        if (item.ItemID == 0)
        {
            saveToDb = false;
            pb.AddGoods(item);
        }
        mailInfo.Annex1 = item.ItemID.ToString();
        mailInfo.Annex1Name = item.Template.Name;
        if (pb.SendMail(mailInfo))
        {
            TakeOutItem(item);
            if (originalBagType != -1 && saveToDb)
            {
                this.GetInventory((eBageType)originalBagType).SaveRemovedItems();
            }

            return true;
        }
        return false;
    }

    public bool SendMailToUser(PlayerBussiness pb, string content, string title, eMailType type)
    {
        MailInfo mailInfo = new MailInfo
        {
            Content = content,
            Title = title,
            Gold = 0,
            IsExist = true,
            Money = 0,
            GiftToken = 0,
            Receiver = PlayerCharacter.NickName,
            ReceiverID = PlayerCharacter.ID,
            Sender = PlayerCharacter.NickName,
            SenderID = PlayerCharacter.ID,
            Type = (int)type
        };
        mailInfo.Annex1 = "";
        mailInfo.Annex1Name = "";
        return pb.SendMail(mailInfo);
    }

    public void SendMessage(string msg)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(3);
        gSPacketIn.WriteInt(0);
        gSPacketIn.WriteString(msg);
        SendTCP(gSPacketIn);
    }

    public void SendMessage(eMessageType type, string msg)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(3);
        gSPacketIn.WriteInt((int)type);
        gSPacketIn.WriteString(msg);
        SendTCP(gSPacketIn);
    }

    public bool SendMoneyMailToUser(string title, string content, int money, eMailType type)
    {
        using PlayerBussiness pb = new PlayerBussiness();
        return SendMoneyMailToUser(pb, content, title, money, type);
    }

    public bool SendMoneyMailToUser(PlayerBussiness pb, string content, string title, int money, eMailType type)
    {
        MailInfo mailInfo = new MailInfo
        {
            Content = content,
            Title = title,
            Gold = 0,
            IsExist = true,
            Money = money,
            GiftToken = 0,
            Receiver = PlayerCharacter.NickName,
            ReceiverID = PlayerCharacter.ID,
            Sender = PlayerCharacter.NickName,
            SenderID = PlayerCharacter.ID,
            Type = (int)type
        };
        mailInfo.Annex1 = "";
        mailInfo.Annex1Name = "";
        return pb.SendMail(mailInfo);
    }

    public void SendPrivateChat(int receiverID, string receiver, string sender, string msg, bool isAutoReply)
    {
        GSPacketIn gSPacketIn = new GSPacketIn(37, PlayerCharacter.ID);
        gSPacketIn.WriteInt(receiverID);
        gSPacketIn.WriteString(receiver);
        gSPacketIn.WriteString(sender);
        gSPacketIn.WriteString(msg);
        gSPacketIn.WriteBoolean(isAutoReply);
        SendTCP(gSPacketIn);
    }

    public virtual void SendTCP(GSPacketIn pkg)
    {
        if (m_client.IsConnected)
        {
            m_client.SendTCP(pkg);
        }
    }

    public bool SetPvePermission(int copyId, eHardLevel hardLevel)
    {
        if (copyId <= m_pvepermissions.Length && copyId > 0 && hardLevel != eHardLevel.Epic && m_pvepermissions[copyId - 1] == permissionChars[(int)hardLevel - 1 < 0 ? (int)hardLevel : (int)hardLevel - 1])
        {
            m_pvepermissions[copyId - 1] = permissionChars[(int)(hardLevel)];
            m_character.PvePermission = ConverterPvePermission(m_pvepermissions);
            OnPropertiesChanged();
            return true;
        }
        return false;
    }

    public void OpenAllNoviceActive()
    {
        DateTime startTime = DateTime.Now;
        DateTime endTime = DateTime.Now.AddYears(2);
        DateTime startDate = DateTime.Parse(GameProperties.EventStartDate);
        DateTime stopDate = DateTime.Parse(GameProperties.EventEndDate);
        using (PlayerBussiness pb = new PlayerBussiness())
        {
            EventRewardProcessInfo[] userEventProcess = pb.GetUserEventProcess(PlayerId);
            foreach (EventRewardProcessInfo eventRewardProcessInfo in userEventProcess)
            {
                startTime = startDate;
                endTime = stopDate;
                Out.SendOpenNoviceActive(0, eventRewardProcessInfo.ActiveType, eventRewardProcessInfo.Conditions, eventRewardProcessInfo.AwardGot, startTime, endTime);
            }
        }
    }

    public void ShowAllFootballCard()
    {
        for (int i = 0; i < CardsTakeOut.Length; i++)
        {
            if (CardsTakeOut[i] == null)
            {
                CardsTakeOut[i] = Card[i];
                if (takeoutCount > 0)
                {
                    TakeFootballCard(Card[i]);
                }
            }
        }
    }

    public bool StackItemToAnother(ItemInfo item)
    {
        return GetItemInventory(item.Template).StackItemToAnother(item);
    }

    public void TakeFootballCard(CardInfoOld card)
    {
        List<ItemInfo> list = new List<ItemInfo>();
        for (int i = 0; i < CardsTakeOut.Length; i++)
        {
            if (card.place == i)
            {
                CardsTakeOut[i] = card;
                CardsTakeOut[i].IsTake = true;
                ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(card.templateID);
                if (itemTemplateInfo != null)
                {
                    list.Add(ItemInfo.CreateFromTemplate(itemTemplateInfo, card.count, 110));
                }
                takeoutCount--;
                break;
            }
        }
        if (list.Count <= 0)
        {
            return;
        }
        foreach (ItemInfo item in list)
        {
            AddTemplate(list);
        }
    }

    public bool TakeOutItem(ItemInfo item)
    {
        if (item.BagType == m_propBag.BagType)
        {
            return m_propBag.TakeOutItem(item);
        }
        if (item.BagType == m_fightBag.BagType)
        {
            return m_fightBag.TakeOutItem(item);
        }
        if (item.BagType == m_ConsortiaBag.BagType)
        {
            return m_ConsortiaBag.TakeOutItem(item);
        }
        if (item.BagType == m_BankBag.BagType)
        {
            return m_BankBag.TakeOutItem(item);
        }
        return m_equipBag.TakeOutItem(item);
    }

    public void TestQuest()
    {
        using ProduceBussiness produceBussiness = new ProduceBussiness();
        QuestInfo[] aLlQuest = produceBussiness.GetALlQuest();
        QuestInfo[] array = aLlQuest;
        QuestInfo[] array2 = array;
        foreach (QuestInfo info in array2)
        {
            QuestInventory.AddQuest(info, out var _);
        }
    }

    public override string ToString()
    {
        return $"Id:{PlayerId} nickname:{PlayerCharacter.NickName} room:{CurrentRoom} ";
    }

    public void RemoveFistGetPet()
    {
        PlayerCharacter.IsFistGetPet = false;
        PlayerCharacter.LastRefreshPet = DateTime.Now.AddDays(-1.0);
    }

    public void RemoveLastRefreshPet()
    {
        PlayerCharacter.LastRefreshPet = DateTime.Now;
    }

    public void UpdateAnswerSite(int id)
    {
        if (PlayerCharacter.AnswerSite < id)
        {
            PlayerCharacter.AnswerSite = id;
        }
        UpdateWeaklessGuildProgress();
        Out.SendWeaklessGuildProgress(PlayerCharacter);
    }

    public void UpdateBadgeId(int Id)
    {
        m_character.badgeID = Id;
    }

    public void UpdateBarrier(int barrier, string pic)
    {
        if (CurrentRoom != null)
        {
            CurrentRoom.Pic = pic;
            CurrentRoom.barrierNum = barrier;
            CurrentRoom.currentFloor = barrier;
        }
    }

    public void UpdateBaseProperties(int attack, int defence, int agility, int lucky, int hp, int Guard)
    {
        if (attack != m_character.Attack || defence != m_character.Defence || agility != m_character.Agility || lucky != m_character.Luck)
        {
            m_character.Attack = attack;
            m_character.Defence = defence;
            m_character.Agility = agility;
            m_character.Luck = lucky;
            OnPropertiesChanged();
        }
        m_character.hp = (int)((double)(hp + LevelPlusBlood + m_character.Defence / 10) * GetBaseBlood());
        HoGiap = Guard;
    }

    public bool UpdateChangedPlaces()
    {
        try
        {
            EquipBag.UpdateChangedPlaces();
            PropBag.UpdateChangedPlaces();
            return true;
        }
        catch (Exception exception)
        {
            log.Error("Error Update Changed Places " + m_character.NickName + "!", exception);
            return false;
        }
    }

    public void UpdateDrill(int index, UserDrillInfo drill)
    {
        m_userDrills[index] = drill;
    }

    public void UpdateFightBuff(BufferInfo info)
    {
        int num = -1;
        for (int i = 0; i < FightBuffs.Count; i++)
        {
            if (info != null && info.Type == FightBuffs[i].Type)
            {
                FightBuffs[i] = info;
                num = info.Type;
            }
        }
        if (num == -1)
        {
            FightBuffs.Add(info);
        }
    }

    public void UpdateFightPower()
    {
        int num = 0;
        FightPower = 0;
        int hp = PlayerCharacter.hp;
        num += PlayerCharacter.Attack;
        num += PlayerCharacter.Defence;
        num += PlayerCharacter.Agility;
        num += PlayerCharacter.Luck;
        double baseAttack = GetBaseAttack();
        double baseDefence = GetBaseDefence();
        FightPower += (int)((double)(num + 1000) * (baseAttack * baseAttack * baseAttack + 3.5 * baseDefence * baseDefence * baseDefence) / 100000000.0 + (double)hp * 0.95);
        if (m_currentSecondWeapon != null)
        {
            FightPower += (int)((double)m_currentSecondWeapon.Template.Property7 * Math.Pow(1.1, m_currentSecondWeapon.StrengthenLevel));
        }
        if (FightPower < 0)
        {
            FightPower = int.MaxValue;
        }
        PlayerCharacter.FightPower = FightPower;
        OnPlayerPropertyChanged(m_character);
        //Extra.UpdateEventCondition((int)NoviceActiveType.UPDATE_FIGHTPOWER, m_character.FightPower);
    }

    public void UpdateHealstone(ItemInfo item)
    {
        if (item != null)
        {
            m_healstone = item;
        }
    }

    public void UpdateHide(int hide)
    {
        if (hide != m_character.Hide)
        {
            m_character.Hide = hide;
            OnPropertiesChanged();
        }
    }

    public void UpdateHonor(string honor)
    {
        UserRankInfo singleRank = Rank.GetSingleRank(honor);
        if (singleRank != null && singleRank.IsValidRank())
        {
            PlayerCharacter.honorId = singleRank.NewTitleID;
            PlayerCharacter.Honor = honor;
            EquipBag.UpdatePlayerProperties();
        }
        else
        {
            PlayerCharacter.honorId = 0;
            PlayerCharacter.Honor = "";
            EquipBag.UpdatePlayerProperties();
            //SendMessage("Cập nhật danh hiệu thất bại!");
        }
    }

    public void UpdateHonor(int honorid)
    {
        UserRankInfo singleRank = Rank.GetRankByHonnor(honorid);
        if (singleRank != null && singleRank.IsValidRank())
        {
            PlayerCharacter.honorId = honorid;
            PlayerCharacter.Honor = singleRank.Info.Name;
            EquipBag.UpdatePlayerProperties();
        }
        else
        {
            PlayerCharacter.honorId = 0;
            PlayerCharacter.Honor = "";
            EquipBag.UpdatePlayerProperties();
            //SendMessage("Cập nhật danh hiệu thất bại!");
        }
    }

    public void UpdateItem(ItemInfo item)
    {
        GetInventory((eBageType)item.BagType)?.UpdateItem(item);
    }

    public void AccumulativeUpdate()
    {
        if (PlayerCharacter.accumulativeLoginDays < 7)
        {
            if (PlayerCharacter.accumulativeLoginDays == 0)
            {
                PlayerCharacter.accumulativeLoginDays = 1;
            }
            else
            {
                PlayerCharacter.accumulativeLoginDays++;
            }
        }
    }

    public void UpdateItemForUser(object state)
    {
        m_battle.LoadFromDatabase();
        m_equipBag.LoadFromDatabase();
        m_propBag.LoadFromDatabase();
        m_ConsortiaBag.LoadFromDatabase();
        m_BankBag.LoadFromDatabase();
        m_storeBag.LoadFromDatabase();
        m_cardBag.LoadFromDatabase();
        m_questInventory.LoadFromDatabase(m_character.ID);
        m_achievementInventory.LoadFromDatabase(m_character.ID);
        m_eventLiveInventory.LoadFromDatabase();
        m_bufferList.LoadFromDatabase(m_character.ID);
        m_rank.LoadFromDatabase();
        m_extra.LoadFromDatabase();
        m_petBag.LoadFromDatabase();
        FarmBag.LoadFromDatabase();
        m_playerActive.LoadFromDatabase();
        this.m_avatarcollect.LoadFromDatabase();
    }

    public void UpdateLevel()
    {
        Level = LevelMgr.GetLevel(m_character.GP);
        int maxLevel = LevelMgr.MaxLevel;
        LevelInfo levelInfo = LevelMgr.FindLevel(maxLevel);
        if (Extra.CheckNoviceActiveOpen(NoviceActiveType.GRADE_UP_ACTIVE))
        {
            Extra.UpdateEventCondition((int)NoviceActiveType.GRADE_UP_ACTIVE, Level);
        }
        OnLevelUp(Level);
        if (Level == maxLevel && levelInfo != null)
        {
            m_character.GP = levelInfo.GP;
        }
    }

    public void UpdatePet(UsersPetInfo pet)
    {
        m_pet = pet;
    }

    public void UpdateProperties()
    {
        Out.SendUpdatePrivateInfo(m_character, GetMedalNum());
        GSPacketIn pkg = Out.SendUpdatePublicPlayer(m_character, MatchInfo, m_extra.Info);
        if (m_currentRoom != null)
        {
            m_currentRoom.SendToAll(pkg, this);
        }
    }

    public void UpdatePveResult(string type, int value, bool option)
    {
        var damageScore = 0;
        var honor = 0;
        var msg = "";
        switch (type)
        {
            case "worldboss":
                {
                    if (RoomMgr.WorldBossRoom.ReduceBlood(value) && !RoomMgr.WorldBossRoom.FightOver)
                    {
                        damageScore = value / 400;
                        honor = value / 1200;
                        msg = LanguageMgr.GetTranslation("GamePlayer.Msg20", damageScore, honor);
                        AddDamageScores(damageScore);
                        RoomMgr.WorldBossRoom.UpdateRank(this, damageScore, honor);
                        RoomMgr.WorldBossRoom.ReduceBlood(value);
                        if (option)
                        {
                            RoomMgr.WorldBossRoom.SendFightOver();
                        }
                    }
                }
                break;
            default:
                break;
        }

        AddHonor(honor);
        if (!string.IsNullOrEmpty(msg))
            SendMessage(msg);
    }

    public int AddEliteScore(int value)
    {
        if (value > 0)
        {
            PlayerCharacter.EliteScore += value;
            GameServer.Instance.LoginServer.SendEliteScoreUpdate(PlayerCharacter.ID, PlayerCharacter.NickName, (PlayerCharacter.Grade <= 40) ? 1 : 2, PlayerCharacter.EliteScore);
        }
        return 0;
    }

    public int RemoveEliteScore(int value)
    {
        if (value > 0)
        {
            PlayerCharacter.EliteScore -= value;
            if (PlayerCharacter.EliteScore <= 0)
            {
                PlayerCharacter.EliteScore = 1;
            }
            GameServer.Instance.LoginServer.SendEliteScoreUpdate(PlayerCharacter.ID, PlayerCharacter.NickName, (PlayerCharacter.Grade <= 40) ? 1 : 2, PlayerCharacter.EliteScore);
        }
        return 0;
    }

    public void SendWinEliteChampion()
    {
        EliteGameRoundInfo eliteGameRoundInfo = ExerciseMgr.FindEliteRoundByUser(PlayerCharacter.ID);
        if (eliteGameRoundInfo != null)
        {
            eliteGameRoundInfo.PlayerWin = ((eliteGameRoundInfo.PlayerOne.UserID == PlayerCharacter.ID) ? eliteGameRoundInfo.PlayerOne : eliteGameRoundInfo.PlayerTwo);
            GameServer.Instance.LoginServer.SendEliteChampionRoundUpdate(eliteGameRoundInfo);
            ExerciseMgr.RemoveEliteRound(eliteGameRoundInfo);
        }
        else
        {
            log.Error("////// ELITEGAME Send Win Elite Champion Round ERROR NOT FOUND: " + PlayerCharacter.UserName);
        }
    }

    public void OnTakeCard(int roomType, int place, int templateId, int count)
    {
        TakeCardPlace = place;
        TakeCardTemplateID = templateId;
        TakeCardCount = count;
    }

    public void UpdateReduceDame(ItemInfo item)
    {
        if (item != null && item.Template != null)
        {
            PlayerCharacter.ReduceDamePlus = item.Template.Property1;
        }
    }

    public void UpdateSecondWeapon(ItemInfo item)
    {
        if (item != m_currentSecondWeapon)
        {
            m_currentSecondWeapon = item;
            OnPropertiesChanged();
        }
    }

    public void UpdateStyle(string style, string colors, string skin)
    {
        if (style != m_character.Style || colors != m_character.Colors || skin != m_character.Skin)
        {
            m_character.Style = style;
            m_character.Colors = colors;
            m_character.Skin = skin;
            OnPropertiesChanged();
        }
    }

    public void UpdateWeaklessGuildProgress()
    {
        if (PlayerCharacter.weaklessGuildProgress == null)
        {
            PlayerCharacter.weaklessGuildProgress = Base64.decodeToByteArray(PlayerCharacter.WeaklessGuildProgressStr);
        }
        PlayerCharacter.CheckLevelFunction();
        if (PlayerCharacter.Grade == 1)
        {
            PlayerCharacter.openFunction(Step.GAIN_ADDONE);
        }
        if (PlayerCharacter.IsOldPlayer)
        {
            PlayerCharacter.openFunction(Step.OLD_PLAYER);
        }
        PlayerCharacter.WeaklessGuildProgressStr = Base64.encodeByteArray(PlayerCharacter.weaklessGuildProgress);
    }

    public void UpdateWeapon(ItemInfo item)
    {
        if (item != m_MainWeapon)
        {
            m_MainWeapon = item;
            OnPropertiesChanged();
        }
    }

    public bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving)
    {
        if (bag == 1 && templateId >= 10001 && templateId <= 10008)
        {
            ItemTemplateInfo itemTemplateInfo = PropItemMgr.FindFightingProp(templateId);
            if (isLiving && itemTemplateInfo != null)
            {
                OnUsingItem(itemTemplateInfo.TemplateID, 1);
                if (place == -1 && CanUseProp)
                {
                    return true;
                }
                ItemInfo itemAt = m_propBag.GetItemAt(place);
                if (itemAt != null && itemAt.IsValidItem() && itemAt.Count >= 0)
                {
                    m_propBag.RemoveCountFromStack(itemAt, 1);
                    return true;
                }
            }
        }
        else
        {
            ItemInfo itemAt2 = m_fightBag.GetItemAt(place);
            if (itemAt2 != null)
            {
                OnUsingItem(itemAt2.TemplateID, 1);
                if (itemAt2.TemplateID == templateId)
                {
                    return m_fightBag.RemoveItem(itemAt2);
                }
            }
        }
        return false;
    }

    public void OnPlayerAddItem(string type, int value)
    {
        if (this.PlayerAddItem != null)
        {
            this.PlayerAddItem(type, value);
        }
    }

    public void OnPlayerSpa(int onlineTimeSpa)
    {
        if (this.PlayerSpa != null)
        {
            this.PlayerSpa(onlineTimeSpa);
        }
    }

    public void OnPlayerQuestFinish(BaseQuest baseQuest)
    {
        if (this.PlayerQuestFinish != null)
        {
            this.PlayerQuestFinish(baseQuest);
        }
    }

    public void OnPlayerLogin()
    {
        if (this.PlayerLogin != null)
        {
            this.PlayerLogin();
        }
    }

    public void OnPlayerPropertyChanged(PlayerInfo character)
    {
        if (this.PlayerPropertyChanged != null)
        {
            this.PlayerPropertyChanged(character);
        }
    }

    public void OnVIPUpgrade(int level, int exp)
    {
        if (this.Event_0 != null && m_character.typeVIP > 0 && m_character.VIPLevel == level)
        {
            this.Event_0(level, exp);
        }
    }

    public void OnUseBugle(int value)
    {
        if (this.UseBugle != null)
        {
            this.UseBugle(value);
        }
    }

    public void OnPlayerMarry()
    {
        if (this.PlayerMarry != null)
        {
            this.PlayerMarry();
        }
    }

    public void OnPlayerDispatches()
    {
        if (this.PlayerDispatches != null)
        {
            this.PlayerDispatches();
        }
    }

    public void OnGameOver(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple, int blood, int playerCount)
    {
        if (game.RoomType == eRoomType.Match)
        {
            if (isWin)
            {
                m_character.Win++;
            }
            m_character.Total++;
        }
        if (blood == 1)
        {
            OnFightOneBloodIsWin(game.RoomType, isWin);
        }
        if (playerCount == 4)
        {
            OnGameOver2v2(isWin);
        }
        if (isCouple && this.GameMarryTeam != null)
        {
            this.GameMarryTeam(game, isWin, gainXp, playerCount);
        }
        if (this.GameOverCountTeam != null)
        {
            this.GameOverCountTeam(game, isWin, gainXp, playerCount);
        }
        if (this.GameOver != null)
        {
            this.GameOver(game, isWin, gainXp, isSpanArea, isCouple);
        }
        ClearFightBuffOneMatch();
    }

    public void OnFightOneBloodIsWin(eRoomType roomType, bool isWin)
    {
        if (this.FightOneBloodIsWin != null)
        {
            this.FightOneBloodIsWin(roomType, isWin);
        }
    }

    public void OnGameOver2v2(bool isWin)
    {
        if (this.GameOver2v2 != null)
        {
            this.GameOver2v2(isWin);
        }
    }

    public void OnAcademyEvent(GamePlayer friendly, int type)
    {
        if (this.AcademyEvent != null)
        {
            this.AcademyEvent(friendly, type);
        }
    }

    public void OnEquipCardEvent()
    {
        if (this.EquipCardEvent != null)
        {
            this.EquipCardEvent();
        }
    }

    public bool IsLimitMail()
    {
        if (!GameProperties.IsLimitMail)
        {
            return false;
        }
        if (Extra.Info.FreeSendMailCount >= GameProperties.LimitMail)
        {
            SendMessage($"Số lần gửi = {GameProperties.LimitMail}");
            return true;
        }
        Extra.Info.FreeSendMailCount++;
        return false;
    }

    public static List<Suit_TemplateInfo> Load_Template_Suit_info()
    {
        List<Suit_TemplateInfo> list = new List<Suit_TemplateInfo>();
        using (ProduceBussiness produceBussiness = new ProduceBussiness())
        {
            Suit_TemplateInfo[] array = produceBussiness.Load_Suit_TemplateInfo();
            Suit_TemplateInfo[] array2 = array;
            Suit_TemplateInfo[] array3 = array2;
            foreach (Suit_TemplateInfo item in array3)
            {
                list.Add(item);
            }
        }
        return list;
    }

    public static List<Suit_TemplateID> Load_Suit_TemplateID()
    {
        List<Suit_TemplateID> list = new List<Suit_TemplateID>();
        using (ProduceBussiness produceBussiness = new ProduceBussiness())
        {
            Suit_TemplateID[] array = produceBussiness.Load_Suit_TemplateID();
            for (int i = 0; i < array.Length; i++)
            {
                list.Add(array[i]);
            }
        }
        return list;
    }

    private static List<int> DS_Item_Suit()
    {
        List<int> list = new List<int>();
        List<Suit_TemplateID> list2 = Load_Suit_TemplateID();
        for (int i = 0; i < list2.Count; i++)
        {
            if (tachchuoi(list2[i].ContainEquip).Length > 1)
            {
                int num = 0;
                while (i < tachchuoi(list2[i].ContainEquip).Length)
                {
                    list.Add(tachchuoi(list2[i].ContainEquip)[num]);
                    num++;
                }
            }
            else
            {
                list.Add(tachchuoi(list2[i].ContainEquip)[0]);
            }
        }
        return list;
    }

    private static int[] tachchuoi(string A)
    {
        List<int> list = new List<int>();
        if (!A.Contains(","))
        {
            list.Add(int.Parse(A));
        }
        else
        {
            bool flag = true;
            while (flag)
            {
                if (!A.Contains(","))
                {
                    list.Add(int.Parse(A));
                    flag = false;
                    break;
                }
                if (A.IndexOf(",") > 0)
                {
                    int num = A.IndexOf(",");
                    list.Add(int.Parse(A.Substring(0, num)));
                    A = A.Remove(0, num + 1);
                }
            }
        }
        return list.ToArray();
    }

    public void ClearStoreBagWithOutPlace(int place)
    {
        List<ItemInfo> list = new List<ItemInfo>();
        for (int i = 0; i < StoreBag.Capalility; i++)
        {
            if (i == place)
            {
                continue;
            }
            ItemInfo itemAt = StoreBag.GetItemAt(i);
            int num = 0;
            if (itemAt == null)
            {
                continue;
            }
            if (itemAt.Template.BagType == eBageType.PropBag)
            {
                num = PropBag.FindFirstEmptySlot();
                if (!PropBag.AddItemTo(itemAt, num))
                {
                    //PropBag.SaveToDatabase();
                    list.Add(itemAt);
                }
                else
                {
                    StoreBag.TakeOutItem(itemAt);
                    //StoreBag.SaveToDatabase();
                }
            }
            else
            {
                num = EquipBag.FindFirstEmptySlot(31);
                if (!EquipBag.AddItemTo(itemAt, num))
                {
                    //EquipBag.SaveToDatabase();
                    list.Add(itemAt);
                }
                else
                {
                    StoreBag.TakeOutItem(itemAt);
                    //StoreBag.SaveToDatabase();
                }
            }
        }
        if (list.Count > 0)
        {
            StoreBag.ClearBagWithoutPlace(place);
            SendItemsToMail(list, "Túi đầy vật phẩm từ tiệm rèn trả về thư.", "Vật phẩm trả về từ Tiệm rèn.", eMailType.StoreCanel);

        }
        this.SaveIntoDatabase();
    }

    public void ResetRoom(bool isWin, string parram)
    {
        if (CurrentRoom != null)
        {
            if (CurrentRoom.RoomType == eRoomType.Dungeon)
            {
                CurrentRoom.Pic = "";
                CurrentRoom.MapId = 10000;
                CurrentRoom.currentFloor = 0;
                CurrentRoom.isOpenBoss = false;
                CurrentRoom.SendRoomSetupChange(CurrentRoom);
            }
        }

    }

    #region WorldBoss

    public WorldBossProcessor WorldBoss { get; private set; }
    private WorldBossLogicProcessor _worldBossProcessor;
    public int AddDamageScores(int value) //trminhpc
    {
        if (value > 0)
        {
            PlayerCharacter.damageScores += value;
            if (PlayerCharacter.damageScores <= int.MinValue)
            {
                PlayerCharacter.damageScores = int.MaxValue;
                SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg11"));
            }

            OnPropertiesChanged();
            return value;
        }

        return 0;
    }

    public int RemoveDamageScores(int value) //baolt dep trai
    {
        if (value > 0 && PlayerCharacter.damageScores >= value)
        {
            PlayerCharacter.damageScores -= value;
            if (PlayerCharacter.damageScores <= int.MinValue)
            {
                PlayerCharacter.damageScores = int.MaxValue;

            }
            if (PlayerCharacter.damageScores <= 0)
            {
                PlayerCharacter.damageScores = 0;

            }
            OnPropertiesChanged();
            return value;
        }

        return 0;
    }
    #endregion

    public bool ActiveMoneyEnable(int value)
    {
        if (GameProperties.IsActiveMoney)
        {
            if (value < 1)
                return false;
            if (Actives.Info.ActiveMoney >= value)
            {
                RemoveActiveMoney(value);
                RemoveMoney(value);
                return true;
            }
            SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg8", Actives.Info.ActiveMoney));
        }
        else
        {
            return MoneyDirect(value, IsAntiMult: false, false);
        }
        return false;
    }

    public int AddActiveMoney(int value)
    {
        if (value > 0)
        {
            if (GameProperties.IsActiveMoney)
            {
                Actives.Info.ActiveMoney += value;
                if (Actives.Info.ActiveMoney <= int.MinValue)
                {
                    Actives.Info.ActiveMoney = int.MaxValue;
                    SendMessage(LanguageMgr.GetTranslation("GamePlayer.Msg9"));
                }
                else
                {
                    SendHideMessage(LanguageMgr.GetTranslation("GamePlayer.Msg1", value, Actives.Info.ActiveMoney));
                }
                return value;
            }
        }
        return 0;
    }

    public int RemoveActiveMoney(int value)
    {
        if (value > 0 && value <= Actives.Info.ActiveMoney)
        {
            Actives.Info.ActiveMoney -= value;
            SendHideMessage(LanguageMgr.GetTranslation("GamePlayer.Msg2", value, Actives.Info.ActiveMoney));
            return value;
        }
        return 0;
    }

    public void LoadGemStone(PlayerBussiness db)
    {
        lock (this.m_GemStone)
        {
            this.m_GemStone = db.GetSingleGemStones(this.m_character.ID);
            if (this.m_GemStone.Count != 0)
                return;
            List<int> intList1 = new List<int>()
        {
          11,
          5,
          2,
          3,
          13
        };
            List<int> intList2 = new List<int>()
        {
          100002,
          100003,
          100001,
          100004,
          100005
        };
            for (int index = 0; index < intList1.Count; ++index)
            {
                UserGemStone userGemStone1 = new UserGemStone();
                userGemStone1.ID = 0;
                int id = this.m_character.ID;
                userGemStone1.UserID = id;
                int num1 = intList2[index];
                userGemStone1.FigSpiritId = num1;
                string str = "0,0,0|0,0,1|0,0,2";
                userGemStone1.FigSpiritIdValue = str;
                int num2 = intList1[index];
                userGemStone1.EquipPlace = num2;
                UserGemStone userGemStone2 = userGemStone1;
                this.m_GemStone.Add(userGemStone2);
                db.AddUserGemStone(userGemStone2);
            }
        }
    }

    public UserGemStone GetGemStone(int place)
    {
        return this.m_GemStone.FirstOrDefault<UserGemStone>((Func<UserGemStone, bool>)(g => place == g.EquipPlace));
    }

    public void UpdateGemStone(int place, UserGemStone gem)
    {
        lock (this.m_GemStone)
        {
            for (int index = 0; index < this.m_GemStone.Count; ++index)
            {
                if (place == this.m_GemStone[index].EquipPlace)
                {
                    this.m_GemStone[index] = gem;
                    break;
                }
            }
        }
    }

    //

    public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count)
    {
        PlayerInventory bag = GetInventory(bagType);
        if (bag != null)
        {
            // cloneItem.IsBinds = cloneItem.Template.BindType == 1;
            if (bag.AddTemplate(cloneItem, count))
            {

                if (CurrentRoom != null && CurrentRoom.IsPlaying) SendItemNotice(cloneItem);
                return true;
            }
        }
        return false;
    }

    public int AddTotem(int value)
    {
        if (value > 0)
        {
            m_character.totemId = value;
            OnPropertiesChanged();
            return value;
        }
        return m_character.totemId;
    }
    public int AddHonor(int value)
    {
        if (value > 0)
        {
            m_character.myHonor += value;
            OnPropertiesChanged();
            return value;
        }
        else
        {
            return 0;
        }
    }

    public int RemovemyHonor(int value)
    {
        if (value > 0 && value <= m_character.myHonor)
        {
            m_character.myHonor -= value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }

    public int AddMaxHonor(int value)
    {
        if (value > 0)
        {
            m_character.MaxBuyHonor += value;
            OnPropertiesChanged();
            return value;
        }
        return 0;
    }
}
