package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class TimeManager
   {
      
      public static const DAY_TICKS:Number = 1000 * 24 * 60 * 60;
      
      public static const HOUR_TICKS:Number = 1000 * 60 * 60;
      
      public static const Minute_TICKS:Number = 1000 * 60;
      
      public static const Second_TICKS:Number = 1000;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var CHANGE:String = "change";
      
      private static var _instance:TimeManager;
       
      
      private var _serverDate:Date;
      
      private var _serverTick:int;
      
      private var _enterFightTime:Number;
      
      private var _startGameTime:Date;
      
      private var _currentTime:Date;
      
      private var _totalGameTime:Number;
      
      public function TimeManager()
      {
         super();
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.removeEventListener(param1,param2);
      }
      
      public static function get Instance() : TimeManager
      {
         if(_instance == null)
         {
            _instance = new TimeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._serverDate = new Date();
         this._serverTick = getTimer();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE,this.__update);
      }
      
      private function __update(param1:CrazyTankSocketEvent) : void
      {
         this._serverTick = getTimer();
         this._serverDate = param1.pkg.readDate();
      }
      
      public function Now() : Date
      {
         return new Date(this._serverDate.getTime() + getTimer() - this._serverTick);
      }
      
      public function get serverDate() : Date
      {
         return this._serverDate;
      }
      
      public function get currentDay() : Number
      {
         return this.Now().getDay();
      }
      
      public function TimeSpanToNow(param1:Date) : Date
      {
         return new Date(Math.abs(this._serverDate.getTime() + getTimer() - this._serverTick - param1.time));
      }
      
      public function TotalDaysToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / DAY_TICKS;
      }
      
      public function TotalHoursToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / HOUR_TICKS;
      }
      
      public function TotalMinuteToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Minute_TICKS;
      }
      
      public function TotalSecondToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Second_TICKS;
      }
      
      public function TotalDaysToNow2(param1:Date) : Number
      {
         var _loc2_:Date = this.Now();
         _loc2_.setHours(0,0,0,0);
         var _loc3_:Date = new Date(param1.time);
         _loc3_.setHours(0,0,0,0);
         return (_loc2_.time - _loc3_.time) / DAY_TICKS;
      }
      
      public function set totalGameTime(param1:int) : void
      {
         this._totalGameTime = param1;
         _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
      }
      
      public function get totalGameTime() : int
      {
         return this._totalGameTime;
      }
      
      public function get enterFightTime() : Number
      {
         return this._enterFightTime;
      }
      
      public function set enterFightTime(param1:Number) : void
      {
         this._enterFightTime = param1;
      }
	  
	  public function getMaxRemainDateStr(param1:Date, param2:int = 1) : String
	  {
		  var _loc7_:String = null;
		  if(!param1)
		  {
			  return "0" + LanguageMgr.GetTranslation("second");
		  }
		  var _loc3_:Number = param1.getTime();
		  var _loc4_:Number = this.Now().getTime();
		  var _loc5_:Number = _loc3_ - _loc4_;
		  _loc5_ = _loc5_ - 10000 < 0?Number(_loc5_):Number(_loc5_ - 10000);
		  _loc5_ = _loc5_ < 0?Number(0):Number(_loc5_);
		  var _loc6_:int = 0;
		  if(_loc5_ / DAY_TICKS > 1)
		  {
			  if(param2 == 1)
			  {
				  _loc6_ = Math.floor(_loc5_ / DAY_TICKS);
			  }
			  else
			  {
				  _loc6_ = Math.ceil(_loc5_ / DAY_TICKS);
			  }
			  _loc7_ = _loc6_ + LanguageMgr.GetTranslation("day");
		  }
		  else if(_loc5_ / HOUR_TICKS > 1)
		  {
			  _loc6_ = _loc5_ / HOUR_TICKS;
			  _loc7_ = _loc6_ + LanguageMgr.GetTranslation("hour");
		  }
		  else if(_loc5_ / Minute_TICKS > 1)
		  {
			  _loc6_ = _loc5_ / Minute_TICKS;
			  _loc7_ = _loc6_ + LanguageMgr.GetTranslation("minute");
		  }
		  else
		  {
			  _loc6_ = _loc5_ / Second_TICKS;
			  _loc7_ = _loc6_ + LanguageMgr.GetTranslation("second");
		  }
		  return _loc7_;
	  }
   }
}
