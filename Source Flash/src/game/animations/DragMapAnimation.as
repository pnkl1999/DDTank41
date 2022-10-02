package game.animations
{
   public class DragMapAnimation extends BaseSetCenterAnimation
   {
       
      
      public function DragMapAnimation(param1:Number, param2:Number, param3:Boolean = false, param4:int = 100)
      {
         super(param1,param2,param4,param3,AnimationLevel.HIGHT);
      }
      
      override public function canAct() : Boolean
      {
         return !_finished;
      }
   }
}
