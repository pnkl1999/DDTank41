package hotSpring.event
{
   import flash.events.Event;
   
   public class HotSpringRoomEvent extends Event
   {
      
      public static const ROOM_PLAYER_ADD:String = "roomPlayerAdd";
      
      public static const ROOM_PLAYER_UPDATE:String = "roomPlayerUpdate";
      
      public static const ROOM_PLAYER_REMOVE:String = "roomPlayerRemove";
      
      public static const ROOM_PLAYER_UPDATE_ATTRIBUTE:String = "roomPlayerUpdateAttribute";
       
      
      public var data:Object;
      
      public function HotSpringRoomEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
   }
}
