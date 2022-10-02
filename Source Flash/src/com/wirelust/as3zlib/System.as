package com.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public class System
   {
       
      
      public function System()
      {
         super();
      }
      
      public static function arrayCopy(param1:Array, param2:int, param3:Array, param4:int, param5:int) : void
      {
         var _loc6_:int = 0;
         while(_loc6_ < param5)
         {
            param3[param4 + _loc6_] = param1[param2 + _loc6_];
            _loc6_++;
         }
      }
      
      public static function byteArrayCopy(param1:ByteArray, param2:int, param3:ByteArray, param4:int, param5:int) : void
      {
         var _loc6_:int = 0;
         while(_loc6_ < param5)
         {
            param3[param4 + _loc6_] = param1[param2 + _loc6_];
            _loc6_++;
         }
      }
   }
}
