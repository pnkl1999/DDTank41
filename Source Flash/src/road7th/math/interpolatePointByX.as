package road7th.math
{
   import flash.geom.Point;
   
   public function interpolatePointByX(param1:Point, param2:Point, param3:Number) : Number
   {
      return (param3 - param1.x) * (param2.y - param1.y) / (param2.x - param1.x) + param1.y;
   }
}
