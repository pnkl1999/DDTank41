package luckStar.event
{
   import flash.events.Event;
   
   public class LuckStarEvent extends Event
   {
      
      public static const LUCKYSTAR_EVENT:String = "luckystarevent";
      
      public static const CELL_ACTION_COMPLETE:int = 4;
      
      public static const GOODS:int = 0;
      
      public static const COINS:int = 1;
      
      public static const NEW_REWARD_LIST:int = 2;
       
      
      public var code:int;
      
      public function LuckStarEvent(param1:int)
      {
         this.code = param1;
         super(LUCKYSTAR_EVENT);
      }
   }
}
