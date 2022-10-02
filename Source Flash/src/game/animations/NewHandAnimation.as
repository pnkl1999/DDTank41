package game.animations
{
   import flash.geom.Point;
   import game.view.map.MapView;
   
   public class NewHandAnimation extends BaseSetCenterAnimation
   {
       
      
      public function NewHandAnimation(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false, param5:int = 0, param6:int = 4, param7:Object = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function canAct() : Boolean
      {
         if(_life <= 0)
         {
            return false;
         }
         return true;
      }
      
      override public function prepare(param1:AnimationSet) : void
      {
         _target.x = param1.stageWidth / 2 - _target.x;
         _target.y = param1.stageHeight / 2 - _target.y;
         _target.x = _target.x < param1.minX ? Number(Number(param1.minX)) : (_target.x > 0 ? Number(Number(0)) : Number(Number(_target.x)));
         _target.y = _target.y < param1.minY ? Number(Number(param1.minY)) : (_target.y > 0 ? Number(Number(0)) : Number(Number(_target.y)));
      }
      
      override public function update(param1:MapView) : Boolean
      {
         var _loc2_:Point = null;
         --_life;
         if(_life <= 0)
         {
            return false;
         }
         if(!_directed)
         {
            _tween.target = _target;
            _loc2_ = _tween.update(param1);
            param1.x = _loc2_.x;
            param1.y = _loc2_.y;
         }
         else
         {
            param1.x = _target.x;
            param1.y = _target.y;
         }
         return true;
      }
   }
}
