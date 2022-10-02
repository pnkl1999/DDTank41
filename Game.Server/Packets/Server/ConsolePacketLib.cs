using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameUtils;
using Game.Server.Quests;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Server
{
    public class ConsolePacketLib : IPacketLib
    {
        public void SendLeftRouleteResult(UsersExtraInfo info)
        {
			throw new NotImplementedException();
        }

        public void SendLeftRouleteOpen(UsersExtraInfo info)
        {
			throw new NotImplementedException();
        }

        public void SendAcademyGradute(GamePlayer app, int type)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAcademyAppState(PlayerInfo player, int removeUserId)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAcademySystemNotice(string text, bool isAlert)
        {
			throw new NotImplementedException();
        }

   //     public GSPacketIn SendConsortiaTaskInfo(BaseConsortiaTask baseTask)
   //     {
			//throw new NotImplementedException();
   //     }

        public GSPacketIn SendSystemConsortiaChat(string content, bool sendToSelf)
        {
			throw new NotImplementedException();
        }

        public void SendShopGoodsCountUpdate(List<ShopFreeCountInfo> list)
        {
			throw new NotImplementedException();
        }

        public void SendEliteGameStartRoom()
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendLabyrinthUpdataInfo(int ID, UserLabyrinthInfo laby)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPetInfo(int id, int zoneId, UsersPetInfo[] pets, EatPetsInfo eatpet)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn sendBuyBadge(int consortiaID, int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
        {
			throw new NotImplementedException();
        }

        public void SendEdictumVersion()
        {
			throw new NotImplementedException();
        }

        public void SendEnthrallLight()
        {
			throw new NotImplementedException();
        }

        public void SendUpdateFirstRecharge(bool isRecharge, bool isGetAward)
        {
			throw new NotImplementedException();
        }

        public void SendOpenNoviceActive(int channel, int activeId, int condition, int awardGot, DateTime startTime, DateTime endTime)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendOpenTimeBox(int condtion, bool isSuccess)
        {
			throw new NotImplementedException();
        }

        public void SendUpdateCardData(PlayerInfo player, List<UsersCardInfo> userCard)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMessage(eMessageType type, string message)
        {
			//Console.WriteLine(message);
			return null;
        }

        public GSPacketIn SendAddFriend(PlayerInfo user, int relation, bool state)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendFriendRemove(int FriendID)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendConsortiaMail(bool result, int playerid)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateConsotiaBoss(ConsortiaBossInfo bossInfo)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateConsotiaBuffer(GamePlayer player, Dictionary<string, BufferInfo> bufflist)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerDrill(int ID, Dictionary<int, UserDrillInfo> drills)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendGameRoomSetupChange(BaseRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateAchievementData(List<AchievementDataInfo> infos)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAchievementSuccess(AchievementDataInfo d)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateAchievements(List<UsersRecordInfo> infos)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendInitAchievements(List<UsersRecordInfo> infos)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateAchievements(UsersRecordInfo info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendHotSpringUpdateTime(GamePlayer player, int expAdd)
        {
			throw new NotImplementedException();
        }

        public void SendTCP(GSPacketIn packet)
        {
			throw new NotImplementedException();
        }

        public void SendLoginSuccess()
        {
			throw new NotImplementedException();
        }

        public void SendLoginSuccess2()
        {
			throw new NotImplementedException();
        }

        public void SendCheckCode()
        {
			throw new NotImplementedException();
        }

        public void SendLoginFailed(string msg)
        {
			throw new NotImplementedException();
        }

        public void SendKitoff(string msg)
        {
			throw new NotImplementedException();
        }

        public void SendEditionError(string msg)
        {
			throw new NotImplementedException();
        }

        public void SendDateTime()
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendDailyAward(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public void SendPingTime(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public void SendUpdatePrivateInfo(PlayerInfo info, int medal)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdatePublicPlayer(PlayerInfo info, UserMatchInfo matchInfo, UsersExtraInfo extraInfo)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendNetWork(int id, long delay)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUserEquip(PlayerInfo player, List<ItemInfo> items, List<UserGemStone> UserGemStone)
        {
			throw new NotImplementedException();
        }

        public void SendWaitingRoom(bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateRoomList(List<BaseRoom> room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendSceneAddPlayer(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendSceneRemovePlayer(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomCreate(BaseRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomLoginResult(bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomPlayerAdd(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomPlayerRemove(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomUpdatePlayerStates(byte[] states)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomUpdatePlacesStates(int[] states)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomPairUpStart(BaseRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomPairUpCancel(BaseRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomChange(BaseRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isBind, int MinValid)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendFusionResult(GamePlayer player, bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind, ItemInfo item)
        {
			throw new NotImplementedException();
        }

        public void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots)
        {
			throw new NotImplementedException();
        }

        public void SendUpdateCardData(CardInventory bag, int[] updatedSlots)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateBuffer(GamePlayer player, AbstractBuffer[] infos)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] quests)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMailResponse(int playerID, eMailRespose type)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendIDNumberCheck(bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAASState(bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAASInfoSet(bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendAASControl(bool result, bool bool_0, bool IsMinor)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendGameRoomInfo(GamePlayer player, BaseRoom game)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerEnterMarryRoom(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation, int ID)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant, int ID)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendBigSpeakerMsg(GamePlayer player, string msg)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendMarryProp(GamePlayer player, MarryProp info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRoomType(GamePlayer player, BaseRoom game)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendInsufficientMoney(GamePlayer player, int type)
        {
			throw new NotImplementedException();
        }

        public void SendWeaklessGuildProgress(PlayerInfo player)
        {
			throw new NotImplementedException();
        }

        public void SendUserLuckyNum()
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUpdatePlayerProperty(PlayerInfo info, PlayerProperty PlayerProp)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendOpenVIP(GamePlayer Player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendUserRanks(int Id, List<UserRankInfo> ranks)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendEnterHotSpringRoom(GamePlayer player)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendGetUserGift(PlayerInfo player, UserGiftInfo[] allGifts)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendEatPetsInfo(EatPetsInfo info)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendRefreshPet(GamePlayer player, UsersPetInfo[] pets, ItemInfo[] items, bool refreshBtn)
        {
			throw new NotImplementedException();
        }

        public void SendLeagueNotice(int id, int restCount, int maxCount, byte type)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SenddoMature(PlayerFarm farm)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm)
        {
			throw new NotImplementedException();
        }

        public GSPacketIn SendChickenBoxOpen(int ID, int flushPrice, int[] openCardPrice, int[] eagleEyePrice)
        {
			throw new NotImplementedException();
        }

        public void SendOpenWorldBoss(int pX, int pY)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendLuckStarOpen(int ID)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendAvatarCollect(PlayerAvatarCollection avtCollect)
        {
            throw new NotImplementedException();
        }

        public void SendGuildMemberWeekOpenClose(UsersExtraInfo info)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendPlayerRefreshTotem(PlayerInfo player)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendUpdateUpCount(PlayerInfo player)
        {
            throw new NotImplementedException();
        }

        public GSPacketIn SendNecklaceStrength(PlayerInfo player)
        {
            throw new NotImplementedException();
        }
    }
}
