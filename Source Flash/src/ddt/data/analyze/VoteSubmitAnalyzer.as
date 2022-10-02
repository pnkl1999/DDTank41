package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class VoteSubmitAnalyzer extends DataAnalyzer
   {
      
      public static const FILENAME:String = "vote.xml";
       
      
      public var result:String = "";
      
      public function VoteSubmitAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         if(param1 != -1)
         {
            this.result = param1;
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
