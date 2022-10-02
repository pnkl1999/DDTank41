package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.loader.MapLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.model.GameInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Player;
   import im.IMController;
   import labyrinth.LabyrinthManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import worldboss.WorldBossManager;
   
   public class RoomLoadingView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _gameInfo:GameInfo;
      
      private var _versus:RoomLoadingVersusItem;
      
      private var _countDownTxt:RoomLoadingCountDownNum;
      
      private var _battleField:RoomLoadingBattleFieldItem;
      
      private var _tipsItem:RoomLoadingTipsItem;
      
      private var _viewerItem:RoomLoadingViewerItem;
      
      private var _dungeonMapItem:RoomLoadingDungeonMapItem;
      
      private var _characterItems:Vector.<RoomLoadingCharacterItem>;
      
      private var _countDownTimer:Timer;
      
      private var _selfFinish:Boolean;
      
      private var _trainerLoad:TrainerLoader;
      
      private var _startTime:Number;
      
      protected var _leaving:Boolean = false;
      
      protected var _amountOfFinishedPlayer:int = 0;
      
      protected var _hasLoadedFinished:DictionaryData;
      
      protected var blueCharacterIndex:int = 1;
      
      protected var redCharacterIndex:int = 1;
      
      private var _unloadedmsg:String = "";
      
      public function RoomLoadingView(param1:GameInfo)
      {
         this._hasLoadedFinished = new DictionaryData();
         super();
         this._gameInfo = param1;
         this.init();
      }
      
      private function init() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            this._startTime = new Date().getTime();
         }
         TimeManager.Instance.enterFightTime = new Date().getTime();
         LevelRewardManager.Instance.hide();
         this._characterItems = new Vector.<RoomLoadingCharacterItem>();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.Bg");
         this._versus = ComponentFactory.Instance.creatCustomObject("roomLoading.VersusItem",[RoomManager.Instance.current.gameMode]);
         this._countDownTxt = ComponentFactory.Instance.creatCustomObject("roomLoading.CountDownItem");
         this._battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem",[this._gameInfo.mapIndex]);
         this._tipsItem = ComponentFactory.Instance.creatCustomObject("roomLoading.TipsItem");
         this._viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
         if(this._gameInfo.gameMode == 7 || this._gameInfo.gameMode == 8 || this._gameInfo.gameMode == 10)
         {
            this._dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
         }
         this._selfFinish = false;
         addChild(this._bg);
         addChild(this._versus);
         addChild(this._countDownTxt);
         addChild(this._battleField);
         addChild(this._tipsItem);
         this.initLoadingItems();
         if(this._dungeonMapItem)
         {
            addChild(this._dungeonMapItem);
         }
         var _loc1_:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM ? int(int(94)) : int(int(64));
         this._countDownTimer = new Timer(1000,_loc1_);
         this._countDownTimer.addEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.start();
         StateManager.currentStateType = StateType.GAME_LOADING;
      }
      
      private function initLoadingItems() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:RoomPlayer = null;
         var _loc9_:RoomPlayer = null;
         var _loc10_:int = 0;
         var _loc12_:GameNeedPetSkillInfo = null;
         var _loc13_:RoomPlayer = null;
         var _loc14_:RoomLoadingCharacterItem = null;
         var _loc15_:Point = null;
         var _loc16_:Player = null;
         var _loc17_:PetInfo = null;
         var _loc18_:int = 0;
         var _loc19_:PetSkillTemplateInfo = null;
         var _loc20_:BallInfo = null;
         var _loc1_:int = this._gameInfo.roomPlayers.length;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Array = this._gameInfo.roomPlayers;
         LoadBombManager.Instance.loadFullRoomPlayersBomb(_loc6_);
         LoadBombManager.Instance.loadSpecialBomb();
         for each(_loc8_ in _loc6_)
         {
            if(PlayerManager.Instance.Self.ID == _loc8_.playerInfo.ID)
            {
               _loc7_ = _loc8_.team;
            }
         }
         for each(_loc9_ in _loc6_)
         {
            if(!_loc9_.isViewer)
            {
               if(_loc9_.team == RoomPlayer.BLUE_TEAM)
               {
                  _loc4_++;
               }
               else
               {
                  _loc5_++;
               }
               if(!(RoomManager.Instance.current.type == RoomInfo.FREE_MODE && _loc9_.team != _loc7_))
               {
                  IMController.Instance.saveRecentContactsID(_loc9_.playerInfo.ID);
               }
            }
         }
         _loc10_ = 0;
         while(_loc10_ < _loc1_)
         {
            _loc13_ = this._gameInfo.roomPlayers[_loc10_];
            _loc13_.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onLoadingFinished);
            if(_loc13_.isViewer)
            {
               if(contains(this._tipsItem))
               {
                  removeChild(this._tipsItem);
               }
               addChild(this._viewerItem);
            }
            else
            {
               _loc14_ = new RoomLoadingCharacterItem(_loc13_);
               if(_loc13_.team == RoomPlayer.BLUE_TEAM)
               {
                  PositionUtils.setPos(_loc14_,"asset.roomLoading.CharacterItemBluePos_" + _loc4_.toString() + "_" + (_loc2_ + 1).toString());
                  _loc15_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_" + (_loc2_ + 1).toString());
                  TweenMax.from(_loc14_,0.5,{
                     "x":_loc15_.x,
                     "y":_loc15_.y,
                     "ease":Quint.easeIn,
                     "delay":1 + _loc2_ * 0.2
                  });
                  _loc2_++;
               }
               else
               {
                  PositionUtils.setPos(_loc14_,"asset.roomLoading.CharacterItemRedPos_" + _loc5_.toString() + "_" + (_loc3_ + 1).toString());
                  _loc15_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_" + (_loc3_ + 1).toString());
                  TweenMax.from(_loc14_,0.5,{
                     "x":_loc15_.x,
                     "y":_loc15_.y,
                     "ease":Quint.easeIn,
                     "delay":1 + _loc3_ * 0.2
                  });
                  _loc3_++;
               }
               this._characterItems.push(_loc14_);
               addChild(_loc14_);
               _loc16_ = this._gameInfo.findLivingByPlayerID(_loc13_.playerInfo.ID,_loc13_.playerInfo.ZoneID);
               _loc16_.movie = _loc13_.movie;
               _loc16_.character = _loc13_.character;
               _loc16_.character.showGun = true;
               if(_loc14_.x < 500)
               {
                  _loc16_.character.x = -118;
                  _loc16_.character.show(false,-1);
                  _loc14_.index = this.blueCharacterIndex;
                  ++this.blueCharacterIndex;
               }
               else
               {
                  _loc16_.character.x = 37;
                  _loc16_.character.show(false,1);
                  _loc14_.index = this.redCharacterIndex;
                  ++this.redCharacterIndex;
               }
               _loc16_.character.y = 32;
               _loc16_.movie.show(true,-1);
               _loc17_ = _loc16_.playerInfo.currentPet;
               if(_loc17_)
               {
                  LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(_loc17_.GameAssetUrl),BaseLoader.MODULE_LOADER);
                  for each(_loc18_ in _loc17_.equipdSkills)
                  {
                     if(_loc18_ > 0)
                     {
                        _loc19_ = PetSkillManager.getSkillByID(_loc18_);
                        if(_loc19_.EffectPic)
                        {
                           LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_loc19_.EffectPic),BaseLoader.MODULE_LOADER);
                        }
                        if(_loc19_.NewBallID != -1)
                        {
                           _loc20_ = BallManager.findBall(_loc19_.NewBallID);
                           _loc20_.loadBombAsset();
                           _loc20_.loadCraterBitmap();
                        }
                     }
                  }
               }
            }
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < this._gameInfo.neededMovies.length)
         {
            if(this._gameInfo.neededMovies[_loc11_].type == 2)
            {
               this._gameInfo.neededMovies[_loc11_].startLoad();
            }
            else if(this._gameInfo.neededMovies[_loc11_].type == 1)
            {
               this._gameInfo.neededMovies[_loc11_].startLoad();
            }
            _loc11_++;
         }
         for each(_loc12_ in this._gameInfo.neededPetSkillResource)
         {
            _loc12_.startLoad();
         }
         this._gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(this._gameInfo.mapIndex));
         this._gameInfo.loaderMap.load();
         switch(NewHandGuideManager.Instance.mapID)
         {
            case 111:
               this._trainerLoad = new TrainerLoader("1");
               break;
            case 112:
               this._trainerLoad = new TrainerLoader("2");
               break;
            case 113:
               this._trainerLoad = new TrainerLoader("3");
               break;
            case 114:
               this._trainerLoad = new TrainerLoader("4");
               break;
            case 115:
               this._trainerLoad = new TrainerLoader("5");
               break;
            case 116:
               this._trainerLoad = new TrainerLoader("6");
         }
         if(this._trainerLoad)
         {
            this._trainerLoad.load();
         }
      }
      
      protected function __onLoadingFinished(param1:Event) : void
      {
         var _loc2_:RoomPlayer = param1.currentTarget as RoomPlayer;
         if(_loc2_.progress < 100 || this._hasLoadedFinished.hasKey(_loc2_))
         {
            return;
         }
         ++this._amountOfFinishedPlayer;
         this._hasLoadedFinished.add(_loc2_,_loc2_);
         if(this._amountOfFinishedPlayer == this._gameInfo.roomPlayers.length)
         {
            this.leave();
         }
      }
      
      protected function leave() : void
      {
         if(!this._leaving)
         {
            this._characterItems.forEach(function(param1:RoomLoadingCharacterItem, param2:int, param3:Vector.<RoomLoadingCharacterItem>):void
            {
               param1.disappear(param1.index.toString());
            });
            this._leaving = true;
         }
      }
      
      private function __countDownTick(param1:TimerEvent) : void
      {
         this._selfFinish = this.checkProgress();
         this._countDownTxt.updateNum();
         if(this._selfFinish)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            if(NewHandGuideManager.Instance.mapID == 111)
            {
               WeakGuildManager.Instance.timeStatistics(1,this._startTime);
            }
         }
      }
      
      private function __countDownComplete(param1:TimerEvent) : void
      {
         if(!this._selfFinish)
         {
            if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FIGHT_LIB_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
            {
               StateManager.setState(StateType.MAIN,LabyrinthManager.Instance.show);
            }
			else if(RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
			{
				WorldBossManager.IsSuccessStartGame = false;
				StateManager.setState(StateType.WORLDBOSS_ROOM);
			}
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
         }
      }
      
      private function checkProgress() : Boolean
      {
         var _loc3_:RoomPlayer = null;
         var _loc4_:GameNeedPetSkillInfo = null;
         var _loc5_:int = 0;
         var _loc7_:Player = null;
         var _loc8_:PetInfo = null;
         var _loc9_:int = 0;
         var _loc10_:PetSkillTemplateInfo = null;
         var _loc11_:BallInfo = null;
         this._unloadedmsg = "";
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in this._gameInfo.roomPlayers)
         {
            if(!_loc3_.isViewer)
            {
               _loc7_ = this._gameInfo.findLivingByPlayerID(_loc3_.playerInfo.ID,_loc3_.playerInfo.ZoneID);
               if(_loc7_.character.completed)
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += _loc3_.playerInfo.NickName + "gameplayer.character.completed false\n";
                  this._unloadedmsg += _loc7_.character.getCharacterLoadLog();
               }
               _loc1_++;
               if(_loc7_.movie.completed)
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += _loc3_.playerInfo.NickName + "gameplayer.movie.completed false\n";
               }
               _loc1_++;
               if(LoadBombManager.Instance.getLoadBombComplete(_loc3_.currentWeapInfo))
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLoadBombComplete(info.currentWeapInfo) false" + LoadBombManager.Instance.getUnloadedBombString(_loc3_.currentWeapInfo) + "\n";
               }
               _loc1_++;
               _loc8_ = _loc7_.playerInfo.currentPet;
               if(_loc8_)
               {
                  if(_loc8_.assetReady)
                  {
                     _loc2_++;
                  }
                  _loc1_++;
                  for each(_loc9_ in _loc8_.equipdSkills)
                  {
                     if(_loc9_ > 0)
                     {
                        _loc10_ = PetSkillManager.getSkillByID(_loc9_);
                        if(_loc10_.EffectPic)
                        {
                           if(ModuleLoader.hasDefinition(_loc10_.EffectClassLink))
                           {
                              _loc2_++;
                           }
                           else
                           {
                              this._unloadedmsg += "ModuleLoader.hasDefinition(skill.EffectClassLink):" + _loc10_.EffectClassLink + " false\n";
                           }
                           _loc1_++;
                        }
                        if(_loc10_.NewBallID != -1)
                        {
                           _loc11_ = BallManager.findBall(_loc10_.NewBallID);
                           if(_loc11_.isComplete())
                           {
                              _loc2_++;
                           }
                           else
                           {
                              this._unloadedmsg += "BallManager.findBall(skill.NewBallID):" + _loc10_.NewBallID + "false\n";
                           }
                           _loc1_++;
                        }
                     }
                  }
               }
            }
         }
         for each(_loc4_ in this._gameInfo.neededPetSkillResource)
         {
            if(_loc4_.effect)
            {
               if(ModuleLoader.hasDefinition(_loc4_.effectClassLink))
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += "ModuleLoader.hasDefinition(" + _loc4_.effectClassLink + ") false\n";
               }
               _loc1_++;
            }
         }
         _loc5_ = 0;
         while(_loc5_ < this._gameInfo.neededMovies.length)
         {
            if(this._gameInfo.neededMovies[_loc5_].type == 2)
            {
               if(ModuleLoader.hasDefinition(this._gameInfo.neededMovies[_loc5_].classPath))
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += "ModuleLoader.hasDefinition(_gameInfo.neededMovies[i].classPath):" + this._gameInfo.neededMovies[_loc5_].classPath + " false\n";
               }
               _loc1_++;
            }
            else if(this._gameInfo.neededMovies[_loc5_].type == 1)
            {
               if(LoadBombManager.Instance.getLivingBombComplete(this._gameInfo.neededMovies[_loc5_].bombId))
               {
                  _loc2_++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLivingBombComplete(_gameInfo.neededMovies[i].bombId):" + this._gameInfo.neededMovies[_loc5_].bombId + " false\n";
               }
               _loc1_++;
            }
            _loc5_++;
         }
         if(this._gameInfo.loaderMap.completed)
         {
            _loc2_++;
         }
         else
         {
            this._unloadedmsg += "_gameInfo.loaderMap.completed false\n";
         }
         _loc1_++;
         if(LoadBombManager.Instance.getLoadSpecialBombComplete())
         {
            _loc2_++;
         }
         else
         {
            this._unloadedmsg += "LoadBombManager.getLoadSpecialBombComplete() false  " + LoadBombManager.Instance.getUnloadedSpecialBombString() + "\n";
         }
         _loc1_++;
         if(this._trainerLoad)
         {
            if(this._trainerLoad.completed)
            {
               _loc2_++;
            }
            else
            {
               this._unloadedmsg += "_trainerLoad.completed false\n";
            }
            _loc1_++;
         }
         var _loc6_:Number = int(_loc2_ / _loc1_ * 100);
         GameInSocketOut.sendLoadingProgress(_loc6_);
         RoomManager.Instance.current.selfRoomPlayer.progress = _loc6_;
         return _loc1_ == _loc2_;
      }
      
      public function dispose() : void
      {
         KeyboardShortcutsManager.Instance.cancelForbidden();
         this._countDownTimer.removeEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.stop();
         this._countDownTimer = null;
         ObjectUtils.disposeObject(this._trainerLoad);
         ObjectUtils.disposeObject(this._bg);
         this._versus.dispose();
         this._countDownTxt.dispose();
         this._battleField.dispose();
         this._tipsItem.dispose();
         this._viewerItem.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._characterItems.length)
         {
            TweenMax.killTweensOf(this._characterItems[_loc1_]);
            this._characterItems[_loc1_].dispose();
            this._characterItems[_loc1_] = null;
            _loc1_++;
         }
         if(this._dungeonMapItem)
         {
            ObjectUtils.disposeObject(this._dungeonMapItem);
            this._dungeonMapItem = null;
         }
         this._characterItems = null;
         this._trainerLoad = null;
         this._bg = null;
         this._gameInfo = null;
         this._versus = null;
         this._countDownTxt = null;
         this._battleField = null;
         this._tipsItem = null;
         this._countDownTimer = null;
         this._viewerItem = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
