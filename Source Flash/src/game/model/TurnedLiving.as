package game.model
{
   import ddt.events.LivingEvent;
   import flash.utils.Dictionary;
   
   [Event(name="attackingChanged",type="ddt.events.LivingEvent")]
   public class TurnedLiving extends Living
   {
       
      
      protected var _isAttacking:Boolean = false;
      
      private var _fightBuffs:Dictionary;
      
      public function TurnedLiving(param1:int, param2:int, param3:int)
      {
         super(param1,param2,param3);
      }
      
      public function get isAttacking() : Boolean
      {
         return this._isAttacking;
      }
      
      public function set isAttacking(param1:Boolean) : void
      {
         if(this._isAttacking == param1)
         {
            return;
         }
         this._isAttacking = param1;
         dispatchEvent(new LivingEvent(LivingEvent.ATTACKING_CHANGED));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this.isAttacking = false;
         this._fightBuffs = new Dictionary();
      }
      
      override public function die(param1:Boolean = true) : void
      {
         if(isLiving)
         {
            if(this._isAttacking)
            {
               this.stopAttacking();
            }
            super.die(param1);
         }
      }
      
      public function hasState(param1:int) : Boolean
      {
         return this._fightBuffs[param1] != null;
      }
      
      public function addState(param1:int, param2:String = "") : void
      {
         if(param1 != 0)
         {
            this._fightBuffs[param1] = true;
         }
         dispatchEvent(new LivingEvent(LivingEvent.ADD_STATE,param1,0,param2));
      }
      
      public function startAttacking() : void
      {
         this.isAttacking = true;
      }
      
      public function stopAttacking() : void
      {
         this.isAttacking = false;
      }
      
      override public function dispose() : void
      {
         this._fightBuffs = null;
         super.dispose();
      }
   }
}
