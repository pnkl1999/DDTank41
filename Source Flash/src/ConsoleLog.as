package
{
   import flash.external.ExternalInterface;
   
   public class ConsoleLog
   {
      
      private static var _instance:ConsoleLog;
       
      
      public function ConsoleLog()
      {
         super();
      }
      
      public static function get Instance() : ConsoleLog
      {
         if(!_instance)
         {
            _instance = new ConsoleLog();
         }
         return _instance;
      }
      
      public static function write(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("console.log",param1);
         }
      }
   }
}
