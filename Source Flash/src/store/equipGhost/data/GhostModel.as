package store.equipGhost.data
{
   import flash.utils.Dictionary;
   
   public final class GhostModel
   {
       
      
      private var _dataList:Vector.<GhostData>;
      
      private var _topLvDic:Dictionary;
      
      public function GhostModel()
      {
         this._topLvDic = new Dictionary();
         super();
      }
      
      public function initModel(param1:Vector.<GhostData>) : void
      {
         var _loc3_:* = undefined;
         this._dataList = param1;
         var _loc2_:int = -1;
         for each(_loc3_ in this._dataList)
         {
            _loc2_ = _loc3_.categoryID;
            if(!this._topLvDic[_loc2_])
            {
               this._topLvDic[_loc2_] = 0;
            }
            if(_loc3_.level > this._topLvDic[_loc2_])
            {
               this._topLvDic[_loc2_] = _loc3_.level;
            }
         }
      }
      
      public function get topLvDic() : Dictionary
      {
         return this._topLvDic;
      }
      
      public function getGhostData(param1:int, param2:int) : GhostData
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in this._dataList)
         {
            if(_loc3_.categoryID == param1 && _loc3_.level == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
