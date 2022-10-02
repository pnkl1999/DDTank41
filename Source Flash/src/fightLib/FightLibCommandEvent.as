package fightLib
{
   import flash.events.Event;
   
   public class FightLibCommandEvent extends Event
   {
      
      public static const WAIT:String = "wait";
      
      public static const FINISH:String = "finish";
       
      
      public function FightLibCommandEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
