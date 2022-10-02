package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StrDirectlyTween extends BaseStageTween
   {
       
      
      public function StrDirectlyTween(param1:TweenObject = null)
      {
         super(param1);
      }
      
      override public function get type() : String
      {
         return "StrDirectlyTween";
      }
      
      override public function update(param1:DisplayObject) : Point
      {
         _isFinished = true;
         return target;
      }
      
      override protected function get propertysNeed() : Array
      {
         return ["target"];
      }
   }
}
