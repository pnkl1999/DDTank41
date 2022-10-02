package ddt.events
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const WIND_CHANGED:String = "windChanged";
      
      public static const TURN_CHANGED:String = "turnChanged";
      
      public static const READY_CHANGED:String = "readyChanged";
      
      public static const DungeonHelpVisibleChanged:String = "DungeonHelpVisibleChanged";
      
      public static const UPDATE_SMALLMAPVIEW:String = "updateSmallMapView";
      
      public static const EXPSHOWED:String = "expshowed";
      
      public static const TRYAGAIN:String = "tryagain";
      
      public static const GIVEUP:String = "giveup";
      
      public static const TIMEOUT:String = "timeOut";
      
      public static const MISSIONAGAIN:String = "missionAgain";
      
      public static const UPDATE_NAMEPOS:String = "updatenamepos";
       
      
      public var data:*;
      
      public function GameEvent(param1:String, param2:*)
      {
         this.data = param2;
         super(param1);
      }
   }
}
