package game.motions
{
   public class VerticalMoveMotionFunc extends BaseMotionFunc
   {
       
      
      private var speed:int;
      
      public function VerticalMoveMotionFunc(param1:Object)
      {
         super(param1);
      }
      
      override public function getVectorByTime(param1:int) : Object
      {
         _result = new Object();
         _result.x = this.speed;
         return _result;
      }
   }
}
