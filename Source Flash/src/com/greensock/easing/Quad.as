package com.greensock.easing
{
   public class Quad
   {
      
      public static const power:uint = 1;
       
      
      public function Quad()
      {
         super();
      }
      
      public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 + param2;
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if((param1 = param1 / (param4 * 0.5)) < 1)
         {
            return param3 * 0.5 * param1 * param1 + param2;
         }
         return -param3 * 0.5 * (--param1 * (param1 - 2) - 1) + param2;
      }
   }
}
