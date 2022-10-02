package ddt.data.player
{
   import com.hurlant.util.Base64;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PVEMapPermissionManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.GoodUtils;
   import ddt.view.buff.BuffControl;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import ddt.view.goods.AddPricePanel;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import store.data.StoreEquipExperience;
   import store.equipGhost.data.EquipGhostData;
   
   public class SelfInfo extends PlayerInfo
   {
      
      public static const PET:String = "Pets";
      
      private static const buffScanTime:int = 60;
       
      
      public var CivilPlayerList:Array;
      
      private var _timer:Timer;
      
      private var _questionOne:String;
      
      private var _questionTwo:String;
      
      private var _leftTimes:int = 5;
      
      public var hasPopUPVipWeeklyAwards:Boolean;
      
      public var IsNovice:Boolean;
      
      public var rid:String;
      
      public var _hasPopupLeagueNotice:Boolean;
      
      public var baiduEnterCode:String;
      
      private var _marryInfoID:int;
      
      private var _civilIntroduction:String;
      
      private var _isPublishEquit:Boolean;
      
      private var _bagPwdState:Boolean;
      
      private var _bagLocked:Boolean;
      
      private var _shouldPassword:Boolean;
      
      private var _isFirst:int;
      
      public var IsBanChat:Boolean;
      
      public var _props:DictionaryData;
      
      private var FirstLoaded:Boolean = false;
      
      private var _questList:Array;
      
      public var PropBag:BagInfo;
      
      public var FightBag:BagInfo;
      
      public var TempBag:BagInfo;
      
      public var ConsortiaBag:BagInfo;
      
      public var CaddyBag:BagInfo;
      
      public var farmBag:BagInfo;
      
      public var vegetableBag:BagInfo;
      
      public var BankBag:BagInfo;
      
      private var _overtimeList:Array;
      
      private var sendedGrade:Array;
      
      public var StoreBag:BagInfo;
      
      private var _weaklessGuildProgress:ByteArray;
      
      public var _canTakeVipReward:Boolean;
      
      private var _VIPExpireDay:Object;
      
      public var LastDate:Object;
      
      public var isOldPlayerHasValidEquitAtLogin:Boolean;
      
      private var _vipNextLevelDaysNeeded:int;
      
      public var systemDate:Object;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      private var _gold:Number;
      
      private var _money:Number;
      
      private var _gift:Number;
      
      private var _medal:Number;
      
      private var _isFarmHelper:Boolean;
      
      private var _petScore:Number = 0;
	  
	  private var _myHonor:int;
      
      public function SelfInfo()
      {
         this.CivilPlayerList = new Array();
         this.sendedGrade = [];
         super();
         this.PropBag = new BagInfo(BagInfo.PROPBAG,48);
         this.FightBag = new BagInfo(BagInfo.FIGHTBAG,48);
         this.TempBag = new BagInfo(BagInfo.TEMPBAG,48);
         this.ConsortiaBag = new BagInfo(BagInfo.CONSORTIA,100);
         this.StoreBag = new BagInfo(BagInfo.STOREBAG,11);
         this.CaddyBag = new BagInfo(BagInfo.CADDYBAG,99);
         this.BankBag = new BagInfo(BagInfo.BANKBAG,100);
         this.farmBag = new BagInfo(BagInfo.FARM,100);
         this.vegetableBag = new BagInfo(BagInfo.VEGETABLE,100);
         _isSelf = true;
      }
      
      override public function set NickName(param1:String) : void
      {
         super.NickName = param1;
      }
      
      public function set MarryInfoID(param1:int) : void
      {
         this._marryInfoID = param1;
         onPropertiesChanged("MarryInfoID");
      }
      
      public function get MarryInfoID() : int
      {
         return this._marryInfoID;
      }
      
      public function set Introduction(param1:String) : void
      {
         this._civilIntroduction = param1;
         onPropertiesChanged("Introduction");
      }
      
      public function get Introduction() : String
      {
         if(this._civilIntroduction == null)
         {
            this._civilIntroduction = "";
         }
         return this._civilIntroduction;
      }
      
      public function set IsPublishEquit(param1:Boolean) : void
      {
         this._isPublishEquit = param1;
         onPropertiesChanged("IsPublishEquit");
      }
      
      public function get IsPublishEquit() : Boolean
      {
         return this._isPublishEquit;
      }
      
      public function set bagPwdState(param1:Boolean) : void
      {
         this._bagPwdState = param1;
      }
      
      public function get bagPwdState() : Boolean
      {
         return this._bagPwdState;
      }
      
      public function set bagLocked(param1:Boolean) : void
      {
         this._bagLocked = param1;
         onPropertiesChanged("bagLocked");
      }
      
      public function get bagLocked() : Boolean
      {
         if(!this._bagPwdState)
         {
            return false;
         }
         return this._bagLocked;
      }
      
      public function get shouldPassword() : Boolean
      {
         return this._shouldPassword;
      }
      
      public function set IsFirst(param1:int) : void
      {
         this._isFirst = param1;
      }
      
      public function get IsFirst() : int
      {
         return this._isFirst;
      }
      
      public function set shouldPassword(param1:Boolean) : void
      {
         this._shouldPassword = param1;
      }
      
      public function onReceiveTypes(param1:String) : void
      {
         dispatchEvent(new BagEvent(param1,new Dictionary()));
      }
      
      public function resetProps() : void
      {
         this._props = new DictionaryData();
      }
      
      public function findOvertimeItems(param1:Number = 0) : Array
      {
         return this.getOverdueItems();
      }
      
      public function getOverdueItems() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = GoodUtils.getOverdueItemsFrom(this.PropBag.items);
         var _loc4_:Array = GoodUtils.getOverdueItemsFrom(this.FightBag.items);
         var _loc5_:Array = GoodUtils.getOverdueItemsFrom(Bag.items);
         var _loc6_:Array = GoodUtils.getOverdueItemsFrom(this.ConsortiaBag.items);
         _loc1_ = _loc1_.concat(_loc3_[0],_loc4_[0],[],_loc5_[0]);
         _loc2_ = _loc2_.concat(_loc3_[1],_loc4_[1],[],_loc5_[1]);
         return [_loc1_,_loc2_];
      }
      
      public function findItemCount(param1:int) : int
      {
         return Bag.getItemCountByTemplateId(param1);
      }
      
      public function loadPlayerItem() : void
      {
      }
      
      public function loadRelatedPlayersInfo() : void
      {
         if(this.FirstLoaded)
         {
            return;
         }
         this.FirstLoaded = true;
      }
      
      private function loadBodyThingComplete(param1:DictionaryData, param2:DictionaryData) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BuffInfo = null;
         for each(_loc3_ in param1)
         {
            Bag.addItem(_loc3_);
         }
         for each(_loc4_ in param2)
         {
            super.addBuff(_loc4_);
         }
      }
      
      public function getPveMapPermission(param1:int, param2:int) : Boolean
      {
         return PVEMapPermissionManager.Instance.getPermission(param1,param2,PvePermission);
      }
      
      public function canEquip(param1:InventoryItemInfo) : Boolean
      {
         if(!EquipType.canEquip(param1))
         {
            if(!isNaN(param1.CategoryID))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.this"));
            }
         }
         else if(param1.getRemainDate() <= 0)
         {
            AddPricePanel.Instance.setInfo(param1,true);
            AddPricePanel.Instance.show();
         }
         else if(param1.NeedSex != 0 && param1.NeedSex != (!!Sex ? 1 : 2))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.object"));
         }
         else
         {
            if(param1.CategoryID == EquipType.HEALSTONE)
            {
               if(Grade >= int(param1.Property1))
               {
                  return true;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",param1.Property1));
               return false;
            }
            if(param1.NeedLevel <= Grade)
            {
               return true;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
         }
         return false;
      }
      
      override public function addBuff(param1:BuffInfo) : void
      {
         super.addBuff(param1);
         if(!this._timer)
         {
            this._timer = new Timer(1000 * 60);
            this._timer.addEventListener(TimerEvent.TIMER,this.__refreshSelfInfo);
            this._timer.start();
         }
      }
      
      private function __refreshSelfInfo(param1:TimerEvent) : void
      {
         this.refreshBuff();
      }
      
      private function refreshBuff() : void
      {
         var _loc1_:BuffInfo = null;
         var _loc2_:ChatData = null;
         for each(_loc1_ in _buffInfo)
         {
            if(!BuffControl.isPayBuff(_loc1_))
            {
               if(_loc1_.ValidDate - Math.floor((TimeManager.Instance.Now().time - _loc1_.BeginData.time) / (1000 * 60)) - 1 == buffScanTime)
               {
                  _loc2_ = new ChatData();
                  _loc2_.channel = ChatInputView.SYS_TIP;
                  _loc2_.msg = LanguageMgr.GetTranslation("tank.view.buffInfo.outDate",_loc1_.buffName,buffScanTime);
                  ChatManager.Instance.chat(_loc2_);
               }
            }
         }
      }
      
      public function achievedQuest(param1:int) : Boolean
      {
         if(this._questList && this._questList[param1])
         {
            return true;
         }
         return false;
      }
      
      public function unlockAllBag() : void
      {
         Bag.unLockAll();
         this.PropBag.unLockAll();
      }
      
      public function getBag(param1:int) : BagInfo
      {
         switch(param1)
         {
            case BagInfo.EQUIPBAG:
               return Bag;
            case BagInfo.PROPBAG:
               return this.PropBag;
            case BagInfo.FIGHTBAG:
               return this.FightBag;
            case BagInfo.TEMPBAG:
               return this.TempBag;
            case BagInfo.CONSORTIA:
               return this.ConsortiaBag;
            case BagInfo.STOREBAG:
               return this.StoreBag;
            case BagInfo.CADDYBAG:
               return this.CaddyBag;
            case BagInfo.FARM:
               return this.farmBag;
            case BagInfo.VEGETABLE:
               return this.vegetableBag;
            case BagInfo.BANKBAG:
               return this.BankBag;
            default:
               return null;
         }
      }
      
      public function get questionOne() : String
      {
         return this._questionOne;
      }
      
      public function set questionOne(param1:String) : void
      {
         this._questionOne = param1;
      }
      
      public function get questionTwo() : String
      {
         return this._questionTwo;
      }
      
      public function set questionTwo(param1:String) : void
      {
         this._questionTwo = param1;
      }
      
      public function get leftTimes() : int
      {
         return this._leftTimes;
      }
      
      public function set leftTimes(param1:int) : void
      {
         this._leftTimes = param1;
      }
      
      public function getMedalNum() : int
      {
         var _loc1_:int = this.PropBag.getItemCountByTemplateId(EquipType.MEDAL);
         var _loc2_:int = this.ConsortiaBag.getItemCountByTemplateId(EquipType.MEDAL);
         var _loc3_:int = this.BankBag.getItemCountByTemplateId(EquipType.MEDAL);
         return _loc1_ + _loc2_ + _loc3_;
      }
      
      public function get OvertimeListByBody() : Array
      {
         return PlayerManager.Instance.Self.Bag.findOvertimeItemsByBody();
      }
      
      public function sendOverTimeListByBody() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:* = undefined;
         var _loc1_:Array = PlayerManager.Instance.Self.Bag.findOvertimeItemsByBodyII();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
            {
               if(PlayerManager.Instance.Self.pets.length > 0)
               {
                  for(_loc3_ in PlayerManager.Instance.Self.pets)
                  {
                     SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[_loc3_].Place,_loc2_.Place);
                  }
               }
               return;
            }
			if(_loc2_.BagType > 51)
			{
				SocketManager.Instance.out.sendErrorMsg("BagType sendOverTimeListByBody:" + _loc2_.BagType);
			}
            SocketManager.Instance.out.sendItemOverDue(_loc2_.BagType,_loc2_.Place);
         }
      }
      
      override public function set Grade(param1:int) : void
      {
         super.Grade = param1;
         if(IsUpGrade && PathManager.solveExternalInterfaceEnabel() && this.sendedGrade.indexOf(param1) == -1)
         {
            ExternalInterfaceManager.sendToAgent(2,ID,NickName,ServerManager.Instance.zoneName,Grade);
            this.sendedGrade.push(Grade);
         }
      }
      
      public function get weaklessGuildProgress() : ByteArray
      {
         return this._weaklessGuildProgress;
      }
      
      public function set weaklessGuildProgress(param1:ByteArray) : void
      {
         this._weaklessGuildProgress = param1;
      }
      
      public function set weaklessGuildProgressStr(param1:String) : void
      {
         this.weaklessGuildProgress = Base64.decodeToByteArray(param1);
      }
      
      public function IsWeakGuildFinish(param1:int) : Boolean
      {
         if(!WeakGuildManager.Instance.switchUserGuide && param1 != Step.GHOST_FIRST && param1 != Step.GHOSTPROP_FIRST)
         {
            return true;
         }
         if(!this._weaklessGuildProgress || param1 > this._weaklessGuildProgress.length * 8 || param1 < 1)
         {
            return false;
         }
         if(this.bit(Step.OLD_PLAYER) && param1 != Step.GHOST_FIRST && param1 != Step.GHOSTPROP_FIRST)
         {
            return true;
         }
         return this.bit(param1);
      }
      
      private function bit(param1:int) : Boolean
      {
         param1--;
         var _loc2_:int = param1 / 8;
         var _loc3_:int = param1 % 8;
         var _loc4_:int = this._weaklessGuildProgress[_loc2_] & 1 << _loc3_;
         return _loc4_ != 0;
      }
      
      public function get canTakeVipReward() : Boolean
      {
         return this._canTakeVipReward;
      }
      
      public function set canTakeVipReward(param1:Boolean) : void
      {
         this._canTakeVipReward = param1;
         onPropertiesChanged("canTakeVipReward");
      }
      
      public function get VIPExpireDay() : Object
      {
         return this._VIPExpireDay;
      }
      
      public function set VIPExpireDay(param1:Object) : void
      {
         this._VIPExpireDay = param1;
         onPropertiesChanged("VipExpireDay");
      }
      
      public function set VIPNextLevelDaysNeeded(param1:int) : void
      {
         this._vipNextLevelDaysNeeded = param1;
         onPropertiesChanged("VIPNextLevelDaysNeeded");
      }
      
      public function get VIPNextLevelDaysNeeded() : int
      {
         return this._vipNextLevelDaysNeeded;
      }
      
      public function get VIPLeftDays() : int
      {
         return int(this.VipLeftHours / 24);
      }
      
      public function get VipLeftHours() : int
      {
         return int((this.VIPExpireDay.valueOf() - this.systemDate.valueOf()) / 3600000);
      }
      
      public function get isSameDay() : Boolean
      {
         if(this.LastDate.fullYear == this.systemDate.fullYear && this.LastDate.month == this.systemDate.month && this.LastDate.date == this.systemDate.date)
         {
            return true;
         }
         return false;
      }
      
      public function set consortiaInfo(param1:ConsortiaInfo) : void
      {
         if(this._consortiaInfo == param1)
         {
            return;
         }
         this.consortiaInfo.beginChanges();
         ObjectUtils.copyProperties(this.consortiaInfo,param1);
         this.consortiaInfo.commitChanges();
         onPropertiesChanged("consortiaInfo");
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         if(this._consortiaInfo == null)
         {
            this._consortiaInfo = new ConsortiaInfo();
         }
         return this._consortiaInfo;
      }
      
      public function get Gold() : Number
      {
         return this._gold;
      }
      
      public function set Gold(param1:Number) : void
      {
         if(this._gold == param1)
         {
            return;
         }
         this._gold = param1;
         onPropertiesChanged(PlayerInfo.GOLD);
      }
      
      public function get Money() : Number
      {
         return this._money;
      }
      
      public function set Money(param1:Number) : void
      {
         if(this._money == param1)
         {
            return;
         }
         this._money = param1;
         onPropertiesChanged(PlayerInfo.MONEY);
      }
      
      public function get Gift() : Number
      {
         return this._gift;
      }
      
      public function get petScore() : Number
      {
         return this._petScore;
      }
	  
	  public function set myHonor(param1:int) : void
	  {
		  this._myHonor = param1;
		  onPropertiesChanged("myHonor");
	  }
	  
	  public function get myHonor() : int
	  {
		  return this._myHonor;
	  }
      
      public function set petScore(param1:Number) : void
      {
         if(this._petScore == param1)
         {
            return;
         }
         this._petScore = param1;
         onPropertiesChanged(PlayerInfo.PETSCORE);
      }
      
      public function set Gift(param1:Number) : void
      {
         if(this._gift == param1)
         {
            return;
         }
         this._gift = param1;
         onPropertiesChanged(PlayerInfo.GIFT);
      }
      
      public function get medal() : Number
      {
         return this._medal;
      }
      
      public function set medal(param1:Number) : void
      {
         if(this._medal == param1)
         {
            return;
         }
         this._medal = param1;
         onPropertiesChanged(PlayerInfo.MEDAL);
      }
      
      public function get isFarmHelper() : Boolean
      {
         return this._isFarmHelper;
      }
      
      public function set isFarmHelper(param1:Boolean) : void
      {
         this._isFarmHelper = param1;
      }
      
      override public function get pets() : DictionaryData
      {
         if(_pets == null)
         {
            _pets = new DictionaryData();
            _pets.addEventListener("add",this.__petsDataChanged);
            _pets.addEventListener("remove",this.__petsDataChanged);
         }
         return _pets;
      }
      
      protected function __petsDataChanged(param1:DictionaryEvent) : void
      {
         onPropertiesChanged(PET);
      }
	  
	  public function isNewOnceFinish(param1:int) : Boolean
	  {
		  return this.bit(param1);
	  }
   }
}

class DateGeter
{
   
   public static var date:Date;
    
   
   function DateGeter()
   {
      super();
   }
}
