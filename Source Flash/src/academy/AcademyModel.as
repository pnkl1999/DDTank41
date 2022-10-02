package academy
{
   import ddt.data.player.AcademyPlayerInfo;
   
   public class AcademyModel
   {
       
      
      private var _requestType:Boolean;
      
      private var _currentSex:Boolean;
      
      private var _register:Boolean;
      
      private var _appshipStateType:Boolean;
      
      private var _academyPlayers:Vector.<AcademyPlayerInfo>;
      
      private var _currentAcademyItemInfo:AcademyPlayerInfo;
      
      private var _totalPage:int;
      
      private var _selfIsRegister:Boolean;
      
      private var _selfDescribe:String;
      
      public function AcademyModel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._academyPlayers = new Vector.<AcademyPlayerInfo>();
      }
      
      public function set list(param1:Vector.<AcademyPlayerInfo>) : void
      {
         this._academyPlayers = param1;
      }
      
      public function get list() : Vector.<AcademyPlayerInfo>
      {
         return this._academyPlayers;
      }
      
      public function set sex(param1:Boolean) : void
      {
         this._currentSex = param1;
      }
      
      public function get sex() : Boolean
      {
         return this._currentSex;
      }
      
      public function set state(param1:Boolean) : void
      {
         this._appshipStateType = param1;
      }
      
      public function get state() : Boolean
      {
         return this._appshipStateType;
      }
      
      public function set info(param1:AcademyPlayerInfo) : void
      {
         this._currentAcademyItemInfo = param1;
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._currentAcademyItemInfo;
      }
      
      public function set totalPage(param1:int) : void
      {
         this._totalPage = param1;
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      public function set selfIsRegister(param1:Boolean) : void
      {
         this._selfIsRegister = param1;
      }
      
      public function get selfIsRegister() : Boolean
      {
         return this._selfIsRegister;
      }
      
      public function set selfDescribe(param1:String) : void
      {
         this._selfDescribe = param1;
      }
      
      public function get selfDescribe() : String
      {
         return this._selfDescribe;
      }
   }
}
