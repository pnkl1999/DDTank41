using Bussiness;
using Game.Base.Packets;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Logic
{
    public interface IGamePlayer
    {
        bool IsViewer { get; set; }

        long AllWorldDameBoss { get; }

        bool CanUseProp { get; set; }

        bool CanX2Exp { get; set; }

        bool CanX3Exp { get; set; }

        List<int> EquipEffect { get; }

        List<BufferInfo> FightBuffs { get; }

        List<int> CardBuff { get; }

        int GamePlayerId { get; set; }

        ItemInfo Healstone { get; }

        ItemInfo MainWeapon { get; }

        UserMatchInfo MatchInfo { get; }

        UsersPetInfo Pet { get; }

        PlayerInfo PlayerCharacter { get; }

        string ProcessLabyrinthAward { get; set; }

        ItemInfo SecondWeapon { get; }

        int ServerID { get; set; }

        long WorldbossBood { get; }

        int ZoneId { get; }

        string ZoneName { get; }

        double GPAddPlus { get; set; }

        double OfferAddPlus { get; set; }

        double GPApprenticeOnline { get; set; }

        double GPApprenticeTeam { get; set; }

        double GPSpouseTeam { get; set; }

        bool IsAccountLimit { get; set; }

        int CurrentEnemyId { get; set; }

        int GameId { get; set; }

        int AddGold(int value);

        int AddGP(int gp);

        int AddGiftToken(int value);

        int AddMoney(int value);

        int AddMoney(int value, bool igroneAll);

        int AddOffer(int value);

        int AddRichesOffer(int value);

        int AddRobRiches(int value);

        bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count, eGameView gameView);

        bool ClearFightBag();

        void ClearFightBuffOneMatch();

        bool ClearTempBag();

        int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int count);

        void Disconnect();

        void UpdateRestCount();

        double GetBaseAttack();

        double GetBaseBlood();

        double GetBaseDefence();

        void LogAddMoney(AddMoneyType masterType, AddMoneyType sonType, int userId, int moneys, int SpareMoney);

        void OnGameOver(AbstractGame game, bool isWin, int gainGP, bool isSpanArea, bool IsCouple, int blood, int playerCount);

        void OnKillingBoss(AbstractGame game, NpcInfo npc, int damage);

        void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage);

        void OnMissionOver(AbstractGame game, bool isWin, int MissionID, int TurnNum);

        int RemoveGold(int value);

        int RemoveGP(int gp);

        int RemoveGiftToken(int value);

        bool RemoveHealstone();

        int RemoveMedal(int value);

        int RemoveMoney(int value);

        int RemoveOffer(int value);

        void SendConsortiaFight(int consortiaID, int riches, string msg);

        bool SetPvePermission(int missionId, eHardLevel hardLevel);

        bool IsPvePermission(int missionId, eHardLevel hardLevel);

        void SendHideMessage(string msg);

        void SendInsufficientMoney(int type);

        void SendMessage(string msg);

        void SendTCP(GSPacketIn pkg);

        void UpdateBarrier(int barrier, string pic);

        void UpdatePveResult(string type, int value, bool isWin);

        bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving);

        bool SetFightLabPermission(int copyId, eHardLevel hardLevel, int missionId);

        bool IsFightLabPermission(int missionId, eHardLevel hardLevel);

        void PVERewardNotice(string msg, int itemID, int templateID);

        void AddLog(string type, string content);

        bool UsePayBuff(BuffType type);

        void UpdateLabyrinth(int currentFloor, int m_missionInfoId, bool bigAward);

        void OutLabyrinth(bool isWin);

        int AddEliteScore(int value);

        int RemoveEliteScore(int value);

        void SendWinEliteChampion();

        void ResetRoom(bool isWin, string parram);

        void UpdatePublicPlayer(string tempStyle = "");

        int AddDamageScores(int value);

        int AddHonor(int value);

        void AddPrestige(bool isWin, eRoomType roomType);
    }
}
