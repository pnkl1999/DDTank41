package ddt.manager
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BagLockedController;
   import calendar.CalendarManager;
   import cardSystem.data.CardInfo;
   import cityWide.CityWideEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.ConsortionModelControl;
   import ddt.data.AccountInfo;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.CMFriendInfo;
   import ddt.data.CheckCodeData;
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.club.ClubInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerPropertyType;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.view.CheckCodeFrame;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import game.GameManager;
   import giftSystem.GiftController;
   import giftSystem.data.MyGiftCellInfo;
   import im.AddCommunityFriend;
   import im.IMController;
   import im.IMEvent;
   import im.info.CustomInfo;
   import pet.date.PetEquipData;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import petsBag.controller.PetBagController;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.BitmapReader;
   import roomList.PassInputFrame;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstListInfo;
   
   public class PlayerManager extends EventDispatcher
   {
      
      public static const FRIEND_STATE_CHANGED:String = "friendStateChanged";
      
      public static const FRIENDLIST_COMPLETE:String = "friendListComplete";
      
      public static const RECENT_CONTAST_COMPLETE:String = "recentContactsComplete";
      
      public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
      
      public static const VIP_STATE_CHANGE:String = "VIPStateChange";
      
      public static const GIFT_INFO_CHANGE:String = "giftInfoChange";
      
      public static const SELF_GIFT_INFO_CHANGE:String = "selfGiftInfoChange";
      
      public static const NEW_GIFT_UPDATE:String = "newGiftUPDATE";
      
      public static const NEW_GIFT_ADD:String = "newGiftAdd";
      
      public static const FARM_BAG_UPDATE:String = "farmDataUpdate";
      
      public static var isShowPHP:Boolean = false;
      
      public static const CUSTOM_MAX:int = 10;
      
      private static var _instance:PlayerManager;
      
      public static var SelfStudyEnergy:Boolean = true;
       
      
      private var _recentContacts:DictionaryData;
      
      public var customList:Vector.<CustomInfo>;
      
      private var _friendList:DictionaryData;
      
      private var _cmFriendList:DictionaryData;
      
      private var _blackList:DictionaryData;
      
      private var _clubPlays:DictionaryData;
      
      private var _tempList:DictionaryData;
      
      private var _mailTempList:DictionaryData;
      
      private var _myAcademyPlayers:DictionaryData;
      
      private var _sameCityList:Array;
      
      private var _self:SelfInfo;
      
      public var SelfConsortia:ClubInfo;
      
      private var _account:AccountInfo;
      
      private var tempStyle:Array;
      
      private var changedStyle:DictionaryData;
	  
	  public var gemstoneInfoList:Vector.<GemstonInitInfo>;
      
      public function PlayerManager()
      {
         this.SelfConsortia = new ClubInfo();
         this.tempStyle = [];
         this.changedStyle = new DictionaryData();
         super();
         this._self = new SelfInfo();
         this._clubPlays = new DictionaryData();
         this._tempList = new DictionaryData();
         this._mailTempList = new DictionaryData();
      }
      
      public static function get Instance() : PlayerManager
      {
         if(_instance == null)
         {
            _instance = new PlayerManager();
         }
         return _instance;
      }
	  
	  private function rezArr(param1:String) : Array
	  {
		  var _loc2_:Array = param1.split("|");
		  return _loc2_;
	  }
	  
      public static function readLuckyPropertyName(param1:int) : String
      {
         switch(param1)
         {
            case PlayerPropertyType.Exp:
               return LanguageMgr.GetTranslation("exp");
            case PlayerPropertyType.Offer:
               return LanguageMgr.GetTranslation("offer");
            case PlayerPropertyType.Attack:
               return LanguageMgr.GetTranslation("attack");
            case PlayerPropertyType.Agility:
               return LanguageMgr.GetTranslation("agility");
            case PlayerPropertyType.Damage:
               return LanguageMgr.GetTranslation("damage");
            case PlayerPropertyType.Defence:
               return LanguageMgr.GetTranslation("defence");
            case PlayerPropertyType.Luck:
               return LanguageMgr.GetTranslation("luck");
            case PlayerPropertyType.MaxHp:
               return LanguageMgr.GetTranslation("MaxHp");
            case PlayerPropertyType.Recovery:
               return LanguageMgr.GetTranslation("recovery");
            default:
               return "";
         }
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function setup(param1:AccountInfo) : void
      {
         this._account = param1;
         this.customList = new Vector.<CustomInfo>();
         this._friendList = new DictionaryData();
         this._blackList = new DictionaryData();
         this.initEvents();
      }
      
      public function get Account() : AccountInfo
      {
         return this._account;
      }
      
      public function getDressEquipPlace(param1:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(EquipType.isWeddingRing(param1) && this.Self.Bag.getItemAt(16) == null)
         {
            return 16;
         }
         var _loc2_:Array = EquipType.CategeryIdToPlace(param1.CategoryID);
         if(_loc2_.length == 1)
         {
            _loc3_ = _loc2_[0];
         }
         else
         {
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(PlayerManager.Instance.Self.Bag.getItemAt(_loc2_[_loc5_]) == null)
               {
                  _loc3_ = _loc2_[_loc5_];
                  break;
               }
               _loc4_++;
               if(_loc4_ == _loc2_.length)
               {
                  _loc3_ = _loc2_[0];
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      private function __updateInventorySlot(param1:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var slot:int = 0;
         var isUpdate:Boolean = false;
         var item:InventoryItemInfo = null;
         var evt:CrazyTankSocketEvent = param1;
         var pkg:PackageIn = evt.pkg as PackageIn;
         var bagType:int = pkg.readInt();
         var len:int = pkg.readInt();
         var bag:BagInfo = this._self.getBag(bagType);
         bag.beginChanges();
         try
         {
            i = 0;
            while(i < len)
            {
               slot = pkg.readInt();
               isUpdate = pkg.readBoolean();
               if(isUpdate)
               {
                  item = bag.getItemAt(slot);
                  if(item == null)
                  {
                     item = new InventoryItemInfo();
                     item.Place = slot;
                  }
                  item.UserID = pkg.readInt();
                  item.ItemID = pkg.readInt();
                  item.Count = pkg.readInt();
                  item.Place = pkg.readInt();
                  item.TemplateID = pkg.readInt();
                  item.AttackCompose = pkg.readInt();
                  item.DefendCompose = pkg.readInt();
                  item.AgilityCompose = pkg.readInt();
                  item.LuckCompose = pkg.readInt();
                  item.StrengthenLevel = pkg.readInt();
                  item.StrengthenExp = pkg.readInt();
                  item.IsBinds = pkg.readBoolean();
                  item.IsJudge = pkg.readBoolean();
                  item.BeginDate = pkg.readDateString();
                  item.ValidDate = pkg.readInt();
                  item.Color = pkg.readUTF();
                  item.Skin = pkg.readUTF();
                  item.IsUsed = pkg.readBoolean();
                  item.Hole1 = pkg.readInt();
                  item.Hole2 = pkg.readInt();
                  item.Hole3 = pkg.readInt();
                  item.Hole4 = pkg.readInt();
                  item.Hole5 = pkg.readInt();
                  item.Hole6 = pkg.readInt();
                  ItemManager.fill(item);
                  item.Pic = pkg.readUTF();
                  item.RefineryLevel = pkg.readInt();
                  item.DiscolorValidDate = pkg.readDateString();
                  item.StrengthenTimes = pkg.readInt();
                  item.Hole5Level = pkg.readByte();
                  item.Hole5Exp = pkg.readInt();
                  item.Hole6Level = pkg.readByte();
                  item.Hole6Exp = pkg.readInt();
                  item.isGold = pkg.readBoolean();
                  if(item.isGold)
                  {
                     item.goldValidDate = pkg.readInt();
                     item.goldBeginTime = pkg.readDateString();
                  }
				  item.latentEnergyCurStr = pkg.readUTF();
				  item.latentEnergyNewStr = pkg.readUTF();
				  item.latentEnergyEndTime = pkg.readDate();
                  bag.addItem(item);
                  if(item.Place == 15 && bagType == 0 && item.UserID == this.Self.ID)
                  {
                     this._self.DeputyWeaponID = item.TemplateID;
                  }
                  if(PathManager.solveExternalInterfaceEnabel() && bagType == BagInfo.STOREBAG && item.StrengthenLevel >= 7)
                  {
                     ExternalInterfaceManager.sendToAgent(3,this.Self.ID,this.Self.NickName,ServerManager.Instance.zoneName,item.StrengthenLevel);
                  }
               }
               else
               {
                  bag.removeItemAt(slot);
               }
               i++;
            }
            return;
         }
         finally
         {
            bag.commiteChanges();
         }
      }
      
      private function __itemEquip(param1:CrazyTankSocketEvent) : void
      {
		 var _loc18_:Vector.<GemstListInfo> = null;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.deCompress();
         _loc3_ = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_,-1,_loc4_);
         _loc5_.ID = _loc3_;
         if(_loc5_ != null)
         {
            _loc5_.beginChanges();
            _loc5_.Agility = _loc2_.readInt();
            _loc5_.Attack = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Colors = _loc2_.readUTF();
               _loc5_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc5_.Colors = this.changedStyle[_loc3_]["Colors"];
               _loc5_.Skin = this.changedStyle[_loc3_]["Skin"];
            }
            _loc5_.Defence = _loc2_.readInt();
            _loc5_.GP = _loc2_.readInt();
            _loc5_.Grade = _loc2_.readInt();
            _loc5_.Luck = _loc2_.readInt();
            _loc5_.hp = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc5_.Hide = this.changedStyle[_loc3_]["Hide"];
            }
            _loc5_.Repute = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Sex = _loc2_.readBoolean();
               _loc5_.Style = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readBoolean();
               _loc2_.readUTF();
               _loc5_.Sex = this.changedStyle[_loc3_]["Sex"];
               _loc5_.Style = this.changedStyle[_loc3_]["Style"];
            }
            _loc5_.Offer = _loc2_.readInt();
            _loc5_.NickName = _loc4_;
            _loc5_.typeVIP = _loc2_.readByte();
            _loc5_.VIPLevel = _loc2_.readInt();
            _loc5_.WinCount = _loc2_.readInt();
            _loc5_.TotalCount = _loc2_.readInt();
            _loc5_.EscapeCount = _loc2_.readInt();
            _loc5_.ConsortiaID = _loc2_.readInt();
            _loc5_.ConsortiaName = _loc2_.readUTF();
            _loc5_.badgeID = _loc2_.readInt();
            _loc5_.RichesOffer = _loc2_.readInt();
            _loc5_.RichesRob = _loc2_.readInt();
            _loc5_.IsMarried = _loc2_.readBoolean();
            _loc5_.SpouseID = _loc2_.readInt();
            _loc5_.SpouseName = _loc2_.readUTF();
            _loc5_.DutyName = _loc2_.readUTF();
            _loc5_.Nimbus = _loc2_.readInt();
            _loc5_.FightPower = _loc2_.readInt();
            _loc5_.apprenticeshipState = _loc2_.readInt();
            _loc5_.masterID = _loc2_.readInt();
            _loc5_.setMasterOrApprentices(_loc2_.readUTF());
            _loc5_.graduatesCount = _loc2_.readInt();
            _loc5_.honourOfMaster = _loc2_.readUTF();
            _loc5_.AchievementPoint = _loc2_.readInt();
            _loc5_.honor = _loc2_.readUTF();
            _loc5_.LastLoginDate = _loc2_.readDate();
            _loc5_.spdTexpExp = _loc2_.readInt();
            _loc5_.attTexpExp = _loc2_.readInt();
            _loc5_.defTexpExp = _loc2_.readInt();
            _loc5_.hpTexpExp = _loc2_.readInt();
            _loc5_.lukTexpExp = _loc2_.readInt();
            _loc5_.DailyLeagueFirst = _loc2_.readBoolean();
            _loc5_.DailyLeagueLastScore = _loc2_.readInt();
			_loc5_.totemId = _loc2_.readInt();
			_loc5_.necklaceExp = _loc2_.readInt();
			_loc5_.commitChanges();
            _loc6_ = _loc2_.readInt();
            _loc5_.Bag.beginChanges();
            if(!(_loc5_ is SelfInfo))
            {
               _loc5_.Bag.clearnAll();
            }
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = new InventoryItemInfo();
               _loc8_.BagType = _loc2_.readByte();
               _loc8_.UserID = _loc2_.readInt();
               _loc8_.ItemID = _loc2_.readInt();
               _loc8_.Count = _loc2_.readInt();
               _loc8_.Place = _loc2_.readInt();
               _loc8_.TemplateID = _loc2_.readInt();
               _loc8_.AttackCompose = _loc2_.readInt();
               _loc8_.DefendCompose = _loc2_.readInt();
               _loc8_.AgilityCompose = _loc2_.readInt();
               _loc8_.LuckCompose = _loc2_.readInt();
               _loc8_.StrengthenLevel = _loc2_.readInt();
               _loc8_.IsBinds = _loc2_.readBoolean();
               _loc8_.IsJudge = _loc2_.readBoolean();
               _loc8_.BeginDate = _loc2_.readDateString();
               _loc8_.ValidDate = _loc2_.readInt();
               _loc8_.Color = _loc2_.readUTF();
               _loc8_.Skin = _loc2_.readUTF();
               _loc8_.IsUsed = _loc2_.readBoolean();
               ItemManager.fill(_loc8_);
               _loc8_.Hole1 = _loc2_.readInt();
               _loc8_.Hole2 = _loc2_.readInt();
               _loc8_.Hole3 = _loc2_.readInt();
               _loc8_.Hole4 = _loc2_.readInt();
               _loc8_.Hole5 = _loc2_.readInt();
               _loc8_.Hole6 = _loc2_.readInt();
               _loc8_.Pic = _loc2_.readUTF();
               _loc8_.RefineryLevel = _loc2_.readInt();
               _loc8_.DiscolorValidDate = _loc2_.readDateString();
               _loc8_.Hole5Level = _loc2_.readByte();
               _loc8_.Hole5Exp = _loc2_.readInt();
               _loc8_.Hole6Level = _loc2_.readByte();
               _loc8_.Hole6Exp = _loc2_.readInt();
               _loc8_.isGold = _loc2_.readBoolean();
               if(_loc8_.isGold)
               {
                  _loc8_.goldValidDate = _loc2_.readInt();
                  _loc8_.goldBeginTime = _loc2_.readDateString();
               }
			   _loc8_.latentEnergyCurStr = _loc2_.readUTF();
			   _loc8_.latentEnergyNewStr = _loc2_.readUTF();
			   _loc8_.latentEnergyEndTime = _loc2_.readDate();
               _loc5_.Bag.addItem(_loc8_);
               _loc7_++;
            }
			//GemStone
			var _int1:int = 0;
			var _int2:int = 0;
			var _loc15_:GemstonInitInfo = null;
			var _loc16_:String = null;
			var _loc17_:Array = null;
			//var _loc18_:Vector.<GemstListInfo> = null;
			var _loc19_:int = 0;
			var _loc20_:Array = null;
			var _loc21_:GemstListInfo = null;
			_int1 = _loc2_.readInt();
			this.gemstoneInfoList = new Vector.<GemstonInitInfo>();
			_int2 = 0;
			while(_int2 < _int1)
			{
				_loc15_ = new GemstonInitInfo();
				_loc15_.figSpiritId = _loc2_.readInt();
				_loc16_ = _loc2_.readUTF();
				_loc17_ = this.rezArr(_loc16_);
				_loc18_ = new Vector.<GemstListInfo>();
				_loc19_ = 0;
				while(_loc19_ < 3)
				{
					_loc20_ = _loc17_[_loc19_].split(",");
					_loc21_ = new GemstListInfo();
					_loc21_.fightSpiritId = _loc15_.figSpiritId;
					_loc21_.level = _loc20_[0];
					_loc21_.exp = _loc20_[1];
					_loc21_.place = _loc20_[2];
					_loc18_.push(_loc21_);
					_loc19_++;
				}
				_loc15_.equipPlace = _loc2_.readInt();
				if(_loc5_.Bag.getItemAt(_loc15_.equipPlace))
				{
					_loc5_.Bag.getItemAt(_loc15_.equipPlace).gemstoneList = _loc18_;
				}
				_loc15_.list = _loc18_;
				this.gemstoneInfoList.push(_loc15_);
				_int2++;
			}
			_loc5_.gemstoneList = this.gemstoneInfoList;
			//
            _loc5_.Bag.commiteChanges();
            _loc5_.commitChanges();
         }
      }
      
      private function __onsItemEquip(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_);
         if(_loc5_ != null)
         {
            _loc5_.beginChanges();
            _loc5_.Agility = _loc2_.readInt();
            _loc5_.Attack = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Colors = _loc2_.readUTF();
               _loc5_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc5_.Colors = this.changedStyle[_loc3_]["Colors"];
               _loc5_.Skin = this.changedStyle[_loc3_]["Skin"];
            }
            _loc5_.Defence = _loc2_.readInt();
            _loc5_.GP = _loc2_.readInt();
            _loc5_.Grade = _loc2_.readInt();
            _loc5_.Luck = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc5_.Hide = this.changedStyle[_loc3_]["Hide"];
            }
            _loc5_.Repute = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Sex = _loc2_.readBoolean();
               _loc5_.Style = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readBoolean();
               _loc2_.readUTF();
               _loc5_.Sex = this.changedStyle[_loc3_]["Sex"];
               _loc5_.Style = this.changedStyle[_loc3_]["Style"];
            }
            _loc5_.Offer = _loc2_.readInt();
            _loc5_.NickName = _loc4_;
            _loc5_.typeVIP = _loc2_.readByte();
            _loc5_.VIPLevel = _loc2_.readInt();
            _loc5_.WinCount = _loc2_.readInt();
            _loc5_.TotalCount = _loc2_.readInt();
            _loc5_.EscapeCount = _loc2_.readInt();
            _loc5_.ConsortiaID = _loc2_.readInt();
            _loc5_.ConsortiaName = _loc2_.readUTF();
            _loc5_.RichesOffer = _loc2_.readInt();
            _loc5_.RichesRob = _loc2_.readInt();
            _loc5_.IsMarried = _loc2_.readBoolean();
            _loc5_.SpouseID = _loc2_.readInt();
            _loc5_.SpouseName = _loc2_.readUTF();
            _loc5_.DutyName = _loc2_.readUTF();
            _loc5_.Nimbus = _loc2_.readInt();
            _loc5_.FightPower = _loc2_.readInt();
            _loc5_.apprenticeshipState = _loc2_.readInt();
            _loc5_.masterID = _loc2_.readInt();
            _loc5_.setMasterOrApprentices(_loc2_.readUTF());
            _loc5_.graduatesCount = _loc2_.readInt();
            _loc5_.honourOfMaster = _loc2_.readUTF();
            _loc5_.AchievementPoint = _loc2_.readInt();
            _loc5_.honor = _loc2_.readUTF();
            _loc5_.LastLoginDate = _loc2_.readDate();
            _loc5_.commitChanges();
            _loc5_.Bag.beginChanges();
            _loc5_.Bag.commiteChanges();
            _loc5_.commitChanges();
         }
         super.dispatchEvent(new CityWideEvent(CityWideEvent.ONS_PLAYERINFO,_loc5_));
      }
      
      private function __bagLockedHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:int = param1.pkg.readInt();
         var _loc8_:String = param1.pkg.readUTF();
         var _loc9_:String = param1.pkg.readUTF();
         if(_loc4_)
         {
            switch(_loc3_)
            {
               case 1:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  this._self.onReceiveTypes(BagEvent.CHANGEPSW);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 2:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = false;
                  if(!ServerManager.AUTO_UNLOCK)
                  {
                     MessageTipManager.getInstance().show(_loc6_);
                     ServerManager.AUTO_UNLOCK = false;
                  }
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  this._self.onReceiveTypes(BagEvent.CLEAR);
                  break;
               case 3:
                  this._self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 4:
                  this._self.bagPwdState = false;
                  this._self.bagLocked = false;
                  this._self.onReceiveTypes(BagEvent.AFTERDEL);
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 5:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 6:
            }
         }
         else
         {
            MessageTipManager.getInstance().show(_loc6_);
         }
      }
      
      private function __friendAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:FriendListPlayer = null;
         var _loc5_:PlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = new FriendListPlayer();
            _loc4_.beginChanges();
            _loc4_.ID = _loc2_.readInt();
            _loc4_.NickName = _loc2_.readUTF();
            _loc4_.typeVIP = _loc2_.readByte();
            _loc4_.VIPLevel = _loc2_.readInt();
            _loc4_.Sex = _loc2_.readBoolean();
            _loc5_ = this.findPlayer(_loc4_.ID);
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_.ID))
            {
               _loc4_.Style = _loc2_.readUTF();
               _loc4_.Colors = _loc2_.readUTF();
               _loc4_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc4_.Style = _loc5_.Style;
               _loc4_.Colors = _loc5_.Colors;
               _loc4_.Skin = _loc5_.Skin;
            }
            _loc4_.playerState = new PlayerState(_loc2_.readInt());
            _loc4_.Grade = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_.ID))
            {
               _loc4_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc4_.Hide = _loc5_.Hide;
            }
            _loc4_.ConsortiaName = _loc2_.readUTF();
            _loc4_.TotalCount = _loc2_.readInt();
            _loc4_.EscapeCount = _loc2_.readInt();
            _loc4_.WinCount = _loc2_.readInt();
            _loc4_.Offer = _loc2_.readInt();
            _loc4_.Repute = _loc2_.readInt();
            _loc4_.Relation = _loc2_.readInt();
            _loc4_.LoginName = _loc2_.readUTF();
            _loc4_.Nimbus = _loc2_.readInt();
            _loc4_.FightPower = _loc2_.readInt();
            _loc4_.apprenticeshipState = _loc2_.readInt();
            _loc4_.masterID = _loc2_.readInt();
            _loc4_.setMasterOrApprentices(_loc2_.readUTF());
            _loc4_.graduatesCount = _loc2_.readInt();
            _loc4_.honourOfMaster = _loc2_.readUTF();
            _loc4_.AchievementPoint = _loc2_.readInt();
            _loc4_.honor = _loc2_.readUTF();
            _loc4_.IsMarried = _loc2_.readBoolean();
            _loc4_.commitChanges();
            if(_loc4_.Relation != 1)
            {
               this.addFriend(_loc4_);
               if(PathInfo.isUserAddFriend)
               {
                  new AddCommunityFriend(_loc4_.LoginName,_loc4_.NickName);
               }
            }
            else
            {
               this.addBlackList(_loc4_);
            }
            dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND,_loc4_));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.playerManager.addFriend.isRefused"));
         }
      }
      
      public function addFriend(param1:PlayerInfo) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.blackList.remove(param1.ID);
         this.friendList.add(param1.ID,param1);
      }
      
      public function addBlackList(param1:FriendListPlayer) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1.ID);
         this.blackList.add(param1.ID,param1);
      }
      
      public function removeFriend(param1:int) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1);
         this.blackList.remove(param1);
      }
      
      private function __friendRemove(param1:CrazyTankSocketEvent) : void
      {
         this.removeFriend(param1.pkg.clientId);
      }
      
      private function __playerState(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            _loc3_ = _loc2_.clientId;
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readByte();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readBoolean();
            this.playerStateChange(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            if(_loc3_ == this.Self.SpouseID)
            {
               this.spouseStateChange(_loc4_);
            }
            ConsortionModelControl.Instance.model.consortiaPlayerStateChange(_loc3_,_loc4_);
         }
      }
      
      private function spouseStateChange(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 == PlayerState.ONLINE)
         {
            _loc2_ = !!this.Self.Sex ? LanguageMgr.GetTranslation("ddt.manager.playerManager.wifeOnline",this.Self.SpouseName) : LanguageMgr.GetTranslation("ddt.manager.playerManager.hushandOnline",this.Self.SpouseName);
            ChatManager.Instance.sysChatYellow(_loc2_);
         }
      }
      
      private function masterStateChange(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         if(param1 == PlayerState.ONLINE && param2 != this.Self.SpouseID)
         {
            if(param2 == this.Self.masterID)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.masterState",this.Self.getMasterOrApprentices()[param2]);
            }
            else
            {
               if(!this.Self.getMasterOrApprentices()[param2])
               {
                  return;
               }
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.ApprenticeState",this.Self.getMasterOrApprentices()[param2]);
            }
            ChatManager.Instance.sysChatYellow(_loc3_);
         }
      }
      
      public function playerStateChange(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         var _loc7_:String = null;
         var _loc8_:PlayerInfo = null;
         var _loc6_:PlayerInfo = this.friendList[param1];
         if(_loc6_)
         {
            if(_loc6_.playerState.StateID != param2 || _loc6_.typeVIP != param3 || _loc6_.isSameCity != param5)
            {
               _loc6_.typeVIP = param3;
               _loc6_.VIPLevel = param4;
               _loc6_.isSameCity = param5;
               _loc7_ = "";
               if(_loc6_.playerState.StateID != param2)
               {
                  _loc6_.playerState = new PlayerState(param2);
                  this.friendList.add(param1,_loc6_);
                  if(param1 == this.Self.SpouseID)
                  {
                     return;
                  }
                  if(param1 == this.Self.masterID || this.Self.getMasterOrApprentices()[param1])
                  {
                     this.masterStateChange(param2,param1);
                     return;
                  }
                  if(param2 == PlayerState.ONLINE && SharedManager.Instance.showOL)
                  {
                     _loc7_ = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend") + "[" + _loc6_.NickName + "]" + LanguageMgr.GetTranslation("tank.manager.PlayerManger.friendOnline");
                     ChatManager.Instance.sysChatYellow(_loc7_);
                     return;
                  }
                  return;
               }
            }
            this.friendList.add(param1,_loc6_);
         }
         else if(this.myAcademyPlayers)
         {
            _loc8_ = this.myAcademyPlayers[param1];
            if(_loc8_)
            {
               if(_loc8_.playerState.StateID != param2 || _loc8_.IsVIP != param3)
               {
                  _loc8_.typeVIP = param3;
                  _loc8_.VIPLevel = param4;
                  _loc8_.playerState = new PlayerState(param2);
                  this.myAcademyPlayers.add(param1,_loc8_);
               }
            }
         }
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS,this.__updateInventorySlot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP,this.__itemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONS_EQUIP,this.__onsItemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED,this.__bagLockedHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePrivateInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,this.__updatePlayerInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TEMP_STYLE,this.__readTempStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD,this.__dailyAwardHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE,this.__checkCodePopup);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         this.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPopChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD,this.__friendAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE,this.__friendRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE,this.__playerState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_IS_OPENED,this.__upVipInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_GET_GIFTS,this.__getGifts);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_UPDATE_GIFT,this.__addGiftItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_RELOAD_GIFT,this.__canReLoadGift);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_DATA,this.__getCards);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER,this.__updateUerGuild);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,this.__chatFilteringFriendsShare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAME_CITY_FRIEND,this.__sameCity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PET,this.__updatePet);
		 SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NECKLACE_STRENGTH,this.__necklaceStrengthInfoUpadte);
      }
      
      private function __updatePet(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:PetInfo = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:PetSkill = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:PetEquipData = null;
         var _loc25_:InventoryItemInfo = null;
         var _loc26_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_,_loc4_);
         _loc5_.ID = _loc3_;
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readBoolean();
            if(_loc9_)
            {
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc12_ = new PetInfo();
               _loc12_.TemplateID = _loc11_;
               _loc12_.ID = _loc10_;
               PetInfoManager.fillPetInfo(_loc12_);
               _loc12_.Name = _loc2_.readUTF();
               _loc12_.UserID = _loc2_.readInt();
               _loc12_.Attack = _loc2_.readInt();
               _loc12_.Defence = _loc2_.readInt();
               _loc12_.Luck = _loc2_.readInt();
               _loc12_.Agility = _loc2_.readInt();
               _loc12_.Blood = _loc2_.readInt();
               _loc12_.Damage = _loc2_.readInt();
               _loc12_.Guard = _loc2_.readInt();
               _loc12_.AttackGrow = _loc2_.readInt();
               _loc12_.DefenceGrow = _loc2_.readInt();
               _loc12_.LuckGrow = _loc2_.readInt();
               _loc12_.AgilityGrow = _loc2_.readInt();
               _loc12_.BloodGrow = _loc2_.readInt();
               _loc12_.DamageGrow = _loc2_.readInt();
               _loc12_.GuardGrow = _loc2_.readInt();
               _loc12_.Level = _loc2_.readInt();
               _loc12_.GP = _loc2_.readInt();
               _loc12_.MaxGP = _loc2_.readInt();
               _loc12_.Hunger = _loc2_.readInt();
               _loc12_.PetHappyStar = _loc2_.readInt();
               _loc12_.MP = _loc2_.readInt();
               _loc12_.clearSkills();
               _loc12_.clearEquipedSkills();
               _loc13_ = _loc2_.readInt();
               _loc14_ = 0;
               while(_loc14_ < _loc13_)
               {
                  _loc20_ = _loc2_.readInt();
                  _loc21_ = new PetSkill(_loc20_);
                  _loc12_.addSkill(_loc21_);
                  _loc2_.readInt();
                  _loc14_++;
               }
               _loc15_ = _loc2_.readInt();
               _loc16_ = 0;
               while(_loc16_ < _loc15_)
               {
                  _loc22_ = _loc2_.readInt();
                  _loc23_ = _loc2_.readInt();
                  _loc12_.equipdSkills.add(_loc22_,_loc23_);
                  _loc16_++;
               }
               _loc17_ = _loc2_.readBoolean();
               _loc12_.IsEquip = _loc17_;
               _loc12_.Place = _loc8_;
               _loc5_.pets.add(_loc12_.Place,_loc12_);
               _loc18_ = _loc2_.readInt();
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc24_ = new PetEquipData();
                  _loc24_.eqType = _loc2_.readInt();
                  _loc24_.eqTemplateID = _loc2_.readInt();
                  _loc24_.startTime = _loc2_.readDateString();
                  _loc24_.ValidDate = _loc2_.readInt();
                  _loc25_ = new InventoryItemInfo();
                  _loc25_.TemplateID = _loc24_.eqTemplateID;
                  _loc25_.ValidDate = _loc24_.ValidDate;
                  _loc25_.BeginDate = _loc24_.startTime;
                  _loc25_.IsBinds = true;
                  _loc25_.IsUsed = true;
                  _loc25_.Place = _loc24_.eqType;
                  _loc26_ = ItemManager.fill(_loc25_) as InventoryItemInfo;
                  _loc12_.equipList.add(_loc26_.Place,_loc26_);
                  if(PetBagController.instance().view && PetBagController.instance().view.parent)
                  {
                     PetBagController.instance().view.addPetEquip(_loc26_);
                  }
                  _loc19_++;
               }
               _loc12_.currentStarExp = _loc2_.readInt();
            }
            else
            {
               _loc5_.pets.remove(_loc8_);
            }
            _loc5_.commitChanges();
            _loc7_++;
         }
      }
      
      private function __roomListPass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PassInputFrame = ComponentFactory.Instance.creat("roomList.RoomList.passInputFrame");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.ID = _loc2_;
      }
      
      private function __sameCity(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = param1.pkg.readInt();
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.pkg.readInt();
            this.findPlayer(_loc4_,this.Self.ZoneID).isSameCity = true;
            if(!this._sameCityList)
            {
               this._sameCityList = new Array();
            }
            this._sameCityList.push(_loc4_);
            _loc3_++;
         }
         this.initSameCity();
      }
      
      private function initSameCity() : void
      {
         if(!this._sameCityList)
         {
            this._sameCityList = new Array();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._sameCityList.length)
         {
            this.findPlayer(this._sameCityList[_loc1_]).isSameCity = true;
            _loc1_++;
         }
         this._friendList[this._self.ZoneID].dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE));
      }
      
      private function __chatFilteringFriendsShare(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:CMFriendInfo = null;
         if(!this._cmFriendList)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:Boolean = false;
         for each(_loc6_ in this._cmFriendList)
         {
            if(_loc6_.UserId == _loc3_)
            {
               _loc5_ = true;
            }
         }
         if(_loc5_)
         {
            ChatManager.Instance.sysChatYellow(_loc4_);
         }
      }
      
      private function __updateUerGuild(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.writeByte(param1.pkg.readByte());
            _loc4_++;
         }
         this._self.weaklessGuildProgress = _loc2_;
      }
      
      private function __getCards(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:CardInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_);
         _loc5_.beginChanges();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc2_.readInt();
            _loc8_ = _loc2_.readBoolean();
            if(_loc8_)
            {
               _loc9_ = new CardInfo();
               _loc9_.CardID = _loc2_.readInt();
               _loc9_.UserID = _loc2_.readInt();
               _loc9_.Count = _loc2_.readInt();
               _loc9_.Place = _loc2_.readInt();
               _loc9_.TemplateID = _loc2_.readInt();
               _loc9_.Attack = _loc2_.readInt();
               _loc9_.Defence = _loc2_.readInt();
               _loc9_.Agility = _loc2_.readInt();
               _loc9_.Luck = _loc2_.readInt();
               _loc9_.Damage = _loc2_.readInt();
               _loc9_.Guard = _loc2_.readInt();
               _loc9_.Level = _loc2_.readInt();
               _loc9_.CardGP = _loc2_.readInt();
               _loc9_.isFirstGet = _loc2_.readBoolean();
               if(_loc9_.Place <= CardInfo.MAX_EQUIP_CARDS)
               {
                  _loc5_.cardEquipDic.add(_loc9_.Place,_loc9_);
               }
               else
               {
                  _loc5_.cardBagDic.add(_loc9_.Place,_loc9_);
               }
            }
            else if(_loc7_ <= CardInfo.MAX_EQUIP_CARDS)
            {
               _loc5_.cardEquipDic.remove(_loc7_);
            }
            else
            {
               _loc5_.cardBagDic.remove(_loc7_);
            }
            _loc6_++;
         }
         _loc5_.commitChanges();
      }
      
      private function __canReLoadGift(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            SocketManager.Instance.out.sendPlayerGift(this._self.ID);
         }
      }
      
      private function __addGiftItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = this._self.myGiftData.length;
         if(_loc5_ != 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(this._self.myGiftData[_loc6_].TemplateID == _loc3_)
               {
                  this._self.myGiftData[_loc6_].amount = _loc4_;
                  dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,this._self.myGiftData[_loc6_]));
                  break;
               }
               if(_loc6_ == _loc5_ - 1)
               {
                  this.addItem(_loc3_,_loc4_);
               }
               _loc6_++;
            }
         }
         else
         {
            this.addItem(_loc3_,_loc4_);
         }
         GiftController.Instance.loadRecord(GiftController.RECEIVEDPATH,this._self.ID);
      }
      
      private function addItem(param1:int, param2:int) : void
      {
         var _loc3_:MyGiftCellInfo = new MyGiftCellInfo();
         _loc3_.TemplateID = param1;
         _loc3_.amount = param2;
         this._self.myGiftData.push(_loc3_);
         dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,this._self.myGiftData[this._self.myGiftData.length - 1]));
      }
      
      private function __getGifts(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:Vector.<MyGiftCellInfo> = null;
         var _loc7_:int = 0;
         var _loc8_:MyGiftCellInfo = null;
         var _loc9_:Vector.<MyGiftCellInfo> = null;
         var _loc10_:int = 0;
         var _loc11_:MyGiftCellInfo = null;
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:PlayerInfo = this.findPlayer(_loc4_);
         if(_loc4_ == this._self.ID)
         {
            this._self.charmGP = _loc3_.readInt();
            _loc2_ = _loc3_.readInt();
            _loc6_ = new Vector.<MyGiftCellInfo>();
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc8_ = new MyGiftCellInfo();
               _loc8_.TemplateID = _loc3_.readInt();
               _loc8_.amount = _loc3_.readInt();
               _loc6_.push(_loc8_);
               _loc7_++;
            }
            this._self.myGiftData = _loc6_;
            dispatchEvent(new Event(SELF_GIFT_INFO_CHANGE));
         }
         else
         {
            _loc5_.beginChanges();
            _loc5_.charmGP = _loc3_.readInt();
            _loc2_ = _loc3_.readInt();
            _loc9_ = new Vector.<MyGiftCellInfo>();
            _loc10_ = 0;
            while(_loc10_ < _loc2_)
            {
               _loc11_ = new MyGiftCellInfo();
               _loc11_.TemplateID = _loc3_.readInt();
               _loc11_.amount = _loc3_.readInt();
               _loc9_.push(_loc11_);
               _loc10_++;
            }
            _loc5_.myGiftData = _loc9_;
            _loc5_.commitChanges();
            dispatchEvent(new Event(GIFT_INFO_CHANGE));
         }
      }
      
      private function __upVipInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.typeVIP = _loc2_.readByte();
         this._self.VIPLevel = _loc2_.readInt();
         this._self.VIPExp = _loc2_.readInt();
         this._self.VIPExpireDay = _loc2_.readDate();
         this._self.LastDate = _loc2_.readDate();
         this._self.VIPNextLevelDaysNeeded = _loc2_.readInt();
         this._self.canTakeVipReward = _loc2_.readBoolean();
         dispatchEvent(new Event(VIP_STATE_CHANGE));
      }
      
      public function setupFriendList(param1:FriendListAnalyzer) : void
      {
         this.customList = param1.customList;
         this.friendList = param1.friendlist;
         this.blackList = param1.blackList;
         this.initSameCity();
      }
      
      public function checkHasGroupName(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.customList.length)
         {
            if(this.customList[_loc2_].Name == param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addFirend.repet"),0,true);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setupMyacademyPlayers(param1:MyAcademyPlayersAnalyze) : void
      {
         this._myAcademyPlayers = param1.myAcademyPlayers;
      }
      
      private function romoveAcademyPlayers() : void
      {
         var _loc1_:FriendListPlayer = null;
         for each(_loc1_ in this._myAcademyPlayers)
         {
            this.friendList.remove(_loc1_.ID);
         }
      }
      
      public function setupRecentContacts(param1:RecentContactsAnalyze) : void
      {
         this.recentContacts = param1.recentContacts;
      }
      
      public function set friendList(param1:DictionaryData) : void
      {
         this._friendList[this._self.ZoneID] = param1;
         IMController.Instance.isLoadComplete = true;
         dispatchEvent(new Event(FRIENDLIST_COMPLETE));
      }
      
      public function get friendList() : DictionaryData
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._friendList[this._self.ZoneID];
      }
      
      public function getFriendForCustom(param1:int) : DictionaryData
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:DictionaryData = new DictionaryData();
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         for each(_loc3_ in this._friendList[this._self.ZoneID])
         {
            if(_loc3_.Relation == param1)
            {
               _loc2_.add(_loc3_.ID,_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function deleteCustomGroup(param1:int) : void
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this._friendList[this._self.ZoneID])
         {
            if(_loc2_.Relation == param1)
            {
               _loc2_.Relation = 0;
            }
         }
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function get recentContacts() : DictionaryData
      {
         if(!this._recentContacts)
         {
            this._recentContacts = new DictionaryData();
         }
         return this._recentContacts;
      }
      
      public function set recentContacts(param1:DictionaryData) : void
      {
         this._recentContacts = param1;
         dispatchEvent(new Event(RECENT_CONTAST_COMPLETE));
      }
      
      public function get onlineRecentContactList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE || this.findPlayer(_loc2_.ID) && this.findPlayer(_loc2_.ID).playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get offlineRecentContactList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getByNameFriend(param1:String) : FriendListPlayer
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.NickName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function deleteRecentContact(param1:int) : void
      {
         this.recentContacts.remove(param1);
      }
      
      public function get onlineFriendList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getOnlineFriendForCustom(param1:int) : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.friendList)
         {
            if(_loc3_.playerState.StateID != PlayerState.OFFLINE && _loc3_.Relation == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get offlineFriendList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getOfflineFriendForCustom(param1:int) : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.friendList)
         {
            if(_loc3_.playerState.StateID == PlayerState.OFFLINE && _loc3_.Relation == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get onlineMyAcademyPlayers() : Array
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._myAcademyPlayers)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_ as FriendListPlayer);
            }
         }
         return _loc1_;
      }
      
      public function get offlineMyAcademyPlayers() : Array
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._myAcademyPlayers)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_ as FriendListPlayer);
            }
         }
         return _loc1_;
      }
      
      public function set blackList(param1:DictionaryData) : void
      {
         this._blackList[this._self.ZoneID] = param1;
      }
      
      public function get blackList() : DictionaryData
      {
         if(this._blackList[this._self.ZoneID] == null)
         {
            this._blackList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._blackList[this._self.ZoneID];
      }
      
      public function get CMFriendList() : DictionaryData
      {
         return this._cmFriendList;
      }
      
      public function set CMFriendList(param1:DictionaryData) : void
      {
         this._cmFriendList = param1;
      }
      
      public function get PlayCMFriendList() : Array
      {
         if(this._cmFriendList)
         {
            return this._cmFriendList.filter("IsExist",true);
         }
         return [];
      }
      
      public function get UnPlayCMFriendList() : Array
      {
         if(this._cmFriendList)
         {
            return this._cmFriendList.filter("IsExist",false);
         }
         return [];
      }
      
      private function __updatePrivateInfo(param1:CrazyTankSocketEvent) : void
      {
         this._self.beginChanges();
         this._self.Money = param1.pkg.readInt();
         this._self.medal = param1.pkg.readInt();
         this._self.Score = param1.pkg.readInt();
         this._self.Gold = param1.pkg.readInt();
         this._self.Gift = param1.pkg.readInt();
         //this._self.badLuckNumber = param1.pkg.readInt();
		 this._self.damageScores = param1.pkg.readInt();
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._self.petScore = param1.pkg.readInt();
         }
         this._self.hardCurrency = param1.pkg.readInt();
		 this._self.myHonor = param1.pkg.readInt();
         this._self.commitChanges();
      }
      
      public function get hasTempStyle() : Boolean
      {
         return this.tempStyle.length > 0;
      }
      
      public function isChangeStyleTemp(param1:int) : Boolean
      {
         return this.changedStyle.hasOwnProperty(param1) && this.changedStyle[param1] != null;
      }
      
      public function setStyleTemply(param1:Object) : void
      {
         var _loc2_:PlayerInfo = this.findPlayer(param1.ID);
         if(_loc2_)
         {
            this.storeTempStyle(_loc2_);
            _loc2_.beginChanges();
            _loc2_.Sex = param1.Sex;
            _loc2_.Hide = param1.Hide;
            _loc2_.Style = param1.Style;
            _loc2_.Colors = param1.Colors;
            _loc2_.Skin = param1.Skin;
            _loc2_.commitChanges();
         }
      }
      
      private function storeTempStyle(param1:PlayerInfo) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.Style = param1.getPrivateStyle();
         _loc2_.Hide = param1.Hide;
         _loc2_.Sex = param1.Sex;
         _loc2_.Skin = param1.Skin;
         _loc2_.Colors = param1.Colors;
         _loc2_.ID = param1.ID;
         this.tempStyle.push(_loc2_);
      }
      
      public function readAllTempStyleEvent() : void
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tempStyle.length)
         {
            _loc2_ = this.findPlayer(this.tempStyle[_loc1_].ID);
            if(_loc2_)
            {
               _loc2_.beginChanges();
               _loc2_.Sex = this.tempStyle[_loc1_].Sex;
               _loc2_.Hide = this.tempStyle[_loc1_].Hide;
               _loc2_.Style = this.tempStyle[_loc1_].Style;
               _loc2_.Colors = this.tempStyle[_loc1_].Colors;
               _loc2_.Skin = this.tempStyle[_loc1_].Skin;
               _loc2_.commitChanges();
            }
            _loc1_++;
         }
         this.tempStyle = [];
         this.changedStyle.clear();
      }
      
      private function __readTempStyle(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Object();
            _loc5_.Style = _loc2_.readUTF();
            _loc5_.Hide = _loc2_.readInt();
            _loc5_.Sex = _loc2_.readBoolean();
            _loc5_.Skin = _loc2_.readUTF();
            _loc5_.Colors = _loc2_.readUTF();
            _loc5_.ID = _loc2_.readInt();
            this.setStyleTemply(_loc5_);
            this.changedStyle.add(_loc5_.ID,_loc5_);
            _loc4_++;
         }
      }
      
      private function __updatePlayerInfo(param1:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var style:String = null;
         var arm:String = null;
         var offHand:String = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var unknown3:int = 0;
         var len:int = 0;
         var n:int = 0;
         var gradeId:int = 0;
         var mapId:int = 0;
         var flag:int = 0;
         var evt:CrazyTankSocketEvent = param1;
         var info:PlayerInfo = this.findPlayer(evt.pkg.clientId);
         if(info)
         {
				info.beginChanges();
				try
				{
					pkg = evt.pkg;
					info.GP = pkg.readInt();
					info.Offer = pkg.readInt();
					info.RichesOffer = pkg.readInt();
					info.RichesRob = pkg.readInt();
					info.WinCount = pkg.readInt();
					info.TotalCount = pkg.readInt();
					info.EscapeCount = pkg.readInt();
					info.Attack = pkg.readInt();
					info.Defence = pkg.readInt();
					info.Agility = pkg.readInt();
					info.Luck = pkg.readInt();
					info.hp = pkg.readInt();
					if(!this.isChangeStyleTemp(info.ID))
					{
						info.Hide = pkg.readInt();
					}
					else
					{
						pkg.readInt();
					}
					style = pkg.readUTF();
					if(!this.isChangeStyleTemp(info.ID))
					{
						info.Style = style;
					}
					arm = style.split(",")[6].split("|")[0];
					offHand = style.split(",")[10].split("|")[0];
					if(arm == "-1" || arm == "0")
					{
						info.WeaponID = -1;
					}
					else
					{
						info.WeaponID = int(arm);
					}
					if(offHand == "0" || offHand == "")
					{
						info.DeputyWeaponID = -1;
					}
					else
					{
						info.DeputyWeaponID = int(offHand);
					}
					if(!this.isChangeStyleTemp(info.ID))
					{
						info.Colors = pkg.readUTF();
						info.Skin = pkg.readUTF();
					}
					else
					{
						pkg.readUTF();
						pkg.readUTF();
					}
					info.IsShowConsortia = pkg.readBoolean();
					info.ConsortiaID = pkg.readInt();
					info.ConsortiaName = pkg.readUTF();
					info.badgeID = pkg.readInt();
					unknown1 = pkg.readInt();
					unknown2 = pkg.readInt();
					info.Nimbus = pkg.readInt();
					info.PvePermission = pkg.readUTF();
					info.fightLibMission = pkg.readUTF();
					info.FightPower = pkg.readInt();
					info.apprenticeshipState = pkg.readInt();
					info.masterID = pkg.readInt();
					info.setMasterOrApprentices(pkg.readUTF());
					info.graduatesCount = pkg.readInt();
					info.honourOfMaster = pkg.readUTF();
					info.AchievementPoint = pkg.readInt();
					info.honor = pkg.readUTF();
					info.LastSpaDate = pkg.readDate();
					info.charmGP = pkg.readInt();
					unknown3 = pkg.readInt();
					info.shopFinallyGottenTime = pkg.readDate();
					info.UseOffer = pkg.readInt();
					info.matchInfo.dailyScore = pkg.readInt();
					info.matchInfo.dailyWinCount = pkg.readInt();
					info.matchInfo.dailyGameCount = pkg.readInt();
					info.matchInfo.weeklyScore = pkg.readInt();
					info.matchInfo.weeklyGameCount = pkg.readInt();
					info.spdTexpExp = pkg.readInt();
					info.attTexpExp = pkg.readInt();
					info.defTexpExp = pkg.readInt();
					info.hpTexpExp = pkg.readInt();
					info.lukTexpExp = pkg.readInt();
					info.texpTaskCount = pkg.readInt();
					info.texpCount = pkg.readInt();
					info.texpTaskDate = pkg.readDate();
					len = pkg.readInt();
					n = 0;
					while(n < len)
					{
						mapId = pkg.readInt();
						flag = pkg.readByte();
						info.dungeonFlag[mapId] = flag;
						n++;
					}
					gradeId = pkg.readInt();
					info.evolutionGrade = gradeId;
					info.evolutionExp = pkg.readInt();
					return;
				}
				finally
				{
					info.commitChanges();
				}
         }
      }
      
      public function getDeputyWeaponIcon(param1:InventoryItemInfo, param2:int = 0) : DisplayObject
      {
         var _loc3_:BagCell = null;
         if(param1)
         {
            _loc3_ = new BagCell(param1.Place,param1);
            if(param2 == 0)
            {
               return _loc3_.getContent();
            }
            if(param2 == 1)
            {
               return _loc3_.getSmallContent();
            }
         }
         return null;
      }
      
      private function __dailyAwardHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         if(_loc3_ == 0)
         {
            CalendarManager.getInstance().setDailyAwardState(_loc2_);
         }
         else if(_loc3_ != 1)
         {
            if(_loc3_ == 2)
            {
            }
         }
      }
      
      public function get checkEnterDungeon() : Boolean
      {
         if(Instance.Self.Grade < GameManager.MinLevelDuplicate)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
            return false;
         }
         return true;
      }
      
      public function __checkCodePopup(param1:CrazyTankSocketEvent) : void
      {
         var checkCodeData:CheckCodeData = null;
         var bitmapReader:BitmapReader = null;
         var readComplete:Function = null;
         var type:int = 0;
         var msg:String = null;
         checkCodeData = null;
         var ba:ByteArray = null;
         bitmapReader = null;
         var e:CrazyTankSocketEvent = param1;
         readComplete = function(param1:Event):void
         {
            checkCodeData.pic = bitmapReader.bitmap;
            CheckCodeFrame.Instance.data = checkCodeData;
         };
         var checkCodeState:int = e.pkg.readByte();
         var backType:Boolean = e.pkg.readBoolean();
         if(checkCodeState == 1)
         {
            SoundManager.instance.play("058");
         }
         else if(checkCodeState == 2)
         {
            SoundManager.instance.play("057");
         }
         if(backType)
         {
            type = e.pkg.readByte();
            if(type == 1)
            {
               CheckCodeFrame.Instance.time = 11;
            }
            else
            {
               CheckCodeFrame.Instance.time = 20;
            }
            msg = e.pkg.readUTF();
            CheckCodeFrame.Instance.tip = msg;
            checkCodeData = new CheckCodeData();
            ba = new ByteArray();
            e.pkg.readBytes(ba,0,e.pkg.bytesAvailable);
            bitmapReader = new BitmapReader();
            bitmapReader.addEventListener(Event.COMPLETE,readComplete);
            bitmapReader.readByteArray(ba);
            CheckCodeFrame.Instance.isShowed = false;
            CheckCodeFrame.Instance.show();
            return;
         }
         CheckCodeFrame.Instance.close();
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            return;
         }
         this._self.clearBuff();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc2_.readDate();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
            this._self.addBuff(_loc12_);
            _loc4_++;
         }
         param1.stopImmediatePropagation();
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            return;
         }
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc2_.readDate();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
            if(_loc6_)
            {
               this._self.addBuff(_loc12_);
            }
            else
            {
               this._self.buffInfo.remove(_loc12_.Type);
            }
            _loc4_++;
         }
         param1.stopImmediatePropagation();
      }
      
      public function findPlayerByNickName(param1:PlayerInfo, param2:String) : PlayerInfo
      {
         var _loc3_:PlayerInfo = null;
         if(param2)
         {
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID][param2] != null)
            {
               return this._tempList[this._self.ZoneID][param2] as PlayerInfo;
            }
            for each(_loc3_ in this._tempList[this._self.ZoneID])
            {
               if(_loc3_.NickName == param2)
               {
                  return _loc3_;
               }
            }
            param1.NickName = param2;
            this._tempList[this._self.ZoneID][param2] = param1;
            return param1;
         }
         return param1;
      }
      
      public function findPlayer(param1:int, param2:int = -1, param3:String = "") : PlayerInfo
      {
         var _loc4_:PlayerInfo = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:PlayerInfo = null;
         if(param2 == -1 || param2 == this._self.ZoneID)
         {
            if(this._friendList[this._self.ZoneID] == null)
            {
               this._friendList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._clubPlays[this._self.ZoneID] == null)
            {
               this._clubPlays[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._myAcademyPlayers == null)
            {
               this._myAcademyPlayers = new DictionaryData();
            }
            if(param1 == this._self.ID && (param2 == -1 || param2 == this._self.ZoneID))
            {
               return this._self;
            }
            if(this._friendList[this._self.ZoneID][param1])
            {
               return this._friendList[this._self.ZoneID][param1];
            }
            if(this._clubPlays[this._self.ZoneID][param1])
            {
               return this._clubPlays[this._self.ZoneID][param1];
            }
            if(this._tempList[this._self.ZoneID][param3])
            {
               return this._tempList[this._self.ZoneID][param3];
            }
            if(this._myAcademyPlayers[param1])
            {
               return this._myAcademyPlayers[param1];
            }
            if(this._tempList[this._self.ZoneID][param1])
            {
               if(this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][param1].NickName])
               {
                  return this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][param1].NickName];
               }
               return this._tempList[this._self.ZoneID][param1];
            }
            for each(_loc4_ in this._tempList[this._self.ZoneID])
            {
               if(_loc4_.ID == param1)
               {
                  this._tempList[this._self.ZoneID][param1] = _loc4_;
                  return _loc4_;
               }
            }
            _loc5_ = new PlayerInfo();
            _loc5_.ID = param1;
            _loc5_.ZoneID = this._self.ZoneID;
            this._tempList[this._self.ZoneID][param1] = _loc5_;
            return _loc5_;
         }
         if(param1 == this._self.ID && (param2 == this._self.ZoneID || this._self.ZoneID == 0))
         {
            return this._self;
         }
         if(this._friendList[param2] && this._friendList[param2][param1])
         {
            return this._friendList[param2][param1];
         }
         if(this._clubPlays[param2] && this._clubPlays[param2][param1])
         {
            return this._clubPlays[param2][param1];
         }
         if(this._tempList[param2] && this._tempList[param2][param1])
         {
            return this._tempList[param2][param1];
         }
         _loc6_ = new PlayerInfo();
         _loc6_.ID = param1;
         _loc6_.ZoneID = param2;
         if(this._tempList[param2] == null)
         {
            this._tempList[param2] = new DictionaryData();
         }
         this._tempList[param2][param1] = _loc6_;
         return _loc6_;
      }
      
      public function hasInMailTempList(param1:int) : Boolean
      {
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      public function set mailTempList(param1:DictionaryData) : void
      {
         if(this._mailTempList == null)
         {
            this._mailTempList = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         this._mailTempList[this._self.ZoneID] = param1;
      }
      
      public function hasInFriendList(param1:int) : Boolean
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[this._self.ZoneID] = new DictionaryData();
         }
         if(this._friendList[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      public function hasInClubPlays(param1:int) : Boolean
      {
         if(this._clubPlays[this._self.ZoneID] == null)
         {
            this._clubPlays[this._self.ZoneID] = new DictionaryData();
         }
         if(this._clubPlays[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      private function __selfPopChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["TotalCount"])
         {
            switch(PlayerManager.Instance.Self.TotalCount)
            {
               case 1:
                  StatisticManager.Instance().startAction("gameOver1","yes");
                  break;
               case 3:
                  StatisticManager.Instance().startAction("gameOver3","yes");
                  break;
               case 5:
                  StatisticManager.Instance().startAction("gameOver5","yes");
                  break;
               case 10:
                  StatisticManager.Instance().startAction("gameOver10","yes");
            }
         }
         if(param1.changedProperties["Grade"])
         {
            TaskManager.requestCanAcceptTask();
         }
      }
	  
	  protected function __necklaceStrengthInfoUpadte(param1:CrazyTankSocketEvent) : void
	  {
		  this.Self.necklaceExp = param1.pkg.readInt();
		  this.Self.necklaceExpAdd = param1.pkg.readInt();
	  }
   }
}
