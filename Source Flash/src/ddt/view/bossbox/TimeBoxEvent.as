package ddt.view.bossbox
{
   import flash.events.Event;
   
   public class TimeBoxEvent extends Event
   {
      
      public static const UPDATETIMECOUNT:String = "updateTimeCount";
      
      public static const UPDATESMALLBOXBUTTONSTATE:String = "update_smallBoxButton_state";
       
      
      public var delaySumTime:int = 0;
      
      public var boxButtonShowType:int = 0;
      
      public function TimeBoxEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
