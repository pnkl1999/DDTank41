package game.objects
{
   import ddt.events.LivingEvent;
   import game.model.TurnedLiving;
   import game.view.smallMap.SmallLiving;
   
   public class GameTurnedLiving extends GameLiving
   {
       
      
      public function GameTurnedLiving(param1:TurnedLiving)
      {
         super(param1);
      }
      
      public function get turnedLiving() : TurnedLiving
      {
         return _info as TurnedLiving;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
      }
      
      protected function __attackingChanged(param1:LivingEvent) : void
      {
         SmallLiving(_smallView).isAttacking = this.turnedLiving.isAttacking;
      }
      
      override public function die() : void
      {
         this.turnedLiving.isAttacking = false;
         super.die();
      }
   }
}
