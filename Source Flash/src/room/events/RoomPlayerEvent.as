package room.events
{
   import flash.events.Event;
   
   public class RoomPlayerEvent extends Event
   {
      
      public static const READY_CHANGE:String = "readyChange";
      
      public static const IS_HOST_CHANGE:String = "isHostChange";
      
      public static const PROGRESS_CHANGE:String = "progressChange";
       
      
      public function RoomPlayerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
