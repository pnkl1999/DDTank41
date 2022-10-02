package hotSpring.event
{
   import flash.events.Event;
   
   public class HotSpringRoomListEvent extends Event
   {
      
      public static const ROOM_CREATE:String = "roomCreate";
      
      public static const ROOM_LIST_UPDATE:String = "roomListUpdate";
      
      public static const ROOM_REMOVE:String = "roomRemove";
      
      public static const ROOM_ADD:String = "roomAdd";
      
      public static const ROOM_UPDATE:String = "roomUpdate";
      
      public static const ROOM_LIST_UPDATE_VIEW:String = "roomListUpdateView";
       
      
      public var data:Object;
      
      public function HotSpringRoomListEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
   }
}
