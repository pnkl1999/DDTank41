package phy.math
{
   public class EulerVector
   {
       
      
      public var x0:Number;
      
      public var x1:Number;
      
      public var x2:Number;
      
      public function EulerVector(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.x0 = param1;
         this.x1 = param2;
         this.x2 = param3;
      }
      
      public function clear() : void
      {
         this.x0 = 0;
         this.x1 = 0;
         this.x2 = 0;
      }
      
      public function clearMotion() : void
      {
         this.x1 = 0;
         this.x2 = 0;
      }
      
      public function ComputeOneEulerStep(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.x2 = (param3 - param2 * this.x1) / param1;
         this.x1 += this.x2 * param4;
         this.x0 += this.x1 * param4;
      }
      
      public function toString() : String
      {
         return "x:" + this.x0 + ",v:" + this.x1 + ",a" + this.x2;
      }
   }
}
