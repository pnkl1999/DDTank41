package giftSystem.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import giftSystem.data.RecordInfo;
   import giftSystem.data.RecordItemInfo;
   
   public class RecordAnalyzer extends DataAnalyzer
   {
       
      
      private var _info:RecordInfo;
      
      public function RecordAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:RecordItemInfo = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this._info = new RecordInfo();
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new RecordItemInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._info.recordList.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get info() : RecordInfo
      {
         return this._info;
      }
   }
}
