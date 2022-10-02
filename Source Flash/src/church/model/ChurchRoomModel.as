package church.model
{
   import church.events.WeddingRoomEvent;
   import church.vo.PlayerVO;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ChurchRoomModel extends EventDispatcher
   {
       
      
      private var _players:DictionaryData;
      
      private var _playerNameVisible:Boolean = true;
      
      private var _playerChatBallVisible:Boolean = true;
      
      private var _playerFireVisible:Boolean = true;
      
      private var _fireEnable:Boolean;
      
      private var _fireTemplateIDList:Array;
      
      public function ChurchRoomModel()
      {
         this._fireTemplateIDList = [21002,21006];
         super();
         this._players = new DictionaryData(true);
      }
      
      public function get players() : DictionaryData
      {
         return this._players;
      }
      
      public function addPlayer(param1:PlayerVO) : void
      {
         this._players.add(param1.playerInfo.ID,param1);
      }
      
      public function removePlayer(param1:int) : void
      {
         this._players.remove(param1);
      }
      
      public function getPlayers() : DictionaryData
      {
         return this._players;
      }
      
      public function getPlayerFromID(param1:int) : PlayerVO
      {
         return this._players[param1];
      }
      
      public function reset() : void
      {
         this.dispose();
         this._players = new DictionaryData(true);
      }
      
      public function get playerNameVisible() : Boolean
      {
         return this._playerNameVisible;
      }
      
      public function set playerNameVisible(param1:Boolean) : void
      {
         this._playerNameVisible = param1;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_NAME_VISIBLE));
      }
      
      public function get playerChatBallVisible() : Boolean
      {
         return this._playerChatBallVisible;
      }
      
      public function set playerChatBallVisible(param1:Boolean) : void
      {
         this._playerChatBallVisible = param1;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE));
      }
      
      public function set playerFireVisible(param1:Boolean) : void
      {
         this._playerFireVisible = param1;
      }
      
      public function get playerFireVisible() : Boolean
      {
         return this._playerFireVisible;
      }
      
      public function set fireEnable(param1:Boolean) : void
      {
         this._fireEnable = param1;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE));
      }
      
      public function get fireEnable() : Boolean
      {
         return this._fireEnable;
      }
      
      public function get fireTemplateIDList() : Array
      {
         return this._fireTemplateIDList;
      }
      
      public function dispose() : void
      {
         this._players = null;
      }
   }
}
