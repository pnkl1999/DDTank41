package church.events
{
   import flash.events.Event;
   
   public class WeddingRoomEvent extends Event
   {
      
      public static const PLAYER_NAME_VISIBLE:String = "playerNameVisible";
      
      public static const PLAYER_CHATBALL_VISIBLE:String = "playerChatBallVisible";
      
      public static const PLAYER_FIRE_VISIBLE:String = "playerFireVisible";
      
      public static const ROOM_VALIDETIME_CHANGE:String = "valide time change";
      
      public static const WEDDING_STATUS_CHANGE:String = "wedding status change";
      
      public static const ROOM_FIRE_ENABLE_CHANGE:String = "room fire enable change";
      
      public static const SCENE_CHANGE:String = "scene change";
       
      
      public var data:Object;
      
      public function WeddingRoomEvent(param1:String, param2:Object = null)
      {
         this.data = param2;
         super(param1);
      }
   }
}
