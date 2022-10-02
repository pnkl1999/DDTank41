package ddt.utils
{
   import flash.geom.Point;
   
   public class Geometry
   {
       
      
      public function Geometry()
      {
         super();
      }
      
      public static function getAngle4(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.atan2(param4 - param2,param3 - param1);
      }
      
      public static function getAngle(param1:Point, param2:Point) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x);
      }
      
      public static function nextPoint2(param1:Number, param2:Number, param3:Number, param4:Number) : Point
      {
         return new Point(param1 + Math.cos(param3) * param4,param2 + Math.sin(param3) * param4);
      }
      
      public static function nextPoint(param1:Point, param2:Number, param3:Number) : Point
      {
         return new Point(param1.x + Math.cos(param2) * param3,param1.y + Math.sin(param2) * param3);
      }
      
      private static function standardAngle(param1:Number) : Number
      {
         param1 %= 2 * Math.PI;
         if(param1 > Math.PI)
         {
            param1 -= 2 * Math.PI;
         }
         else if(param1 < -Math.PI)
         {
            param1 += 2 * Math.PI;
         }
         return param1;
      }
      
      public static function crossAngle(param1:Number, param2:Number) : Number
      {
         return standardAngle(standardAngle(param1) - standardAngle(param2));
      }
      
      public static function isClockwish(param1:Number, param2:Number) : Boolean
      {
         return crossAngle(param1,param2) < 0;
      }
      
      public static function cross_x(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Number
      {
         var _loc9_:Number = (param2 - param4) / (param3 * param2 - param1 * param4);
         var _loc10_:Number = (param3 - param1) / (param3 * param2 - param1 * param4);
         var _loc11_:Number = (param6 - param8) / (param7 * param6 - param5 * param8);
         var _loc12_:Number = (param7 - param5) / (param7 * param6 - param5 * param8);
         return Number((_loc10_ - _loc12_) / (_loc11_ * _loc10_ - _loc9_ * _loc12_));
      }
      
      public static function cross_y(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Number
      {
         var _loc9_:Number = (param2 - param4) / (param3 * param2 - param1 * param4);
         var _loc10_:Number = (param3 - param1) / (param3 * param2 - param1 * param4);
         var _loc11_:Number = (param6 - param8) / (param7 * param6 - param5 * param8);
         var _loc12_:Number = (param7 - param5) / (param7 * param6 - param5 * param8);
         return Number((_loc9_ - _loc11_) / (_loc12_ * _loc9_ - _loc10_ * _loc11_));
      }
      
      public static function crossPoint2D(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point
      {
         var _loc9_:Number = (param2 - param4) / (param3 * param2 - param1 * param4);
         var _loc10_:Number = (param3 - param1) / (param3 * param2 - param1 * param4);
         var _loc11_:Number = (param6 - param8) / (param7 * param6 - param5 * param8);
         var _loc12_:Number = (param7 - param5) / (param7 * param6 - param5 * param8);
         var _loc13_:Number = (_loc10_ - _loc12_) / (_loc11_ * _loc10_ - _loc9_ * _loc12_);
         var _loc14_:Number = (_loc9_ - _loc11_) / (_loc12_ * _loc9_ - _loc10_ * _loc11_);
         return new Point(_loc13_,_loc14_);
      }
      
      public static function distance(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(distanceSq(param1,param2));
      }
      
      public static function distanceSq(param1:Point, param2:Point) : Number
      {
         return (param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y);
      }
   }
}
