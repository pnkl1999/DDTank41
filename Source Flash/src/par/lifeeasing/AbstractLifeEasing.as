package par.lifeeasing
{
   import road7th.math.ColorLine;
   import road7th.math.XLine;
   
   public class AbstractLifeEasing
   {
       
      
      public var vLine:XLine;
      
      public var rvLine:XLine;
      
      public var spLine:XLine;
      
      public var sizeLine:XLine;
      
      public var weightLine:XLine;
      
      public var alphaLine:XLine;
      
      public var colorLine:ColorLine;
      
      public function AbstractLifeEasing()
      {
         this.vLine = new XLine();
         this.rvLine = new XLine();
         this.spLine = new XLine();
         this.sizeLine = new XLine();
         this.weightLine = new XLine();
         this.alphaLine = new XLine();
         super();
      }
      
      public function easingVelocity(param1:Number, param2:Number) : Number
      {
         return param1 * this.vLine.interpolate(param2);
      }
      
      public function easingRandomVelocity(param1:Number, param2:Number) : Number
      {
         return param1 * this.rvLine.interpolate(param2);
      }
      
      public function easingSize(param1:Number, param2:Number) : Number
      {
         return param1 * this.sizeLine.interpolate(param2);
      }
      
      public function easingSpinVelocity(param1:Number, param2:Number) : Number
      {
         return param1 * this.spLine.interpolate(param2);
      }
      
      public function easingWeight(param1:Number, param2:Number) : Number
      {
         return param1 * this.weightLine.interpolate(param2);
      }
      
      public function easingColor(param1:uint, param2:Number) : uint
      {
         if(this.colorLine)
         {
            return this.colorLine.interpolate(param2);
         }
         return param1;
      }
      
      public function easingApha(param1:Number, param2:Number) : Number
      {
         return param1 * this.alphaLine.interpolate(param2);
      }
   }
}
