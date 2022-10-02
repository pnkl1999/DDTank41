package cardSystem.analyze
{
   import cardSystem.data.SetsPropertyInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class SetsPropertiesAnalyzer extends DataAnalyzer
   {
       
      
      public var setsList:DictionaryData;
      
      public function SetsPropertiesAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Vector.<SetsPropertyInfo> = null;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         var _loc9_:SetsPropertyInfo = null;
         this.setsList = new DictionaryData();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Card;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = _loc3_[_loc4_].@CardID;
               _loc6_ = new Vector.<SetsPropertyInfo>();
               _loc7_ = _loc3_[_loc4_]..Item;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length())
               {
                  if(_loc7_[_loc8_].@condition != "0")
                  {
                     _loc9_ = new SetsPropertyInfo();
                     ObjectUtils.copyPorpertiesByXML(_loc9_,_loc7_[_loc8_]);
                     _loc6_.push(_loc9_);
                  }
                  _loc8_++;
               }
               this.setsList.add(_loc5_,_loc6_);
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
