using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameUtils;
using Game.Server.Packets;
using Game.Server.Quests;
using Game.Server.Rooms;
using Game.Server.SceneMarryRooms;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.GameObjects
{
    internal class RobotGamePlayer : GamePlayer
    {
        public class NullOut : IPacketLib
        {
            public void SendLeftRouleteResult(UsersExtraInfo info)
            {
                Nothing();
            }

            public void SendLeftRouleteOpen(UsersExtraInfo info)
            {
                Nothing();
            }

            public void SendAcademyGradute(GamePlayer app, int type)
            {
                Nothing();
            }

            public GSPacketIn SendAcademyAppState(PlayerInfo player, int removeUserId)
            {
                return null;
            }

            public GSPacketIn SendAcademySystemNotice(string text, bool isAlert)
            {
                return null;
            }

            //        public GSPacketIn SendConsortiaTaskInfo(BaseConsortiaTask baseTask)
            //        {
            //return null;
            //        }

            public GSPacketIn SendSystemConsortiaChat(string content, bool sendToSelf)
            {
                return null;
            }

            public void SendShopGoodsCountUpdate(List<ShopFreeCountInfo> list)
            {
                Nothing();
            }

            public void SendEliteGameStartRoom()
            {
                Nothing();
            }

            public GSPacketIn SendLabyrinthUpdataInfo(int ID, UserLabyrinthInfo laby)
            {
                return null;
            }

            public GSPacketIn SendPetInfo(int id, int zoneId, UsersPetInfo[] pets, EatPetsInfo eatpet)
            {
                return null;
            }

            public GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots)
            {
                return null;
            }

            public GSPacketIn sendBuyBadge(int consortiaID, int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
            {
                return null;
            }

            public void SendEdictumVersion()
            {
                Nothing();
            }

            public void SendEnthrallLight()
            {
                Nothing();
            }

            public void SendUpdateFirstRecharge(bool isRecharge, bool isGetAward)
            {
                Nothing();
            }

            public void SendOpenNoviceActive(int channel, int activeId, int condition, int awardGot, DateTime startTime, DateTime endTime)
            {
                Nothing();
            }

            public GSPacketIn SendOpenTimeBox(int condtion, bool isSuccess)
            {
                return null;
            }

            public void SendUpdateCardData(PlayerInfo player, List<UsersCardInfo> userCard)
            {
                Nothing();
            }

            public GSPacketIn SendAddFriend(PlayerInfo user, int relation, bool state)
            {
                return null;
            }

            public GSPacketIn SendFriendRemove(int FriendID)
            {
                return null;
            }

            public GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel)
            {
                return null;
            }

            public GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
            {
                return null;
            }

            public GSPacketIn SendConsortiaMail(bool result, int playerid)
            {
                return null;
            }

            public GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid)
            {
                return null;
            }

            public GSPacketIn SendUpdateConsotiaBoss(ConsortiaBossInfo bossInfo)
            {
                return null;
            }

            public GSPacketIn SendHotSpringUpdateTime(GamePlayer player, int expAdd)
            {
                return null;
            }

            public GSPacketIn SendPlayerDrill(int ID, Dictionary<int, UserDrillInfo> drills)
            {
                return null;
            }

            public void SendTCP(GSPacketIn packet)
            {
                Nothing();
            }

            public GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid)
            {
                return null;
            }

            public GSPacketIn SendUpdateConsotiaBuffer(GamePlayer player, Dictionary<string, BufferInfo> bufflist)
            {
                return null;
            }

            public void SendLoginSuccess()
            {
                Nothing();
            }

            public void SendLoginSuccess2()
            {
                Nothing();
            }

            public void SendCheckCode()
            {
                Nothing();
            }

            public void SendLoginFailed(string msg)
            {
                Nothing();
            }

            public void SendKitoff(string msg)
            {
                Nothing();
            }

            public void SendEditionError(string msg)
            {
                Nothing();
            }

            public void SendWeaklessGuildProgress(PlayerInfo player)
            {
                Nothing();
            }

            public GSPacketIn SendUpdateAchievementData(List<AchievementDataInfo> infos)
            {
                return null;
            }

            public GSPacketIn SendAchievementSuccess(AchievementDataInfo d)
            {
                return null;
            }

            public GSPacketIn SendUpdateAchievements(List<UsersRecordInfo> infos)
            {
                return null;
            }

            public GSPacketIn SendInitAchievements(List<UsersRecordInfo> infos)
            {
                return null;
            }

            public GSPacketIn SendUpdateAchievements(UsersRecordInfo info)
            {
                return null;
            }

            public GSPacketIn SendGameRoomSetupChange(BaseRoom room)
            {
                return null;
            }

            public void SendDateTime()
            {
                Nothing();
            }

            public GSPacketIn SendDailyAward(GamePlayer player)
            {
                return null;
            }

            public void SendPingTime(GamePlayer player)
            {
                Nothing();
            }

            public void SendUpdatePrivateInfo(PlayerInfo info, int medal)
            {
                Nothing();
            }

            public GSPacketIn SendUpdatePublicPlayer(PlayerInfo info, UserMatchInfo matchInfo, UsersExtraInfo extraInfo)
            {
                return null;
            }

            public GSPacketIn SendNetWork(int id, long delay)
            {
                return null;
            }

            public GSPacketIn SendUserEquip(PlayerInfo player, List<ItemInfo> items, List<UserGemStone> UserGemStone)
            {
                return null;
            }

            public GSPacketIn SendMessage(eMessageType type, string message)
            {
                return null;
            }

            public void SendWaitingRoom(bool result)
            {
                Nothing();
            }

            public GSPacketIn SendUpdateRoomList(List<BaseRoom> room)
            {
                return null;
            }

            public GSPacketIn SendSceneAddPlayer(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendSceneRemovePlayer(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendRoomCreate(BaseRoom room)
            {
                return null;
            }

            public GSPacketIn SendRoomLoginResult(bool result)
            {
                return null;
            }

            public GSPacketIn SendRoomPlayerAdd(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendRoomPlayerRemove(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendRoomUpdatePlayerStates(byte[] states)
            {
                return null;
            }

            public GSPacketIn SendRoomUpdatePlacesStates(int[] states)
            {
                return null;
            }

            public GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendRoomPairUpStart(BaseRoom room)
            {
                return null;
            }

            public GSPacketIn SendRoomPairUpCancel(BaseRoom room)
            {
                return null;
            }

            public GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style)
            {
                return null;
            }

            public GSPacketIn SendRoomChange(BaseRoom room)
            {
                return null;
            }

            public GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isBind, int MinValid)
            {
                return null;
            }

            public GSPacketIn SendFusionResult(GamePlayer player, bool result)
            {
                return null;
            }

            public GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind, ItemInfo item)
            {
                return null;
            }

            public void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots)
            {
                Nothing();
            }

            public void SendUpdateCardData(CardInventory bag, int[] updatedSlots)
            {
                Nothing();
            }

            public GSPacketIn SendUpdateBuffer(GamePlayer player, AbstractBuffer[] infos)
            {
                return null;
            }

            public GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos)
            {
                return null;
            }

            public GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] quests)
            {
                return null;
            }

            public GSPacketIn SendMailResponse(int playerID, eMailRespose type)
            {
                return null;
            }

            public GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item)
            {
                return null;
            }

            public GSPacketIn SendIDNumberCheck(bool result)
            {
                return null;
            }

            public GSPacketIn SendAASState(bool result)
            {
                return null;
            }

            public GSPacketIn SendAASInfoSet(bool result)
            {
                return null;
            }

            public GSPacketIn SendAASControl(bool result, bool bool_0, bool IsMinor)
            {
                return null;
            }

            public GSPacketIn SendGameRoomInfo(GamePlayer player, BaseRoom game)
            {
                return null;
            }

            public GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist)
            {
                return null;
            }

            public GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room)
            {
                return null;
            }

            public GSPacketIn SendPlayerEnterMarryRoom(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried)
            {
                return null;
            }

            public GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation, int ID)
            {
                return null;
            }

            public GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer)
            {
                return null;
            }

            public GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant, int ID)
            {
                return null;
            }

            public GSPacketIn SendBigSpeakerMsg(GamePlayer player, string msg)
            {
                return null;
            }

            public GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result)
            {
                return null;
            }

            public GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info)
            {
                return null;
            }

            public GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info)
            {
                return null;
            }

            public GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info)
            {
                return null;
            }

            public GSPacketIn SendMarryProp(GamePlayer player, MarryProp info)
            {
                return null;
            }

            public GSPacketIn SendRoomType(GamePlayer player, BaseRoom game)
            {
                return null;
            }

            public void SendUserLuckyNum()
            {
                Nothing();
            }

            public GSPacketIn SendUpdatePlayerProperty(PlayerInfo info, PlayerProperty PlayerProp)
            {
                return null;
            }

            public GSPacketIn SendOpenVIP(GamePlayer Player)
            {
                return null;
            }

            public GSPacketIn SendUserRanks(int Id, List<UserRankInfo> ranks)
            {
                return null;
            }

            public GSPacketIn SendEnterHotSpringRoom(GamePlayer player)
            {
                return null;
            }

            public GSPacketIn SendGetUserGift(PlayerInfo player, UserGiftInfo[] allGifts)
            {
                return null;
            }

            public GSPacketIn SendEatPetsInfo(EatPetsInfo info)
            {
                return null;
            }

            public GSPacketIn SendRefreshPet(GamePlayer player, UsersPetInfo[] pets, ItemInfo[] items, bool refreshBtn)
            {
                return null;
            }

            public void SendLeagueNotice(int id, int restCount, int maxCount, byte type)
            {
                Nothing();
            }

            public GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields)
            {
                return null;
            }

            public GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field)
            {
                return null;
            }

            public GSPacketIn SenddoMature(PlayerFarm farm)
            {
                return null;
            }

            public GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field)
            {
                return null;
            }

            public GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field)
            {
                return null;
            }

            public GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm)
            {
                return null;
            }

            public GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds)
            {
                return null;
            }

            public GSPacketIn SendChickenBoxOpen(int ID, int flushPrice, int[] openCardPrice, int[] eagleEyePrice)
            {
                return null;
            }

            public GSPacketIn SendLuckStarOpen(int ID)
            {
                return null;
            }

            public GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems)
            {
                return null;
            }

            public GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir)
            {
                return null;
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

            private void Nothing()
            {
            }

            public void SendOpenWorldBoss(int pX, int pY)
            {
                //throw new NotImplementedException();
            }
        }

        public static IPacketLib NULLOUT = new NullOut();

        public override IPacketLib Out => NULLOUT;

        public override bool IsActive => true;

        public RobotGamePlayer(int playerId, PlayerInfo info)
            : base(playerId, "", null, info)
        {
        }

        public void Equip(int equipid, int strength, int compose)
        {
            ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(equipid), 1, 0);
            if (itemInfo.Template.CategoryID == 1 || itemInfo.Template.CategoryID == 5 || itemInfo.Template.CategoryID == 7 || itemInfo.Template.CategoryID == 17)
            {
                itemInfo.StrengthenLevel = strength;
            }
            else
            {
                itemInfo.StrengthenLevel = 0;
            }
            itemInfo.AgilityCompose = compose;
            itemInfo.AttackCompose = compose;
            itemInfo.DefendCompose = compose;
            itemInfo.LuckCompose = compose;
            base.EquipBag.AddItem(itemInfo, base.EquipBag.FindItemEpuipSlot(itemInfo.Template));
        }

        public override void SendTCP(GSPacketIn pkg)
        {
        }

        public override bool LoadFromDatabase()
        {
            return true;
        }

        public override bool SaveIntoDatabase()
        {
            return true;
        }

        public override void Disconnect()
        {
        }
    }
}
