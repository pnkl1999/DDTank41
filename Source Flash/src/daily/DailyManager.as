package daily
{
   import calendar.CalendarManager;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   
   public class DailyManager
   {
      
      public static var list:Array;
      
      public static var list200:Array = new Array();
      
      public static var list201:Array = new Array();
      
      public static var list203:Array = new Array();
      
      public static var list205:Array = new Array();
      
      public static var list210:Array = new Array();
      
      private static var _instance:DailyManager;
       
      
      public function DailyManager()
      {
         super();
      }
      
      public static function setupDailyInfo(param1:DaylyGiveAnalyzer) : void
      {
         list = param1.list;
         CalendarManager.getInstance().setDailyInfo(param1);
      }
      
      public static function get Instance() : DailyManager
      {
         if(_instance == null)
         {
            _instance = new DailyManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
      }
   }
}
