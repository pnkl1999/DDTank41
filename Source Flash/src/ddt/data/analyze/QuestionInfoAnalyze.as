package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.QuestionInfo;
   import road7th.data.DictionaryData;
   
   public class QuestionInfoAnalyze extends DataAnalyzer
   {
       
      
      public var questionList:DictionaryData;
      
      public var allQuestion:Array;
      
      public function QuestionInfoAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:QuestionInfo = null;
         var _loc2_:XML = new XML(param1);
         this.allQuestion = [];
         this.questionList = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new QuestionInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               if(this.allQuestion[_loc5_.QuestionCatalogID] == null)
               {
                  this.allQuestion[_loc5_.QuestionCatalogID] = new DictionaryData();
               }
               this.allQuestion[_loc5_.QuestionCatalogID].add(_loc5_.QuestionID,_loc5_);
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
