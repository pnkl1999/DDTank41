package civil
{
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   
   public class CivilModel extends EventDispatcher
   {
       
      
      private var _civilPlayers:Array;
      
      private var _currentcivilItemInfo:CivilPlayerInfo;
      
      private var _totalPage:int;
      
      private var _currentLeafSex:Boolean = true;
      
      private var _register:Boolean = false;
      
      private var _IsFirst:Boolean = false;
      
      public function CivilModel(param1:Boolean)
      {
         this._IsFirst = param1;
         super();
      }
      
      public function set currentcivilItemInfo(param1:CivilPlayerInfo) : void
      {
         this._currentcivilItemInfo = param1;
         dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE));
      }
      
      public function get currentcivilItemInfo() : CivilPlayerInfo
      {
         return this._currentcivilItemInfo;
      }
      
      public function upSelfPublishEquit(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._civilPlayers.length)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[_loc2_].UserId)
            {
               (this._civilPlayers[_loc2_] as CivilPlayerInfo).IsPublishEquip = param1;
               break;
            }
            _loc2_++;
         }
      }
      
      public function upSelfIntroduction(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._civilPlayers.length)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[_loc2_].UserId)
            {
               (this._civilPlayers[_loc2_] as CivilPlayerInfo).Introduction = param1;
               break;
            }
            _loc2_++;
         }
      }
      
      public function set civilPlayers(param1:Array) : void
      {
         this._civilPlayers = param1;
         var _loc2_:int = this._civilPlayers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[_loc3_].UserId && PlayerManager.Instance.Self.Introduction == "")
            {
               PlayerManager.Instance.Self.Introduction = (this._civilPlayers[_loc3_] as CivilPlayerInfo).Introduction;
               break;
            }
            _loc3_++;
         }
         dispatchEvent(new CivilEvent(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE));
      }
      
      public function update() : void
      {
      }
      
      public function updateBtn() : void
      {
         dispatchEvent(new CivilEvent(CivilEvent.CIVIL_UPDATE_BTN));
      }
      
      public function get civilPlayers() : Array
      {
         return this._civilPlayers;
      }
      
      public function set TotalPage(param1:int) : void
      {
         this._totalPage = param1;
      }
      
      public function get TotalPage() : int
      {
         return this._totalPage;
      }
      
      public function get sex() : Boolean
      {
         return this._currentLeafSex;
      }
      
      public function set sex(param1:Boolean) : void
      {
         this._currentLeafSex = param1;
      }
      
      public function get registed() : Boolean
      {
         return this._register;
      }
      
      public function set registed(param1:Boolean) : void
      {
         this._register = param1;
         dispatchEvent(new CivilEvent(CivilEvent.REGISTER_CHANGE));
      }
      
      public function get IsFirst() : Boolean
      {
         return this._IsFirst;
      }
      
      public function dispose() : void
      {
         this._civilPlayers = null;
         this.currentcivilItemInfo = null;
      }
   }
}
