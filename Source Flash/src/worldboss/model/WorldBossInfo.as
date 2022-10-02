package worldboss.model
{
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import worldboss.player.PlayerVO;
   
   public class WorldBossInfo extends EventDispatcher
   {
       
      
      private var _total_Blood:Number;
      
      private var _current_Blood:Number;
      
      private var _isLiving:Boolean;
      
      private var _begin_time:Date;
      
      private var _fight_time:int;
      
      private var _end_time:Date;
      
      private var _fightOver:Boolean;
      
      private var _room_close:Boolean;
      
      private var _currentState:int = 0;
      
      private var _ticketID:int;
      
      private var _need_ticket_count:int;
      
      private var _cutValue:Number;
      
      private var _name:String;
      
      private var _timeCD:int;
      
      private var _reviveMoney:int;
      
      private var _myPlayerVO:PlayerVO;
      
      private var _playerDefaultPos:Point;
      
      private var _buffArray:Array;
      
      public function WorldBossInfo()
      {
         this._buffArray = new Array();
         super();
      }
      
      public function set total_Blood(param1:Number) : void
      {
         this._total_Blood = param1;
      }
      
      public function get total_Blood() : Number
      {
         return this._total_Blood;
      }
      
      public function set current_Blood(param1:Number) : void
      {
         if(this._current_Blood == param1)
         {
            this._cutValue = -1;
            return;
         }
         this._cutValue = this._current_Blood - param1;
         this._current_Blood = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get current_Blood() : Number
      {
         return this._current_Blood;
      }
      
      public function set isLiving(param1:Boolean) : void
      {
         this._isLiving = param1;
         if(!this._isLiving)
         {
            this.current_Blood = 0;
         }
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      public function get begin_time() : Date
      {
         return this._begin_time;
      }
      
      public function set begin_time(param1:Date) : void
      {
         this._begin_time = param1;
      }
      
      public function get end_time() : Date
      {
         return this._end_time;
      }
      
      public function set end_time(param1:Date) : void
      {
         this._end_time = param1;
      }
      
      public function get fight_time() : int
      {
         return this._fight_time;
      }
      
      public function set fight_time(param1:int) : void
      {
         this._fight_time = param1;
      }
      
      public function getLeftTime() : int
      {
         var _loc1_:Number = TimeManager.Instance.TotalSecondToNow(this.begin_time);
         if(_loc1_ > 0 && _loc1_ < this.fight_time * 60)
         {
            return this.fight_time * 60 - _loc1_;
         }
         return 0;
      }
      
      public function get fightOver() : Boolean
      {
         return this._fightOver;
      }
      
      public function set fightOver(param1:Boolean) : void
      {
         this._fightOver = param1;
      }
      
      public function get roomClose() : Boolean
      {
         return this._room_close;
      }
      
      public function set roomClose(param1:Boolean) : void
      {
         this._room_close = param1;
      }
      
      public function get currentState() : int
      {
         return this._currentState;
      }
      
      public function set currentState(param1:int) : void
      {
         this._currentState = param1;
      }
      
      public function set ticketID(param1:int) : void
      {
         this._ticketID = param1;
      }
      
      public function get ticketID() : int
      {
         return this._ticketID;
      }
      
      public function set need_ticket_count(param1:int) : void
      {
         this._need_ticket_count = param1;
      }
      
      public function get need_ticket_count() : int
      {
         return this._need_ticket_count;
      }
      
      public function get cutValue() : Number
      {
         return this._cutValue;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set timeCD(param1:int) : void
      {
         this._timeCD = param1;
      }
      
      public function get timeCD() : int
      {
         return this._timeCD;
      }
      
      public function set reviveMoney(param1:int) : void
      {
         this._reviveMoney = param1;
      }
      
      public function get reviveMoney() : int
      {
         return this._reviveMoney;
      }
      
      public function get buffArray() : Array
      {
         return this._buffArray;
      }
      
      public function getbuffInfoByID(param1:int) : WorldBossBuffInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buffArray.length)
         {
            if(param1 == (this._buffArray[_loc2_] as WorldBossBuffInfo).ID)
            {
               return this._buffArray[_loc2_];
            }
            _loc2_++;
         }
         return new WorldBossBuffInfo();
      }
      
      public function set myPlayerVO(param1:PlayerVO) : void
      {
         this._myPlayerVO = param1;
      }
      
      public function get myPlayerVO() : PlayerVO
      {
         return this._myPlayerVO;
      }
      
      public function set playerDefaultPos(param1:Point) : void
      {
         this._playerDefaultPos = param1;
      }
      
      public function get playerDefaultPos() : Point
      {
         return this._playerDefaultPos;
      }
   }
}
