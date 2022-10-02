package ddt.view.scenePathSearcher
{
   import flash.geom.Point;
   
   public class PathAstarPoint extends Point
   {
       
      
      public var g:int;
      
      public var h:int;
      
      public var f:int;
      
      public var source_point:PathAstarPoint;
      
      public function PathAstarPoint(param1:int = 0, param2:int = 0)
      {
         super(param1,param2);
         this.source_point = null;
      }
   }
}
