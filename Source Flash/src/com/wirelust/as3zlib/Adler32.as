package com.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class Adler32
   {
      
      private static var BASE:int = 65521;
      
      private static var NMAX:int = 5552;
       
      
      public function Adler32()
      {
         super();
      }
      
      public function adler32(param1:Number, param2:ByteArray, param3:int, param4:int) : Number
      {
         var _loc7_:int = 0;
         if(param2 == null)
         {
            return 1;
         }
         var _loc5_:Number = param1 & 65535;
         var _loc6_:Number = param1 >> 16 & 65535;
         while(param4 > 0)
         {
            _loc7_ = param4 < NMAX ? int(int(param4)) : int(int(NMAX));
            param4 -= _loc7_;
            while(_loc7_ >= 16)
            {
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc5_ += param2[param3++] & 255;
               _loc6_ += _loc5_;
               _loc7_ -= 16;
            }
            if(_loc7_ != 0)
            {
               do
               {
                  _loc5_ += param2[param3++] & 255;
                  _loc6_ += _loc5_;
               }
               while(--_loc7_ != 0);
               
            }
            _loc5_ %= BASE;
            _loc6_ %= BASE;
         }
         return _loc6_ << 16 | _loc5_;
      }
   }
}
