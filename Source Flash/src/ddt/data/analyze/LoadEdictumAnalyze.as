package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class LoadEdictumAnalyze extends DataAnalyzer
   {
       
      
      public var edictumDataList:DictionaryData;
      
      public function LoadEdictumAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         this.edictumDataList = new DictionaryData();
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         if(_loc2_.@value == "true")
         {
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new Object();
               _loc5_["id"] = _loc3_[_loc4_].@ID.toString();
               _loc5_["Title"] = _loc3_[_loc4_].@Title.toString();
               _loc5_["Text"] = _loc3_[_loc4_].@Text.toString();
               _loc5_["IsExist"] = _loc3_[_loc4_].@IsExist.toString();
               this.edictumDataList[_loc5_["id"]] = _loc5_;
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
   }
}
