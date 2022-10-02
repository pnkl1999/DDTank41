package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import flash.utils.Dictionary;
   
   public class VoteInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var firstQuestionID:String;
      
      public var completeMessage:String;
      
      public var questionLength:int;
      
      public var list:Dictionary;
      
      public var voteId:String;
      
      private var award:String;
      
      public function VoteInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get awardArr() : Array
      {
         return this.award.split(",");
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:VoteQuestionInfo = null;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         this.list = new Dictionary();
         var _loc2_:XML = new XML(param1);
         this.voteId = _loc2_.@voteId;
         this.firstQuestionID = _loc2_.@firstQuestionID;
         this.completeMessage = _loc2_.@completeMessage;
         this.award = _loc2_.@award;
         var _loc3_:XMLList = _loc2_..item;
         this.questionLength = _loc3_.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new VoteQuestionInfo();
            _loc5_.questionID = _loc3_[_loc4_].@id;
            _loc5_.multiple = _loc3_[_loc4_].@multiple == "true"?Boolean(Boolean(true)):Boolean(Boolean(false));
            _loc5_.question = _loc3_[_loc4_].@question;
            _loc5_.nextQuestionID = _loc3_[_loc4_].@nextQuestionID;
            _loc6_ = _loc3_[_loc4_]..answer;
            _loc5_.answerLength = _loc6_.length();
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length())
            {
               _loc8_ = _loc6_[_loc7_].@id;
               _loc9_ = _loc6_[_loc7_].@value;
               _loc5_.answer[_loc8_] = _loc9_;
               _loc7_++;
            }
            this.list[_loc5_.questionID] = _loc5_;
            _loc4_++;
         }
         onAnalyzeComplete();
      }
   }
}
