package lanternriddles.event
{
   import flash.events.Event;
   
   public class LanternEvent extends Event
   {
      
      public static const LANTERN_SELECT:String = "lanternSelect";
      
      public static const LANTERN_SETTIME:String = "lanternSettime";
       
      
      public var flag:Boolean;
      
      public var Time:String;
      
      public function LanternEvent(param1:String, param2:String = "")
      {
         super(param1,bubbles,cancelable);
         this.Time = param2;
      }
   }
}
