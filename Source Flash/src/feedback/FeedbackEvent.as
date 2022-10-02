package feedback
{
   import flash.events.Event;
   
   public class FeedbackEvent extends Event
   {
      
      public static const FEEDBACK_REPLY_ADD:String = "feedbackReplyAdd";
      
      public static const FEEDBACK_REPLY_REMOVE:String = "feedbackReplyRemove";
      
      public static const FEEDBACK_StopReply:String = "feedbackStopReply";
       
      
      public var data:Object;
      
      public function FeedbackEvent(param1:String, param2:Object)
      {
         this.data = param2;
         super(param1);
      }
   }
}
