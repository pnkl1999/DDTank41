package ddt.data
{
   import ddt.events.PlayerPropertyEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.utils.DateUtils;
   
   public class ConsortiaInfo extends EventDispatcher
   {
      
      public static const LEVEL:String = "level";
      
      public static const STORE_LEVEL:String = "storeLevel";
      
      public static const SHOP_LEVEL:String = "shopLevel";
      
      public static const BANK_LEVEL:String = "bankLevel";
      
      public static const RICHES:String = "riches";
      
      public static const DESCRIPTION:String = "description";
      
      public static const PLACARD:String = "placard";
      
      public static const CHAIRMANNAME:String = "chairmanName";
      
      public static const CONSORTIANAME:String = "consortiaName";
      
      public static const BADGE_ID:String = "badgeID";
      
      public static const BADGE_DATE:String = "badgedate";
      
      public static const COUNT:String = "count";
      
      public static const POLLOPEN:String = "pollOpen";
      
      public static const SKILL_LEVEL:String = "skillLevel";
      
      public static const IS_VOTING:String = "isVoting";
       
      
      public var ConsortiaID:int;
      
      private var _consortiaName:String = "";
      
      private var _badgeID:int = 0;
      
      private var _badgeBuyTime:String;
      
      private var _validDate:int;
      
      private var _IsVoting:Boolean;
      
      public var VoteRemainDay:int;
      
      public var CreatorID:int;
      
      public var CreatorName:String = "";
      
      public var ChairmanID:int;
      
      private var _chairmanName:String = "";
      
      public var MaxCount:int;
      
      public var CelebCount:int;
      
      public var BuildDate:String = "";
      
      public var IP:String;
      
      public var Port:int;
      
      private var _count:int;
      
      public var Repute:int;
      
      public var IsApply:Boolean;
      
      public var State:int;
      
      public var DeductDate:String;
      
      public var Honor:int;
      
      public var LastDayRiches:int;
      
      public var OpenApply:Boolean;
      
      public var FightPower:int;
      
      public var ChairmanTypeVIP:int;
      
      public var ChairmanVIPLevel:int;
      
      private var _PollOpen:Boolean;
      
      public var CharmGP:int;
      
      private var _Level:int;
      
      private var _storeLevel:int;
      
      private var _SmithLevel:int;
      
      private var _ShopLevel:int;
      
      private var _bufferLevel:int;
      
      private var _riches:int;
      
      private var _description:String;
      
      private var _placard:String = "";
      
      public var BadgeType:int;
      
      public var BadgeName:String;
      
      protected var _changeCount:int = 0;
      
      protected var _changedPropeties:Dictionary;
      
      public function ConsortiaInfo()
      {
         this._badgeBuyTime = DateUtils.dateFormat(new Date());
         this._changedPropeties = new Dictionary();
         super();
      }
      
      public function get ValidDate() : int
      {
         return this._validDate;
      }
      
      public function set ValidDate(param1:int) : void
      {
         this._validDate = param1;
      }
      
      public function get BadgeBuyTime() : String
      {
         return this._badgeBuyTime;
      }
      
      public function set BadgeBuyTime(param1:String) : void
      {
         this._badgeBuyTime = param1;
         this.onPropertiesChanged(BADGE_DATE);
      }
      
      public function get BadgeID() : int
      {
         return this._badgeID;
      }
      
      public function set BadgeID(param1:int) : void
      {
         this._badgeID = param1;
         this.onPropertiesChanged(BADGE_ID);
      }
      
      public function get ConsortiaName() : String
      {
         return this._consortiaName;
      }
      
      public function set ConsortiaName(param1:String) : void
      {
         if(this._consortiaName == param1)
         {
            return;
         }
         this._consortiaName = param1;
         this.onPropertiesChanged(CONSORTIANAME);
      }
      
      public function get IsVoting() : Boolean
      {
         return this._IsVoting;
      }
      
      public function set IsVoting(param1:Boolean) : void
      {
         this._IsVoting = param1;
         this.onPropertiesChanged(IS_VOTING);
      }
      
      public function get ChairmanName() : String
      {
         return this._chairmanName;
      }
      
      public function set ChairmanName(param1:String) : void
      {
         if(this._chairmanName == param1)
         {
            return;
         }
         this._chairmanName = param1;
         this.onPropertiesChanged(CHAIRMANNAME);
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
         this.onPropertiesChanged(COUNT);
      }
      
      public function get PollOpen() : Boolean
      {
         return this._PollOpen;
      }
      
      public function get ChairmanIsVIP() : Boolean
      {
         return this.ChairmanTypeVIP > 0;
      }
      
      public function set PollOpen(param1:Boolean) : void
      {
         if(this._PollOpen == param1)
         {
            return;
         }
         this._PollOpen = param1;
         this.onPropertiesChanged(POLLOPEN);
      }
      
      public function get Level() : int
      {
         return this._Level;
      }
      
      public function set Level(param1:int) : void
      {
         this._Level = param1;
         this.onPropertiesChanged(LEVEL);
      }
      
      public function set StoreLevel(param1:int) : void
      {
         this._storeLevel = param1;
         this.onPropertiesChanged(BANK_LEVEL);
      }
      
      public function get StoreLevel() : int
      {
         return this._storeLevel;
      }
      
      public function get SmithLevel() : int
      {
         return this._SmithLevel;
      }
      
      public function set SmithLevel(param1:int) : void
      {
         this._SmithLevel = param1;
         this.onPropertiesChanged(STORE_LEVEL);
      }
      
      public function get ShopLevel() : int
      {
         return this._ShopLevel;
      }
      
      public function set ShopLevel(param1:int) : void
      {
         this._ShopLevel = param1;
         this.onPropertiesChanged(SHOP_LEVEL);
      }
      
      public function get BufferLevel() : int
      {
         return this._bufferLevel;
      }
      
      public function set BufferLevel(param1:int) : void
      {
         this._bufferLevel = param1;
         this.onPropertiesChanged(SKILL_LEVEL);
      }
      
      public function set Riches(param1:int) : void
      {
         this._riches = param1;
         this.onPropertiesChanged(RICHES);
      }
      
      public function get Riches() : int
      {
         return this._riches;
      }
      
      public function get Description() : String
      {
         return this._description;
      }
      
      public function set Description(param1:String) : void
      {
         if(this._description == param1)
         {
            return;
         }
         this._description = param1;
         this.onPropertiesChanged(DESCRIPTION);
      }
      
      public function get Placard() : String
      {
         return this._placard;
      }
      
      public function set Placard(param1:String) : void
      {
         if(this._placard == param1)
         {
            return;
         }
         this._placard = param1;
         this.onPropertiesChanged(PLACARD);
      }
      
      public function beginChanges() : void
      {
         ++this._changeCount;
      }
      
      public function commitChanges() : void
      {
         --this._changeCount;
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      protected function onPropertiesChanged(param1:String = null) : void
      {
         if(param1 != null)
         {
            this._changedPropeties[param1] = true;
         }
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      public function updateProperties() : void
      {
         var _loc1_:Dictionary = this._changedPropeties;
         this._changedPropeties = new Dictionary();
         dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE,_loc1_));
      }
   }
}
