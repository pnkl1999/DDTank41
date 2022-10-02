package room
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import game.GameManager;
   import invite.ResponseInviteFrame;
   import labyrinth.LabyrinthManager;
   import pet.date.PetInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import worldboss.WorldBossManager;
   
   public class RoomManager extends EventDispatcher
   {
      
      public static const PAYMENT_TAKE_CARD:String = "PaymentCard";
      
      public static const LOGIN_ROOM_RESULT:String = "loginRoomResult";
      
      private static var _instance:RoomManager;
       
      
      private var _current:RoomInfo;
      
      public var _removeRoomMsg:String = "";
      
      public var IsLastMisstion:Boolean = false;
      
      public var IsFirstInWarriorsarena:Boolean = true;
      
      private var _tempInventPlayerID:int = -1;
      
      private var _alert:BaseAlerFrame;
      
      public function RoomManager()
      {
         super();
      }
      
      public static function getTurnTimeByType(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return 6;
            case 2:
               return 8;
            case 3:
               return 11;
            case 4:
               return 16;
            case 5:
               return 21;
            case 6:
               return 31;
            default:
               return -1;
         }
      }
      
      public static function get Instance() : RoomManager
      {
         if(_instance == null)
         {
            _instance = new RoomManager();
         }
         return _instance;
      }
      
      public function set current(param1:RoomInfo) : void
      {
         this.setCurrent(param1);
      }
      
      public function get current() : RoomInfo
      {
         return this._current;
      }
      
      private function setCurrent(param1:RoomInfo) : void
      {
         if(this._current)
         {
            this._current.dispose();
         }
         this._current = param1;
      }
      
      public function createTrainerRoom() : void
      {
         this.setCurrent(new RoomInfo());
         this._current.timeType = 3;
      }
      
      public function setRoomDefyInfo(param1:Array) : void
      {
         if(this._current)
         {
            this._current.defyInfo = param1;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__createRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_LOGIN,this.__loginRoomResult);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__settingRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,this.__updateRoomPlaces);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,this.__playerStateChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GMAE_STYLE_RECV,this.__updateGameStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TEAM,this.__setPlayerTeam);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NETWORK,this.__netWork);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED,this.__waitGameFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV,this.__waitGameRecv);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_AWIT_CANCEL,this.__waitCancel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_ENTER,this.__addPlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_EXIT,this.__removePlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INSUFFICIENT_MONEY,this.__paymentFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PASSED_WARRIORSARENA_10,this.__hasPassedWarriorsarena);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__isLastForWarriorsarena);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.No_WARRIORSARENA_TICKET,this.__noWarriorsarenaTicket);
      }
      
      private function __hasPassedWarriorsarena(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert("",LanguageMgr.GetTranslation("ddt.dungeonroom.pass.warriorsArena",10),LanguageMgr.GetTranslation("ok"),"",false,true,true,2);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         ObjectUtils.disposeObject(_loc2_);
         _loc2_ = null;
      }
      
      private function __noWarriorsarenaTicket(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
            this._alert = null;
         }
         this._alert = AlertManager.Instance.simpleAlert("",_loc3_,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._alert.moveEnable = false;
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __isLastForWarriorsarena(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.IsLastMisstion = _loc2_.readBoolean();
      }
      
      public function canCloseItem(param1:RoomPlayerItem) : Boolean
      {
         var _loc2_:int = param1.place;
         var _loc3_:uint = 4;
         var _loc4_:Array = this._current.placesState;
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            if(_loc5_ % 2 == _loc2_ % 2)
            {
               if(_loc4_[_loc5_] == 0)
               {
                  _loc3_--;
               }
            }
            _loc5_++;
         }
         if(_loc3_ <= 1)
         {
            return false;
         }
         return true;
      }
      
      private function __paymentFailed(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:BaseAlerFrame = null;
         var _loc6_:BaseAlerFrame = null;
         var _loc7_:BaseAlerFrame = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc3_ == 0)
         {
            if(!_loc4_)
            {
               _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
         }
         else if(_loc3_ == 1)
         {
            if(!_loc4_)
            {
               dispatchEvent(new Event(PAYMENT_TAKE_CARD));
               _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               if(_loc6_.parent)
               {
                  _loc6_.parent.removeChild(_loc6_);
               }
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc6_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.NotEnoughPayToTakeCard"));
            }
         }
         else if(_loc3_ == 2)
         {
            if(!_loc4_)
            {
               _loc7_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc7_.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__toPaymentTryagainHandler();
         }
         else
         {
            this.__cancelPaymenttryagainHandler();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __toPaymentTryagainHandler() : void
      {
         LeavePageManager.leaveToFillPath();
         GameManager.Instance.dispatchPaymentConfirm();
      }
      
      private function __cancelPaymenttryagainHandler() : void
      {
         GameManager.Instance.dispatchLeaveMission();
      }
      
      private function __createRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:RoomInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         _loc3_ = new RoomInfo();
         _loc3_.ID = _loc2_.readInt();
         _loc3_.type = _loc2_.readByte();
         _loc3_.hardLevel = _loc2_.readByte();
         _loc3_.timeType = _loc2_.readByte();
         _loc3_.totalPlayer = _loc2_.readByte();
         _loc3_.viewerCnt = _loc2_.readByte();
         _loc3_.placeCount = _loc2_.readByte();
         _loc3_.isLocked = _loc2_.readBoolean();
         _loc3_.mapId = _loc2_.readInt();
         _loc3_.started = _loc2_.readBoolean();
         _loc3_.Name = _loc2_.readUTF();
         _loc3_.gameMode = _loc2_.readByte();
         _loc3_.levelLimits = _loc2_.readInt();
         _loc3_.isCrossZone = _loc2_.readBoolean();
         _loc3_.isWithinLeageTime = _loc2_.readBoolean();
         _loc3_.isOpenBoss = _loc2_.readBoolean();
         _loc3_.pic = param1.pkg.readUTF();
         this.setCurrent(_loc3_);
      }
      
      public function set tempInventPlayerID(param1:int) : void
      {
         this._tempInventPlayerID = param1;
      }
      
      public function get tempInventPlayerID() : int
      {
         return this._tempInventPlayerID;
      }
      
      public function haveTempInventPlayer() : Boolean
      {
         return this._tempInventPlayerID != -1;
      }
      
      private function __loginRoomResult(param1:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new Event(LOGIN_ROOM_RESULT));
         if(param1.pkg.readBoolean() == false)
         {
         }
      }
      
      private function __addPlayerInRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:PlayerInfo = null;
         var _loc15_:RoomPlayer = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:PetInfo = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         ResponseInviteFrame.clearInviteFrame();
         if(this._current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.clientId;
            _loc4_ = _loc2_.readBoolean();
            _loc5_ = _loc2_.readByte();
            _loc6_ = _loc2_.readByte();
            _loc7_ = _loc2_.readBoolean();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = _loc2_.readInt();
            _loc13_ = _loc2_.readInt();
            if(_loc3_ != PlayerManager.Instance.Self.ID)
            {
               _loc14_ = PlayerManager.Instance.findPlayer(_loc3_);
               _loc14_.beginChanges();
               _loc14_.ID = _loc2_.readInt();
               _loc14_.NickName = _loc2_.readUTF();
               _loc14_.typeVIP = _loc2_.readByte();
               _loc14_.VIPLevel = _loc2_.readInt();
               _loc14_.Sex = _loc2_.readBoolean();
               _loc14_.Style = _loc2_.readUTF();
               _loc14_.Colors = _loc2_.readUTF();
               _loc14_.Skin = _loc2_.readUTF();
               _loc14_.WeaponID = _loc2_.readInt();
               _loc14_.DeputyWeaponID = _loc2_.readInt();
               _loc14_.Repute = _loc11_;
               _loc14_.Grade = _loc8_;
               _loc14_.Offer = _loc9_;
               _loc14_.Hide = _loc10_;
               _loc14_.ConsortiaID = _loc2_.readInt();
               _loc14_.ConsortiaName = _loc2_.readUTF();
               _loc14_.badgeID = _loc2_.readInt();
               _loc14_.WinCount = _loc2_.readInt();
               _loc14_.TotalCount = _loc2_.readInt();
               _loc14_.EscapeCount = _loc2_.readInt();
               _loc16_ = _loc2_.readInt();
               _loc17_ = _loc2_.readInt();
               _loc14_.IsMarried = _loc2_.readBoolean();
               if(_loc14_.IsMarried)
               {
                  _loc14_.SpouseID = _loc2_.readInt();
                  _loc14_.SpouseName = _loc2_.readUTF();
               }
               else
               {
                  _loc14_.SpouseID = 0;
                  _loc14_.SpouseName = "";
               }
               _loc14_.LoginName = _loc2_.readUTF();
               _loc14_.Nimbus = _loc2_.readInt();
               _loc14_.FightPower = _loc2_.readInt();
               _loc14_.apprenticeshipState = _loc2_.readInt();
               _loc14_.masterID = _loc2_.readInt();
               _loc14_.setMasterOrApprentices(_loc2_.readUTF());
               _loc14_.graduatesCount = _loc2_.readInt();
               _loc14_.honourOfMaster = _loc2_.readUTF();
               _loc14_.DailyLeagueFirst = _loc2_.readBoolean();
               _loc14_.DailyLeagueLastScore = _loc2_.readInt();
               _loc18_ = _loc2_.readInt();
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc20_ = _loc2_.readInt();
                  _loc21_ = _loc14_.pets[_loc20_];
                  _loc22_ = _loc2_.readInt();
                  if(_loc21_ == null)
                  {
                     _loc21_ = new PetInfo();
                     _loc21_.TemplateID = _loc22_;
                     PetInfoManager.fillPetInfo(_loc21_);
                  }
                  _loc21_.ID = _loc2_.readInt();
                  _loc21_.Name = _loc2_.readUTF();
                  _loc21_.UserID = _loc2_.readInt();
                  _loc21_.Level = _loc2_.readInt();
                  _loc21_.IsEquip = true;
                  _loc21_.clearEquipedSkills();
                  _loc23_ = _loc2_.readInt();
                  _loc24_ = 0;
                  while(_loc24_ < _loc23_)
                  {
                     _loc25_ = _loc2_.readInt();
                     _loc26_ = _loc2_.readInt();
                     _loc21_.equipdSkills.add(_loc25_,_loc26_);
                     _loc24_++;
                  }
                  _loc21_.Place = _loc20_;
                  _loc14_.pets.add(_loc21_.Place,_loc21_);
                  _loc19_++;
               }
               _loc14_.commitChanges();
            }
            else
            {
               _loc14_ = PlayerManager.Instance.Self;
            }
            _loc14_.ZoneID = _loc13_;
            if(GameManager.Instance.Current != null)
            {
               _loc15_ = GameManager.Instance.Current.findRoomPlayer(_loc3_,_loc13_);
            }
            if(_loc15_ == null)
            {
               _loc15_ = new RoomPlayer(_loc14_);
            }
            _loc15_.isFirstIn = _loc7_;
            _loc15_.place = _loc5_;
            _loc15_.team = _loc6_;
            _loc15_.webSpeedInfo.delay = _loc12_;
            if(_loc15_.isSelf && this._current)
            {
               if(this._current.type != 5)
               {
                  if(this._current.type == RoomInfo.MATCH_ROOM || this._current.type == RoomInfo.SCORE_ROOM || this._current.type == RoomInfo.RANK_ROOM)
                  {
                     StateManager.setState(StateType.MATCH_ROOM);
                  }
                  else if(this._current.type == RoomInfo.CHALLENGE_ROOM)
                  {
                     StateManager.setState(StateType.CHALLENGE_ROOM);
                  }
                  else if(this._current.type == RoomInfo.DUNGEON_ROOM || this._current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || this._current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
                  {
                     StateManager.setState(StateType.DUNGEON_ROOM);
                  }
                  else if(this._current.type == RoomInfo.FRESHMAN_ROOM)
                  {
                     StateManager.setState(StateType.FRESHMAN_ROOM);
                  }
                  else if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
                  {
                     LabyrinthManager.Instance.enterGame();
                  }
				  else if(this._current.type == RoomInfo.WORLD_BOSS_FIGHT)
				  {
					  WorldBossManager.Instance.enterGame();
				  }
               }
            }
            this._current.addPlayer(_loc15_);
         }
      }
      
      public function isReset(param1:int) : Boolean
      {
         return param1 != RoomInfo.LANBYRINTH_ROOM;
      }
      
      private function __removePlayerInRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RoomPlayer = null;
         if(this._current)
         {
            _loc2_ = param1.pkg.clientId;
            _loc3_ = param1.pkg.readInt();
            _loc4_ = this._current.findPlayerByID(_loc2_,_loc3_);
            if(_loc4_ && _loc4_.isSelf)
            {
               if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
               else if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
               {
                  StateManager.setState(StateType.FIGHT_LIB);
               }
               else if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.ROOM_LOADING || StateManager.currentStateType == StateType.GAME_LOADING)
               {
                  if(this._current.type == RoomInfo.DUNGEON_ROOM || this._current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
                  {
                     StateManager.setState(StateType.DUNGEON_LIST);
                  }
                  else if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
                  {
                     StateManager.setState(StateType.MAIN,LabyrinthManager.Instance.show);
                  }
                  else
                  {
                     StateManager.setState(StateType.ROOM_LIST);
                  }
               }
               PlayerManager.Instance.Self.unlockAllBag();
            }
            else
            {
               if(GameManager.Instance.Current)
               {
                  GameManager.Instance.Current.removeRoomPlayer(_loc3_,_loc2_);
                  GameManager.Instance.Current.removeGamePlayerByPlayerID(_loc3_,_loc2_);
               }
               this._current.removePlayer(_loc3_,_loc2_);
            }
         }
         this.IsLastMisstion = false;
      }
      
      private function __playerStateChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(this._current)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < 8)
            {
               _loc2_[_loc3_] = param1.pkg.readByte();
               _loc3_++;
            }
            this._current.updatePlayerState(_loc2_);
         }
      }
      
      public function findRoomPlayer(param1:int) : RoomPlayer
      {
         if(this._current)
         {
            return this._current.players[param1] as RoomPlayer;
         }
         return null;
      }
      
      private function __settingRoom(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            this._current.pic = param1.pkg.readUTF();
            if(!RoomManager.Instance.current.selfRoomPlayer.isHost && StateManager.currentStateType != StateType.DUNGEON_ROOM)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.bossRoom"));
            }
         }
         this._current.isOpenBoss = _loc2_;
         this._current.mapId = param1.pkg.readInt();
         this._current.type = param1.pkg.readByte();
         this._current.roomPass = param1.pkg.readUTF();
         this._current.roomName = param1.pkg.readUTF();
         this._current.timeType = param1.pkg.readByte();
         this._current.hardLevel = param1.pkg.readByte();
         this._current.levelLimits = param1.pkg.readInt();
         this._current.isCrossZone = param1.pkg.readBoolean();
         if(MapManager.PVE_ADVANCED_MAP.indexOf(this._current.mapId) != -1 && RoomManager.Instance.IsFirstInWarriorsarena)
         {
            this._alert = AlertManager.Instance.simpleAlert("",LanguageMgr.GetTranslation("ddt.dungeonroom.FisrtInWarriorsArena"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            RoomManager.Instance.IsFirstInWarriorsarena = false;
         }
         if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            dispatchEvent(new RoomEvent(RoomEvent.START_LABYRINTH));
         }
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function __updateRoomPlaces(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc2_[_loc3_] = param1.pkg.readInt();
            _loc3_++;
         }
         if(this._current)
         {
            this._current.updatePlaceState(_loc2_);
         }
      }
      
      private function __updateGameStyle(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.gameMode = param1.pkg.readByte();
         if(this._current.gameMode == 2)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.UpdateGameStyle"));
         }
      }
      
      private function __setPlayerTeam(param1:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.updatePlayerTeam(param1.pkg.clientId,param1.pkg.readByte(),param1.pkg.readByte());
      }
      
      private function __netWork(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PlayerInfo = PlayerManager.Instance.findPlayer(param1.pkg.clientId);
         var _loc3_:int = param1.pkg.readInt();
         if(_loc2_)
         {
            _loc2_.webSpeed = _loc3_;
         }
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._current.findPlayerByID(_loc2_.clientId) != null)
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
               this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
               _loc4_++;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._current.findPlayerByID(_loc2_.clientId) != null)
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
               if(_loc6_)
               {
                  this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.add(_loc10_.Type,_loc10_);
               }
               else
               {
                  this._current.findPlayerByID(_loc2_.clientId).playerInfo.buffInfo.remove(_loc10_.Type);
               }
               _loc4_++;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function __waitGameFailed(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.pickupFailed();
         }
      }
      
      private function __waitGameRecv(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.startPickup();
         }
      }
      
      private function __waitCancel(param1:CrazyTankSocketEvent) : void
      {
         if(this._current)
         {
            this._current.cancelPickup();
         }
      }
      
      public function resetAllPlayerState() : void
      {
         var _loc1_:RoomPlayer = null;
         for each(_loc1_ in this._current.players)
         {
            _loc1_.isReady = false;
            _loc1_.progress = 0;
            if(this._current.type != RoomInfo.CHALLENGE_ROOM)
            {
               _loc1_.team = 1;
            }
         }
      }
      
      public function isIdenticalRoom(param1:int = 0, param2:String = "") : Boolean
      {
         var _loc5_:RoomPlayer = null;
         var _loc3_:DictionaryData = this.current.players;
         var _loc4_:SelfInfo = PlayerManager.Instance.Self;
         if(param1 == _loc4_.ID)
         {
            return false;
         }
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.playerInfo.ID == param1 || _loc5_.playerInfo.NickName == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function reset() : void
      {
         if(this._current)
         {
            this._current.dispose();
            this._current = null;
         }
      }
   }
}
