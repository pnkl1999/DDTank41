package ddt.view.scenePathSearcher
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class SceneScene extends EventDispatcher
   {
       
      
      private var _hitTester:PathIHitTester;
      
      private var _pathSearcher:PathIPathSearcher;
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function SceneScene()
      {
         super();
         this._pathSearcher = new PathRoboSearcher(18,1000,8);
         this._x = 0;
         this._y = 0;
      }
      
      public function get HitTester() : PathIHitTester
      {
         return this._hitTester;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set position(param1:Point) : void
      {
         if(param1.x != this._x || param1.y != this._y)
         {
            this._x = param1.x;
            this._y = param1.y;
         }
      }
      
      public function get position() : Point
      {
         return new Point(this._x,this._y);
      }
      
      public function setPathSearcher(param1:PathIPathSearcher) : void
      {
         this._pathSearcher = param1;
      }
      
      public function setHitTester(param1:PathIHitTester) : void
      {
         this._hitTester = param1;
      }
      
      public function hit(param1:Point) : Boolean
      {
         return this._hitTester.isHit(param1);
      }
      
      public function searchPath(param1:Point, param2:Point) : Array
      {
         return this._pathSearcher.search(param1,param2,this._hitTester);
      }
      
      public function localToGlobal(param1:Point) : Point
      {
         return new Point(param1.x + this._x,param1.y + this._y);
      }
      
      public function globalToLocal(param1:Point) : Point
      {
         return new Point(param1.x - this._x,param1.y - this._y);
      }
      
      public function dispose() : void
      {
         this._hitTester = null;
         this._pathSearcher = null;
      }
   }
}
