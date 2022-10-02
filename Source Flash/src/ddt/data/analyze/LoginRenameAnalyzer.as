package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class LoginRenameAnalyzer extends DataAnalyzer
   {
       
      
      private var _result:XML;
      
      public var tempPassword:String;
      
      public function LoginRenameAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this._result = new XML(param1);
         onAnalyzeComplete();
      }
      
      public function get result() : XML
      {
         return this._result;
      }
   }
}
