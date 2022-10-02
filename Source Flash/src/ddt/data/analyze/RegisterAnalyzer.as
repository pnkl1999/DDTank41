package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class RegisterAnalyzer extends DataAnalyzer
   {
       
      
      public function RegisterAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         var _loc3_:String = _loc2_.@value;
         message = _loc2_.@message;
         if(_loc3_ == "true")
         {
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}
