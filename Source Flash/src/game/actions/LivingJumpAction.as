package game.actions
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import game.animations.PhysicalObjFocusAnimation;
   import game.model.Living;
   import game.objects.GameLiving;
   
   public class LivingJumpAction extends BaseAction
   {
       
      
      private var _living:GameLiving;
      
      protected var _target:Point;
      
      private var _speed:int;
      
      private var _firstExcuted:Boolean = true;
      
      private var _jumpType:int;
      
      private var _moveMovie:MovieClip;
      
      private var _state:int = 0;
      
      private var _times:int = 0;
      
      private var _g:Number = 0.04;
      
      private var _tempSpeed:Number = 0;
      
      public function LivingJumpAction(param1:GameLiving, param2:Point, param3:int, param4:int = 0)
      {
         this._living = param1;
         this._target = param2;
         this._speed = param3;
         this._jumpType = param4;
         super();
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:LivingJumpAction = param1 as LivingJumpAction;
         if(_loc2_ && _loc2_._target.y > this._target.y)
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
         if(this._living.isLiving)
         {
            this._living.startMoving();
            if(this._jumpType == 1)
            {
               this._living.actionMovie.addEventListener(Event.ENTER_FRAME,this.__checkMoveMovie);
            }
         }
         else
         {
            this.finish();
         }
      }
      
      private function __checkMoveMovie(param1:Event) : void
      {
         if(this._living.actionMovie.getChildAt(0))
         {
            this._living.actionMovie.removeEventListener(Event.ENTER_FRAME,this.__checkMoveMovie);
            this._moveMovie = this._living.actionMovie.getChildAt(0) as MovieClip;
            this._moveMovie.gotoAndStop(4);
            this._moveMovie.addFrameScript(4,this.stopMovie);
            this._moveMovie.addFrameScript(this._moveMovie.totalFrames - 1,this.doActionStand);
         }
      }
      
      private function stopMovie() : void
      {
         this._moveMovie.stop();
      }
      
      private function contuineMovie() : void
      {
         this._moveMovie.addFrameScript(4,null);
         if(this._moveMovie.currentFrame < this._moveMovie.totalFrames)
         {
            this._moveMovie.gotoAndStop(this._moveMovie.currentFrame + 1);
         }
         this._moveMovie.nextFrame();
      }
      
      private function doActionStand() : void
      {
         this._moveMovie.addFrameScript(this._moveMovie.totalFrames - 1,null);
         this._living.actionMovie.doAction("stand");
      }
      
      override public function execute() : void
      {
         if(this._jumpType == 0)
         {
            this.jumpBass();
         }
         else if(this._jumpType == 1)
         {
            this.jumpAmortize();
         }
         else
         {
            this.jumpContinuous();
         }
      }
      
      private function jumpAmortize() : void
      {
         if(this._state > 4)
         {
            ++this._times;
            this._tempSpeed = this._times * this._times * this._g * 50;
            this.setPoint(-this._tempSpeed);
            if(this._living.info.pos.y - this._target.y >= 0)
            {
               this._living.info.pos = this._target;
               this._times = -1;
               this.contuineMovie();
               ++this._state;
               if(this._state > 12)
               {
                  this._state = 0;
                  this.executeAtOnce();
               }
            }
            else
            {
               this._moveMovie.gotoAndStop(6);
            }
         }
         else if(this._living.info.pos.y - this._target.y < -(this._speed * 2))
         {
            this._state += 1;
            this._times = 0;
            this._moveMovie.gotoAndStop(5);
         }
         else
         {
            this._tempSpeed = this._speed * 1.5 - this._times * this._g;
            if(this._tempSpeed < this._speed / 2)
            {
               this._tempSpeed = this._speed / 2;
            }
            this.setPoint(this._tempSpeed);
         }
      }
      
      private function jumpContinuous() : void
      {
         this._speed = 20;
         if(this._state == 25)
         {
            --this._times;
            this.setPoint(-this._speed / 2);
            if(this._times <= 3)
            {
               this._state = 0;
               this._times = 0;
               if(this._living.info.pos.y <= this._target.y)
               {
                  this.executeAtOnce();
               }
            }
         }
         else if(this._state == 24)
         {
            ++this._times;
            this.setPoint(this._speed + 1);
            if(this._times >= 5)
            {
               this._state = 25;
            }
         }
         else
         {
            ++this._state;
         }
      }
      
      private function setPoint(param1:Number) : void
      {
         this._living.info.pos = new Point(this._target.x,this._living.info.pos.y - param1);
         this._living.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this._living,25,-150));
      }
      
      private function jumpBass() : void
      {
         if(this._living.info.pos.y - this._target.y <= this._speed)
         {
            this.executeAtOnce();
         }
         else
         {
            this.setPoint(this._speed);
         }
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
         this.finish();
      }
      
      private function finish() : void
      {
         this._living.stopMoving();
         _isFinished = true;
      }
   }
}
