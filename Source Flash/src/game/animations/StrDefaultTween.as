package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StrDefaultTween extends BaseStageTween
   {
       
      
      protected var speed:int = 4;
      
      public function StrDefaultTween(param1:TweenObject = null)
      {
         super(param1);
      }
      
      override public function get type() : String
      {
         return "StrDefaultTween";
      }
      
      override public function copyPropertyFromData(param1:TweenObject) : void
      {
         if(param1.target)
         {
            target = param1.target;
         }
         if(param1.speed)
         {
            this.speed = param1.speed;
         }
      }
      
      override public function update(param1:DisplayObject) : Point
      {
         if(!_prepared)
         {
            return null;
         }
         var _loc2_:Point = new Point(param1.x,param1.y);
         var _loc3_:Point = new Point(target.x - param1.x,target.y - param1.y);
         if(_loc3_.length >= this.speed)
         {
            _loc3_.normalize(_loc3_.length / 16 * this.speed);
            _loc2_.x += _loc3_.x;
            _loc2_.y += _loc3_.y;
         }
         else
         {
            _loc2_.x += _loc3_.x;
            _loc2_.y += _loc3_.y;
            _isFinished = true;
         }
         return _loc2_;
      }
      
      override protected function get propertysNeed() : Array
      {
         return ["target","speed"];
      }
   }
}
