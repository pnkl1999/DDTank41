package littleGame.events
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class LittleGameSocketEvent extends Event
   {
      
      public static const INHALED:String = "inhaled";
      
      public static const WORLD_LIST:String = "worldlist";
      
      public static const START_LOAD:String = "startload";
      
      public static const GAME_START:String = "gamestart";
      
      public static const ADD_SPRITE:String = "addsprite";
      
      public static const REMOVE_SPRITE:String = "removesprite";
      
      public static const MOVE:String = "move";
      
      public static const ADD_SCHEDULE:String = "addschedule";
      
      public static const REMOVE_SCHEDULE:String = "removeschedule";
      
      public static const INVOKE_SCHEDULE:String = "invokeschedule";
      
      public static const UPDATE_POS:String = "updatepos";
      
      public static const ADD_OBJECT:String = "addObject";
      
      public static const REMOVE_OBJECT:String = "removeObject";
      
      public static const INVOKE_OBJECT:String = "invokeObject";
      
      public static const UPDATELIVINGSPROPERTY:String = "updatelivingsproperty";
      
      public static const DOMOVIE:String = "domive";
      
      public static const DOACTION:String = "doaction";
      
      public static const GETSCORE:String = "getscore";
      
      public static const SETCLOCK:String = "setclock";
      
      public static const PONG:String = "pong";
      
      public static const NET_DELAY:String = "netdelay";
      
      public static const KICK_PLAYE:String = "kickpalyer";
       
      
      private var _pkg:PackageIn;
      
      public function LittleGameSocketEvent(type:String, pkg:PackageIn = null)
      {
         super(type);
         this._pkg = pkg;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}
