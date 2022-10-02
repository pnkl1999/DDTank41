package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class VoteSubmitResultAnalyzer extends DataAnalyzer
   {
       
      
      public var result:int;
      
      public function VoteSubmitResultAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this.result = param1;
         onAnalyzeComplete();
      }
   }
}
