package game.objects
{
   public class ActionType
   {
      
      public static const STAND_ACTION:String = "stand";
      
      public static const ANGRY_ACTION:String = "angry";
      
      public static const DEFENCE_ACTION:String = "shield";
      
      public static const FORZEN_ACTION:String = "cryB";
      
      public static const STANDB_ACTION:String = "standB";
      
      public static const STANDC_ACTION:String = "standC";
      
      public static const STANDD_ACTION:String = "standD";
      
      public static const PICK:int = 1;
      
      public static const BOMB:int = 2;
      
      public static const START_MOVE:int = 3;
      
      public static const FLY_OUT:int = 4;
      
      public static const KILL_PLAYER:int = 5;
      
      public static const TRANSLATE:int = 6;
      
      public static const FORZEN:int = 7;
      
      public static const CHANGE_SPEED:int = 8;
      
      public static const UNFORZEN:int = 9;
      
      public static const DANER:int = 10;
      
      public static const CURE:int = 11;
      
      public static const PLAYBUFFER:int = 15;
      
      public static const Laser:int = 16;
      
      public static const GEM_DEFENSE_CHANGED:int = 12;
      
      public static const CHANGE_STATE:int = 13;
      
      public static const DO_ACTION:int = 14;
      
      public static const BOMBED:int = 17;
      
      public static const ACTION_TYPES:Array = [STAND_ACTION,ANGRY_ACTION,DEFENCE_ACTION,FORZEN_ACTION,STANDB_ACTION,STANDC_ACTION,STANDD_ACTION];
      
      public static const PUP:int = 18;
      
      public static const AUP:int = 19;
      
      public static const PET:int = 20;
       
      
      public function ActionType()
      {
         super();
      }
   }
}
