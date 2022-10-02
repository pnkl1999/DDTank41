package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class HonorUpDataAnalyz extends DataAnalyzer
   {
       
      
      private var _dataList:Array;
      
      public function HonorUpDataAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:HonorUpDataVo = null;
         var _loc5_:XML = new XML(param1);
         this._dataList = [];
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new HonorUpDataVo();
               _loc4_.index = _loc2_[_loc3_].@ID;
               _loc4_.honor = _loc2_[_loc3_].@AddHonor;
               _loc4_.money = _loc2_[_loc3_].@NeedMoney;
               this._dataList.push(_loc4_);
               _loc3_++;
            }
            this._dataList.sortOn("index",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
   }
}
