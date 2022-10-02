package ddt.data.vote
{
   import flash.utils.Dictionary;
   
   public class VoteQuestionInfo
   {
       
      
      public var questionID:String;
      
      public var question:String;
      
      public var nextQuestionID:String;
      
      public var multiple:Boolean;
      
      public var answer:Dictionary;
      
      public var answerLength:int;
      
      public function VoteQuestionInfo()
      {
         super();
         this.answer = new Dictionary();
      }
   }
}
