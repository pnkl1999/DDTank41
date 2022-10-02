package com.pickgliss.geom
{
   import flash.geom.Rectangle;
   
   public class IntRectangle
   {
       
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var width:int = 0;
      
      public var height:int = 0;
      
      public function IntRectangle(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.setRectXYWH(param1,param2,param3,param4);
      }
      
      public static function creatWithRectangle(param1:Rectangle) : IntRectangle
      {
         return new IntRectangle(param1.x,param1.y,param1.width,param1.height);
      }
      
      public function toRectangle() : Rectangle
      {
         return new Rectangle(this.x,this.y,this.width,this.height);
      }
      
      public function setWithRectangle(param1:Rectangle) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.width = param1.width;
         this.height = param1.height;
      }
      
      public function setRect(param1:IntRectangle) : void
      {
         this.setRectXYWH(param1.x,param1.y,param1.width,param1.height);
      }
      
      public function setRectXYWH(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.x = param1;
         this.y = param2;
         this.width = param3;
         this.height = param4;
      }
      
      public function setLocation(param1:IntPoint) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function setSize(param1:IntDimension) : void
      {
         this.width = param1.width;
         this.height = param1.height;
      }
      
      public function getSize() : IntDimension
      {
         return new IntDimension(this.width,this.height);
      }
      
      public function getLocation() : IntPoint
      {
         return new IntPoint(this.x,this.y);
      }
      
      public function union(param1:IntRectangle) : IntRectangle
      {
         var _loc2_:int = Math.min(this.x,param1.x);
         var _loc3_:int = Math.max(this.x + this.width,param1.x + param1.width);
         var _loc4_:int = Math.min(this.y,param1.y);
         var _loc5_:int = Math.max(this.y + this.height,param1.y + param1.height);
         return new IntRectangle(_loc2_,_loc4_,_loc3_ - _loc2_,_loc5_ - _loc4_);
      }
      
      public function grow(param1:int, param2:int) : void
      {
         this.x -= param1;
         this.y -= param2;
         this.width += param1 * 2;
         this.height += param2 * 2;
      }
      
      public function move(param1:int, param2:int) : void
      {
         this.x += param1;
         this.y += param2;
      }
      
      public function resize(param1:int = 0, param2:int = 0) : void
      {
         this.width += param1;
         this.height += param2;
      }
      
      public function leftTop() : IntPoint
      {
         return new IntPoint(this.x,this.y);
      }
      
      public function rightTop() : IntPoint
      {
         return new IntPoint(this.x + this.width,this.y);
      }
      
      public function leftBottom() : IntPoint
      {
         return new IntPoint(this.x,this.y + this.height);
      }
      
      public function rightBottom() : IntPoint
      {
         return new IntPoint(this.x + this.width,this.y + this.height);
      }
      
      public function containsPoint(param1:IntPoint) : Boolean
      {
         if(param1.x < this.x || param1.y < this.y || param1.x > this.x + this.width || param1.y > this.y + this.height)
         {
            return false;
         }
         return true;
      }
      
      public function equals(param1:Object) : Boolean
      {
         var _loc2_:IntRectangle = param1 as IntRectangle;
         if(_loc2_ == null)
         {
            return false;
         }
         return this.x === _loc2_.x && this.y === _loc2_.y && this.width === _loc2_.width && this.height === _loc2_.height;
      }
      
      public function clone() : IntRectangle
      {
         return new IntRectangle(this.x,this.y,this.width,this.height);
      }
      
      public function toString() : String
      {
         return "IntRectangle[x:" + this.x + ",y:" + this.y + ", width:" + this.width + ",height:" + this.height + "]";
      }
   }
}
