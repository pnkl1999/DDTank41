package worldboss.event
{
   import flash.events.Event;
   
   public class WorldBossRoomEvent extends Event
   {
      
      public static const PLAYER_NAME_VISIBLE:String = "playerNameVisible";
      
      public static const PLAYER_CHATBALL_VISIBLE:String = "playerChatBallVisible";
      
      public static const ROOM_VALIDETIME_CHANGE:String = "valide time change";
      
      public static const ROOM_CLOSE:String = "room close";
      
      public static const ROOM_FIRE_ENABLE_CHANGE:String = "room fire enable change";
      
      public static const SCENE_CHANGE:String = "scene change";
      
      public static const ALLOW_ENTER:String = "can enter";
      
      public static const BOSS_HP_UPDATA:String = "boss_hp_updata";
      
      public static const FIGHT_OVER:String = "fight_over";
      
      public static const READYFIGHT:String = "readyFight";
      
      public static const STOPFIGHT:String = "stopFight";
      
      public static const ENTERING_GAME:String = "enteringGame";
      
      public static const ENTER_GAME_TIME_OUT:String = "enterGameTimeOut";
      
      public static const GAME_INIT:String = "gameInit";
      
      public static const WORLDBOSS_ROOM_FULL:String = "worldBossRoomFull";
      
      public var data:Object;
      
      public function WorldBossRoomEvent(param1:String, param2:Object = null)
      {
         this.data = param2;
         super(param1,bubbles,cancelable);
      }
   }
}
