package store
{
   public class StoreBagBgWHPoint
   {
       
      
      public var sequencePoint:String;
      
      public function StoreBagBgWHPoint()
      {
         super();
      }
      
      public function get pointArr() : Array
      {
         return this.sequencePoint.split(/,/g);
      }
   }
}
