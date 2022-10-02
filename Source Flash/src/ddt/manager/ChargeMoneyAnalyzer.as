package ddt.manager
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class ChargeMoneyAnalyzer extends DataAnalyzer
   {
       
      
      public var result:Boolean;
      
      public function ChargeMoneyAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.result = true;
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
