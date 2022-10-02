package com.pickgliss.geom
{
   import flash.geom.Rectangle;
   
   public class InnerRectangle
   {
       
      
      public var lockDirection:int;
      
      public var para1:int;
      
      public var para2:int;
      
      public var para3:int;
      
      public var para4:int;
      
      private var _outerHeight:int;
      
      private var _outerWidth:int;
      
      private var _resultRect:Rectangle;
      
      public function InnerRectangle(param1:int, param2:int, param3:int, param4:int, param5:int = 0)
      {
         super();
         this.para1 = param1;
         this.para2 = param2;
         this.para3 = param3;
         this.para4 = param4;
         this.lockDirection = param5;
      }
      
      public function equals(param1:InnerRectangle) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return this.para4 == param1.para4 && this.para1 == param1.para1 && this.lockDirection == param1.lockDirection && this.para2 == param1.para2 && this.para3 == param1.para3;
      }
      
      public function getInnerRect(param1:int, param2:int) : Rectangle
      {
         this._outerWidth = param1;
         this._outerHeight = param2;
         return this.calculateCurrent();
      }
      
      private function calculateCurrent() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(this.lockDirection == LockDirectionTypes.UNLOCK)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para3;
            _loc1_.width = this._outerWidth - this.para1 - this.para2;
            _loc1_.height = this._outerHeight - this.para3 - this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_T)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para3;
            _loc1_.width = this._outerWidth - this.para1 - this.para2;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_L)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para3;
            _loc1_.width = this.para2;
            _loc1_.height = this._outerHeight - this.para3 - this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_R)
         {
            _loc1_.x = this._outerWidth - this.para1 - this.para2;
            _loc1_.y = this.para3;
            _loc1_.width = this.para1;
            _loc1_.height = this._outerHeight - this.para3 - this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_B)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this._outerHeight - this.para3 - this.para4;
            _loc1_.width = this._outerWidth - this.para1 - this.para2;
            _loc1_.height = this.para3;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_T)
         {
            _loc1_.x = (this._outerWidth - this.para1) / 2 + this.para4;
            _loc1_.y = this.para3;
            _loc1_.width = this.para1;
            _loc1_.height = this.para2;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_B)
         {
            _loc1_.x = (this._outerWidth - this.para1) / 2 + this.para3;
            _loc1_.y = this._outerHeight - this.para4 - this.para2;
            _loc1_.width = this.para1;
            _loc1_.height = this.para2;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_L)
         {
            _loc1_.x = this.para1;
            _loc1_.y = (this._outerHeight - this.para4) / 2 + this.para2;
            _loc1_.width = this.para3;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_R)
         {
            _loc1_.x = this._outerWidth - this.para2 - this.para3;
            _loc1_.y = (this._outerHeight - this.para3) / 2 + this.para1;
            _loc1_.width = this.para3;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_TL)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para3;
            _loc1_.width = this.para2;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_TR)
         {
            _loc1_.x = this._outerWidth - this.para1 - this.para2;
            _loc1_.y = this.para3;
            _loc1_.width = this.para1;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_BL)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this._outerHeight - this.para4 - this.para3;
            _loc1_.width = this.para2;
            _loc1_.height = this.para3;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_BR)
         {
            _loc1_.x = this._outerWidth - this.para1 - this.para2;
            _loc1_.y = this._outerHeight - this.para4 - this.para3;
            _loc1_.width = this.para1;
            _loc1_.height = this.para3;
         }
         else if(this.lockDirection == LockDirectionTypes.UNLOCK_OUTSIDE)
         {
            _loc1_.x = -this.para1;
            _loc1_.y = -this.para3;
            _loc1_.width = this._outerWidth + this.para1 + this.para2;
            _loc1_.height = this._outerHeight + this.para4 + this.para3;
         }
         else if(this.lockDirection == LockDirectionTypes.NO_SCALE_C)
         {
            _loc1_.x = (this._outerWidth - this.para2) / 2 + this.para1;
            _loc1_.y = (this._outerHeight - this.para4) / 2 + this.para3;
            _loc1_.width = this.para2;
            _loc1_.height = this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_TL)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para2;
            _loc1_.width = this._outerWidth - this.para3;
            _loc1_.height = this._outerHeight - this.para4;
         }
         else if(this.lockDirection == LockDirectionTypes.LOCK_OUTER_DOWN)
         {
            _loc1_.x = this.para1;
            _loc1_.y = this.para2;
            _loc1_.width = this._outerWidth - this.para3;
            _loc1_.height = this.para4;
         }
         return _loc1_;
      }
   }
}
