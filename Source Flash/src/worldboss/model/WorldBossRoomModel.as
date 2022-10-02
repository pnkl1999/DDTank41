package worldboss.model
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.player.PlayerVO;
   
   public class WorldBossRoomModel extends EventDispatcher
   {
       
      
      private var _players:DictionaryData;
      
      private var _playersBuffer:Array;
      
      private var _playerNameVisible:Boolean = true;
      
      private var _playerChatBallVisible:Boolean = true;
      
      private var _playerFireVisible:Boolean = true;
      
      public function WorldBossRoomModel()
      {
         super();
         this._players = new DictionaryData(true);
         this._playersBuffer = new Array();
      }
      
      public function get players() : DictionaryData
      {
         return this._players;
      }
      
      public function addPlayer(param1:PlayerVO) : void
      {
         this._playersBuffer.push(param1);
         setTimeout(this.addPlayerToMap,500 + this._playersBuffer.length * 200);
      }
      
      private function addPlayerToMap() : void
      {
         if(!this._players || !this._playersBuffer[0])
         {
            return;
         }
         this._players.add(this._playersBuffer[0].playerInfo.ID,this._playersBuffer[0]);
         this._playersBuffer.shift();
      }
      
      public function updatePlayerStauts(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PlayerVO = null;
         if(this._playersBuffer && this._playersBuffer.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this._playersBuffer.length)
            {
               if(param1 == this._playersBuffer[_loc4_].playerInfo.ID)
               {
                  _loc5_ = this._playersBuffer[_loc4_] as PlayerVO;
                  _loc5_.playerStauts = param2;
                  _loc5_.playerPos = param3;
                  return;
               }
               _loc4_++;
            }
         }
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
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.PLAYER_NAME_VISIBLE));
      }
      
      public function dispose() : void
      {
         this._players = null;
         this._playersBuffer = null;
      }
   }
}
