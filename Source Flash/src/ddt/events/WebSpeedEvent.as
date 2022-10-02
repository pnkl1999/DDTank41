package ddt.events
{
   import flash.events.Event;
   
   public class WebSpeedEvent extends Event
   {
      
      public static const STATE_CHANE:String = "stateChange";
       
      
      public function WebSpeedEvent(param1:String)
      {
         super(param1,bubbles,cancelable);
      }
   }
}
