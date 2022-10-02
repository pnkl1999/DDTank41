package feedback.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import feedback.data.FeedbackReplyInfo;
   import road7th.data.DictionaryData;
   
   public class LoadFeedbackReplyAnalyzer extends DataAnalyzer
   {
       
      
      public var listData:DictionaryData;
      
      public function LoadFeedbackReplyAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:FeedbackReplyInfo = null;
         if(String(param1) != "0" || !param1)
         {
            this.listData = new DictionaryData();
            _loc2_ = XML(param1)..Question;
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length())
               {
                  _loc4_ = new FeedbackReplyInfo();
                  _loc4_.questionId = _loc2_[_loc3_].@QuestionID;
                  _loc4_.replyId = _loc2_[_loc3_].@ReplyID;
                  _loc4_.occurrenceDate = _loc2_[_loc3_].@OccurrenceDate;
                  _loc4_.questionTitle = _loc2_[_loc3_].@Title;
                  _loc4_.questionContent = _loc2_[_loc3_].@QuestionContent;
                  _loc4_.replyContent = _loc2_[_loc3_].@ReplyContent;
                  _loc4_.stopReply = _loc2_[_loc3_].@StopReply;
                  this.listData.add(_loc4_.questionId + "_" + _loc4_.replyId,_loc4_);
                  _loc3_++;
               }
            }
         }
         onAnalyzeComplete();
      }
   }
}
