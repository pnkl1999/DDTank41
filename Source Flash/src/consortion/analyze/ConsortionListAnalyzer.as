package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaInfo;
   
   public class ConsortionListAnalyzer extends DataAnalyzer
   {
       
      
      public var consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsTotalCount:int;
      
      public function ConsortionListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ConsortiaInfo = null;
         this.consortionList = new Vector.<ConsortiaInfo>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.consortionsTotalCount = int(_loc2_.@total);
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortiaInfo();
               _loc5_.beginChanges();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc5_.commitChanges();
               this.consortionList.push(_loc5_);
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
