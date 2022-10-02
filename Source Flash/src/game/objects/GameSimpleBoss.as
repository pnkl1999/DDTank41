package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.view.chat.chatBall.ChatBallBoss;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import game.actions.ChangeDirectionAction;
   import game.actions.MonsterShootBombAction;
   import game.model.Living;
   import game.model.Player;
   import game.model.SimpleBoss;
   import phy.maps.Map;
   
   public class GameSimpleBoss extends GameTurnedLiving
   {
       
      
      private var bombList:Array;
      
      private var shootEvt:CrazyTankSocketEvent;
      
      private var shoots:Array;
      
      public function GameSimpleBoss(param1:SimpleBoss)
      {
         this.bombList = [];
         this.shoots = [];
         super(param1);
         param1.defaultAction = Living.STAND_ACTION;
      }
      
      override protected function initView() : void
      {
         initMovie();
         this.initFreezonRect();
         super.initView();
         _nickName.x -= 2;
         _nickName.y += 2;
      }
      
      override protected function initChatball() : void
      {
         _chatballview = new ChatBallBoss();
         _originalHeight = this.height;
         _originalWidth = this.width;
         addChild(_chatballview);
      }
      
      override protected function initFreezonRect() : void
      {
         _effRect = new Rectangle(-10,35,bodyWidth * 1.3,bodyHeight * 1.4);
      }
      
      override protected function __forzenChanged(param1:LivingEvent) : void
      {
         if(_info.isFrozen)
         {
            effectForzen = ComponentFactory.Instance.creatCustomObject("asset.gameFrostEffectAsset") as MovieClip;
            effectForzen.width = _effRect.width;
            effectForzen.height = _effRect.height;
            effectForzen.x = _effRect.x;
            effectForzen.y = _effRect.y;
            addChild(effectForzen);
         }
         else if(effectForzen)
         {
            removeChild(effectForzen);
            effectForzen = null;
         }
      }
      
      override protected function __dirChanged(param1:LivingEvent) : void
      {
         _info.act(new ChangeDirectionAction(this,_info.direction));
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            this.__posChanged(null);
         }
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         map.act(new MonsterShootBombAction(this,param1.paras[0],param1.paras[1],Player.SHOOT_INTERVAL));
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
      }
      
      override protected function __posChanged(param1:LivingEvent) : void
      {
         super.__posChanged(param1);
      }
      
      public function get simpleBoss() : SimpleBoss
      {
         return info as SimpleBoss;
      }
      
      override protected function __bloodChanged(param1:LivingEvent) : void
      {
         if(param1.paras[0] == 0)
         {
            if(_actionMovie != null)
            {
               _actionMovie.doAction(Living.RENEW,super.__bloodChanged,[param1]);
            }
         }
         else if(param1.paras[0] == 10)
         {
            super.__bloodChanged(param1);
         }
         else
         {
            if(param1.paras[0] == 5)
            {
               updateBloodStrip();
               return;
            }
            super.__bloodChanged(param1);
            if(_info.State != 1)
            {
               doAction(Living.CRY_ACTION);
            }
         }
      }
      
      override protected function __die(param1:LivingEvent) : void
      {
         if(isMoving())
         {
            stopMoving();
         }
         super.__die(param1);
         if(_info.typeLiving == 6)
         {
            _actionMovie.doAction("specialDie");
            return;
         }
         if(param1.paras[0])
         {
            if(_info.typeLiving == 5)
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.clearEnemy);
            }
            else
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.dispose);
            }
         }
         else if(_info.typeLiving == 5)
         {
            this.clearEnemy();
         }
         else
         {
            this.dispose();
         }
         _isDie = true;
      }
      
      private function clearEnemy() : void
      {
         removeListener();
         deleteSmallView();
      }
      
      override protected function __changeState(param1:LivingEvent) : void
      {
         if(_info.State == 1)
         {
            doAction(Living.ANGRY_ACTION);
         }
         else
         {
            doAction(Living.STAND_ACTION);
         }
      }
      
      override public function dispose() : void
      {
         if(_chatballview.visible && _chatballview.parent)
         {
            _chatballview.addEventListener(Event.COMPLETE,this.__disposeLater);
            return;
         }
         if(map && map.currentPlayer == _info)
         {
            map.currentPlayer = null;
         }
         super.dispose();
      }
      
      private function __disposeLater(param1:Event) : void
      {
         _chatballview.removeEventListener(Event.COMPLETE,this.__disposeLater);
         this.dispose();
      }
   }
}
