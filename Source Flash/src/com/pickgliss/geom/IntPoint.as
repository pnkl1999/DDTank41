package com.pickgliss.geom
{
   import flash.geom.Point;
   
   public class IntPoint
   {
       
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public function IntPoint(param1:int = 0, param2:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function creatWithPoint(param1:Point) : IntPoint
      {
         return new IntPoint(param1.x,param1.y);
      }
      
      public function toPoint() : Point
      {
         return new Point(this.x,this.y);
      }
      
      public function setWithPoint(param1:Point) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function setLocation(param1:IntPoint) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function setLocationXY(param1:int = 0, param2:int = 0) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function move(param1:int, param2:int) : IntPoint
      {
         this.x += param1;
         this.y += param2;
         return this;
      }
      
      public function moveRadians(param1:int, param2:int) : IntPoint
      {
         this.x += Math.round(Math.cos(param1) * param2);
         this.y += Math.round(Math.sin(param1) * param2);
         return this;
      }
      
      public function nextPoint(param1:Number, param2:Number) : IntPoint
      {
         return new IntPoint(this.x + Math.cos(param1) * param2,this.y + Math.sin(param1) * param2);
      }
      
      public function distanceSq(param1:IntPoint) : int
      {
         var _loc2_:int = param1.x;
         var _loc3_:int = param1.y;
         return (this.x - _loc2_) * (this.x - _loc2_) + (this.y - _loc3_) * (this.y - _loc3_);
      }
      
      public function distance(param1:IntPoint) : int
      {
         return Math.sqrt(this.distanceSq(param1));
      }
      
      public function equals(param1:Object) : Boolean
      {
         var _loc2_:IntPoint = param1 as IntPoint;
         if(_loc2_ == null)
         {
            return false;
         }
         return this.x === _loc2_.x && this.y === _loc2_.y;
      }
      
      public function clone() : IntPoint
      {
         return new IntPoint(this.x,this.y);
      }
      
      public function toString() : String
      {
         return "IntPoint[" + this.x + "," + this.y + "]";
      }
   }
}
