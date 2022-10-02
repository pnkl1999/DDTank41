package ddt.view.scenePathSearcher
{
   import flash.geom.Point;
   
   public interface PathIHitTester
   {
       
      
      function isHit(param1:Point) : Boolean;
      
      function getNextMoveAblePoint(param1:Point, param2:Number, param3:Number, param4:Number) : Point;
   }
}
