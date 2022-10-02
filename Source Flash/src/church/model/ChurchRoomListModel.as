package church.model
{
   import ddt.data.ChurchRoomInfo;
   import road7th.data.DictionaryData;
   
   public class ChurchRoomListModel
   {
       
      
      private var _roomList:DictionaryData;
      
      public function ChurchRoomListModel()
      {
         super();
         this._roomList = new DictionaryData(true);
      }
      
      public function get roomList() : DictionaryData
      {
         return this._roomList;
      }
      
      public function addRoom(param1:ChurchRoomInfo) : void
      {
         if(param1)
         {
            this._roomList.add(param1.id,param1);
         }
      }
      
      public function removeRoom(param1:int) : void
      {
         if(this._roomList[param1])
         {
            this._roomList.remove(param1);
         }
      }
      
      public function updateRoom(param1:ChurchRoomInfo) : void
      {
         if(param1)
         {
            this._roomList.add(param1.id,param1);
         }
      }
      
      public function dispose() : void
      {
         this._roomList = null;
      }
   }
}
