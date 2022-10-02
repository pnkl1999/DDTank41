package calendar
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.core.Disposeable;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   [Event(name="LuckyNumChanged",type="calendar.CalendarEvent")]
   [Event(name="SignCountChanged",type="calendar.CalendarEvent")]
   [Event(name="TodayChanged",type="calendar.CalendarEvent")]
   public class CalendarModel extends EventDispatcher implements Disposeable
   {
      
      public static const Current:int = 1;
      
      public static const NewAward:int = 2;
      
      public static const Received:int = 3;
      
      public static const Calendar:int = 1;
      
      public static const Activity:int = 2;
      
      public static const MS_of_Day:int = 86400000;
       
      
      private var _luckyNum:int;
      
      private var _myLuckyNum:int;
      
      private var _selectedActives:ActiveEventsInfo;
      
      private var _eventActives:Array;
      
      private var _signCount:int = 0;
      
      private var _awardCounts:Array;
      
      private var _awards:Array;
      
      private var _today:Date;
      
      private var _dayLog:Dictionary;
      
      public function CalendarModel(param1:Date, param2:int, param3:Dictionary, param4:Array, param5:Array, param6:Array)
      {
         super();
         this._today = param1;
         this._signCount = param2;
         this._dayLog = param3;
         this._awards = param4;
         this._awardCounts = param5;
         this._eventActives = param6;
         this._selectedActives = this._eventActives[0];
      }
      
      public static function getMonthMaxDay(param1:int, param2:int) : int
      {
         switch(param1)
         {
            case 0:
               return 31;
            case 1:
               if(param2 % 4 == 0)
               {
                  return 29;
               }
               return 28;
               break;
            case 2:
               return 31;
            case 3:
               return 30;
            case 4:
               return 31;
            case 5:
               return 30;
            case 6:
               return 31;
            case 7:
               return 31;
            case 8:
               return 30;
            case 9:
               return 31;
            case 10:
               return 30;
            case 11:
               return 31;
            default:
               return 0;
         }
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function set luckyNum(param1:int) : void
      {
         if(this._luckyNum == param1)
         {
            return;
         }
         this._luckyNum = param1;
         dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
      }
      
      public function get myLuckyNum() : int
      {
         return this._myLuckyNum;
      }
      
      public function set myLuckyNum(param1:int) : void
      {
         if(this._myLuckyNum == param1)
         {
            return;
         }
         this._myLuckyNum = param1;
         dispatchEvent(new CalendarEvent(CalendarEvent.LuckyNumChanged));
      }
      
      public function get selectedActives() : ActiveEventsInfo
      {
         return this._selectedActives;
      }
      
      public function get eventActives() : Array
      {
         return this._eventActives;
      }
      
      public function get signCount() : int
      {
         return this._signCount;
      }
      
      public function set signCount(param1:int) : void
      {
         if(this._signCount == param1)
         {
            return;
         }
         this._signCount = param1;
         dispatchEvent(new CalendarEvent(CalendarEvent.SignCountChanged));
      }
      
      public function get awardCounts() : Array
      {
         return this._awardCounts;
      }
      
      public function get awards() : Array
      {
         return this._awards;
      }
      
      public function get today() : Date
      {
         return this._today;
      }
      
      public function set today(param1:Date) : void
      {
         if(this._today == param1)
         {
            return;
         }
         this._today = param1;
         dispatchEvent(new CalendarEvent(CalendarEvent.TodayChanged));
      }
      
      public function get dayLog() : Dictionary
      {
         return this._dayLog;
      }
      
      public function set dayLog(param1:Dictionary) : void
      {
         if(this._dayLog == param1)
         {
            return;
         }
         this._dayLog = param1;
         dispatchEvent(new CalendarEvent(CalendarEvent.DayLogChanged));
      }
      
      public function hasSigned(param1:Date) : Boolean
      {
         return this._dayLog && param1.fullYear == this._today.fullYear && param1.month == this._today.month && this._dayLog[param1.date.toString()] == "True";
      }
      
      public function hasReceived(param1:int) : Boolean
      {
         if(param1 <= this._signCount)
         {
            return true;
         }
         return false;
      }
      
      public function dispose() : void
      {
      }
   }
}
