package game.animations
{
   import game.view.map.MapView;
   
   public class DirectionMovingAnimation extends BaseAnimate
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
       
      
      private var _dir:String;
      
      public function DirectionMovingAnimation(param1:String)
      {
         super();
         this._dir = param1;
         _level = AnimationLevel.MIDDLE;
      }
      
      override public function cancel() : void
      {
         _finished = true;
      }
      
      override public function update(param1:MapView) : Boolean
      {
         switch(this._dir)
         {
            case RIGHT:
               param1.x -= 18;
               break;
            case LEFT:
               param1.x += 18;
               break;
            case UP:
               param1.y += 18;
               break;
            case DOWN:
               param1.y -= 18;
               break;
            default:
               return false;
         }
         return true;
      }
   }
}
