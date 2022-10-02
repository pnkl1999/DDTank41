package lottery.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class LotteryWorldWagerAnalyzer extends DataAnalyzer
   {
       
      
      public var worldWager:Number;
      
      public function LotteryWorldWagerAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.worldWager = Number(_loc2_.Bonus.@sum);
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
