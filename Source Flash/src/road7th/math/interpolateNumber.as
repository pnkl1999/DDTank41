package road7th.math
{
   public function interpolateNumber(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
   {
      return (param5 - param1) * (param4 - param2) / (param3 - param1) + param2;
   }
}
