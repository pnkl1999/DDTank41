using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Fighting.Server.GameObjects
{
    public class ProxyPlayer : IGamePlayer
    {
        public List<BufferInfo> Buffers;

        private double GPRate;

        public double m_antiAddictionRate;

        private double m_baseAglilty;

        private double m_baseAttack;

        private double m_baseBlood;

        private double m_baseDefence;

        private bool m_canUseProp;

        private bool m_canX2Exp;

        private bool m_canX3Exp;

        private ServerClient m_client;

        private ItemInfo m_currentWeapon;

        private PlayerInfo m_character;

        private List<int> m_equipEffect;

        private List<BufferInfo> m_fightBuffs;

        private int m_gamePlayerId;

        private ItemInfo m_healstone;

        private UserMatchInfo m_matchInfo;

        private UsersPetInfo m_pet;

        private ItemInfo m_secondWeapon;

        public int m_serverid;

        private int m_zoneId;

        private string m_zoneName;

        private double OfferRate;

        private ServerClient serverClient;

        private PlayerInfo info;

        private ItemTemplateInfo itemTemplate;

        private ItemInfo item;

        private double baseAttack;

        private double baseDefence;

        private double baseAgility;

        private double baseBlood;

        private double gprate;

        private double offerrate;

        private double rate;

        private List<BufferInfo> infos;

        private int serverid;

        private int currentEnemyId;

        private int int_1;

        public List<int> CardBuff { get; set; }

        public int CurrentEnemyId
        {
			get
			{
				return currentEnemyId;
			}
			set
			{
				currentEnemyId = value;
			}
        }

        public string ProcessLabyrinthAward { get; set; }

        public int GameId
        {
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
				m_client.SendGamePlayerId(this);
			}
        }

        public long AllWorldDameBoss=> 0L;

        public bool CanUseProp
        {
			get
			{
				return m_canUseProp;
			}
			set
			{
				m_canUseProp = value;
			}
        }

        public bool CanX2Exp
        {
			get
			{
				return m_canX2Exp;
			}
			set
			{
				m_canX2Exp = value;
			}
        }

        public bool CanX3Exp
        {
			get
			{
				return m_canX3Exp;
			}
			set
			{
				m_canX3Exp = value;
			}
        }

        public List<int> EquipEffect=> m_equipEffect;

        public List<BufferInfo> FightBuffs=> m_fightBuffs;

        public int GamePlayerId
        {
			get
			{
				return m_gamePlayerId;
			}
			set
			{
				m_gamePlayerId = value;
				m_client.SendGamePlayerId(this);
			}
        }

        public ItemInfo Healstone=> m_healstone;

        public ItemInfo MainWeapon=> m_currentWeapon;

        public UserMatchInfo MatchInfo=> m_matchInfo;

        public UsersPetInfo Pet=> m_pet;

        public PlayerInfo PlayerCharacter=> m_character;

        public ItemInfo SecondWeapon=> m_secondWeapon;

        public int ServerID
        {
			get
			{
				return m_serverid;
			}
			set
			{
				m_serverid = value;
			}
        }

        public long WorldbossBood=> 0L;

        public int ZoneId=> m_zoneId;

        public string ZoneName=> m_zoneName;

        public double GPAddPlus { get; set; }

        public double OfferAddPlus { get; set; }

        public double GPApprenticeOnline { get; set; }

        public double GPApprenticeTeam { get; set; }

        public double GPSpouseTeam { get; set; }

        public bool IsAccountLimit { get; set; }

        public bool IsViewer { get; set; }
        public ProxyPlayer(ServerClient client, PlayerInfo character, UsersPetInfo pet, List<BufferInfo> buffers, List<int> equipEffect, List<BufferInfo> fightBuffer, ProxyPlayerInfo proxyPlayer, UserMatchInfo matchInfo)
        {
			m_client = client;
			m_character = character;
			m_serverid = proxyPlayer.ServerId;
			m_baseAttack = proxyPlayer.BaseAttack;
			m_baseDefence = proxyPlayer.BaseDefence;
			m_baseAglilty = proxyPlayer.BaseAgility;
			m_baseBlood = proxyPlayer.BaseBlood;
			m_currentWeapon = proxyPlayer.GetItemTemplateInfo();
			m_secondWeapon = proxyPlayer.GetItemInfo();
			m_healstone = proxyPlayer.GetHealstone();
			m_equipEffect = equipEffect;
			m_fightBuffs = fightBuffer;
			m_matchInfo = matchInfo;
			OfferRate = proxyPlayer.OfferAddPlus;
			GPRate = proxyPlayer.GPAddPlus;
			Buffers = buffers;
			m_zoneId = proxyPlayer.ZoneId;
			m_zoneName = proxyPlayer.ZoneName;
			m_pet = pet;
			m_antiAddictionRate = proxyPlayer.AntiAddictionRate;
        }

        public ProxyPlayer(ServerClient serverClient, PlayerInfo info, ItemTemplateInfo itemTemplate, ItemInfo item, double baseAttack, double baseDefence, double baseAgility, double baseBlood, double gprate, double offerrate, double rate, List<BufferInfo> infos, int serverid)
        {
			this.serverClient = serverClient;
			this.info = info;
			this.itemTemplate = itemTemplate;
			this.item = item;
			this.baseAttack = baseAttack;
			this.baseDefence = baseDefence;
			this.baseAgility = baseAgility;
			this.baseBlood = baseBlood;
			this.gprate = gprate;
			this.offerrate = offerrate;
			this.rate = rate;
			this.infos = infos;
			this.serverid = serverid;
        }

        public int AddDamageScores(int value)
        {
			return value;
        }

        public int AddRichesOffer(int value)
        {
			return value;
        }

        public int AddGold(int value)
        {
			if (value > 0)
			{
				m_client.SendPlayerAddGold(PlayerCharacter.ID, value);
			}
			return value;
        }

        public int AddGP(int gp)
        {
			if (gp > 0)
			{
				m_client.SendPlayerAddGP(PlayerCharacter.ID, gp);
			}
			return (int)(GPRate * (double)gp);
        }

        public int AddGiftToken(int value)
        {
			if (value > 0)
			{
				m_client.SendPlayerAddGiftToken(m_character.ID, value);
			}
			return value;
        }

        public int AddHardCurrency(int value)
        {
			return 0;
        }

        public void PVERewardNotice(string msg, int itemID, int templateID)
        {
        }

        public int AddHonor(int value)
        {
			return value;
        }

        public bool UsePayBuff(BuffType type)
        {
			return true;
        }

        public int AddMoney(int value)
        {
			if (value > 0)
			{
				m_client.SendPlayerAddMoney(m_character.ID, value, isAll: true);
			}
			return value;
        }

        public int AddMoney(int value, bool isAll)
        {
			if (value > 0)
			{
				m_client.SendPlayerAddMoney(m_character.ID, value, isAll);
			}
			return value;
        }

        public int AddEliteScore(int value)
        {
			if (value > 0)
			{
				m_client.SendAddEliteGameScore(PlayerCharacter.ID, value);
			}
			return value;
        }

        public int RemoveEliteScore(int value)
        {
			if (value > 0)
			{
				m_client.SendRemoveEliteGameScore(PlayerCharacter.ID, value);
			}
			return value;
        }

        public void SendWinEliteChampion()
        {
			m_client.SendEliteGameWinUpdate(PlayerCharacter.ID);
        }

        public int AddOffer(int value)
        {
			if (value > 0)
			{
				m_client.SendPlayerAddOffer(m_character.ID, value);
				return value;
			}
			RemoveOffer(Math.Abs(value));
			return value;
        }

        public void UpdateLabyrinth(int currentFloor, int m_missionInfoId, bool bigAward)
        {
        }

        public void OutLabyrinth(bool iswin)
        {
        }

        public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView typeGet)
        {
			m_client.SendPlayerAddTemplate(m_character.ID, cloneItem, bagType, count);
			return true;
        }

        public bool ClearFightBag()
        {
			return true;
        }

        public void ClearFightBuffOneMatch()
        {
        }

        public bool ClearTempBag()
        {
			return true;
        }

        public int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int count)
        {
			m_client.SendPlayerConsortiaFight(m_character.ID, consortiaWin, consortiaLose, players, roomType, gameClass, totalKillHealth);
			return 0;
        }

        public void Disconnect()
        {
			m_client.SendDisconnectPlayer(m_character.ID);
        }

        public double GetBaseAgility()
        {
			return m_baseAglilty;
        }

        public double GetBaseAttack()
        {
			return m_baseAttack;
        }

        public double GetBaseBlood()
        {
			return m_baseBlood;
        }

        public double GetBaseDefence()
        {
			return m_baseDefence;
        }

        public bool isDoubleAward()
        {
			return false;
        }

        public void LogAddMoney(AddMoneyType masterType, AddMoneyType sonType, int userId, int moneys, int SpareMoney)
        {
        }

        public bool MissionEnergyEmpty(int value)
        {
			return false;
        }

        public void OnGameOver(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple, int blood, int playerCount)
        {
			m_client.SendPlayerOnGameOver(PlayerCharacter.ID, game.Id, isWin, gainXp, isSpanArea, isCouple, blood, playerCount);
        }

        public void OnKillingBoss(AbstractGame game, NpcInfo npc, int damage)
        {
			throw new NotImplementedException();
        }

        public void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage)
        {
			m_client.SendPlayerOnKillingLiving(m_character.ID, game, type, id, isLiving, demage);
        }

        public void OnMissionOver(AbstractGame game, bool isWin, int MissionID, int turnNum)
        {
			m_client.SendPlayerOnMissionOver(m_character.ID, game, isWin, MissionID, turnNum);
        }

        public void OutLabyrinth()
        {
        }

        public int RemoveGold(int value)
        {
			m_client.SendPlayerRemoveGold(m_character.ID, value);
			return 0;
        }

        public int RemoveGP(int gp)
        {
			m_client.SendPlayerRemoveGP(PlayerCharacter.ID, gp);
			return gp;
        }

        public void UpdateRestCount()
        {
			m_client.SendUpdateRestCount(m_character.ID);
        }

        public int RemoveGiftToken(int value)
        {
			return 0;
        }

        public bool RemoveHealstone()
        {
			m_client.SendPlayerRemoveHealstone(m_character.ID);
			return false;
        }

        public int RemoveMedal(int value)
        {
			return 0;
        }

        public bool RemoveMissionEnergy(int value)
        {
			return false;
        }

        public int RemoveMoney(int value)
        {
			m_client.SendPlayerRemoveMoney(m_character.ID, value);
			return 0;
        }

        public int RemoveOffer(int value)
        {
			m_client.SendPlayerRemoveOffer(m_character.ID, value);
			return value;
        }

        public void SendConsortiaFight(int consortiaID, int riches, string msg)
        {
			m_client.SendPlayerSendConsortiaFight(m_character.ID, consortiaID, riches, msg);
        }

        public bool SetPvePermission(int missionId, eHardLevel hardLevel)
        {
			return true;
        }

        public bool IsPvePermission(int missionId, eHardLevel hardLevel)
        {
			return true;
        }

        public int AddRobRiches(int value)
        {
			if (value > 0)
			{
				value = (int)(double)value;
				if (value > 100000)
				{
					Console.WriteLine(string.Format("ProxyPlayer ====== player.nickname : {0}, player.RichesRob : {1}, add rob riches: {2}", new object[3]
					{
						PlayerCharacter.NickName,
						PlayerCharacter.RichesRob,
						value
					}));
				}
				m_client.SendAddRobRiches(m_character.ID, value);
				return value;
			}
			return 0;
        }

        public void SendHideMessage(string msg)
        {
			GSPacketIn pkg = new GSPacketIn(3);
			pkg.WriteInt(3);
			pkg.WriteString(msg);
			SendTCP(pkg);
        }

        public void SendInsufficientMoney(int type)
        {
        }

        public void SendMessage(string msg)
        {
			GSPacketIn pkg = new GSPacketIn(3);
			pkg.WriteInt(0);
			pkg.WriteString(msg);
			SendTCP(pkg);
        }

        public void SendTCP(GSPacketIn pkg)
        {
			m_client.SendPacketToPlayer(m_character.ID, pkg);
        }

        public void UpdateBarrier(int barrier, string pic)
        {
        }

        public void UpdatePveResult(string type, int value, bool isWin)
        {
        }

        public bool UseKingBlessHelpStraw(eRoomType roomType)
        {
			return false;
        }

        public bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving)
        {
			m_client.SendPlayerUsePropInGame(PlayerCharacter.ID, bag, place, templateId, isLiving);
			game.Pause(500);
			return false;
        }

        public bool SetFightLabPermission(int missionId, eHardLevel hardLevel)
        {
			return true;
        }

        public bool IsFightLabPermission(int missionId, eHardLevel hardLevel)
        {
			return true;
        }

        public bool SetFightLabPermission(int copyId, eHardLevel hardLevel, int missionId)
        {
			return true;
        }

        public void AddLog(string type, string content)
        {
        }

        public void ResetRoom(bool isWin, string parram) { }

        public void UpdatePublicPlayer(string tempStyle = "")
        {
            m_client.SendUpdatePublicPlayer(m_character.ID, tempStyle);
        }

        public void AddPrestige(bool isWin, eRoomType roomType)
        {
            m_client.SendPlayerAddPrestige(m_character.ID, isWin, roomType);
        }
    }
}
