package game.animations
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import game.view.map.MapView;
   
   public class BaseSetCenterAnimation extends BaseAnimate
   {
       
      
      protected var _target:Point;
      
      protected var _life:int;
      
      protected var _directed:Boolean;
      
      protected var _speed:int;
      
      protected var _moveSpeed:int = 4;
      
      protected var _tween:BaseStageTween;
      
      public function BaseSetCenterAnimation(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false, param5:int = 0, param6:int = 4, param7:Object = null)
      {
         var _loc8_:TweenObject = null;
         super();
         _loc8_ = new TweenObject(param7);
         this._target = new Point(param1,param2);
         _loc8_.target = this._target;
         var _loc9_:String = StageTweenStrategys.getTweenClassNameByShortName(_loc8_.strategy);
         _finished = false;
         this._life = param3;
         _level = param5;
         if(param7 && param7.priority != null)
         {
            _level = param7.priority;
         }
         if(param7 && param7.duration != null)
         {
            this._life = param7.duration;
         }
         this._directed = param4;
         this._speed = param6;
         var _loc10_:Class = getDefinitionByName(_loc9_) as Class;
         this._tween = new _loc10_(_loc8_);
      }
      
      override public function canAct() : Boolean
      {
         if(_finished)
         {
            return false;
         }
         if(this._life <= 0)
         {
            return false;
         }
         return true;
      }
      
      override public function prepare(param1:AnimationSet) : void
      {
         this._target.x = param1.stageWidth / 2 - this._target.x;
         this._target.y = param1.stageHeight / 2 - this._target.y;
         this._target.x = this._target.x < param1.minX ? Number(Number(param1.minX)) : (this._target.x > 0 ? Number(Number(0)) : Number(Number(this._target.x)));
         this._target.y = this._target.y < param1.minY ? Number(Number(param1.minY)) : (this._target.y > 0 ? Number(Number(0)) : Number(Number(this._target.y)));
      }
      
      override public function update(param1:MapView) : Boolean
      {
         var _loc2_:Point = null;
         --this._life;
         if(this._life <= 0)
         {
            this.finished();
         }
         if(!_finished && this._life > 0)
         {
            if(!this._directed)
            {
               this._tween.target = this._target;
               _loc2_ = this._tween.update(param1);
               param1.x = _loc2_.x;
               param1.y = _loc2_.y;
               if(this._tween.isFinished)
               {
                  this.finished();
               }
            }
            else
            {
               param1.x = this._target.x;
               param1.y = this._target.y;
               this.finished();
            }
            param1.setExpressionLoction();
            return true;
         }
         return false;
      }
      
      protected function finished() : void
      {
         _finished = true;
      }
   }
}
