package ddt.manager
{
   import ddt.data.Role;
   import ddt.data.analyze.LoginSelectListAnalyzer;
   
   public class SelectListManager
   {
      
      private static var _instance:SelectListManager;
       
      
      private var _isNewBie:Boolean;
      
      private var _list:Vector.<Role>;
      
      private var _currentLoginRole:Role;
      
      public function SelectListManager()
      {
         super();
      }
      
      public static function get Instance() : SelectListManager
      {
         if(_instance == null)
         {
            _instance = new SelectListManager();
         }
         return _instance;
      }
      
      public function setup(param1:LoginSelectListAnalyzer) : void
      {
         this._list = param1.list;
         if(this._list.length == 0)
         {
            this._isNewBie = true;
         }
         if(this._list.length == 1)
         {
            this.currentLoginRole = this._list[0];
         }
      }
      
      public function get list() : Vector.<Role>
      {
         return this._list;
      }
      
      public function set currentLoginRole(param1:Role) : void
      {
         this._currentLoginRole = param1;
      }
      
      public function get currentLoginRole() : Role
      {
         return this._currentLoginRole;
      }
      
      public function get mustShowSelectWindow() : Boolean
      {
         if(this._list.length == 1 && this._list[0].Rename == false && this._list[0].ConsortiaRename == false)
         {
            return false;
         }
         return true;
      }
      
      public function get isNewbie() : Boolean
      {
         return this._isNewBie;
      }
   }
}
