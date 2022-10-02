package roomList.pvpRoomList
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   
   public class RoomListModel extends EventDispatcher
   {
      
      public static const ROOMSHOWMODE_CHANGE:String = "roomshowmodechange";
      
      public static const ROOM_ITEM_UPDATE:String = "roomItemUpdate";
       
      
      private var _roomList:DictionaryData;
      
      private var _playerlist:DictionaryData;
      
      private var _self:PlayerInfo;
      
      private var _roomTotal:int;
      
      private var _roomShowMode:int;
      
      private var _temListArray:Array;
      
      private var _isAddEnd:Boolean;
      
      public function RoomListModel()
      {
         super();
         this._roomList = new DictionaryData(true);
         this._playerlist = new DictionaryData(true);
         this._self = PlayerManager.Instance.Self;
         this._roomShowMode = 1;
      }
      
      public function getSelfPlayerInfo() : PlayerInfo
      {
         return this._self;
      }
      
      public function get isAddEnd() : Boolean
      {
         return this._isAddEnd;
      }
      
      public function updateRoom(param1:Array) : void
      {
         this._roomList.clear();
         this._isAddEnd = false;
         if(param1.length == 0)
         {
            return;
         }
         param1 = RoomListController.disorder(param1);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ == param1.length - 1)
            {
               this._isAddEnd = true;
            }
            this._roomList.add((param1[_loc2_] as RoomInfo).ID,param1[_loc2_] as RoomInfo);
            _loc2_++;
         }
         dispatchEvent(new Event(ROOM_ITEM_UPDATE));
      }
      
      public function set roomTotal(param1:int) : void
      {
         this._roomTotal = param1;
      }
      
      public function get roomTotal() : int
      {
         return this._roomTotal;
      }
      
      public function getRoomById(param1:int) : RoomInfo
      {
         return this._roomList[param1];
      }
      
      public function getRoomList() : DictionaryData
      {
         return this._roomList;
      }
      
      public function addWaitingPlayer(param1:PlayerInfo) : void
      {
         this._playerlist.add(param1.ID,param1);
      }
      
      public function removeWaitingPlayer(param1:int) : void
      {
         this._playerlist.remove(param1);
      }
      
      public function getPlayerList() : DictionaryData
      {
         return this._playerlist;
      }
      
      public function get roomShowMode() : int
      {
         return this._roomShowMode;
      }
      
      public function set roomShowMode(param1:int) : void
      {
         this._roomShowMode = param1;
         dispatchEvent(new Event(ROOMSHOWMODE_CHANGE));
      }
      
      public function dispose() : void
      {
         this._roomList = null;
         this._playerlist = null;
         this._self = null;
      }
   }
}
