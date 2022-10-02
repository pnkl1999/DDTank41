package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StrStayTween extends BaseStageTween
   {
       
      
      public function StrStayTween(param1:TweenObject = null)
      {
         super(param1);
      }
      
      override public function get type() : String
      {
         return "StrStay";
      }
      
      override public function get isFinished() : Boolean
      {
         return true;
      }
      
      override public function update(param1:DisplayObject) : Point
      {
         if(!_prepared)
         {
            return null;
         }
         return new Point(param1.x,param1.y);
      }
   }
}
