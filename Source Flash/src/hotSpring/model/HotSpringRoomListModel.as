package hotSpring.model
{
   import ddt.data.HotSpringRoomInfo;
   import ddt.manager.HotSpringManager;
   import flash.events.EventDispatcher;
   import hotSpring.event.HotSpringRoomListEvent;
   import road7th.data.DictionaryData;
   
   public class HotSpringRoomListModel extends EventDispatcher
   {
      
      private static var _instance:HotSpringRoomListModel;
       
      
      private var _roomList:DictionaryData;
      
      private var _roomSelf:HotSpringRoomInfo;
      
      public function HotSpringRoomListModel()
      {
         this._roomList = new DictionaryData();
         super();
      }
      
      public static function get Instance() : HotSpringRoomListModel
      {
         if(_instance == null)
         {
            _instance = new HotSpringRoomListModel();
         }
         return _instance;
      }
      
      public function get roomList() : DictionaryData
      {
         this._roomList.list.sortOn("roomNumber",Array.NUMERIC);
         return this._roomList;
      }
      
      public function roomAddOrUpdate(param1:HotSpringRoomInfo) : void
      {
         if(HotSpringManager.instance.roomCurrently && HotSpringManager.instance.roomCurrently.roomID == param1.roomID)
         {
            HotSpringManager.instance.roomCurrently = param1;
         }
         if(this._roomList[param1.roomID] != null)
         {
            this._roomList.add(param1.roomID,param1);
            dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_UPDATE,param1));
         }
         else
         {
            this._roomList.add(param1.roomID,param1);
            dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_ADD,param1));
            dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE));
         }
      }
      
      public function roomRemove(param1:int) : void
      {
         this._roomList.remove(param1);
         dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_REMOVE,param1));
         dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE));
      }
      
      public function get roomSelf() : HotSpringRoomInfo
      {
         return this._roomSelf;
      }
      
      public function set roomSelf(param1:HotSpringRoomInfo) : void
      {
         this._roomSelf = param1;
         dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_CREATE,this._roomSelf));
      }
      
      public function dispose() : void
      {
         this._roomSelf = null;
         if(this._roomList)
         {
            this._roomList.clear();
         }
         this._roomList = null;
         _instance = null;
      }
   }
}
