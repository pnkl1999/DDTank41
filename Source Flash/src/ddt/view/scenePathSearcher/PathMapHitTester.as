package ddt.view.scenePathSearcher
{
   import ddt.utils.Geometry;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PathMapHitTester implements PathIHitTester
   {
       
      
      private var mc:Sprite;
      
      public function PathMapHitTester(param1:Sprite)
      {
         super();
         this.mc = param1;
      }
      
      public function isHit(param1:Point) : Boolean
      {
         var _loc2_:Point = this.mc.localToGlobal(param1);
         return this.mc.hitTestPoint(_loc2_.x,_loc2_.y,true);
      }
      
      public function getNextMoveAblePoint(param1:Point, param2:Number, param3:Number, param4:Number) : Point
      {
         var _loc5_:Number = 0;
         while(this.isHit(param1))
         {
            param1 = Geometry.nextPoint(param1,param2,param3);
            _loc5_ += param3;
            if(_loc5_ > param4)
            {
               return null;
            }
         }
         return param1;
      }
   }
}
