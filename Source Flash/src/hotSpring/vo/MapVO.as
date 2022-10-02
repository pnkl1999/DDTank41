package hotSpring.vo
{
   public class MapVO
   {
       
      
      private var _mapWidth:Number = 1200;
      
      private var _mapHeight:Number = 1077;
      
      public function MapVO()
      {
         super();
      }
      
      public function get mapWidth() : Number
      {
         return this._mapWidth;
      }
      
      public function get mapHeight() : Number
      {
         return this._mapHeight;
      }
   }
}
