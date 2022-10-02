package com.pickgliss.geom
{
   public class IntDimension
   {
       
      
      public var width:int = 0;
      
      public var height:int = 0;
      
      public function IntDimension(param1:int = 0, param2:int = 0)
      {
         super();
         this.width = param1;
         this.height = param2;
      }
      
      public static function createBigDimension() : IntDimension
      {
         return new IntDimension(100000,100000);
      }
      
      public function setSize(param1:IntDimension) : void
      {
         this.width = param1.width;
         this.height = param1.height;
      }
      
      public function setSizeWH(param1:int, param2:int) : void
      {
         this.width = param1;
         this.height = param2;
      }
      
      public function increaseSize(param1:IntDimension) : IntDimension
      {
         this.width += param1.width;
         this.height += param1.height;
         return this;
      }
      
      public function decreaseSize(param1:IntDimension) : IntDimension
      {
         this.width -= param1.width;
         this.height -= param1.height;
         return this;
      }
      
      public function change(param1:int, param2:int) : IntDimension
      {
         this.width += param1;
         this.height += param2;
         return this;
      }
      
      public function changedSize(param1:int, param2:int) : IntDimension
      {
         return new IntDimension(param1,param2);
      }
      
      public function combine(param1:IntDimension) : IntDimension
      {
         this.width = Math.max(this.width,param1.width);
         this.height = Math.max(this.height,param1.height);
         return this;
      }
      
      public function combineSize(param1:IntDimension) : IntDimension
      {
         return this.clone().combine(param1);
      }
      
      public function getBounds(param1:int = 0, param2:int = 0) : IntRectangle
      {
         var _loc3_:IntPoint = new IntPoint(param1,param2);
         var _loc4_:IntRectangle = new IntRectangle();
         _loc4_.setLocation(_loc3_);
         _loc4_.setSize(this);
         return _loc4_;
      }
      
      public function equals(param1:Object) : Boolean
      {
         var _loc2_:IntDimension = param1 as IntDimension;
         if(_loc2_ == null)
         {
            return false;
         }
         return this.width === _loc2_.width && this.height === _loc2_.height;
      }
      
      public function clone() : IntDimension
      {
         return new IntDimension(this.width,this.height);
      }
      
      public function toString() : String
      {
         return "IntDimension[" + this.width + "," + this.height + "]";
      }
   }
}
