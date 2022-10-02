package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaApplyInfo;
   
   public class ConsortionApplyListAnalyzer extends DataAnalyzer
   {
       
      
      public var applyList:Vector.<ConsortiaApplyInfo>;
      
      public var totalCount:int;
      
      public function ConsortionApplyListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ConsortiaApplyInfo = null;
         this.applyList = new Vector.<ConsortiaApplyInfo>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.totalCount = int(_loc2_.@total);
            _loc3_ = XML(_loc2_)..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortiaApplyInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.applyList.push(_loc5_);
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
