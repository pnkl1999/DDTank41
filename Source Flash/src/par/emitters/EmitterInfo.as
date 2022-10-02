package par.emitters
{
   public class EmitterInfo
   {
       
      
      public var id:Number = 0;
      
      public var name:String = "emitter";
      
      public var beginAngle:Number = 0;
      
      public var endAngle:Number = 6.283185307179586;
      
      public var interval:Number = 0.04;
      
      public var life:Number = 1;
      
      public var particales:Array;
      
      public function EmitterInfo()
      {
         this.particales = new Array();
         super();
      }
   }
}
