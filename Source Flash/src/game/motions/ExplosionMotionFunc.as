package game.motions
{
   public class ExplosionMotionFunc extends BaseMotionFunc
   {
      
      private static var D:int = 10;
       
      
      public function ExplosionMotionFunc(param1:Object)
      {
         super(param1);
      }
      
      override public function getVectorByTime(param1:int) : Object
      {
         switch(param1 % 4)
         {
            case 0:
               _result.x = -D;
               _result.y = -D;
               break;
            case 1:
               _result.x = D;
               _result.y = D;
               break;
            case 2:
               _result.x = -D;
               _result.y = D;
               break;
            case 3:
               _result.x = D;
               _result.y = -D;
         }
         return _result;
      }
   }
}
