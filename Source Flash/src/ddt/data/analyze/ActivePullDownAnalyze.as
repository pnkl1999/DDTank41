package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class ActivePullDownAnalyze extends DataAnalyzer
   {
       
      
      public var result:String;
      
      public function ActivePullDownAnalyze(param1:Function)
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
