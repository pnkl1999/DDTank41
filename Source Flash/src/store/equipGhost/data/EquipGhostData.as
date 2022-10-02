package store.equipGhost.data
{
   import ddt.data.BagInfo;
   
   public class EquipGhostData
   {
       
      
      private var _bagType:uint;
      
      private var _place:uint;
      
      private var _categoryID:uint;
      
      public var level:uint;
      
      public var totalGhost:uint;
      
      public function EquipGhostData(param1:uint, param2:uint)
      {
         super();
         this._bagType = param1;
         this._place = param2;
         this._categoryID = BagInfo.parseCategoryID(this._bagType,this._place);
      }
      
      public function get categoryID() : uint
      {
         return this._categoryID;
      }
      
      public function get place() : uint
      {
         return this._place;
      }
      
      public function get bagType() : uint
      {
         return this._bagType;
      }
   }
}
