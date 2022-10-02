package ddt.data.fightLib
{
   import ddt.data.EquipType;
   import ddt.manager.FightLibManager;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class FightLibInfo extends EventDispatcher
   {
      
      public static const MEASHUR_SCREEN:int = 1;
      
      public static const TWENTY_DEGREE:int = 2;
      
      public static const SIXTY_FIVE_DEGREE:int = 3;
      
      public static const HIGH_THROW:int = 4;
      
      public static const HIGH_GAP:int = 5;
      
      public static const EASY:int = 0;
      
      public static const NORMAL:int = 1;
      
      public static const DIFFICULT:int = 2;
      
      private static const AWARD_GIFTS:Array = [100,300,500];
      
      private static const AWARD_EXP:Array = [2000,5000,8000];
      
      private static const AWARD_ITEMS:Array = [[{
         "id":11021,
         "number":4
      },{
         "id":11002,
         "number":4
      },{
         "id":11006,
         "number":4
      },{
         "id":11010,
         "number":4
      },{
         "id":11014,
         "number":4
      },{
         "id":11408,
         "number":4
      }],[{
         "id":11022,
         "number":4
      },{
         "id":11003,
         "number":4
      },{
         "id":11007,
         "number":4
      },{
         "id":11011,
         "number":4
      },{
         "id":11015,
         "number":4
      },{
         "id":11408,
         "number":4
      }],[{
         "id":11023,
         "number":4
      },{
         "id":11004,
         "number":4
      },{
         "id":11008,
         "number":4
      },{
         "id":11012,
         "number":4
      },{
         "id":11016,
         "number":4
      },{
         "id":11408,
         "number":4
      }]];
       
      
      private var _id:int;
      
      private var _name:String;
      
      private var _difficulty:int;
      
      private var _requiedLevel:int;
      
      private var _description:String;
      
      private var _mapID:int;
      
      private var _commit:int = 0;
      
      private var value1:int;
      
      private var value2:int;
      
      public function FightLibInfo()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get difficulty() : int
      {
         return this._difficulty;
      }
      
      public function set difficulty(param1:int) : void
      {
         this._difficulty = param1;
         if(this._commit <= 0)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get requiedLevel() : int
      {
         return this._requiedLevel;
      }
      
      public function set requiedLevel(param1:int) : void
      {
         this._requiedLevel = param1;
         if(this._commit <= 0)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function set mapID(param1:int) : void
      {
         this._mapID = param1;
      }
      
      public function beginChange() : void
      {
         ++this._commit;
      }
      
      public function commitChange() : void
      {
         --this._commit;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getAwardMedal() : int
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            _loc1_ = this.getAwardInfoItems();
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.id == EquipType.MEDAL)
               {
                  return _loc2_.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardGiftsNum() : int
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            _loc1_ = this.getAwardInfoItems();
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.id == EquipType.GIFT)
               {
                  return _loc2_.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardEXPNum() : int
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            _loc1_ = this.getAwardInfoItems();
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.id == EquipType.EXP)
               {
                  return _loc2_.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardItems() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Array = [];
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            _loc2_ = this.getAwardInfoItems();
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.id != EquipType.GIFT && _loc3_.id != EquipType.EXP)
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      private function getAwardInfoItems() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:FightLibAwardInfo = FightLibManager.Instance.getFightLibAwardInfoByID(this.id);
         switch(this.difficulty)
         {
            case EASY:
               _loc1_ = _loc2_.easyAward;
               break;
            case NORMAL:
               _loc1_ = _loc2_.normalAward;
               break;
            case DIFFICULT:
               _loc1_ = _loc2_.difficultAward;
         }
         return _loc1_;
      }
      
      private function initMissionValue() : void
      {
         var _loc1_:String = PlayerManager.Instance.Self.fightLibMission.substr((this.id - 1000) * 2,2);
         this.value1 = int(_loc1_.substr(0,1));
         this.value2 = int(_loc1_.substr(1,1));
      }
      
      public function get InfoCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 0;
      }
      
      public function get easyCanPlay() : Boolean
      {
         return this.InfoCanPlay;
      }
      
      public function get normalCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 1;
      }
      
      public function get difficultCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 2;
      }
      
      public function get easyAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 0;
      }
      
      public function get normalAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 1;
      }
      
      public function get difficultAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 2;
      }
   }
}
