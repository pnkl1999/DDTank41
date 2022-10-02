package ddt.manager
{
   public class InviteManager
   {
      
      private static var _ins:InviteManager;
       
      
      private var _enabled:Boolean = true;
      
      public function InviteManager()
      {
         super();
      }
      
      public static function get Instance() : InviteManager
      {
         return _ins = _ins || new InviteManager();
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled == param1)
         {
            return;
         }
         this._enabled = param1;
      }
   }
}
