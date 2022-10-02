package game.actions
{
   import ddt.manager.SoundManager;
   import flash.geom.Point;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.ShockMapAnimation;
   import game.model.Living;
   import game.objects.GameLiving;
   
   public class LivingFallingAction extends BaseAction
   {
       
      
      private var _living:GameLiving;
      
      protected var _target:Point;
      
      private var _speed:int;
      
      private var _fallType:int;
      
      private var _firstExcuted:Boolean = true;
      
      private var _acceleration:int = 20;
      
      private var _state:int = 0;
      
      private var _times:int = 0;
      
      private var _tempSpeed:int = 0;
      
      private var _g:Number = 0.04;
      
      private var _maxY:Number;
      
      public function LivingFallingAction(param1:GameLiving, param2:Point, param3:int, param4:int = 0)
      {
         this._living = param1;
         this._target = param2;
         this._speed = param3;
         this._fallType = param4;
         super();
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:LivingFallingAction = param1 as LivingFallingAction;
         if(_loc2_ && _loc2_._target.y < this._target.y)
         {
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         super.prepare();
         if(this._living.isLiving)
         {
            if(this._living.x == this._target.x)
            {
               this._living.startMoving();
            }
            else
            {
               this.finish();
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override public function execute() : void
      {
         if(this._fallType == 0)
         {
            this.executeImp();
         }
         else if(this._fallType == 2)
         {
            this.executeImpShock();
         }
         else
         {
            this.fallingAmortize();
         }
      }
      
      private function fallingAmortize() : void
      {
         if(this._state == 0)
         {
            ++this._times;
            this._tempSpeed = this._speed * 1.5 * (1 - this._times * 0.1);
            if(this._tempSpeed < 0)
            {
               this._tempSpeed = 0;
            }
            this.setPoint(-this._tempSpeed);
            if(this._times > 4)
            {
               this._state = 1;
               this._times = 0;
               this._maxY = this._living.info.pos.y;
            }
         }
         else if(this._state > 15)
         {
            ++this._times;
            this._tempSpeed = this._speed + this._times * 10;
            if(this._target.y == this._living.info.pos.y)
            {
               this.executeAtOnce();
               this._times = 0;
               this._tempSpeed = 0;
               this._living.map.animateSet.addAnimation(new ShockMapAnimation(this._living,25,10));
               SoundManager.instance.play("078");
               return;
            }
            this.setPoint(this._tempSpeed);
            if(this._target.y - this._living.info.pos.y < this._speed)
            {
               this._living.info.pos = this._target;
            }
         }
         else
         {
            ++this._state;
            this._living.info.pos = new Point(this._living.info.pos.x,this._maxY);
            this._living.map.animateSet.addAnimation(new BaseSetCenterAnimation(this._living.x,this._living.y - 150,1,true));
         }
      }
      
      private function executeImp() : void
      {
         if(this._target.y - this._living.info.pos.y <= this._speed)
         {
            this.executeAtOnce();
         }
         else
         {
            this.setPoint(this._speed);
         }
      }
      
      private function executeImpShock() : void
      {
         if(this._target.y - this._living.info.pos.y <= this._speed)
         {
            this.executeAtOnce();
            this._living.map.animateSet.addAnimation(new ShockMapAnimation(this._living,25,10));
            SoundManager.instance.play("078");
         }
         else
         {
            this.setPoint(this._speed);
         }
      }
      
      private function setPoint(param1:Number) : void
      {
         this._living.info.pos = new Point(this._target.x,this._living.info.pos.y + param1);
         this._living.map.animateSet.addAnimation(new BaseSetCenterAnimation(this._living.x,this._living.y - 150,1,true));
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._living.info.pos = this._target;
         if(this._living.actionMovie)
         {
            if(this._living.actionMovie.currentAction == Living.STAND_ACTION)
            {
               this._living.info.doDefaultAction();
            }
         }
         if(this._living.map.IsOutMap(this._target.x,this._target.y))
         {
            this._living.info.die();
         }
         this.finish();
      }
      
      private function finish() : void
      {
         this._living.stopMoving();
         _isFinished = true;
      }
   }
}
