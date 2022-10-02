package road7th.math
{
   import flash.geom.Point;
   
   public class ColorLine extends XLine
   {
       
      
      public function ColorLine()
      {
         super();
      }
      
      override public function interpolate(param1:Number) : Number
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(!fix)
         {
            _loc4_ = 1;
            while(_loc4_ < list.length)
            {
               _loc3_ = list[_loc4_];
               _loc2_ = list[_loc4_ - 1];
               if(_loc3_.x > param1)
               {
                  break;
               }
               _loc4_++;
            }
            return interpolateColors(_loc2_.y,_loc3_.y,1 - (param1 - _loc2_.x) / (_loc3_.x - _loc2_.x));
         }
         return fixValue;
      }
   }
}
