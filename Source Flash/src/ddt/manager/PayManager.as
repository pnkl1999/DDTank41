package ddt.manager
{
   public class PayManager
   {
      
      private static var _ins:PayManager;
       
      
      public function PayManager()
      {
         super();
      }
      
      public static function Instance() : PayManager
      {
         return _ins = _ins || new PayManager();
      }
   }
}
