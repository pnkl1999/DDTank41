package calendar
{
   import flash.events.Event;
   
   public class CalendarEvent extends Event
   {
      
      public static const SignCountChanged:String = "SignCountChanged";
      
      public static const TodayChanged:String = "TodayChanged";
      
      public static const DayLogChanged:String = "DayLogChanged";
      
      public static const LuckyNumChanged:String = "LuckyNumChanged";
       
      
      public function CalendarEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
