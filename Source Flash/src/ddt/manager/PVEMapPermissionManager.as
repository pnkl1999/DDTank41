package ddt.manager
{
   import flash.utils.Dictionary;
   
   public class PVEMapPermissionManager
   {
      
      private static var _instance:PVEMapPermissionManager;
       
      
      private var allPermission:Dictionary;
      
      public function PVEMapPermissionManager()
      {
         this.allPermission = new Dictionary();
         super();
      }
      
      public static function get Instance() : PVEMapPermissionManager
      {
         if(_instance == null)
         {
            _instance = new PVEMapPermissionManager();
         }
         return _instance;
      }
      
      public function getPermisitonKey(param1:int, param2:int) : int
      {
         var _loc3_:Array = [String(param1),String(param2)];
         var _loc4_:String = _loc3_.join("|");
         return this.allPermission[_loc4_];
      }
      
      public function getPermission(param1:int, param2:int, param3:String) : Boolean
      {
         var _loc4_:String = param3.substr(param1 - 1,1).toUpperCase();
         if(_loc4_ == "")
         {
            return false;
         }
         if(param2 == 0)
         {
            return true;
         }
         if(param2 == 1)
         {
            return _loc4_ != "1" ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
         if(param2 == 2)
         {
            if(_loc4_ == "F" || _loc4_ == "7")
            {
               return true;
            }
            return false;
         }
         if(param2 == 3)
         {
            return _loc4_ == "F" ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
         return false;
      }
   }
}
