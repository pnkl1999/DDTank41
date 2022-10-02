package game.actions
{
   import ddt.data.BallInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BallManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import game.animations.AnimationLevel;
   import game.objects.ActionType;
   import game.objects.GameLiving;
   import game.objects.SimpleBomb;
   import game.view.Bomb;
   
   public class MonsterShootBombAction extends BaseAction
   {
       
      
      private var _monster:GameLiving;
      
      private var _bombs:Array;
      
      private var _isShoot:Boolean;
      
      private var _prepared:Boolean;
      
      private var _prepareAction:String;
      
      private var _shootInterval:int;
      
      private var _info:BallInfo;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _endAction:String = "";
      
      private var _canShootImp:Boolean;
      
      public function MonsterShootBombAction(param1:GameLiving, param2:Array, param3:CrazyTankSocketEvent, param4:int)
      {
         super();
         this._monster = param1;
         this._bombs = param2;
         this._event = param3;
         this._prepared = false;
         this._shootInterval = param4 / 40;
      }
      
      override public function prepare() : void
      {
         this._info = BallManager.findBall(this._bombs[0].Template.ID);
         this._monster.map.requestForFocus(this._monster,AnimationLevel.LOW);
         this._monster.actionMovie.addEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
         this._monster.actionMovie.doAction("shoot",this.onCallbackPrepared);
      }
      
      protected function onEventPrepared(param1:Event) : void
      {
         this.canShoot();
      }
      
      protected function onCallbackPrepared() : void
      {
         this.canShoot();
      }
      
      private function canShoot() : void
      {
         this._monster.actionMovie.removeEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
         this._prepared = true;
         this._monster.map.cancelFocus(this._monster);
      }
      
      override public function execute() : void
      {
         if(!this._prepared)
         {
            return;
         }
         if(!this._isShoot)
         {
            this.executeImp(false);
         }
         else
         {
            --this._shootInterval;
            if(this._shootInterval <= 0)
            {
               _isFinished = true;
               this._event.executed = true;
            }
         }
      }
      
      private function executeImp(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bomb = null;
         var _loc4_:int = 0;
         var _loc5_:SimpleBomb = null;
         if(!this._isShoot)
         {
            this._isShoot = true;
            SoundManager.instance.play(this._info.ShootSound);
            _loc2_ = 0;
            while(_loc2_ < this._bombs.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this._bombs[_loc2_].Actions.length)
               {
                  if(this._bombs[_loc2_].Actions[_loc4_].type == ActionType.KILL_PLAYER)
                  {
                     this._bombs.unshift(this._bombs.splice(_loc2_,1)[0]);
                     break;
                  }
                  _loc4_++;
               }
               _loc2_++;
            }
            for each(_loc3_ in this._bombs)
            {
               _loc5_ = new SimpleBomb(_loc3_,this._monster.info);
               this._monster.map.addPhysical(_loc5_);
               if(param1)
               {
                  _loc5_.bombAtOnce();
               }
            }
         }
      }
   }
}
