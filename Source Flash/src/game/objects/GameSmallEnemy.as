package game.objects
{
   import ddt.events.LivingEvent;
   import game.actions.MonsterShootBombAction;
   import game.model.Living;
   import game.model.Player;
   import game.model.SmallEnemy;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   import road7th.data.StringObject;
   
   public class GameSmallEnemy extends GameLiving
   {
       
      
      private var _bombEvent:LivingEvent;
      
      private var _noDispose:Boolean = false;
      
      private var _disposedOverTurns:Boolean = true;
      
      public function GameSmallEnemy(param1:SmallEnemy)
      {
         super(param1);
         param1.defaultAction = "stand";
      }
      
      override protected function initView() : void
      {
         super.initView();
         initMovie();
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            __posChanged(null);
         }
      }
      
      public function get smallEnemy() : SmallEnemy
      {
         return info as SmallEnemy;
      }
      
      override protected function __bloodChanged(param1:LivingEvent) : void
      {
         super.__bloodChanged(param1);
         if(param1.value - param1.old < 0)
         {
            doAction(Living.CRY_ACTION);
         }
      }
      
      override protected function __die(param1:LivingEvent) : void
      {
         if(isMoving())
         {
            stopMoving();
         }
         super.__die(param1);
         if(param1.paras[0])
         {
            if(_info.typeLiving == 2)
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.clearEnemy);
            }
            else if(this._noDispose)
            {
               _actionMovie.doAction(Living.DIE_ACTION);
            }
            else
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.dispose);
            }
         }
         else if(_info.typeLiving == 2)
         {
            this.clearEnemy();
         }
         else
         {
            this.dispose();
         }
         _chatballview.dispose();
         _isDie = true;
      }
      
      override public function collidedByObject(param1:PhysicalObj) : void
      {
         if(param1 is SimpleBomb)
         {
            info.isHidden = false;
         }
      }
      
      override protected function fitChatBallPos() : void
      {
         _chatballview.x = 20;
         _chatballview.y = -50;
         if(!actionMovie["popupPos"])
         {
            return;
         }
         super.fitChatBallPos();
      }
      
      private function clearEnemy() : void
      {
         this.removeEvents(true);
         deleteSmallView();
      }
      
      private function removeEvents(param1:Boolean = false) : void
      {
         super.removeListener();
         if(param1)
         {
            _info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         }
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         map.act(new MonsterShootBombAction(this,param1.paras[0],param1.paras[1],Player.SHOOT_INTERVAL));
      }
      
      override protected function __beginNewTurn(param1:LivingEvent) : void
      {
         if(!this._disposedOverTurns)
         {
            return;
         }
         if(_isDie)
         {
            ++_turns;
         }
         if(_turns >= 5)
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         _info.dispose();
         super.dispose();
      }
      
      override public function setProperty(param1:String, param2:String) : void
      {
         var _loc3_:StringObject = new StringObject(param2);
         super.setProperty(param1,param2);
         switch(param1)
         {
            case "disposedOverTurns":
               this._disposedOverTurns = _loc3_.getBoolean();
               break;
            case "noDispose":
               this._noDispose = _loc3_.getBoolean();
         }
      }
   }
}
