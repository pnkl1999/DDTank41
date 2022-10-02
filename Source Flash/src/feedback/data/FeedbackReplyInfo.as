package feedback.data
{
   public class FeedbackReplyInfo
   {
       
      
      private var _questionId:String;
      
      private var _questionTitle:String;
      
      private var _occurrenceDate:String;
      
      private var _questionContent:String;
      
      private var _replyId:int;
      
      private var _nickName:String;
      
      private var _replyDate:Date;
      
      private var _replyContent:String;
      
      private var _stopReply:String;
      
      public function FeedbackReplyInfo()
      {
         super();
      }
      
      public function get questionId() : String
      {
         return this._questionId;
      }
      
      public function set questionId(param1:String) : void
      {
         this._questionId = param1;
      }
      
      public function get replyId() : int
      {
         return this._replyId;
      }
      
      public function set replyId(param1:int) : void
      {
         this._replyId = param1;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function set nickName(param1:String) : void
      {
         this._nickName = param1;
      }
      
      public function get replyDate() : Date
      {
         return this._replyDate;
      }
      
      public function set replyDate(param1:Date) : void
      {
         this._replyDate = param1;
      }
      
      public function get replyContent() : String
      {
         return this._replyContent;
      }
      
      public function set replyContent(param1:String) : void
      {
         this._replyContent = param1;
      }
      
      public function get stopReply() : String
      {
         return this._stopReply;
      }
      
      public function set stopReply(param1:String) : void
      {
         this._stopReply = param1;
      }
      
      public function get questionTitle() : String
      {
         return this._questionTitle;
      }
      
      public function set questionTitle(param1:String) : void
      {
         this._questionTitle = param1;
      }
      
      public function get occurrenceDate() : String
      {
         return this._occurrenceDate;
      }
      
      public function set occurrenceDate(param1:String) : void
      {
         this._occurrenceDate = param1;
      }
      
      public function get questionContent() : String
      {
         return this._questionContent;
      }
      
      public function set questionContent(param1:String) : void
      {
         this._questionContent = param1;
      }
   }
}
