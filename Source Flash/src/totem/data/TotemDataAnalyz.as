package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class TotemDataAnalyz extends DataAnalyzer
   {
       
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      public function TotemDataAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:TotemDataVo = null;
         this._dataList = {};
         this._dataList2 = {};
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new TotemDataVo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._dataList[_loc4_.ID] = _loc4_;
               this._dataList2[_loc4_.Point] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Object
      {
         return this._dataList;
      }
      
      public function get dataList2() : Object
      {
         return this._dataList2;
      }
   }
}
