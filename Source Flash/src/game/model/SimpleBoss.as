package game.model
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   
   public class SimpleBoss extends TurnedLiving
   {
       
      
      public function SimpleBoss(param1:int, param2:int, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override public function shoot(param1:Array, param2:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOOT,0,0,param1,param2));
      }
      
      override public function beginNewTurn() : void
      {
         isAttacking = false;
      }
   }
}
