package ddt.data.goods
{
   import ddt.events.GoodsEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import road7th.utils.DateUtils;
   import store.forge.wishBead.WishBeadManager;
   import store.forge.wishBead.WishChangeInfo;
   import gemstone.info.GemstListInfo;
   import ddt.data.EquipType;
   
   public class InventoryItemInfo extends ItemTemplateInfo
   {
      
      private static var _isTimerStarted:Boolean = false;
      
      private static var _temp_Instances:Array = new Array();
       
	  private var _curExp:int;
	  
      private var _checkTimeOutTimer:Timer;
      
      private var _checkColorValidTimer:Timer;
      
      public var ItemID:Number;
      
      public var UserID:Number;
      
      public var IsBinds:Boolean;
      
      public var IsVisleBound:Boolean = true;
      
      public var isDeleted:Boolean;
      
      public var BagType:int;
      
      public var type:int;
      
      public var isInvalid:Boolean;
      
      public var lock:Boolean = false;
      
      public var isMoveSpace:Boolean = true;
      
      public var Color:String;
      
      public var Skin:String;
      
      private var _isUsed:Boolean;
      
      public var BeginDate:String;
      
      protected var _ValidDate:Number;
      
      private var _DiscolorValidDate:String;
      
      private var atLeastOnHour:Boolean;
      
      private var _count:int = 1;
      
      public var _StrengthenLevel:int;
      
      private var _isGold:Boolean;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var Boold:int;
      
      public var Bless:int;
      
      private var _goldValidDate:int;
      
      private var _goldBeginTime:String;
      
      public var IsJudge:Boolean;
      
      public var Place:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var lockType:int;
      
      public var Hole1:int = -1;
      
      public var Hole2:int = -1;
      
      public var Hole3:int = -1;
      
      public var Hole4:int = -1;
      
      public var Hole5:int = -1;
      
      public var Hole6:int = -1;
      
      public var Hole5Level:int;
      
      public var Hole5Exp:int = 0;
      
      public var Hole6Level:int;
      
      public var Hole6Exp:int = 0;
      
      public var _StrengthenExp:int;
	  
	  public var gemstoneList:Vector.<GemstListInfo>;
	  
	  public var latentEnergyCurStr:String = "0,0,0,0";
	  
	  public var latentEnergyNewStr:String = "0,0,0,0";
	  
	  public var latentEnergyEndTime:Date;
	  
	  public var isShowBind:Boolean = true;
	  
	  public var cellLocked:Boolean;
	  
	  public var fromBag:Boolean = false;
      
      public function InventoryItemInfo()
      {
         super();
         if(!_isTimerStarted)
         {
            _temp_Instances.push(this);
         }
      }
      
      public static function startTimer() : void
      {
         var _loc1_:InventoryItemInfo = null;
         if(!_isTimerStarted)
         {
            _isTimerStarted = true;
            for each(_loc1_ in _temp_Instances)
            {
               _loc1_.updateRemainDate();
            }
            _temp_Instances = null;
         }
      }
      
      public function get IsUsed() : Boolean
      {
         return this._isUsed;
      }
      
      public function set IsUsed(param1:Boolean) : void
      {
         if(this._isUsed == param1)
         {
            return;
         }
         this._isUsed = param1;
         if(this._isUsed && _isTimerStarted)
         {
            this.updateRemainDate();
         }
      }
      
      public function set ValidDate(param1:Number) : void
      {
         this._ValidDate = param1;
      }
      
      public function get ValidDate() : Number
      {
         return this._ValidDate;
      }
      
      public function getRemainDate() : Number
      {
		  var bg:Date = null;
		  var diff:Number = NaN;
		  if(this.ValidDate == 0)
		  {
			  return int.MAX_VALUE;
		  }
		  if(!this._isUsed)
		  {
			  return this.ValidDate;
		  }
		  bg = DateUtils.getDateByStr(this.BeginDate);
		  diff = TimeManager.Instance.TotalDaysToNow(bg);
		  diff = diff < 0 ? Number(0):Number(diff);
		  return this.ValidDate - diff;
      }
      
      public function getColorValidDate() : Number
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(!this._isUsed)
         {
            return int.MAX_VALUE;
         }
         _loc1_ = DateUtils.getDateByStr(this.DiscolorValidDate);
         return Number(TimeManager.Instance.TotalDaysToNow(_loc1_) * -1);
      }
      
      public function set DiscolorValidDate(param1:String) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         this._DiscolorValidDate = param1;
         if(RefineryLevel >= 3 && this._isUsed)
         {
            _loc2_ = DateUtils.getDateByStr(this.DiscolorValidDate);
            _loc3_ = _loc2_.time - TimeManager.Instance.Now().time;
            if(_loc3_ <= 0)
            {
               SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
            }
            else
            {
               this.updateDiscolorValidDate();
            }
         }
      }
      
      public function get DiscolorValidDate() : String
      {
         return this._DiscolorValidDate;
      }
      
      private function updateDiscolorValidDate() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this.DiscolorValidDate);
         var _loc2_:Number = _loc1_.time - TimeManager.Instance.Now().time;
         if(this._checkColorValidTimer != null)
         {
            this._checkColorValidTimer.stop();
            this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
            this._checkColorValidTimer = null;
         }
         this._checkColorValidTimer = new Timer(_loc2_,1);
         this._checkColorValidTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.start();
      }
      
      private function updateRemainDate() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         if(this.ValidDate != 0 && this._isUsed)
         {
            _loc1_ = DateUtils.getDateByStr(this.BeginDate);
            _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_);
            _loc3_ = this.ValidDate - _loc2_;
            if(_loc3_ > 0)
            {
               if(this._checkTimeOutTimer != null)
               {
                  this._checkTimeOutTimer.stop();
                  this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
                  this._checkTimeOutTimer = null;
               }
               this.atLeastOnHour = _loc3_ * 24 > 1;
               _loc4_ = !!this.atLeastOnHour ? uint(uint(_loc3_ * TimeManager.DAY_TICKS - 1 * 60 * 60 * 1000)) : uint(uint(_loc3_ * TimeManager.DAY_TICKS));
               this._checkTimeOutTimer = new Timer(_loc4_,1);
               this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
               this._checkTimeOutTimer.start();
            }
            else
            {
               if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
               {
                  if(PlayerManager.Instance.Self.pets.length > 0)
                  {
                     for(_loc5_ in PlayerManager.Instance.Self.pets)
                     {
                        SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[_loc5_].Place,this.Place);
                     }
                  }
                  return;
               }
			   if(this.BagType > 51)
			   {
				   SocketManager.Instance.out.sendErrorMsg("BagType updateRemainDate: " + this.BagType);
			   }
               SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            }
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._checkTimeOutTimer.stop();
         if(!this.IsBinds)
         {
            return;
         }
         if(this.atLeastOnHour)
         {
            this._checkTimeOutTimer.delay = 10000 + 1 * 60 * 60 * 1000;
         }
         else
         {
            this._checkTimeOutTimer.delay = 10000;
         }
         this._checkTimeOutTimer.reset();
         this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
         this._checkTimeOutTimer.start();
      }
      
      private function _timerColorComplete(param1:TimerEvent) : void
      {
         this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.stop();
         SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
      }
      
      private function __sendGoodsTimeOut(param1:TimerEvent) : void
      {
         var _loc2_:* = undefined;
         if(StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
            {
               if(PlayerManager.Instance.Self.pets.length > 0)
               {
                  for(_loc2_ in PlayerManager.Instance.Self.pets)
                  {
                     SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[_loc2_].Place,this.Place);
                  }
               }
               return;
            }
			if(this.BagType > 51)
			{
				SocketManager.Instance.out.sendErrorMsg("BagType __sendGoodsTimeOut:" + this.BagType);
			}
            SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
            this._checkTimeOutTimer.stop();
         }
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(param1:int) : void
      {
         if(this._count == param1)
         {
            return;
         }
         this._count = param1;
         dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE,"Count",this._count));
      }
      
      public function clone() : InventoryItemInfo
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         return _loc1_.readObject();
      }
      
      public function set StrengthenLevel(param1:int) : void
      {
         this._StrengthenLevel = param1;
      }
      
      public function get StrengthenLevel() : int
      {
         return this._StrengthenLevel;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(param1:Boolean) : void
      {
         var _loc2_:WishChangeInfo = null;
         this._isGold = param1;
         if(this._isGold)
         {
            _loc2_ = WishBeadManager.instance.getWishInfoByTemplateID(TemplateID,CategoryID);
            if(!_loc2_)
            {
               return;
            }
            this.StrengthenLevel = _loc2_.Strengthen == 13 ? int(int(_loc2_.Strengthen)) : int(int(this.StrengthenLevel));
            Attack = _loc2_.Attack > 0 ? int(int(_loc2_.Attack)) : int(int(Attack));
            Defence = _loc2_.Defence > 0 ? int(int(_loc2_.Defence)) : int(int(Defence));
            Agility = _loc2_.Agility > 0 ? int(int(_loc2_.Agility)) : int(int(Agility));
            Luck = _loc2_.Luck > 0 ? int(int(_loc2_.Luck)) : int(int(Luck));
            this.Damage = _loc2_.Damage >= 0 ? int(int(_loc2_.Damage)) : int(int(this.Damage));
            this.Guard = _loc2_.Guard >= 0 ? int(int(_loc2_.Guard)) : int(int(this.Guard));
            this.Boold = _loc2_.Boold >= 0 ? int(int(_loc2_.Boold)) : int(int(this.Boold));
            this.Bless = _loc2_.BlessID;
            Pic = _loc2_.Pic != "" ? _loc2_.Pic : Pic;
         }
      }
      
      public function get goldValidDate() : int
      {
         return this._goldValidDate;
      }
      
      public function set goldValidDate(param1:int) : void
      {
         this._goldValidDate = param1;
      }
      
      public function get goldBeginTime() : String
      {
         return this._goldBeginTime;
      }
      
      public function set goldBeginTime(param1:String) : void
      {
         this._goldBeginTime = param1;
      }
      
      public function getGoldRemainDate() : Number
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._goldBeginTime);
         var _loc2_:Number = TimeManager.Instance.TotalDaysToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? Number(Number(0)) : Number(Number(_loc2_));
         return this.goldValidDate - _loc2_;
      }
      
      public function set StrengthenExp(param1:int) : void
      {
         this._StrengthenExp = param1;
      }
      
      public function get StrengthenExp() : int
      {
         return this._StrengthenExp;
      }
	  
	  public function get isHasLatentEnergy() : Boolean
	  {
		  if(!this.latentEnergyEndTime || this.latentEnergyEndTime.getTime() <= TimeManager.Instance.Now().getTime())
		  {
			  return false;
		  }
		  var _loc1_:Array = this.latentEnergyCurList;
		  if(_loc1_[0] == "0" || _loc1_[1] == "0" || _loc1_[2] == "0" || _loc1_[3] == "0")
		  {
			  return false;
		  }
		  return true;
	  }
	  
	  public function get latentEnergyCurList() : Array
	  {
		  if(!this.isCanLatentEnergy)
		  {
			  this.latentEnergyCurStr = "0,0,0,0";
		  }
		  if(this.latentEnergyCurStr == "")
		  {
			  this.latentEnergyCurStr = "0,0,0,0";
		  }
		  return this.latentEnergyCurStr.split(",");
	  }
	  
	  public function get latentEnergyNewList() : Array
	  {
		  if(this.latentEnergyNewStr == "")
		  {
			  this.latentEnergyNewStr = "0,0,0,0";
		  }
		  if(!this.isHasLatentEnergy)
		  {
			  this.latentEnergyNewStr = "0,0,0,0";
		  }
		  return this.latentEnergyNewStr.split(",");
	  }
	  
	  public function get isHasLatenetEnergyNew() : Boolean
	  {
		  var _loc1_:Array = this.latentEnergyNewList;
		  if(_loc1_[0] == "0" || _loc1_[1] == "0" || _loc1_[2] == "0" || _loc1_[3] == "0")
		  {
			  return false;
		  }
		  return true;
	  }
	  
	  public function get isCanLatentEnergy() : Boolean
	  {
		  if(CategoryID == EquipType.HAIR || CategoryID == EquipType.SUITS || CategoryID == EquipType.GLASS || CategoryID == EquipType.EFF || CategoryID == EquipType.FACE || CategoryID == EquipType.WING)
		  {
			  return true;
		  }
		  return true;
	  }
	  
	  public function get hasComposeAttribte() : Boolean
	  {
		  return this.AttackCompose > 0 || this.DefendCompose > 0 || this.LuckCompose > 0 || this.AgilityCompose > 0;
	  }
	  
	  public function get curExp() : int
	  {
		  return this._curExp;
	  }
	  
	  public function set curExp(param1:int) : void
	  {
		  this._curExp = param1;
	  }
   }
}
