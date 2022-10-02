package ddt.manager
{
   import baglocked.BagLockedController;
   import calendar.view.goodsExchange.SendGoodsExchangeInfo;
   import cardSystem.model.CardModel;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.socket.AcademyPackageType;
   import ddt.data.socket.ChurchPackageType;
   import ddt.data.socket.ConsortiaPackageType;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.EliteGamePackageType;
   import ddt.data.socket.FarmPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.HotSpringPackageType;
   import ddt.data.socket.IMPackageType;
   import ddt.data.socket.ePackageType;
   import ddt.utils.CrytoUtils;
   import email.manager.MailManager;
   import flash.utils.ByteArray;
   import inviteFriends.data.InviteFriendPackageType;
   import labyrinth.data.LabyrinthPackageType;
   import newChickenBox.model.NewChickenBoxPackageType;
   import newChickenBox.view.NewChickenBoxItem;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import road7th.math.randRange;
   import trainer.controller.WeakGuildManager;
   import lanternriddles.data.LanternriddlesPackageType;
   import chickActivation.ChickActivationType;
   import gemstone.info.GemstnoeSendInfo;
   import ddt.data.socket.FightSpiritPackageType;
   import AvatarCollection.AvatarCollectionPackageType;
   import lightRoad.data.LightRoadPackageType;
   import guildMemberWeek.data.GuildMemberWeekPackageType;
   import store.fineStore.data.FineStorePackageType;
   
   public class GameSocketOut
   {
      private var _socket:ByteSocket;
      
      public function GameSocketOut(param1:ByteSocket)
      {
         super();
         this._socket = param1;
      }
      
      public function sendLogin(param1:AccountInfo) : void
      {
         this._socket.resetKey();
         var _loc2_:Date = new Date();
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = randRange(100,10000);
         _loc3_.writeShort(_loc2_.fullYearUTC);
         _loc3_.writeByte(_loc2_.monthUTC + 1);
         _loc3_.writeByte(_loc2_.dateUTC);
         _loc3_.writeByte(_loc2_.hoursUTC);
         _loc3_.writeByte(_loc2_.minutesUTC);
         _loc3_.writeByte(_loc2_.secondsUTC);
         var _loc5_:Array = [Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255)];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc3_.writeByte(_loc5_[_loc6_]);
            _loc6_++;
         }
         _loc3_.writeUTFBytes(param1.Account + "," + param1.Password);
         _loc3_ = CrytoUtils.rsaEncry5(param1.Key,_loc3_);
         _loc3_.position = 0;
         var _loc7_:PackageOut = new PackageOut(ePackageType.LOGIN);
         _loc7_.writeInt(Version.Build);
         _loc7_.writeInt(DesktopManager.Instance.desktopType);
         _loc7_.writeBytes(_loc3_);
         this.sendPackage(_loc7_);
         this._socket.setKey(_loc5_);
      }
      
      public function sendWeeklyClick() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WEEKLY_CLICK_CNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendGameLogin(param1:int, param2:int, param3:int = -1, param4:String = "", param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc6_.writeInt(GameRoomPackageType.GAME_ROOM_LOGIN);
         _loc6_.writeBoolean(param5);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         if(param2 == -1)
         {
            _loc6_.writeInt(param3);
            _loc6_.writeUTF(param4);
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendSceneLogin(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGameStyle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDailyAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSignAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GET_SIGNAWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGoods(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array = null, param7:int = 0, param8:Array = null, param9:Array = null) : void
      {
         var _loc13_:Array = null;
         if(param1.length > 50)
         {
            if(param9 && param9.length > 50)
            {
               _loc13_ = param9.splice(0,50);
            }
            else
            {
               _loc13_ = param9;
            }
            this.sendBuyGoods(param1.splice(0,50),param2.splice(0,50),param3.splice(0,50),param4.splice(0,50),param5.splice(0,50),param6.splice(0,50),param7,param8,_loc13_);
            this.sendBuyGoods(param1,param2,param3,param4,param5,param6,param7,param8,param9);
            return;
         }
         var _loc10_:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
         var _loc11_:int = param1.length;
         _loc10_.writeInt(_loc11_);
         var _loc12_:uint = 0;
         while(_loc12_ < _loc11_)
         {
            _loc10_.writeInt(param1[_loc12_]);
            _loc10_.writeInt(param2[_loc12_]);
            _loc10_.writeUTF(param3[_loc12_]);
            _loc10_.writeBoolean(param5[_loc12_]);
            if(param6 == null)
            {
               _loc10_.writeUTF("");
            }
            else
            {
               _loc10_.writeUTF(param6[_loc12_]);
            }
            _loc10_.writeInt(param4[_loc12_]);
            _loc12_++;
         }
         _loc10_.writeInt(param7);
         this.sendPackage(_loc10_);
      }
      
      public function sendBuyProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSellProp(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuickBuyGoldBox(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGiftBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPresentGoods(param1:Array, param2:Array, param3:Array, param4:String, param5:String, param6:Array = null) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
         var _loc8_:int = param1.length;
         _loc7_.writeUTF(param4);
         _loc7_.writeUTF(param5);
         _loc7_.writeInt(_loc8_);
         var _loc9_:uint = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_.writeInt(param1[_loc9_]);
            _loc7_.writeInt(param2[_loc9_]);
            _loc7_.writeUTF(param3[_loc9_]);
            if(param6 == null)
            {
               _loc7_.writeUTF("");
            }
            else
            {
               _loc7_.writeUTF(param6[_loc9_]);
            }
            _loc9_++;
         }
         this.sendPackage(_loc7_);
      }
      
      public function sendGoodsContinue(param1:Array) : void
      {
         var _loc2_:int = param1.length;
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
         _loc3_.writeInt(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeByte(param1[_loc4_][0]);
            _loc3_.writeInt(param1[_loc4_][1]);
            _loc3_.writeInt(param1[_loc4_][2]);
            _loc3_.writeByte(param1[_loc4_][3]);
            _loc3_.writeBoolean(param1[_loc4_][4]);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendSellGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateGoodsCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendEmail(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
         _loc2_.writeUTF(param1.NickName);
         _loc2_.writeUTF(param1.Title);
         _loc2_.writeUTF(param1.Content);
         _loc2_.writeBoolean(param1.isPay);
         _loc2_.writeInt(param1.hours);
         _loc2_.writeInt(param1.SendedMoney);
         while(_loc3_ < MailManager.Instance.NUM_OF_WRITING_DIAMONDS)
         {
            if(param1["Annex" + _loc3_])
            {
               _loc2_.writeByte(param1["Annex" + _loc3_].split(",")[0]);
               _loc2_.writeInt(param1["Annex" + _loc3_].split(",")[1]);
            }
            else
            {
               _loc2_.writeByte(0);
               _loc2_.writeInt(-1);
            }
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateMail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDeleteMail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function untreadEmail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetMail(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPint() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PING);
         this.sendPackage(_loc1_);
      }
      
      public function sendSuicide(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.SUICIDE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendKillSelf(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.KILLSELF);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemCompose(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ITEM_COMPOSE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemTransfer(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemStrength(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemLianhua(param1:int, param2:int, param3:Array, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         var _loc9_:int = 0;
         while(_loc9_ < param3.length)
         {
            _loc8_.writeInt(param3[_loc9_]);
            _loc9_++;
         }
         _loc8_.writeInt(param4);
         _loc8_.writeInt(param5);
         _loc8_.writeInt(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendItemEmbed(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.ITEM_INLAY);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendItemEmbedBackout(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemOpenFiveSixHole(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.OPEN_FIVE_SIX_HOLE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemTrend(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendClearStoreBag() : void
      {
         PlayerManager.Instance.Self.StoreBag.items.clear();
         var _loc1_:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
         this.sendPackage(_loc1_);
      }
      
      public function sendCheckCode(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEquipRetrieve() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EQUIP_RECYCLE_ITEM);
         this.sendPackage(_loc1_);
      }
      
      public function sendItemFusion(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ITEM_FUSION);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.S_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBBugle(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.B_BUGLE);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(PlayerManager.Instance.Self.ID);
         _loc3_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc3_.writeUTF(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendCBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.C_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDefyAffiche(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGameMode(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAddFriend(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc5_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc5_.writeByte(IMPackageType.FRIEND_ADD);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendDelFriend(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFriendState(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBagLocked(param1:String, param2:int, param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "") : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
         BagLockedController.TEMP_PWD = param3 != "" ? param3 : param1;
         _loc8_.writeUTF(param1);
         _loc8_.writeUTF(param3);
         _loc8_.writeInt(param2);
         _loc8_.writeUTF(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeUTF(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendBagLockedII(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
      }
      
      public function sendConsortiaEquipConstrol(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendErrorMsg(param1:String) : void
      {
         var _loc2_:PackageOut = null;
         if(param1.length < 1000)
         {
            _loc2_ = new PackageOut(ePackageType.CLIENT_LOG);
            _loc2_.writeUTF(param1);
            this.sendPackage(_loc2_);
         }
      }
      
      public function sendItemOverDue(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHideLayer(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestAdd(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestRemove(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestFinish(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestCheck(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemOpenUp(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(param3);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemEquip(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
         if(!param2)
         {
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(param1);
         }
         else if(param2)
         {
            _loc3_.writeBoolean(false);
            _loc3_.writeUTF(param1);
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendMateTime(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MATE_ONLINE_TIME);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPlayerGift(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_GET_GIFTS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendActivePullDown(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVE_PULLDOWN);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function auctionGood(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
         _loc8_.writeByte(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeByte(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeInt(param5);
         _loc8_.writeInt(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function auctionCancelSell(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function auctionBid(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncStep(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         _loc3_.writeByte(1);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncWeakStep(param1:int) : void
      {
         WeakGuildManager.Instance.setStepFinish(param1);
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         _loc2_.writeByte(2);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCreateConsortia(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_CREATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryIn(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaCancelTryIn() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaInvate(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReleaseConsortiaTask(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TASK_RELEASE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaInvatePass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaInvateDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDescription(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdatePlacard(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDuty(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc4_.writeInt(param1);
         _loc4_.writeByte(param1 == -1 ? int(int(1)) : int(int(2)));
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendConsortiaUpgradeDuty(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsoritaApplyStatusOut(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_APPLY_STATE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RENEGADE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaMemberGrade(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaUserRemarkUpdate(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDutyDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinPass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendForbidSpeak(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDismiss() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_DISBAND);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaChangeChairman(param1:String = "") : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaRichOffer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDonate(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.DONATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaLevelUp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_LEVEL_UP);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAirPlane() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.AIRPLANE);
         this.sendPackage(_loc1_);
      }
      
      public function useDeputyWeapon() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
         this.sendPackage(_loc1_);
      }
      
      public function sendGamePick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPackage(param1:PackageOut) : void
      {
         this._socket.send(param1);
      }
      
      public function sendMoveGoods(param1:int, param2:int, param3:int, param4:int, param5:int = 1, param6:Boolean = false) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
         _loc7_.writeByte(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeByte(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeBoolean(param6);
         this.sendPackage(_loc7_);
      }
      
      public function reclaimGoods(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendMoveGoodsAll(param1:int, param2:Array, param3:int, param4:Boolean = false) : void
      {
         if(param2.length <= 0)
         {
            return;
         }
         var _loc5_:int = param2.length;
         var _loc6_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
         _loc6_.writeBoolean(param4);
         _loc6_.writeInt(_loc5_);
         _loc6_.writeInt(param1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_.writeInt(param2[_loc7_].Place);
            _loc6_.writeInt(_loc7_ + param3);
            _loc7_++;
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendForSwitch() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDCheck() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDInfo(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         _loc3_.writeBoolean(false);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColor(param1:int, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeInt(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendUseCard(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.CARD_USE);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3.length);
         var _loc7_:int = param3.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_.writeInt(param3[_loc8_]);
            _loc8_++;
         }
         _loc6_.writeInt(param4);
         _loc6_.writeBoolean(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendUseProp(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.PROP_USE);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3.length);
         var _loc7_:int = param3.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_.writeInt(param3[_loc8_]);
            _loc8_++;
         }
         _loc6_.writeInt(param4);
         _loc6_.writeBoolean(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendUseChangeColorShell(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_COLOR_SHELL);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColorShellTimeOver(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHANGE_COLOR_OVER_DUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRouletteBox(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendStartTurn() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LOTTERY_RANDOM_SELECT);
         this.sendPackage(_loc1_);
      }
      
      public function sendFinishRoulette() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
         this.sendPackage(_loc1_);
      }
      
      public function sendSellAll() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_SELL_ALL_GOODS);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenAll() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OPEN_ALL_CARDBOX);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenDead(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendRequestAwards(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CADDY_GET_AWARDS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQequestBadLuck() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_GET_BADLUCK);
         this.sendPackage(_loc1_);
      }
      
	  public function sendUseReworkName(param1:int, param2:int, param3:String) : void
	  {
		  var _loc4_:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
		  _loc4_.writeByte(param1);
		  _loc4_.writeInt(param2);
		  _loc4_.writeUTF(param3);
		  this.sendPackage(_loc4_);
	  }
      
	  public function sendUseConsortiaReworkName(param1:int, param2:int, param3:int, param4:String) : void
	  {
		  var _loc5_:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
		  _loc5_.writeInt(param1);
		  _loc5_.writeByte(param2);
		  _loc5_.writeInt(param3);
		  _loc5_.writeUTF(param4);
		  this.sendPackage(_loc5_);
	  }
      
      public function sendValidateMarry(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPropose(param1:int, param2:String, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendProposeRespose(param1:Boolean, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUnmarry(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendMarryRoomLogin() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
         this.sendPackage(_loc1_);
      }
      
      public function sendExitMarryRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         this.sendPackage(_loc1_);
      }
      
      public function sendCreateRoom(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:String) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
         _loc7_.writeUTF(param1);
         _loc7_.writeUTF(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(100);
         _loc7_.writeBoolean(param5);
         _loc7_.writeUTF(param6);
         this.sendPackage(_loc7_);
      }
      
      public function sendEnterRoom(param1:int, param2:String, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendExitRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendCurrentState(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateRoomList(param1:int, param2:int, param3:int = 10000, param4:int = 1011) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.ROOMLIST_UPDATE);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         if(param1 == 2 && param2 == -2)
         {
            _loc5_.writeInt(param3);
            _loc5_.writeInt(param4);
         }
         this.sendPackage(_loc5_);
      }
      
      public function sendChurchMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc4_.writeByte(ChurchPackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendStartWedding() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.HYMENEAL);
         this.sendPackage(_loc1_);
      }
      
      public function sendChurchContinuation(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.CONTINUATION);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchLargess(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.LARGESS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function refund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.CLIENTCONFIRM);
         this.sendPackage(_loc1_);
      }
      
      public function requestRefund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.BEGINSENDGIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendUseFire(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.USEFIRECRACKERS);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChurchKick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.KICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchMovieOver(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChurchForbid(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.FORBID);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.POSITION);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendModifyChurchDiscription(param1:String, param2:Boolean, param3:String, param4:String) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
         _loc5_.writeUTF(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeUTF(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendSceneChange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGunSalute(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.GUNSALUTE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRegisterInfo(param1:int, param2:Boolean, param3:String = null) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
         _loc4_.writeBoolean(param2);
         _loc4_.writeUTF(param3);
         _loc4_.writeInt(param1);
         this.sendPackage(_loc4_);
      }
      
      public function sendModifyInfo(param1:Boolean, param2:String = null) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRYINFO_UPDATE);
         _loc3_.writeBoolean(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendForMarryInfo(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetLinkGoodsInfo(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendGetTropToBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function createUserGuide(param1:int = 10) : void
      {
         var _loc2_:String = String(Math.random());
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc3_.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         _loc3_.writeByte(param1);
         _loc3_.writeByte(3);
         _loc3_.writeUTF("");
         _loc3_.writeUTF(_loc2_);
         this.sendPackage(_loc3_);
      }
      
      public function enterUserGuide(param1:int, param2:int = 10) : void
      {
         var _loc3_:String = String(Math.random());
         var _loc4_:int = PlayerManager.Instance.Self.Grade < 5 ? int(int(4)) : int(int(3));
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         _loc5_.writeInt(param1);
         _loc5_.writeByte(param2);
         _loc5_.writeUTF(_loc3_);
         _loc5_.writeUTF("");
         _loc5_.writeByte(_loc4_);
         _loc5_.writeByte(0);
         _loc5_.writeInt(0);
         _loc5_.writeBoolean(false);
         this.sendPackage(_loc5_);
      }
      
      public function userGuideStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_START);
         this.sendPackage(_loc1_);
      }
      
      public function sendSaveDB() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SAVE_DB);
         this.sendPackage(_loc1_);
      }
      
      public function createMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function deleteMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomCreate(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         _loc2_.writeInt(param1.maxCount);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEdit(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomQuickEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomEnterConfirm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEnter(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHotSpringRoomEnterView(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerRemove() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotAddTime() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD_B);
         pkg.writeByte(HotSpringPackageType.CONTINU_BY_MONEY);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomPlayerTargetPoint(param1:*) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.TARGET_POINT);
         var _loc3_:Array = param1.walkPath.concat();
         var _loc4_:Array = [];
         while(_loc5_ < _loc3_.length)
         {
            _loc4_.push(int(_loc3_[_loc5_].x),int(_loc3_[_loc5_].y));
            _loc5_++;
         }
         var _loc6_:String = _loc4_.toString();
         _loc2_.writeUTF(_loc6_);
         _loc2_.writeInt(param1.playerInfo.ID);
         _loc2_.writeInt(param1.currentWalkStartPoint.x);
         _loc2_.writeInt(param1.currentWalkStartPoint.y);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1.playerDirection);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomRenewalFee(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomAdminRemovePlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerContinue(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetTimeBox(param1:int, param2:int, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAchievementFinish(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReworkRank(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLookupEffort(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeginFightNpc() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
         this.sendPackage(_loc1_);
      }
      
      public function sendRequestUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.REQUEST_UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendQuestionReply(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUESTION_REPLY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenVip(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.VIP_RENEWAL);
         _loc3_.writeUTF(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyRegister(param1:int, param2:Boolean, param3:String = null, param4:Boolean = false) : void
      {
         var _loc5_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc5_.writeByte(AcademyPackageType.ACADEMY_REGISTER);
         _loc5_.writeInt(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAcademyRemoveRegister() : void
      {
         var _loc1_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc1_.writeByte(AcademyPackageType.ACADEMY_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendAcademyApprentice(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_APPRENTICE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMaster(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_MASTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMasterConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyApprenticeConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyFireMaster(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_MASTER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAcademyFireApprentice(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_APPRENTICE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUseLog(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USE_LOG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGift(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.USER_SEND_GIFTS);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendReloadGift() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.USER_RELOAD_GIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendSnsMsg(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SNS_MSG_RECEIVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function getPlayerCardInfo(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GET_PLAYER_CARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendMoveCards(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc3_.writeInt(0);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendOpenViceCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenCardBox(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc3_.writeInt(2);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendUpGradeCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(3);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCardReset(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         _loc2_.writeInt(0);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReplaceCardProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSortCards(param1:Vector.<int>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(4);
         var _loc3_:int = param1.length;
         _loc2_.writeInt(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc4_ + CardModel.EQUIP_CELLS_SUM;
            _loc2_.writeInt(_loc5_);
            _loc2_.writeInt(_loc6_);
            _loc4_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendFirstGetCards() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc1_.writeInt(5);
         this.sendPackage(_loc1_);
      }
      
      public function sendFace(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
         _loc2_.writeInt(param1);
         _loc2_.writeInt(0);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpition(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OPTION_UPDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionMail(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTION_MAIL);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortionPoll(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.POLL_CANDIDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionSkill(param1:Boolean, param2:int, param3:int, param4:int = 1) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc5_.writeInt(ConsortiaPackageType.SKILL_SOCKET);
         _loc5_.writeBoolean(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendOns() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc1_.writeByte(IMPackageType.ONS_EQUIP);
         this.sendPackage(_loc1_);
      }
      
      public function sendWithBrithday(param1:Vector.<FriendListPlayer>) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FRIEND_BRITHDAY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_].ID);
            _loc2_.writeUTF(param1[_loc3_].NickName);
            _loc2_.writeDate(param1[_loc3_].BirthdayDate);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendChangeDesignation(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_RANK);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDailyRecord() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DAILYRECORD);
         this.sendPackage(_loc1_);
      }
      
      public function sendCollectInfoValidate(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.COLLECTINFO);
         _loc3_.writeByte(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendGoodsExchange(param1:Vector.<SendGoodsExchangeInfo>, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GOODS_EXCHANGE);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.writeInt(param1[_loc4_].id);
            _loc3_.writeInt(param1[_loc4_].place);
            _loc3_.writeInt(param1[_loc4_].bagType);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendTexp(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.TEXP);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendCustomFriends(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ADD_CUSTOM_FRIENDS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendOneOnOneTalk(param1:int, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ONE_ON_ONE_TALK);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUserLuckyNum(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_LUCKYNUM);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendPicc(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PICC);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyBadge(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.BUY_BADGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetEliteGameState() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_TYPE);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetSelfRankSroce() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_PLAYER_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetPaarungDetail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc2_.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_DETAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEliteGameStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_START);
         this.sendPackage(_loc1_);
      }
      
      public function sendStartTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_SOCKET);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendEndTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_COMPLETTE);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendWishBeadEquip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.WISHBEADEQUIP);
         _loc7_.writeInt(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeInt(param6);
         this.sendPackage(_loc7_);
      }
      
      public function gotoCardLottery() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GOTO_CARD_LOTTERY);
         this.sendPackage(_loc1_);
      }
      
      public function sendCardLotteryIds(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_LOTTERY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendLuckLottery() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LUCK_LOTTERY);
         this.sendPackage(_loc1_);
      }
      
      public function enterInviteFriendView() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.INVITE_FRIEND);
         _loc1_.writeInt(InviteFriendPackageType.INVITE_FRIEND_OPENVIEW);
         this.sendPackage(_loc1_);
      }
      
      public function inviteFriendOkClick(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.INVITE_FRIEND);
         _loc2_.writeInt(InviteFriendPackageType.INVITE_FRIEND_FRIENDREWARD);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function inviteFriendRewardBntClick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.INVITE_FRIEND);
         _loc2_.writeInt(InviteFriendPackageType.INVITE_FRIEND_GETREWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function inviteFriendFBBntClick() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.INVITE_FRIEND);
         _loc1_.writeInt(InviteFriendPackageType.INVITE_FRIEND_FBCLICK);
         this.sendPackage(_loc1_);
      }
      
      public function sendEquipPetSkill(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.EQUIP_PET_SKILL);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendRefreshPet(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.REFRESH_PET);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAdoptPet(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.ADOPT_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetFollowOrCall(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.PET_FOLLOW);
         _loc3_.writeBoolean(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetWake(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.PET_WAKE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetFormInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PET);
         _loc1_.writeByte(CrazyTankPackageType.PET_FORMINFO);
         this.sendPackage(_loc1_);
      }
      
      public function delPetEquip(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.DEL_PET_EQUIP);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPaySkill(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.PAY_SKILL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function eatPetsHandler(param1:int, param2:int, param3:int, param4:Array) : void
      {
         var _loc6_:int = 0;
         var _loc5_:PackageOut = new PackageOut(ePackageType.PET);
         _loc5_.writeByte(CrazyTankPackageType.EAT_PETS);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         if(param2 == 1)
         {
            _loc5_.writeInt(param4.length);
            _loc6_ = 0;
            while(_loc6_ < param4.length)
            {
               _loc5_.writeInt(param4[_loc6_][0]);
               _loc5_.writeInt(param4[_loc6_][1].TemplateID);
               _loc6_++;
            }
         }
         else
         {
            _loc5_.writeInt(param3);
         }
         this.sendPackage(_loc5_);
      }
      
      public function sendPetFightUnFight(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.FIGHT_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetRisingStar(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.PET_RISINGSTAR);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendPetEvolution(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.PET_EVOLUTION);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetFeed(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.FEED_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendPetRename(param1:int, param2:String, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.RENAME_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendReleasePet(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.RELEASE_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendRevertPet(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.REVER_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemExalt() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ITEM_ADVANCE);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthCleanOutTimerComplete() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.CLEAN_OUT_COMPLETE);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthDouble(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc2_.writeInt(LabyrinthPackageType.DOUBLE_REWARD);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function labyrinthReset() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.RESET_LABYRINTH);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthTryAgain(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc3_.writeInt(LabyrinthPackageType.TRY_AGAIN);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function labyrinthRequestUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.REQUEST_UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthCleanOut() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.CLEAN_OUT);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthSpeededUpCleanOut(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc2_.writeInt(LabyrinthPackageType.SPEEDED_UP_CLEAN_OUT);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function labyrinthStopCleanOut() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.STOP_CLEAN_OUT);
         this.sendPackage(_loc1_);
      }
      
      public function addPetEquip(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.ADD_PET_EQUIP);
         _loc4_.writeInt(param3);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         this.sendPackage(_loc4_);
      }
      
      public function sendPetSkill(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.PET_SKILL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAddPet(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.ADD_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_SEX);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendNewTitleCard(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.NEWTITLE_CARD);
         _loc3_.writeByte(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function fastForwardGrop(param1:Boolean, param2:Boolean, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.FRAM_GROP_FASTFORWARD);
         _loc4_.writeBoolean(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendCompose(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.COMPOSE_FOOD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function seeding(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.GROW_FIELD);
         _loc3_.writeByte(13);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function enterFarm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.ENTER_FARM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function arrange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(135);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function doMature(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.ACCELERATE_FIELD);
         _loc4_.writeByte(13);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param3);
         _loc4_.writeInt(param2);
         this.sendPackage(_loc4_);
      }
      
      public function toGather(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.GAIN_FIELD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function toSpread(param1:Array, param2:int, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.PAY_FIELD);
         _loc4_.writeInt(param1.length);
         for each(_loc5_ in param1)
         {
            _loc4_.writeInt(_loc5_);
         }
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function toKillCrop(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.KILLCROP_FIELD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function toFarmHelper(param1:Array, param2:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         _loc3_.writeInt(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc3_.writeInt(_loc5_.currentfindIndex);
            _loc3_.writeInt(_loc5_.currentSeedText);
            _loc3_.writeInt(_loc5_.currentSeedNum);
            _loc3_.writeInt(_loc5_.currentFertilizerText);
            _loc3_.writeInt(_loc5_.autoFertilizerNum);
            _loc3_.writeBoolean(param2);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function toHelperRenewMoney(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.HELPER_PAY_FIELD);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function exitFarm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.EXIT_FARM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeginHelper(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         _loc2_.writeBoolean(param1[0]);
         if(param1[0])
         {
            _loc2_.writeInt(param1[1]);
            _loc2_.writeInt(param1[2]);
            _loc2_.writeInt(param1[3]);
            _loc2_.writeInt(param1[4]);
            _loc2_.writeInt(param1[5]);
            _loc2_.writeInt(param1[6]);
            _loc2_.writeBoolean(param1[7]);
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyPetExpItem(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(FarmPackageType.BUY_PET_EXP_ITEM);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function giftPacks(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.FARM_GIFTPACKS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAccumulativeLoginAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACCUMULATIVELOGIN_AWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChickenBoxUseEagleEye(param1:NewChickenBoxItem) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc2_.writeInt(NewChickenBoxPackageType.USEEAGLEEYE);
         _loc2_.writeInt(param1.position);
         this.sendPackage(_loc2_);
      }
      
      public function sendChickenBoxTakeOverCard(param1:NewChickenBoxItem) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc2_.writeInt(NewChickenBoxPackageType.TAKEOVERCARD);
         _loc2_.writeInt(param1.info.Position);
         this.sendPackage(_loc2_);
      }
      
      public function sendOverShowItems() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.AllITEMSHOW);
         this.sendPackage(_loc1_);
      }
      
      public function sendFlushNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.FLUSHCHICKENVIEW);
         this.sendPackage(_loc1_);
      }
      
      public function sendClickStartBntNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.CLICKSTARTBNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.ENTERCHICKENVIEW);
         this.sendPackage(_loc1_);
      }
      
      public function showHideTitleState(flag:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(279);
         _loc2_.writeBoolean(flag);
         this.sendPackage(_loc2_);
      }
	  
	  public function sendpkgCheckHack() : void
	  {
		  //ConsoleLog.write("send");
		  var pkg:PackageOut = new PackageOut(300);
		  pkg.writeInt(0);
		  this.sendPackage(pkg);
	  }
	  
	  //worldboss start
	  import worldboss.model.WorldBossGamePackageType;
	  import flash.geom.Point;
	  public function enterWorldBossRoom() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc1_.writeByte(WorldBossGamePackageType.ENTER_WORLDBOSSROOM);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendAddPlayer(param1:Point) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc2_.writeByte(WorldBossGamePackageType.ADDPLAYERS);
		  _loc2_.writeInt(param1.x);
		  _loc2_.writeInt(param1.y);
		  this.sendPackage(_loc2_);
	  }
	  
	  public function sendWorldBossRoomMove(param1:int, param2:int, param3:String) : void
	  {
		  var _loc4_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc4_.writeByte(WorldBossGamePackageType.MOVE);
		  _loc4_.writeInt(param1);
		  _loc4_.writeInt(param2);
		  _loc4_.writeUTF(param3);
		  this.sendPackage(_loc4_);
	  }
	  
	  public function sendWorldBossRoomStauts(param1:int) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc2_.writeByte(WorldBossGamePackageType.STAUTS);
		  _loc2_.writeByte(param1);
		  this.sendPackage(_loc2_);
	  }
	  
	  public function sendLeaveBossRoom() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc1_.writeByte(WorldBossGamePackageType.LEAVE_ROOM);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendBuyWorldBossBuff(param1:Array) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
		  _loc2_.writeByte(WorldBossGamePackageType.BUFF_BUY);
		  _loc2_.writeInt(param1.length);
		  var _loc3_:int = 0;
		  while(_loc3_ < param1.length)
		  {
			  _loc2_.writeInt(param1[_loc3_]);
			  _loc3_++;
		  }
		  this.sendPackage(_loc2_);
	  }
	  //worldboss end
	  
	  //Lanternriddles Begin
	  public function sendLanternRiddlesQuestion() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
		  _loc1_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_QUESTION);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendLanternRiddlesAnswer(param1:int, param2:int, param3:int) : void
	  {
		  var _loc4_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
		  _loc4_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_ANSWER);
		  _loc4_.writeInt(param1);
		  _loc4_.writeInt(param2);
		  _loc4_.writeInt(param3);
		  this.sendPackage(_loc4_);
	  }
	  
	  public function sendLanternRiddlesUseSkill(param1:int, param2:int, param3:int, param4:Boolean = true) : void
	  {
		  var _loc5_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
		  _loc5_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_SKILL);
		  _loc5_.writeInt(param1);
		  _loc5_.writeInt(param2);
		  _loc5_.writeInt(param3);
		  _loc5_.writeBoolean(false);
		  this.sendPackage(_loc5_);
	  }
	  
	  public function sendLanternRiddlesRankInfo() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
		  _loc1_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_RANKINFO);
		  this.sendPackage(_loc1_);
	  }
	  //Lanternriddles End
	  
	  //Code ga hanh
	  public function sendChickActivationQuery() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
		  _loc1_.writeInt(ChickActivationType.CHICKACTIVATION);
		  _loc1_.writeInt(ChickActivationType.CHICKACTIVATION_QUERY);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendChickActivationOpenKey(param1:String) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
		  _loc2_.writeInt(ChickActivationType.CHICKACTIVATION);
		  _loc2_.writeInt(ChickActivationType.CHICKACTIVATION_OPENKEY);
		  _loc2_.writeUTF(param1);
		  this.sendPackage(_loc2_);
	  }
	  
	  public function sendChickActivationGetAward(param1:int, param2:int) : void
	  {
		  var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
		  _loc3_.writeInt(ChickActivationType.CHICKACTIVATION);
		  _loc3_.writeInt(ChickActivationType.CHICKACTIVATION_GETAWARD);
		  _loc3_.writeInt(param1);
		  _loc3_.writeInt(param2);
		  this.sendPackage(_loc3_);
	  }
	  //
	  //Ngoi sao may man
	  public function sendLuckyStarEnter() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
		  _loc1_.writeInt(NewChickenBoxPackageType.ENTER_GAME);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendLuckyStarClose() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
		  _loc1_.writeInt(NewChickenBoxPackageType.CLOSE_GAME);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendLuckyStarTurn() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
		  _loc1_.writeInt(NewChickenBoxPackageType.START_TURN);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendLuckyStarTurnComplete() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
		  _loc1_.writeInt(NewChickenBoxPackageType.TURN_COMPLETE);
		  this.sendPackage(_loc1_);
	  }
	  //
	  //LatentEnergy
	  public function sendLatentEnergy(param1:int, param2:int, param3:int, param4:int = -1, param5:int = -1) : void
	  {
		  var _loc6_:PackageOut = new PackageOut(ePackageType.LATENT_ENERGY);
		  _loc6_.writeByte(param1);
		  _loc6_.writeInt(param2);
		  _loc6_.writeInt(param3);
		  if(param1 == 1)
		  {
			  _loc6_.writeInt(param4);
			  _loc6_.writeInt(param5);
		  }
		  this.sendPackage(_loc6_);
	  }
	  //
	  //GemStone	  
	  public function fightSpiritRequest() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
		  _loc1_.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_INIT);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function figSpiritUpGrade(param1:GemstnoeSendInfo) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
		  _loc2_.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_LEVELUP);
		  _loc2_.writeInt(param1.autoBuyId);
		  _loc2_.writeInt(param1.goodsId);
		  _loc2_.writeInt(param1.type);
		  _loc2_.writeInt(param1.templeteId);
		  _loc2_.writeInt(param1.fightSpiritId);
		  _loc2_.writeInt(param1.equipPlayce);
		  _loc2_.writeInt(param1.place);
		  _loc2_.writeInt(param1.pointXY);
		  this.sendPackage(_loc2_);
	  }
	  //
	  
	  //Avatar
	  public function sendAvatarCollectionActive(param1:int, param2:int, param3:int) : void
	  {
		  var loc4:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
		  loc4.writeByte(AvatarCollectionPackageType.ACTIVE);
		  loc4.writeInt(param1);
		  loc4.writeInt(param2);
		  loc4.writeInt(param3);
		  this.sendPackage(loc4);
	  }
	  
	  public function sendAvatarCollectionDelayTime(param1:int, param2:int) : void
	  {
		  var loc3:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
		  loc3.writeByte(AvatarCollectionPackageType.DELAY_TIME);
		  loc3.writeInt(param1);
		  loc3.writeInt(param2);
		  this.sendPackage(loc3);
	  }
	  //
	  
	  public function sendLightRoadStarEnter() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
		  _loc1_.writeByte(LightRoadPackageType.ENTER_GAME);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function lightRoadPointWork(param1:int) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
		  _loc2_.writeByte(LightRoadPackageType.BECHOOSE_POINT);
		  _loc2_.writeInt(param1);
		  this.sendPackage(_loc2_);
	  }
	  
	  public function sendGuildMemberWeekAddRanking(param1:Array) : void
	  {
		  var _loc2_:int = param1.length;
		  var _loc3_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
		  _loc3_.writeByte(GuildMemberWeekPackageType.SEND_ADDRUNKING);
		  _loc3_.writeInt(_loc2_);
		  var _loc4_:uint = 0;
		  while(_loc4_ < _loc2_)
		  {
			  _loc3_.writeInt(param1[_loc4_]);
			  _loc4_++;
		  }
		  this.sendPackage(_loc3_);
	  }
	  
	  public function sendGuildMemberWeekStarEnter() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
		  _loc1_.writeByte(GuildMemberWeekPackageType.ENTER_GAME);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendGuildMemberWeekStarClose() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
		  _loc1_.writeByte(GuildMemberWeekPackageType.CLOSE);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendHonorUp(param1:int, param2:Boolean) : void
	  {
		  var _loc3_:PackageOut = new PackageOut(ePackageType.HONOR_UP_COUNT);
		  _loc3_.writeByte(param1);
		  _loc3_.writeBoolean(param2);
		  this.sendPackage(_loc3_);
	  }
	  
	  public function sendOpenOneTotem(param1:Boolean, param2:Boolean) : void
	  {
		  var _loc3_:PackageOut = new PackageOut(ePackageType.TOTEM);
		  _loc3_.writeBoolean(param1);
		  _loc3_.writeBoolean(param2);
		  this.sendPackage(_loc3_);
	  }
	  
	  public function necklaceStrength(param1:int, param2:int, param3:int = 2) : void
	  {
		  var _loc4_:PackageOut = new PackageOut(ePackageType.NECKLACE_STRENGTH);
		  _loc4_.writeByte(param3);
		  _loc4_.writeInt(param2);
		  _loc4_.writeInt(param1);
		  this.sendPackage(_loc4_);
	  }
	  
	  public function sendEquipGhost() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.EQUIP_GHOST);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendForgeSuit(param1:int) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.STORE_FINE_SUIT);
		  _loc2_.writeByte(FineStorePackageType.FORGE_SUIT);
		  _loc2_.writeInt(param1);
		  this.sendPackage(_loc2_);
	  }
   }
}
