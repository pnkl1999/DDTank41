package game.animations
{
   import flash.geom.Point;
   
   public dynamic class TweenObject
   {
       
      
      public var speed:uint;
      
      public var duration:uint;
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _strategy:String;
      
      public function TweenObject(param1:Object = null)
      {
         var _loc2_:* = undefined;
         super();
         for(_loc2_ in param1)
         {
            this[_loc2_] = param1[_loc2_];
         }
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set target(param1:Point) : void
      {
         this._x = param1.x;
         this._y = param1.y;
      }
      
      public function get target() : Point
      {
         return new Point(this._x,this._y);
      }
      
      public function set strategy(param1:String) : void
      {
         this._strategy = param1;
      }
      
      public function get strategy() : String
      {
         if(this._strategy)
         {
            return this._strategy;
         }
         return "default";
      }
   }
}
