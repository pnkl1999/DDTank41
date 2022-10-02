package game.gametrainer
{
   import flash.events.Event;
   
   public class TrainerEvent extends Event
   {
      
      public static const CLOSE_FRAME:String = "closeFrame";
       
      
      public function TrainerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
