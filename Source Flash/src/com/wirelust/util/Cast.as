package com.wirelust.util
{
   public class Cast
   {
       
      
      public function Cast()
      {
         super();
      }
      
      public static function toShort(param1:int) : int
      {
         var _loc2_:Number = param1 & 32767;
         var _loc3_:Number = _loc2_;
         if(param1 >> 15 == 1)
         {
            _loc3_ = _loc2_ - 32768;
         }
         return _loc3_;
      }
      
      public static function toByte(param1:int) : int
      {
         var _loc2_:Number = param1 & 127;
         var _loc3_:Number = _loc2_;
         var _loc4_:Number = (param1 & 255) >> 7;
         if(_loc4_ == 1)
         {
            _loc3_ = _loc2_ - 128;
         }
         return _loc3_;
      }
   }
}
