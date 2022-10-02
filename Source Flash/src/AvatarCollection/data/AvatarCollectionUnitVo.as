package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   
   public class AvatarCollectionUnitVo implements INotSameHeightListCellData
   {
       
      
      public var id:int;
      
      public var sex:int;
      
      public var name:String;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Agility:int;
      
      public var Luck:int;
      
      public var Blood:int;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var needHonor:int;
      
      public var endTime:Date;
      
      public function AvatarCollectionUnitVo()
      {
         super();
      }
      
      public function get totalItemList() : Array
      {
         return AvatarCollectionManager.instance.getItemListById(this.sex,this.id);
      }
      
      public function get totalActivityItemCount() : int
      {
         var _loc3_:AvatarCollectionItemVo = null;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isActivity)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get canActivityCount() : int
      {
         var _loc3_:AvatarCollectionItemVo = null;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isActivity && _loc3_.isHas)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get canBuyCount() : int
      {
         var _loc3_:AvatarCollectionItemVo = null;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isActivity && !_loc3_.isHas && _loc3_.canBuyStatus == 1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function getCellHeight() : Number
      {
         return 37;
      }
   }
}
