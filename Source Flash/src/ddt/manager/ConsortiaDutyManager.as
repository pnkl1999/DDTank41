package ddt.manager
{
   import flash.events.EventDispatcher;
   
   public class ConsortiaDutyManager extends EventDispatcher
   {
      
      private static var _instance:ConsortiaDutyManager;
       
      
      public function ConsortiaDutyManager()
      {
         super();
      }
      
      public static function GetRight(param1:int, param2:int) : Boolean
      {
         return (param1 & int(param2)) != 0;
      }
      
      public static function get Instance() : ConsortiaDutyManager
      {
         if(_instance == null)
         {
            _instance = new ConsortiaDutyManager();
         }
         return _instance;
      }
   }
}
