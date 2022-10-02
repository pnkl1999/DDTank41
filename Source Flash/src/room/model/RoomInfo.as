package room.model
{
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class RoomInfo extends EventDispatcher
   {
      
      public static const MATCH_ROOM:int = 0;
      
      public static const CHALLENGE_ROOM:int = 1;
      
      public static const DUNGEON_ROOM:int = 4;
      
      public static const RING_STATION:int = 24;
      
      public static const FIGHT_LIB_ROOM:int = 5;
      
      public static const FRESHMAN_ROOM:int = 10;
      
      public static const ACADEMY_DUNGEON_ROOM:int = 11;
      
      public static const ACTIVITY_DUNGEON_ROOM:int = 21;
      
      public static const SPECIAL_ACTIVITY_DUNGEON:int = 23;
      
      public static const LEAGE_ROOM:int = 12;
      
      public static const GUILD_LEAGE_MODE:int = 13;
      
      public static const SCORE_ROOM:int = 12;
      
      public static const RANK_ROOM:int = 13;
	  
	  public static const WORLD_BOSS_FIGHT:int = 14;
      
      public static const LANBYRINTH_ROOM:int = 15;
      
      public static const FREE_MODE:int = 0;
      
      public static const GUILD_MODE:int = 1;
      
      public static const BOTH_MODE:int = 4;
      
      public static const MATCH_NPC:int = 9;
      
      public static const EASY:int = 0;
      
      public static const NORMAL:int = 1;
      
      public static const HARD:int = 2;
      
      public static const HERO:int = 3;
      
      public static const DUNGEONTYPE_NO:int = 1;
      
      public static const DUNGEONTYPE_SP:int = 2;
      
      public static const NULL_ROOM:int = -100;
       
      
      public var ID:int;
      
      public var Name:String;
      
      public var maxViewerCnt:int = 2;
      
      public var isWithinLeageTime:Boolean;
      
      private var _type:int;
      
      private var _players:DictionaryData;
      
      private var _gameMode:int;
      
      private var _mapId:int;
      
      private var _timeType:int = -1;
      
      private var _hardLevel:int;
      
      private var _levelLimits:int;
      
      private var _totalPlayer:int;
      
      private var _viewerCnt:int;
      
      private var _placeCount:int;
      
      public var isLocked:Boolean;
      
      private var _started:Boolean;
      
      private var _isCrossZone:Boolean;
      
      private var _isPlaying:Boolean;
      
      private var _isLocked:Boolean;
      
      private var _changedCount:int;
      
      private var _isOpenBoss:Boolean;
      
      private var _pic:String;
      
      private var _roomPass:String = "";
      
      private var _dungeonType:int;
      
      private var _placesState:Array;
      
      private var _defyInfo:Array;
      
      public function RoomInfo()
      {
         this._placesState = [-1,-1,-1,-1,-1,-1,-1,-1];
         super();
         this._players = new DictionaryData();
      }
      
      public function get pic() : String
      {
         return this._pic;
      }
      
      public function set pic(param1:String) : void
      {
         this._pic = param1;
      }
      
      public function get isOpenBoss() : Boolean
      {
         return this._isOpenBoss;
      }
      
      public function set isOpenBoss(param1:Boolean) : void
      {
         if(this._isOpenBoss == param1)
         {
            return;
         }
         this._isOpenBoss = param1;
         dispatchEvent(new RoomEvent(RoomEvent.OPEN_BOSS_CHANGED,this._isOpenBoss));
      }
      
      public function get roomPass() : String
      {
         return this._roomPass;
      }
      
      public function set roomPass(param1:String) : void
      {
         if(this._roomPass == param1)
         {
            return;
         }
         this._roomPass = param1;
      }
      
      public function get roomName() : String
      {
         return this.Name;
      }
      
      public function set roomName(param1:String) : void
      {
         if(this.Name == param1)
         {
            return;
         }
         this.Name = param1;
         dispatchEvent(new RoomEvent(RoomEvent.ROOM_NAME_CHANGED));
      }
      
      public function get defyInfo() : Array
      {
         return this._defyInfo;
      }
      
      public function set defyInfo(param1:Array) : void
      {
         this._defyInfo = param1;
      }
      
      public function get placesState() : Array
      {
         return this._placesState;
      }
      
      public function updatePlaceState(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc10_:RoomPlayer = null;
         var _loc3_:int = 0;
         var _loc4_:int = this.type == CHALLENGE_ROOM ? int(int(8)) : int(int(4));
         var _loc5_:int = -100;
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            if(this._placesState[_loc6_] != param1[_loc6_])
            {
               if(_loc6_ >= 8)
               {
                  if(param1[_loc6_] != -1)
                  {
                     _loc10_ = this.findPlayerByID(param1[_loc6_]);
                     if(_loc10_ != null)
                     {
                        _loc10_.place = _loc6_;
                     }
                  }
                  else if(this._placesState[_loc6_] != -1)
                  {
                     _loc10_ = this.findPlayerByID(this._placesState[_loc6_]);
                     if(_loc10_ != null)
                     {
                        if(_loc5_ != -100)
                        {
                           _loc10_.place = _loc5_;
                        }
                     }
                  }
               }
               _loc5_ = _loc6_;
               _loc2_ = true;
            }
            _loc6_++;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            if(param1[_loc7_] == -1)
            {
               _loc3_++;
            }
            _loc7_++;
         }
         var _loc8_:int = 0;
         switch(this._type)
         {
            case RoomInfo.MATCH_ROOM:
               _loc8_ = 9;
               break;
            case RoomInfo.CHALLENGE_ROOM:
            case RoomInfo.DUNGEON_ROOM:
            case RoomInfo.ACADEMY_DUNGEON_ROOM:
            case RoomInfo.ACTIVITY_DUNGEON_ROOM:
            case RoomInfo.SPECIAL_ACTIVITY_DUNGEON:
            case 47:
            case 48:
               _loc8_ = 10;
         }
         var _loc9_:int = 8;
         while(_loc9_ < _loc8_)
         {
            if(param1[_loc9_] == -1)
            {
               _loc3_++;
            }
            _loc9_++;
         }
         this.placeCount = _loc3_;
         if(_loc2_)
         {
            this._placesState = param1;
            dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
         }
      }
      
      public function updatePlayerState(param1:Array) : void
      {
         var _loc2_:RoomPlayer = null;
         for each(_loc2_ in this.players)
         {
            _loc2_.isReady = param1[_loc2_.place] == 1;
            _loc2_.isHost = param1[_loc2_.place] == 2;
         }
         dispatchEvent(new RoomEvent(RoomEvent.PLAYER_STATE_CHANGED));
      }
      
      public function setPlayerReadyState(param1:int, param2:Boolean) : void
      {
         this.findPlayerByID(param1).isReady = param2;
         dispatchEvent(new RoomEvent(RoomEvent.PLAYER_STATE_CHANGED));
      }
      
      public function updatePlayerTeam(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:RoomPlayer = this._players[param1];
         if(_loc4_)
         {
            _loc4_.team = param2;
            _loc4_.place = param3;
         }
         dispatchEvent(new RoomEvent(RoomEvent.ROOMPLACE_CHANGED));
      }
      
      public function addPlayer(param1:RoomPlayer) : void
      {
         this._players.add(param1.playerInfo.ID,param1);
         dispatchEvent(new RoomEvent(RoomEvent.ADD_PLAYER,param1));
      }
      
      public function removePlayer(param1:int, param2:int) : RoomPlayer
      {
         if(param1 != PlayerManager.Instance.Self.ZoneID)
         {
            return null;
         }
         var _loc3_:RoomPlayer = this.players[param2];
         if(_loc3_)
         {
            this._players.remove(param2);
            dispatchEvent(new RoomEvent(RoomEvent.REMOVE_PLAYER,_loc3_));
         }
         return _loc3_;
      }
      
      public function findPlayerByID(param1:int, param2:int = -1) : RoomPlayer
      {
         return this._players[param1] as RoomPlayer;
      }
      
      public function findPlayerByPlace(param1:int) : RoomPlayer
      {
         var _loc2_:RoomPlayer = null;
         var _loc3_:RoomPlayer = null;
         for each(_loc3_ in this.players)
         {
            if(_loc3_.place == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomPlayer = null;
         for each(_loc1_ in this._players)
         {
            _loc1_.dispose();
         }
         this._players.clear();
         this._players = null;
         this._type = NULL_ROOM;
      }
      
      public function get players() : DictionaryData
      {
         return this._players;
      }
      
      public function startPickup() : void
      {
         this.started = true;
      }
      
      public function cancelPickup() : void
      {
         this.started = false;
      }
      
      public function pickupFailed() : void
      {
         this.started = false;
      }
      
      public function get selfRoomPlayer() : RoomPlayer
      {
         return this.findPlayerByID(PlayerManager.Instance.Self.ID);
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function isYellowBg() : Boolean
      {
         return this._type == DUNGEON_ROOM || this._type == MATCH_ROOM || this._type == ACADEMY_DUNGEON_ROOM || this._type == ACTIVITY_DUNGEON_ROOM || this._type == SCORE_ROOM || this._type == RANK_ROOM || this._type == SPECIAL_ACTIVITY_DUNGEON;
      }
      
      public function canShowTitle() : Boolean
      {
         return this._type >= 2 && this._type != 12 && this._type != 13;
      }
      
      public function get gameMode() : int
      {
         return this._gameMode;
      }
      
      public function set gameMode(param1:int) : void
      {
         if(this._gameMode == param1)
         {
            return;
         }
         this._gameMode = param1;
         dispatchEvent(new RoomEvent(RoomEvent.GAME_MODE_CHANGE));
      }
      
      public function canPlayGuidMode() : Boolean
      {
         var _loc1_:int = 0;
         var _loc3_:RoomPlayer = null;
         var _loc4_:RoomPlayer = null;
         if(this._players.length - this.currentViewerCnt <= 1)
         {
            return false;
         }
         if(this.selfRoomPlayer.isViewer)
         {
            for each(_loc4_ in this.players)
            {
               if(_loc4_ != this.selfRoomPlayer)
               {
                  _loc1_ = _loc4_.playerInfo.ConsortiaID;
                  break;
               }
            }
         }
         else
         {
            _loc1_ = this.selfRoomPlayer.playerInfo.ConsortiaID;
         }
         if(_loc1_ <= 0)
         {
            return false;
         }
         var _loc2_:Boolean = true;
         for each(_loc3_ in this.players)
         {
            if(!_loc3_.isViewer)
            {
               if(_loc3_.playerInfo.ConsortiaID != _loc1_)
               {
                  _loc2_ = false;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function isAllReady() : Boolean
      {
         var _loc2_:RoomPlayer = null;
         var _loc1_:Boolean = true;
         if(this.type == CHALLENGE_ROOM)
         {
            if(this._players.length == 1)
            {
               return false;
            }
         }
         for each(_loc2_ in this._players)
         {
            if(!_loc2_.isReady && !_loc2_.isHost && !_loc2_.isViewer)
            {
               _loc1_ = false;
               break;
            }
         }
         return _loc1_;
      }
      
      public function getDifficulty(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               if(this._type == MapManager.FIGHT_LIB)
               {
                  return LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Easy");
               }
               return LanguageMgr.GetTranslation("tank.room.difficulty.simple");
               break;
            case 1:
               if(this._type == MapManager.FIGHT_LIB)
               {
                  return LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Nomal");
               }
               return LanguageMgr.GetTranslation("tank.room.difficulty.normal");
               break;
            case 2:
               if(this._type == MapManager.FIGHT_LIB)
               {
                  return LanguageMgr.GetTranslation("tank.fightLib.GameOver.Title.Difficult");
               }
               return LanguageMgr.GetTranslation("tank.room.difficulty.hard");
               break;
            case 3:
               return LanguageMgr.GetTranslation("tank.room.difficulty.hero");
            default:
               return "";
         }
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(param1:int) : void
      {
         if(this._mapId == param1)
         {
            return;
         }
         this._mapId = param1;
         dispatchEvent(new RoomEvent(RoomEvent.MAP_CHANGED));
      }
      
      public function get timeType() : int
      {
         return this._timeType;
      }
      
      public function set timeType(param1:int) : void
      {
         if(this._timeType == param1)
         {
            return;
         }
         this._timeType = param1;
         dispatchEvent(new RoomEvent(RoomEvent.MAP_TIME_CHANGED));
      }
      
      public function get hardLevel() : int
      {
         return this._hardLevel;
      }
      
      public function set hardLevel(param1:int) : void
      {
         if(this._hardLevel == param1)
         {
            return;
         }
         this._hardLevel = param1;
         dispatchEvent(new RoomEvent(RoomEvent.HARD_LEVEL_CHANGED));
      }
      
      public function get levelLimits() : int
      {
         return this._levelLimits;
      }
      
      public function set levelLimits(param1:int) : void
      {
         this._levelLimits = param1;
      }
      
      public function get totalPlayer() : int
      {
         return this._totalPlayer;
      }
      
      public function set totalPlayer(param1:int) : void
      {
         if(this._totalPlayer == param1)
         {
            return;
         }
         this._totalPlayer = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get currentViewerCnt() : int
      {
         var _loc2_:RoomPlayer = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._players)
         {
            if(_loc2_.isViewer)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function get viewerCnt() : int
      {
         return this._viewerCnt;
      }
      
      public function set viewerCnt(param1:int) : void
      {
         if(this._viewerCnt == param1)
         {
            return;
         }
         this._viewerCnt = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get placeCount() : int
      {
         return this._placeCount;
      }
      
      public function set placeCount(param1:int) : void
      {
         if(this._placeCount == param1)
         {
            return;
         }
         this._placeCount = param1;
         dispatchEvent(new RoomEvent(RoomEvent.PLACE_COUNT_CHANGED));
      }
      
      public function get started() : Boolean
      {
         return this._started;
      }
      
      public function set started(param1:Boolean) : void
      {
         if(this._started == param1)
         {
            return;
         }
         this._started = param1;
         dispatchEvent(new RoomEvent(RoomEvent.STARTED_CHANGED));
      }
      
      public function get isCrossZone() : Boolean
      {
         return this._isCrossZone;
      }
      
      public function set isCrossZone(param1:Boolean) : void
      {
         if(this._isCrossZone == param1)
         {
            return;
         }
         this._isCrossZone = param1;
         dispatchEvent(new RoomEvent(RoomEvent.ALLOW_CROSS_CHANGE));
      }
      
      public function resetStates() : void
      {
         var _loc1_:RoomPlayer = null;
         for each(_loc1_ in this._players)
         {
            _loc1_.isReady = false;
         }
         this._started = false;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function set isPlaying(param1:Boolean) : void
      {
         this._isPlaying = param1;
      }
      
      public function get IsLocked() : Boolean
      {
         return this._isLocked;
      }
      
      public function set IsLocked(param1:Boolean) : void
      {
         this._isLocked = param1;
      }
      
      public function get dungeonType() : int
      {
         return this._dungeonType;
      }
      
      public function set dungeonType(param1:int) : void
      {
         if(this._dungeonType == param1)
         {
            return;
         }
         this._dungeonType = param1;
      }
      
      public function get isDungeonType() : Boolean
      {
         return RoomInfo.DUNGEON_ROOM == this._type || RoomInfo.ACADEMY_DUNGEON_ROOM == this._type || RoomInfo.LANBYRINTH_ROOM == this._type;
      }
      
      public function get isLeagueRoom() : Boolean
      {
         return RoomInfo.GUILD_LEAGE_MODE == this._gameMode || RoomInfo.LEAGE_ROOM == this._gameMode;
      }
   }
}
