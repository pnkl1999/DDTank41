package com.pickgliss.geom
{
   import flash.geom.Point;
   
   public class OuterRectPos
   {
       
      
      private var _posX:int;
      
      private var _posY:int;
      
      private var _lockDirection:int;
      
      public function OuterRectPos(param1:int, param2:int, param3:int)
      {
         super();
         this._posX = param1;
         this._posY = param2;
         this._lockDirection = param3;
      }
      
      public function getPos(param1:int, param2:int, param3:int, param4:int) : Point
      {
         var _loc5_:Point = new Point();
         if(this._lockDirection == LockDirectionTypes.LOCK_T)
         {
            _loc5_.x = (param3 - param1) / 2 + this._posX;
            _loc5_.y = this._posY;
         }
         else if(this._lockDirection == LockDirectionTypes.LOCK_TL)
         {
            _loc5_.x = this._posX;
            _loc5_.y = this._posY;
         }
         else if(this._lockDirection == LockDirectionTypes.LOCK_TR)
         {
         }
         return _loc5_;
      }
   }
}
