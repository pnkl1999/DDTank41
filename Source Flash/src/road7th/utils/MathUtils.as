package road7th.utils
{
   import flash.geom.Point;
   
   public class MathUtils
   {
       
      
      public function MathUtils()
      {
         super();
      }
      
      public static function AngleToRadian(param1:Number) : Number
      {
         return param1 / 180 * Math.PI;
      }
      
      public static function RadianToAngle(param1:Number) : Number
      {
         return param1 / Math.PI * 180;
      }
      
      public static function atan2(param1:Number, param2:Number) : Number
      {
         return RadianToAngle(Math.atan2(param1,param2));
      }
      
      public static function GetAngleTwoPoint(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return Math.floor(RadianToAngle(Math.atan2(_loc4_,_loc3_)));
      }
      
      public static function cos(param1:Number) : Number
      {
         return Math.cos(MathUtils.AngleToRadian(param1));
      }
      
      public static function sin(param1:Number) : Number
      {
         return Math.sin(MathUtils.AngleToRadian(param1));
      }
      
      public static function getValueInRange(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 <= param2)
         {
            return param2;
         }
         if(param1 >= param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function isInRange(param1:Number, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = true) : Boolean
      {
         if(param1 < param2 || param1 > param3)
         {
            return false;
         }
         if(param1 == param2)
         {
            return param4;
         }
         if(param1 == param3)
         {
            return param5;
         }
         return true;
      }
   }
}
