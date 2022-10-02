package game
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.BallInfo;
   import ddt.data.BuffInfo;
   import ddt.data.FightBuffInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.map.MissionInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.manager.BallManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QueueManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.GameInfo;
   import game.model.GameNeedMovieInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.LocalPlayer;
   import game.model.Pet;
   import game.model.Player;
   import game.view.GameView;
   import game.view.effects.BloodNumberCreater;
   import game.view.experience.ExpTweenManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.WeakGuildManager;
   
   public class GameManager extends EventDispatcher
   {
      
      public static const START_LOAD:String = "StartLoading";
      
      public static var MinLevelDuplicate:int = 8;
      
      public static const SKILL_INFO_INIT_GAME:String = "skillInfoInitGame";
      
      public static const ENTER_MISSION_RESULT:String = "EnterMissionResult";
      
      public static const ENTER_ROOM:String = "EnterRoom";
      
      public static const LEAVE_MISSION:String = "leaveMission";
      
      public static const ENTER_DUNGEON:String = "EnterDungeon";
      
      public static const PLAYER_CLICK_PAY:String = "PlayerClickPay";
      
      private static var _instance:GameManager;
      
      public static const MissionGiveup:int = 0;
      
      public static const MissionAgain:int = 1;
      
      public static const MissionTimeout:int = 2;
       
      
      private var _current:GameInfo;
      
      private var _numCreater:BloodNumberCreater;
      
      public var currentNum:int = 0;
      
      public var bossName:String = "";
      
      private var _loaderArray:Array;
      
      private var _gameView:GameView;
      
      private var _addLivingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _setPropertyEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingFallingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingShowBloodEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _addMapThingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingActionMappingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _updatePhysicObjectEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _playerBloodEvtVec:Vector.<CrazyTankSocketEvent>;
      
      public var viewCompleteFlag:Boolean;
      
      public var TryAgain:int = 0;
      
      public var petSkillList:Array;
      
      private var _recevieLoadSocket:Boolean;
      
      public function GameManager()
      {
         super();
      }
      
      public static function isAcademyRoom(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.ACADEMY_DUNGEON_ROOM;
      }
      
      public static function isDungeonRoom(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.DUNGEON_ROOM || param1.roomType == RoomInfo.LANBYRINTH_ROOM || param1.roomType == RoomInfo.SPECIAL_ACTIVITY_DUNGEON;
      }
      
      public static function isLanbyrinthRoom(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.LANBYRINTH_ROOM;
      }
      
      public static function isFightLib(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.FIGHT_LIB_ROOM;
      }
      
      public static function isFreshMan(param1:GameInfo) : Boolean
      {
         return param1.roomType == RoomInfo.FRESHMAN_ROOM;
      }
      
      public static function get Instance() : GameManager
      {
         if(_instance == null)
         {
            _instance = new GameManager();
         }
         return _instance;
      }
      
      public function get Current() : GameInfo
      {
         return this._current;
      }
      
      private function initData() : void
      {
         this._loaderArray = new Array();
         this._addLivingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._setPropertyEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingFallingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingShowBloodEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._addMapThingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingActionMappingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._updatePhysicObjectEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._playerBloodEvtVec = new Vector.<CrazyTankSocketEvent>();
      }
      
      public function set trainerCurrent(param1:GameInfo) : void
      {
         this._current = param1;
      }
      
      public function setup() : void
      {
         this.initData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_LIVING,this.__addLiving);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY,this.__objectSetProperty);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_FALLING,this.__livingFalling);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,this.__livingShowBlood);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_CREATE,this.__createGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_START,this.__gameStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_LOAD,this.__beginLoad);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD,this.__loadprogress);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,this.__missionAllOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_INFO,this.__gameMissionInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_START,this.__gameMissionStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_PREPARE,this.__gameMissionPrepare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_INFO,this.__missionInviteRoomInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,this.__updatePlayInfoInGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,this.__missionTryAgain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD_RESOURCE,this.__loadResource);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,this.__addMapThing);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTION_MAPPING,this.__livingActionMapping);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,this.__updatePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,this.__playerBlood);
      }
      
      public function ClearAllCrazyTankSocketEvent() : void
      {
         this._addLivingEvtVec.length = 0;
         this._setPropertyEvtVec.length = 0;
         this._livingFallingEvtVec.length = 0;
         this._livingShowBloodEvtVec.length = 0;
         this._addMapThingEvtVec.length = 0;
         this._livingActionMappingEvtVec.length = 0;
         this._updatePhysicObjectEvtVec.length = 0;
         this._playerBloodEvtVec.length = 0;
      }
      
      protected function __addLiving(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._addLivingEvtVec.push(param1);
         }
         else
         {
            this._gameView.addliving(param1);
         }
      }
      
      protected function __updatePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._updatePhysicObjectEvtVec.push(param1);
         }
         else
         {
            this._gameView.updatePhysicObject(param1);
         }
      }
      
      protected function __livingActionMapping(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingActionMappingEvtVec.push(param1);
         }
         else
         {
            this._gameView.livingActionMapping(param1);
         }
      }
      
      protected function __addMapThing(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._addMapThingEvtVec.push(param1);
         }
         else
         {
            this._gameView.addMapThing(param1);
         }
      }
      
      protected function __playerBlood(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._playerBloodEvtVec.push(param1);
         }
         else
         {
            this._gameView.playerBlood(param1);
         }
      }
      
      protected function __objectSetProperty(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._setPropertyEvtVec.push(param1);
         }
         else
         {
            this._gameView.objectSetProperty(param1);
         }
      }
      
      protected function __livingFalling(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingFallingEvtVec.push(param1);
         }
         else
         {
            this._gameView.livingFalling(param1);
         }
      }
      
      protected function __livingShowBlood(param1:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingShowBloodEvtVec.push(param1);
         }
         else
         {
            this._gameView.livingShowBlood(param1);
         }
      }
      
      private function __missionTryAgain(param1:CrazyTankSocketEvent) : void
      {
         this.TryAgain = param1.pkg.readInt();
         dispatchEvent(new GameEvent(GameEvent.MISSIONAGAIN,this.TryAgain));
      }
      
      private function __skillInfoInit(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         this.petSkillList = [];
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            this.petSkillList.push({
               "id":_loc5_,
               "cd":_loc6_
            });
            _loc2_.readInt();
            _loc4_++;
         }
         dispatchEvent(new Event(SKILL_INFO_INIT_GAME));
      }
      
      private function __updatePlayInfoInGame(param1:CrazyTankSocketEvent) : void
      {
         var _loc11_:Player = null;
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:int = _loc3_.readInt();
         var _loc8_:int = _loc3_.readInt();
         var _loc9_:Boolean = _loc3_.readBoolean();
         var _loc10_:RoomPlayer = RoomManager.Instance.current.findPlayerByID(_loc5_);
         if(_loc4_ != PlayerManager.Instance.Self.ZoneID || _loc10_ == null || this._current == null)
         {
            return;
         }
         if(_loc10_.isSelf)
         {
            _loc11_ = new LocalPlayer(PlayerManager.Instance.Self,_loc7_,_loc6_,_loc8_);
         }
         else
         {
            _loc11_ = new Player(_loc10_.playerInfo,_loc7_,_loc6_,_loc8_);
         }
         _loc11_.isReady = _loc9_;
         if(_loc11_.movie)
         {
            _loc11_.movie.setDefaultAction(_loc11_.movie.standAction);
         }
         this._current.addRoomPlayer(_loc10_);
         if(_loc10_.isViewer)
         {
            this._current.addGameViewer(_loc11_);
         }
         else
         {
            this._current.addGamePlayer(_loc11_);
         }
         if(_loc10_.isSelf)
         {
            StateManager.setState(StateType.MISSION_ROOM);
         }
      }
      
      private function __missionInviteRoomInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:GameInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MissionInfo = null;
         var _loc7_:int = 0;
         var _loc8_:PlayerInfo = null;
         var _loc9_:RoomPlayer = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:Player = null;
         if(RoomManager.Instance.current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = new GameInfo();
            _loc3_.mapIndex = _loc2_.readInt();
            _loc3_.roomType = _loc2_.readInt();
            _loc3_.gameMode = _loc2_.readInt();
            _loc3_.timeType = _loc2_.readInt();
            RoomManager.Instance.current.timeType = _loc3_.timeType;
            _loc4_ = _loc2_.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = _loc2_.readInt();
               _loc8_ = PlayerManager.Instance.findPlayer(_loc7_);
               _loc8_.beginChanges();
               _loc9_ = RoomManager.Instance.current.findPlayerByID(_loc7_);
               if(_loc9_ == null)
               {
                  _loc9_ = new RoomPlayer(_loc8_);
                  _loc8_.ID = _loc7_;
               }
               _loc8_.ZoneID = PlayerManager.Instance.Self.ZoneID;
               _loc8_.NickName = _loc2_.readUTF();
               _loc10_ = _loc2_.readBoolean();
               _loc8_.typeVIP = _loc2_.readByte();
               _loc8_.VIPLevel = _loc2_.readInt();
               _loc8_.Sex = _loc2_.readBoolean();
               _loc8_.Hide = _loc2_.readInt();
               _loc8_.Style = _loc2_.readUTF();
               _loc8_.Colors = _loc2_.readUTF();
               _loc8_.Skin = _loc2_.readUTF();
               _loc8_.Grade = _loc2_.readInt();
               _loc8_.Repute = _loc2_.readInt();
               _loc8_.WeaponID = _loc2_.readInt();
               if(_loc8_.WeaponID > 0)
               {
                  _loc11_ = _loc2_.readInt();
                  _loc12_ = _loc2_.readUTF();
                  _loc13_ = _loc2_.readDateString();
               }
               _loc8_.DeputyWeaponID = _loc2_.readInt();
               _loc8_.ConsortiaID = _loc2_.readInt();
               _loc8_.ConsortiaName = _loc2_.readUTF();
               _loc8_.badgeID = _loc2_.readInt();
               _loc14_ = _loc2_.readInt();
               _loc15_ = _loc2_.readInt();
               _loc8_.DailyLeagueFirst = _loc2_.readBoolean();
               _loc8_.DailyLeagueLastScore = _loc2_.readInt();
               _loc8_.commitChanges();
               _loc9_.team = _loc2_.readInt();
               _loc3_.addRoomPlayer(_loc9_);
               _loc16_ = _loc2_.readInt();
               _loc17_ = _loc2_.readInt();
               _loc18_ = _loc2_.readBoolean();
               if(_loc9_.isSelf)
               {
                  _loc19_ = new LocalPlayer(PlayerManager.Instance.Self,_loc16_,_loc9_.team,_loc17_);
               }
               else
               {
                  _loc19_ = new Player(_loc9_.playerInfo,_loc16_,_loc9_.team,_loc17_);
               }
               _loc19_.isReady = _loc18_;
               _loc19_.currentWeapInfo.refineryLevel = _loc11_;
               if(!_loc10_)
               {
                  _loc3_.addGamePlayer(_loc19_);
               }
               else
               {
                  if(_loc9_.isSelf)
                  {
                     _loc3_.setSelfGamePlayer(_loc19_);
                  }
                  _loc3_.addGameViewer(_loc19_);
               }
               _loc5_++;
            }
            this._current = _loc3_;
            _loc6_ = new MissionInfo();
            _loc6_.name = _loc2_.readUTF();
            _loc6_.pic = _loc2_.readUTF();
            _loc6_.success = _loc2_.readUTF();
            _loc6_.failure = _loc2_.readUTF();
            _loc6_.description = _loc2_.readUTF();
            _loc6_.totalMissiton = _loc2_.readInt();
            _loc6_.missionIndex = _loc2_.readInt();
            _loc6_.nextMissionIndex = _loc6_.missionIndex + 1;
            this._current.missionInfo = _loc6_;
            this._current.hasNextMission = true;
         }
      }
      
      private function __createGame(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:GameInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:PlayerInfo = null;
         var _loc10_:RoomPlayer = null;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Player = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:PetInfo = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         if(RoomManager.Instance.current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = new GameInfo();
            _loc3_.roomType = _loc2_.readInt();
            _loc3_.gameMode = _loc2_.readInt();
            _loc3_.timeType = _loc2_.readInt();
            RoomManager.Instance.current.timeType = _loc3_.timeType;
            _loc4_ = _loc2_.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readUTF();
               _loc8_ = _loc2_.readInt();
               _loc9_ = PlayerManager.Instance.findPlayer(_loc8_,_loc6_);
               _loc9_.beginChanges();
               _loc10_ = RoomManager.Instance.current.findPlayerByID(_loc8_,_loc6_);
               if(_loc10_ == null)
               {
                  _loc10_ = new RoomPlayer(_loc9_);
               }
               _loc9_.ID = _loc8_;
               _loc9_.ZoneID = _loc6_;
               _loc11_ = _loc2_.readUTF();
               _loc12_ = _loc2_.readBoolean();
               if(_loc12_ && _loc10_.place < 8)
               {
                  _loc10_.place = 8;
               }
               if(!(_loc10_ is SelfInfo))
               {
                  _loc9_.NickName = _loc11_;
               }
               _loc9_.typeVIP = _loc2_.readByte();
               _loc9_.VIPLevel = _loc2_.readInt();
               if(PlayerManager.Instance.isChangeStyleTemp(_loc9_.ID))
               {
                  _loc2_.readBoolean();
                  _loc2_.readInt();
                  _loc2_.readUTF();
                  _loc2_.readUTF();
                  _loc2_.readUTF();
               }
               else
               {
                  _loc9_.Sex = _loc2_.readBoolean();
                  _loc9_.Hide = _loc2_.readInt();
                  _loc9_.Style = _loc2_.readUTF();
                  _loc9_.Colors = _loc2_.readUTF();
                  _loc9_.Skin = _loc2_.readUTF();
               }
               _loc9_.Grade = _loc2_.readInt();
               _loc9_.Repute = _loc2_.readInt();
               _loc9_.WeaponID = _loc2_.readInt();
               if(_loc9_.WeaponID != 0)
               {
                  _loc20_ = _loc2_.readInt();
                  _loc21_ = _loc2_.readUTF();
                  _loc22_ = _loc2_.readDateString();
               }
               _loc9_.DeputyWeaponID = _loc2_.readInt();
               _loc9_.Nimbus = _loc2_.readInt();
               _loc9_.IsShowConsortia = _loc2_.readBoolean();
               _loc9_.ConsortiaID = _loc2_.readInt();
               _loc9_.ConsortiaName = _loc2_.readUTF();
               _loc9_.badgeID = _loc2_.readInt();
               _loc13_ = _loc2_.readInt();
               _loc14_ = _loc2_.readInt();
               _loc9_.WinCount = _loc2_.readInt();
               _loc9_.TotalCount = _loc2_.readInt();
               _loc9_.FightPower = _loc2_.readInt();
               _loc9_.apprenticeshipState = _loc2_.readInt();
               _loc9_.masterID = _loc2_.readInt();
               _loc9_.setMasterOrApprentices(_loc2_.readUTF());
               _loc9_.AchievementPoint = _loc2_.readInt();
               _loc9_.honor = _loc2_.readUTF();
               _loc9_.Offer = _loc2_.readInt();
               _loc9_.DailyLeagueFirst = _loc2_.readBoolean();
               _loc9_.DailyLeagueLastScore = _loc2_.readInt();
               _loc9_.commitChanges();
               _loc10_.playerInfo.IsMarried = _loc2_.readBoolean();
               if(_loc10_.playerInfo.IsMarried)
               {
                  _loc10_.playerInfo.SpouseID = _loc2_.readInt();
                  _loc10_.playerInfo.SpouseName = _loc2_.readUTF();
               }
               _loc10_.additionInfo.resetAddition();
               _loc10_.additionInfo.GMExperienceAdditionType = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherExperienceAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.GMOfferAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherOfferAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.GMRichesAddition = Number(_loc2_.readInt() / 100);
               _loc10_.additionInfo.AuncherRichesAddition = Number(_loc2_.readInt() / 100);
               _loc10_.team = _loc2_.readInt();
               _loc3_.addRoomPlayer(_loc10_);
               _loc15_ = _loc2_.readInt();
               _loc16_ = _loc2_.readInt();
               if(_loc10_.isSelf)
               {
                  _loc17_ = new LocalPlayer(PlayerManager.Instance.Self,_loc15_,_loc10_.team,_loc16_);
               }
               else
               {
                  _loc17_ = new Player(_loc10_.playerInfo,_loc15_,_loc10_.team,_loc16_);
               }
               _loc18_ = _loc2_.readInt();
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc23_ = _loc2_.readInt();
                  _loc24_ = _loc9_.pets[_loc23_];
                  _loc25_ = _loc2_.readInt();
                  if(_loc24_ == null)
                  {
                     _loc24_ = new PetInfo();
                     _loc24_.TemplateID = _loc25_;
                     PetInfoManager.fillPetInfo(_loc24_);
                  }
                  _loc24_.ID = _loc2_.readInt();
                  _loc24_.Name = _loc2_.readUTF();
                  _loc24_.UserID = _loc2_.readInt();
                  _loc24_.Level = _loc2_.readInt();
                  _loc24_.IsEquip = true;
                  _loc24_.clearEquipedSkills();
                  _loc26_ = _loc2_.readInt();
                  _loc27_ = 0;
                  while(_loc27_ < _loc26_)
                  {
                     _loc28_ = _loc2_.readInt();
                     _loc29_ = _loc2_.readInt();
                     _loc24_.equipdSkills.add(_loc28_,_loc29_);
                     _loc27_++;
                  }
                  _loc24_.Place = _loc23_;
                  _loc9_.pets.add(_loc24_.Place,_loc24_);
                  _loc19_++;
               }
               _loc17_.zoneName = _loc7_;
               _loc17_.currentWeapInfo.refineryLevel = _loc20_;
               if(!_loc10_.isViewer)
               {
                  _loc3_.addGamePlayer(_loc17_);
               }
               else
               {
                  if(_loc10_.isSelf)
                  {
                     _loc3_.setSelfGamePlayer(_loc17_);
                  }
                  _loc3_.addGameViewer(_loc17_);
               }
               _loc5_++;
            }
            this._current = _loc3_;
            QueueManager.setLifeTime(0);
         }
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            if(_loc2_.extend1 == this._current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this._current.findPlayer(_loc2_.extend1) != null)
            {
               _loc3_ = _loc2_.readInt();
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = _loc2_.readInt();
                  _loc6_ = _loc2_.readBoolean();
                  _loc7_ = _loc2_.readDate();
                  _loc8_ = _loc2_.readInt();
                  _loc9_ = _loc2_.readInt();
                  _loc10_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
                  _loc4_++;
               }
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuffInfo = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            if(_loc2_.extend1 == this._current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this._current.findPlayer(_loc2_.extend1) != null)
            {
               _loc3_ = _loc2_.readInt();
               _loc4_ = _loc2_.readInt();
               _loc5_ = _loc2_.readBoolean();
               _loc6_ = _loc2_.readDate();
               _loc7_ = _loc2_.readInt();
               _loc8_ = _loc2_.readInt();
               _loc9_ = new BuffInfo(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
               if(_loc5_)
               {
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.add(_loc9_.Type,_loc9_);
               }
               else
               {
                  this._current.findPlayer(_loc2_.extend1).playerInfo.buffInfo.remove(_loc9_.Type);
               }
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function __beginLoad(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:GameNeedMovieInfo = null;
         var _loc7_:GameNeedPetSkillInfo = null;
         StateManager.getInGame_Step_3 = true;
         this._recevieLoadSocket = true;
         if(this.Current)
         {
            StateManager.getInGame_Step_4 = true;
            this.Current.maxTime = param1.pkg.readInt();
            this.Current.mapIndex = param1.pkg.readInt();
            _loc2_ = param1.pkg.readInt();
            _loc3_ = 1;
            while(_loc3_ <= _loc2_)
            {
               _loc6_ = new GameNeedMovieInfo();
               _loc6_.type = param1.pkg.readInt();
               _loc6_.path = param1.pkg.readUTF();
               _loc6_.classPath = param1.pkg.readUTF();
               this.Current.neededMovies.push(_loc6_);
               _loc3_++;
            }
            _loc4_ = param1.pkg.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_ = new GameNeedPetSkillInfo();
               _loc7_.pic = param1.pkg.readUTF();
               _loc7_.effect = param1.pkg.readUTF();
               this.Current.neededPetSkillResource.push(_loc7_);
               _loc5_++;
            }
         }
         this.checkCanToLoader();
      }
      
      private function __gameMissionStart(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Object = new Object();
         _loc3_.id = _loc2_.clientId;
         var _loc4_:Boolean = _loc2_.readBoolean();
      }
      
      public function dispatchAllGameReadyState(param1:Array) : void
      {
         var _loc2_:CrazyTankSocketEvent = null;
         var _loc3_:PackageIn = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc7_:RoomPlayer = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.pkg;
            _loc4_ = new Object();
            _loc5_ = _loc3_.clientId;
            if(this._current)
            {
               _loc6_ = this._current.findPlayerByPlayerID(_loc5_);
               _loc6_.isReady = _loc3_.readBoolean();
               if(!_loc6_.isSelf && _loc6_.isReady)
               {
                  _loc7_ = RoomManager.Instance.current.findPlayerByID(_loc5_);
                  _loc7_.isReady = true;
               }
            }
            _loc3_.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         }
      }
      
      private function __gameMissionPrepare(param1:CrazyTankSocketEvent) : void
      {
         if(RoomManager.Instance.current)
         {
            RoomManager.Instance.current.setPlayerReadyState(param1.pkg.clientId,param1.pkg.readBoolean());
         }
      }
      
      private function __gameMissionInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:MissionInfo = null;
         if(this.Current == null)
         {
            return;
         }
         if(!this.Current.missionInfo)
         {
            _loc3_ = this.Current.missionInfo = new MissionInfo();
         }
         else
         {
            _loc3_ = this.Current.missionInfo;
         }
         _loc3_.id = param1.pkg.readInt();
         _loc3_.name = param1.pkg.readUTF();
         _loc3_.success = param1.pkg.readUTF();
         _loc3_.failure = param1.pkg.readUTF();
         _loc3_.description = param1.pkg.readUTF();
         _loc2_ = param1.pkg.readUTF();
         _loc3_.totalMissiton = param1.pkg.readInt();
         _loc3_.missionIndex = param1.pkg.readInt();
         _loc3_.totalValue1 = param1.pkg.readInt();
         _loc3_.totalValue2 = param1.pkg.readInt();
         _loc3_.totalValue3 = param1.pkg.readInt();
         _loc3_.totalValue4 = param1.pkg.readInt();
         _loc3_.nextMissionIndex = _loc3_.missionIndex + 1;
         _loc3_.parseString(_loc2_);
         _loc3_.tryagain = param1.pkg.readInt();
         _loc3_.pic = param1.pkg.readUTF();
         this.checkCanToLoader();
      }
      
      private function checkCanToLoader() : void
      {
         if(this._recevieLoadSocket && this.Current && (this.Current.missionInfo || !this.getRoomTypeNeedMissionInfo(this.Current.roomType)))
         {
            dispatchEvent(new Event(START_LOAD));
            StateManager.getInGame_Step_5 = true;
            this._recevieLoadSocket = false;
         }
      }
      
      private function getRoomTypeNeedMissionInfo(param1:int) : Boolean
      {
         return param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5 || param1 == 8 || param1 == 10 || param1 == 11 || param1 == 14 || param1 == 17 || param1 == 20 || param1 == 21;
      }
      
      private function __loadprogress(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:RoomPlayer = null;
         if(this._current)
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = this._current.findRoomPlayer(_loc4_,_loc3_);
            if(_loc5_ && !_loc5_.isSelf)
            {
               _loc5_.progress = _loc2_;
            }
         }
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Vector.<FightBuffInfo> = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:Dictionary = null;
         var _loc21_:int = 0;
         var _loc22_:FightBuffInfo = null;
         var _loc23_:int = 0;
         var _loc24_:FightBuffInfo = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         this.TryAgain = -1;
         ExpTweenManager.Instance.deleteTweens();
         if(this._current)
         {
            param1.executed = false;
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readInt();
            _loc4_ = 1;
            while(_loc4_ <= _loc3_)
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = this._current.findPlayer(_loc5_);
               if(_loc6_ != null)
               {
                  _loc6_.reset();
                  _loc6_.pos = new Point(_loc2_.readInt(),_loc2_.readInt());
                  _loc6_.energy = 1;
                  _loc6_.direction = _loc2_.readInt();
                  _loc7_ = _loc2_.readInt();
                  _loc8_ = _loc2_.readInt();
                  _loc6_.team = _loc2_.readInt();
                  _loc9_ = _loc2_.readInt();
                  _loc6_.powerRatio = _loc2_.readInt();
                  _loc6_.dander = _loc2_.readInt();
                  _loc6_.maxBlood = _loc8_;
                  _loc6_.updateBlood(_loc7_,0,0);
                  _loc6_.currentWeapInfo.refineryLevel = _loc9_;
                  _loc10_ = _loc2_.readInt();
                  _loc11_ = 0;
                  while(_loc11_ < _loc10_)
                  {
                     _loc22_ = BuffManager.creatBuff(_loc2_.readInt());
                     _loc23_ = _loc2_.readInt();
                     if(_loc22_)
                     {
                        _loc22_.data = _loc23_;
                        _loc6_.addBuff(_loc22_);
                     }
                     _loc11_++;
                  }
                  _loc12_ = _loc2_.readInt();
                  _loc13_ = new Vector.<FightBuffInfo>();
                  _loc14_ = 0;
                  while(_loc14_ < _loc12_)
                  {
                     _loc24_ = BuffManager.creatBuff(_loc2_.readInt());
                     _loc6_.outTurnBuffs.push(_loc24_);
                     _loc14_++;
                  }
                  _loc15_ = _loc2_.readBoolean();
                  _loc16_ = _loc2_.readBoolean();
                  _loc17_ = _loc2_.readBoolean();
                  _loc18_ = _loc2_.readBoolean();
                  _loc19_ = _loc2_.readInt();
                  _loc20_ = new Dictionary();
                  _loc21_ = 0;
                  while(_loc21_ < _loc19_)
                  {
                     _loc25_ = _loc2_.readUTF();
                     _loc26_ = _loc2_.readUTF();
                     _loc20_[_loc25_] = _loc26_;
                     _loc21_++;
                  }
                  _loc6_.isFrozen = _loc15_;
                  _loc6_.isHidden = _loc16_;
                  _loc6_.isNoNole = _loc17_;
                  _loc6_.outProperty = _loc20_;
                  if(RoomManager.Instance.current.type != 5 && _loc6_.playerInfo.currentPet)
                  {
                     _loc6_.currentPet = new Pet(_loc6_.playerInfo.currentPet);
                     this.petResLoad(_loc6_.playerInfo.currentPet);
                  }
               }
               _loc4_++;
            }
            _loc2_.readDate();
            if(RoomManager.Instance.current.type == 5)
            {
               StateManager.setState(StateType.FIGHT_LIB_GAMEVIEW,this._current);
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               StateManager.setState(StateType.TRAINER,this._current);
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            else if(_loc3_ == 0)
            {
               if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
            }
            else
            {
               StateManager.setState(StateType.FIGHTING,this._current);
               this._current.IsOneOnOne = _loc3_ == 2;
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            RoomManager.Instance.resetAllPlayerState();
         }
      }
      
      private function petResLoad(param1:PetInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PetSkillTemplateInfo = null;
         var _loc4_:BallInfo = null;
         if(param1)
         {
            LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(param1.GameAssetUrl),BaseLoader.MODULE_LOADER);
            for each(_loc2_ in param1.equipdSkills)
            {
               if(_loc2_ > 0)
               {
                  _loc3_ = PetSkillManager.getSkillByID(_loc2_);
                  if(_loc3_.EffectPic)
                  {
                     LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_loc3_.EffectPic),BaseLoader.MODULE_LOADER);
                  }
                  if(_loc3_.NewBallID != -1)
                  {
                     _loc4_ = BallManager.findBall(_loc3_.NewBallID);
                     _loc4_.loadBombAsset();
                     _loc4_.loadCraterBitmap();
                  }
               }
            }
         }
      }
      
      private function __missionAllOver(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Player = null;
         var _loc10_:SelfInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(this._current == null)
         {
            return;
         }
         while(_loc4_ < _loc3_)
         {
            _loc8_ = _loc2_.readInt();
            _loc9_ = this._current.findPlayerByPlayerID(_loc8_);
            if(_loc9_.expObj)
            {
               _loc7_ = _loc9_.expObj;
            }
            else
            {
               _loc7_ = new Object();
            }
            if(_loc9_)
            {
               _loc7_.killGP = _loc2_.readInt();
               _loc7_.hertGP = _loc2_.readInt();
               _loc7_.fightGP = _loc2_.readInt();
               _loc7_.ghostGP = _loc2_.readInt();
               _loc7_.gpForVIP = _loc2_.readInt();
               _loc7_.gpForSpouse = _loc2_.readInt();
               _loc7_.gpForServer = _loc2_.readInt();
               _loc7_.gpForApprenticeOnline = _loc2_.readInt();
               _loc7_.gpForApprenticeTeam = _loc2_.readInt();
               _loc7_.gpForDoubleCard = _loc2_.readInt();
               _loc7_.consortiaSkill = _loc2_.readInt();
               _loc7_.luckyExp = _loc2_.readInt();
               _loc7_.gainGP = _loc2_.readInt();
               _loc9_.isWin = _loc2_.readBoolean();
               _loc9_.expObj = _loc7_;
            }
            _loc4_++;
         }
         if(PathManager.solveExternalInterfaceEnabel() && this._current.selfGamePlayer.isWin)
         {
            _loc10_ = PlayerManager.Instance.Self;
         }
         this._current.missionInfo.missionOverNPCMovies = [];
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            this._current.missionInfo.missionOverNPCMovies.push(_loc2_.readUTF());
            _loc6_++;
         }
      }
      
      private function __takeOut(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.resultCard.push(param1);
         }
      }
      
      private function __showAllCard(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.showAllCard.push(param1);
         }
      }
      
      public function reset() : void
      {
         if(this._current)
         {
            this._current.dispose();
            this._current = null;
         }
      }
      
      public function startLoading() : void
      {
         StateManager.setState(StateType.GAME_LOADING);
      }
      
      public function dispatchEnterRoom() : void
      {
         dispatchEvent(new Event(ENTER_ROOM));
      }
      
      public function dispatchLeaveMission() : void
      {
         dispatchEvent(new Event(LEAVE_MISSION));
      }
      
      public function dispatchPaymentConfirm() : void
      {
         dispatchEvent(new Event(PLAYER_CLICK_PAY));
      }
      
      public function selfGetItemShowAndSound(param1:Dictionary) : Boolean
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:ChatData = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc4_ = new ChatData();
            _loc4_.channel = ChatInputView.SYS_NOTICE;
            _loc5_ = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
            _loc6_ = ChatFormats.getTagsByChannel(_loc4_.channel);
            _loc7_ = ChatFormats.creatGoodTag("[" + _loc3_.Name + "]",ChatFormats.CLICK_GOODS,_loc3_.TemplateID,_loc3_.Quality,_loc3_.IsBinds,_loc4_);
            _loc4_.htmlMessage = _loc6_[0] + _loc5_ + _loc7_ + _loc6_[1] + "<BR>";
            ChatManager.Instance.chat(_loc4_,false);
            if(_loc3_.Quality >= 3)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function isIdenticalGame(param1:int = 0) : Boolean
      {
         var _loc4_:RoomPlayer = null;
         var _loc2_:DictionaryData = RoomManager.Instance.current.players;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         if(param1 == _loc3_.ID)
         {
            return false;
         }
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.playerInfo.ID == param1 && _loc4_.playerInfo.ZoneID == _loc3_.ZoneID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __loadResource(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:GameNeedMovieInfo = null;
         this.setLoaderStop();
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new GameNeedMovieInfo();
            _loc4_.type = param1.pkg.readInt();
            _loc4_.path = param1.pkg.readUTF();
            _loc4_.classPath = param1.pkg.readUTF();
            _loc4_.startLoad();
            _loc3_++;
         }
      }
      
      private function setLoaderStop() : void
      {
         var _loc1_:int = this._loaderArray.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(!(this._loaderArray[_loc2_] as BaseLoader).isComplete)
            {
               (this._loaderArray[_loc2_] as BaseLoader).unload();
            }
            _loc2_++;
         }
         this._loaderArray.length = 0;
      }
      
      public function get numCreater() : BloodNumberCreater
      {
         if(this._numCreater)
         {
            return this._numCreater;
         }
         this._numCreater = new BloodNumberCreater();
         return this._numCreater;
      }
      
      public function disposeNumCreater() : void
      {
         if(this._numCreater)
         {
            this._numCreater.dispose();
         }
         this._numCreater = null;
      }
      
      public function get gameView() : GameView
      {
         return this._gameView;
      }
      
      public function set gameView(param1:GameView) : void
      {
         this._gameView = param1;
      }
      
      public function get addLivingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._addLivingEvtVec;
      }
      
      public function get setPropertyEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._setPropertyEvtVec;
      }
      
      public function get livingFallingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingFallingEvtVec;
      }
      
      public function get livingShowBloodEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingShowBloodEvtVec;
      }
      
      public function get addMapThingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._addMapThingEvtVec;
      }
      
      public function get livingActionMappingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingActionMappingEvtVec;
      }
      
      public function get updatePhysicObjectEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._updatePhysicObjectEvtVec;
      }
      
      public function get playerBloodEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._playerBloodEvtVec;
      }
   }
}
