package ddt.utils
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.TimeManager;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class GoodUtils
   {
       
      
      public function GoodUtils()
      {
         super();
      }
      
      public static function getOverdueItemsFrom(param1:DictionaryData) : Array
      {
         var _loc4_:Date = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:InventoryItemInfo = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         for each(_loc7_ in param1)
         {
            if(_loc7_)
            {
               if(_loc7_.IsUsed)
               {
                  if(_loc7_.ValidDate != 0)
                  {
                     _loc4_ = DateUtils.getDateByStr(_loc7_.BeginDate);
                     _loc5_ = TimeManager.Instance.TotalDaysToNow(_loc4_);
                     _loc6_ = (_loc7_.ValidDate - _loc5_) * 24;
                     if(_loc6_ < 24 && _loc6_ > 0)
                     {
                        _loc2_.push(_loc7_);
                     }
                     else if(_loc6_ <= 0)
                     {
                        _loc3_.push(_loc7_);
                     }
                  }
               }
            }
         }
         return [_loc2_,_loc3_];
      }
   }
}
