package hotSpring.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.HotSpringManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.common.GradeContainer;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import hotSpring.controller.HotSpringRoomController;
   import hotSpring.event.HotSpringRoomEvent;
   import hotSpring.model.HotSpringRoomModel;
   import hotSpring.player.HotSpringPlayer;
   import hotSpring.vo.MapVO;
   import hotSpring.vo.PlayerVO;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class HotSpringRoomView extends Sprite
   {
      
      private static var _waterArea:MovieClip;
       
      
      private var _model:HotSpringRoomModel;
      
      private var _controller:HotSpringRoomController;
      
      private var _hotSpringViewAsset:MovieClip;
      
      private var _mapVO:MapVO;
      
      private var _playerLayer:MovieClip;
      
      private var _defaultPoint:Point;
      
      private var _selfPlayer:HotSpringPlayer;
      
      private var _mouseMovie:MovieClip;
      
      private var _waterAreaPointPixel:uint = 0;
      
      private var _playerWalkPath:Array;
      
      private var _sceneScene:SceneScene;
      
      private var _lastClick:Number = 0;
      
      private var _clickInterval:Number = 200;
      
      private var _chatFrame:Sprite;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _isShowPalyer:Boolean = true;
      
      private var _sysDateTime:Date;
      
      private var _grade:GradeContainer;
      
      private var _sceneFront:MovieClip;
      
      private var _sceneFront2:MovieClip;
      
      private var _sceneBack:Bitmap;
      
      private var _sceneFrontNight:MovieClip;
      
      private var _sceneFrontNight2:MovieClip;
      
      private var _sceneBackNight:Bitmap;
      
      private var _sceneBackBox:Sprite;
      
      private var _playerList:DictionaryData;
      
      private var _playerListFailure:DictionaryData;
      
      private var _playerListCellLoadCount:DictionaryData;
      
      private var _isPlayerListLoading:Boolean = false;
      
      private var _boxButton:SmallBoxButton;
      
      private var _hotSpringPlayerList:DictionaryData;
      
      private var _expUpAsset:Bitmap;
      
      private var _expUpText:FilterFrameText;
      
      private var _expUpBox:Sprite;
      
      private var _currentLoadingPlayer:HotSpringPlayer;
      
      private var _SceneType:int = 0;
      
      private var _dayStart:Date;
      
      private var _dayEnd:Date;
      
      private var _nightStart:Date;
      
      private var _nightEnd:Date;
      
      private var _ShowNameBtn:ScaleFrameImage;
      
      private var _ShowPaoBtn:ScaleFrameImage;
      
      private var _ShowPlayerBtn:ScaleFrameImage;
      
      private var _countDown:ScaleFrameImage;
      
      private var _roomNum:Bitmap;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _roomNumTxt:FilterFrameText;
      
      private var _remainTime:int;
      
      private var _addTime:int = 30;
      
      public function HotSpringRoomView(param1:HotSpringRoomController, param2:HotSpringRoomModel)
      {
         this._defaultPoint = new Point(480,560);
         this._playerList = new DictionaryData();
         this._playerListFailure = new DictionaryData();
         this._playerListCellLoadCount = new DictionaryData();
         this._hotSpringPlayerList = new DictionaryData();
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      public static function getCurrentAreaType(param1:int, param2:int) : int
      {
         var _loc3_:Point = _waterArea.localToGlobal(new Point(param1,param2));
         if(_waterArea.hitTestPoint(_loc3_.x,_loc3_.y,true))
         {
            return 2;
         }
         return 1;
      }
      
      protected function initialize() : void
      {
         var _loc1_:Point = null;
         CacheSysManager.lock(CacheConsts.ALERT_IN_HOTSPRING);
         this._sysDateTime = HotSpringManager.instance.playerEnterRoomTime;
         this._mapVO = new MapVO();
         MainToolBar.Instance.hide();
         SoundManager.instance.playMusic("3004");
         this._sceneBackBox = new Sprite();
         addChild(this._sceneBackBox);
         this._hotSpringViewAsset = ClassUtils.CreatInstance("asset.hotSpring.HotSpringViewAsset") as MovieClip;
         if(this._hotSpringViewAsset)
         {
            this._hotSpringViewAsset.x = 0;
            this._hotSpringViewAsset.y = -210;
            addChild(this._hotSpringViewAsset);
            this._hotSpringViewAsset.maskPath.visible = false;
            this._hotSpringViewAsset.layerWater.visible = false;
            _waterArea = this._hotSpringViewAsset.layerWater;
            this._sceneScene = new SceneScene();
            this._sceneScene.setHitTester(new PathMapHitTester(this._hotSpringViewAsset.maskPath));
         }
         this._playerLayer = this._hotSpringViewAsset.playerLayer;
         this.sysDateTimeScene(this._sysDateTime);
         this._mouseMovie = ClassUtils.CreatInstance("asset.hotSpring.MouseClickMovie");
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._hotSpringViewAsset.addChild(this._mouseMovie);
         this._roomMenuView = new RoomMenuView(this._controller,this._model,this.addTimeFrame);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.hotSpring.RoomMenuViewPos");
         this._roomMenuView.x = _loc1_.x;
         this._roomMenuView.y = _loc1_.y;
         addChild(this._roomMenuView);
         this._ShowNameBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.showNameBtn");
         this._ShowNameBtn.setFrame(1);
         this._ShowNameBtn.buttonMode = true;
         addChild(this._ShowNameBtn);
         this._ShowPaoBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.showPaoBtn");
         this._ShowPaoBtn.setFrame(1);
         this._ShowPaoBtn.buttonMode = true;
         addChild(this._ShowPaoBtn);
         this._ShowPlayerBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.showPlayerBtn");
         this._ShowPlayerBtn.setFrame(1);
         this._ShowPlayerBtn.buttonMode = true;
         addChild(this._ShowPlayerBtn);
         this._countDown = ComponentFactory.Instance.creatComponentByStylename("asset.hotSpring.countDownIMG");
         addChild(this._countDown);
         this._roomNum = ComponentFactory.Instance.creatBitmap("asset.hotSpring.roomNum");
         addChild(this._roomNum);
         this._countDownTxt = ComponentFactory.Instance.creat("asset.hotSpring.countDownTxt");
         addChild(this._countDownTxt);
         this._roomNumTxt = ComponentFactory.Instance.creat("asset.hotSpring.roomNumTxt");
         this._roomNumTxt.text = HotSpringManager.instance.roomCurrently.roomNumber.toString();
         addChild(this._roomNumTxt);
         if(HotSpringManager.instance.roomCurrently.roomType == 1 || HotSpringManager.instance.roomCurrently.roomType == 2)
         {
            this._countDown.setFrame(2);
            this._countDownTxt.text = HotSpringManager.instance.playerEffectiveTime + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
            this._remainTime = HotSpringManager.instance.playerEffectiveTime;
         }
         else
         {
            this._countDown.setFrame(1);
            this._countDownTxt.text = HotSpringManager.instance.roomCurrently.effectiveTime + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
         }
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.HOTSPRING_ROOM_POINT);
            addChild(this._boxButton);
         }
         this.setEvent();
         if(!this._hotSpringViewAsset && !this.contains(this._hotSpringViewAsset))
         {
            this._controller.roomPlayerRemoveSend(LanguageMgr.GetTranslation("tank.hotSpring.room.load.error"));
            return;
         }
         ChatManager.Instance.state = ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
      }
      
      private function __onStageAddInitMapPath(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__onStageAddInitMapPath);
         this._hotSpringViewAsset.maskPath.mouseEnabled = false;
         this._hotSpringViewAsset.layerWater.mouseEnabled = false;
         stage.addChild(this._hotSpringViewAsset.maskPath);
         stage.addChild(this._hotSpringViewAsset.layerWater);
      }
      
      private function setEvent() : void
      {
         this._ShowNameBtn.addEventListener(MouseEvent.CLICK,this.roomToolMenu);
         this._ShowPaoBtn.addEventListener(MouseEvent.CLICK,this.roomToolMenu);
         this._ShowPlayerBtn.addEventListener(MouseEvent.CLICK,this.roomToolMenu);
         HotSpringManager.instance.addEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE,this.removePlayer);
         this._model.addEventListener(HotSpringRoomEvent.ROOM_PLAYER_ADD,this.addPlayer);
         this._model.addEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE,this.removePlayer);
         this._hotSpringViewAsset.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,this.roomTimeUpdate);
         addEventListener(Event.ADDED_TO_STAGE,this.__onStageAddInitMapPath);
         SocketManager.Instance.out.sendHotSpringRoomEnterView(0);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function playerLoad() : void
      {
         if(this._playerList && this._playerList.list && this._playerList.length > 0)
         {
            this._isPlayerListLoading = true;
            this.playerLoadEnter(this._playerList.list[0]);
         }
         else if(this._playerListFailure && this._playerListFailure.list && this._playerListFailure.length > 0)
         {
            this._isPlayerListLoading = true;
            this.playerLoadEnter(this._playerListFailure.list[0]);
         }
      }
      
      private function playerLoadEnter(param1:PlayerVO) : void
      {
         var _loc2_:int = 0;
         if(this._playerListCellLoadCount && this._playerListCellLoadCount.length > 0)
         {
            _loc2_ = !!Boolean(this._playerListCellLoadCount[param1.playerInfo.ID]) ? int(int(int(this._playerListCellLoadCount[param1.playerInfo.ID]))) : int(int(0));
            if(_loc2_ >= 3)
            {
               this._controller.roomPlayerRemoveSend(LanguageMgr.GetTranslation("tank.hotSpring.room.load.error"));
               return;
            }
         }
         this._playerListCellLoadCount.add(param1.playerInfo.ID,_loc2_ + 1);
         this._currentLoadingPlayer = new HotSpringPlayer(param1,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(param1:HotSpringPlayer, param2:Boolean) : void
      {
         var _loc3_:PlayerVO = null;
         this._currentLoadingPlayer = null;
         if(!param2)
         {
            _loc3_ = param1.playerVO.clone();
            this._playerList.remove(_loc3_.playerInfo.ID);
            this._playerListFailure.add(_loc3_.playerInfo.ID,_loc3_);
            if(param1)
            {
               param1.dispose();
            }
            param1 = null;
            this._isPlayerListLoading = false;
            return;
         }
         param1.playerPoint = param1.playerVO.playerPos;
         param1.sceneScene = this._sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
         param1.playerVO.currentlyArea = getCurrentAreaType(param1.playerVO.playerPos.x,param1.playerVO.playerPos.y);
         if(!this._selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            this._selfPlayer = param1;
            this._playerLayer.addChild(this._selfPlayer);
            this.setCenter();
            this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.playerPropChanged);
         }
         else
         {
            this._playerLayer.addChild(param1);
         }
         this._hotSpringPlayerList.add(param1.playerVO.playerInfo.ID,param1);
         this._playerList.remove(param1.playerVO.playerInfo.ID);
         this._playerListFailure.remove(param1.playerVO.playerInfo.ID);
         this._playerListCellLoadCount.remove(param1.playerVO.playerInfo.ID);
         this._isPlayerListLoading = false;
         param1.isShowName = this._isShowName;
         param1.isChatBall = this._isChatBall;
         param1.isShowPlayer = this._isShowPalyer;
      }
      
      private function roomTimeUp(param1:int, param2:Boolean = false) : void
      {
         if(PlayerManager.Instance.Self.Grade < 60)
         {
            this.expUpPlayer(param1);
         }
         this._sysDateTime.seconds += 60;
         this.sysDateTimeScene(this._sysDateTime);
      }
      
      private function playerPropChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
         {
            this._grade = new GradeContainer(true);
            this._grade.y = -122;
            this._grade.x = -40;
            this._grade.playerGrade();
            this._selfPlayer.addChild(this._grade);
            PlayerManager.Instance.Self.IsUpGrade = false;
         }
      }
      
      private function roomTimeUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         HotSpringManager.instance.roomCurrently.effectiveTime = _loc3_;
         HotSpringManager.instance.playerEffectiveTime = _loc3_;
         if(HotSpringManager.instance.roomCurrently.roomType == 1 || HotSpringManager.instance.roomCurrently.roomType == 2)
         {
            this._countDown.setFrame(2);
            this._remainTime = _loc3_;
            this._countDownTxt.text = _loc3_ + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
         }
         else
         {
            this._countDown.setFrame(1);
            this._countDownTxt.text = _loc3_ + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
         }
         this.roomTimeUp(_loc4_);
      }
      
      public function updataRoomTime() : void
      {
         this._remainTime += this._addTime;
         this._countDownTxt.text = String(this._remainTime) + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
      }
      
      private function sysDateTimeScene(param1:Date) : void
      {
         this._sysDateTime = param1;
         var _loc2_:int = this._sysDateTime.getHours();
         var _loc3_:int = this._sysDateTime.getUTCMinutes();
         this._dayStart = new Date(this._sysDateTime.getFullYear(),this._sysDateTime.getMonth(),this._sysDateTime.getDate(),5,30);
         this._dayEnd = new Date(this._sysDateTime.getFullYear(),this._sysDateTime.getMonth(),this._sysDateTime.getDate(),6,30);
         this._nightStart = new Date(this._sysDateTime.getFullYear(),this._sysDateTime.getMonth(),this._sysDateTime.getDate(),17,30);
         this._nightEnd = new Date(this._sysDateTime.getFullYear(),this._sysDateTime.getMonth(),this._sysDateTime.getDate(),18,30);
         if(this._sysDateTime >= this._dayEnd && this._sysDateTime <= this._nightStart)
         {
            if(this._SceneType == 1)
            {
               return;
            }
            this._SceneType = 1;
            this.removeSceneNight();
            this.addSceneDay();
         }
         else if(this._sysDateTime >= this._nightEnd || this._sysDateTime < this._dayStart)
         {
            if(this._SceneType == 2)
            {
               return;
            }
            this._SceneType = 2;
            this.removeSceneDay();
            this.addSceneNight();
         }
         else
         {
            if(this._SceneType != 3)
            {
               this.removeSceneDay();
               this.removeSceneNight();
            }
            this._SceneType = 3;
            this.dayAndNight();
         }
      }
      
      private function addSceneDay() : void
      {
         if(!this._sceneFront)
         {
            this._sceneFront = ClassUtils.CreatInstance("asset.hotSpring.HotSpringDaySceneFrontAsset");
         }
         if(!this._sceneFront2)
         {
            this._sceneFront2 = ClassUtils.CreatInstance("asset.hotSpring.HotSpringDaySceneFront2Asset");
         }
         if(!this._sceneBack)
         {
            this._sceneBack = ComponentFactory.Instance.creatBitmap("asset.hotSpring.HotSpringDaySceneBackAsset");
         }
         if(this._playerLayer.house.dayHouse && !this._playerLayer.house.contains(this._playerLayer.house.dayHouse))
         {
            this._playerLayer.house.addChild(this._playerLayer.house.dayHouse);
         }
         if(this._playerLayer.tree.dayTree && !this._playerLayer.tree.contains(this._playerLayer.tree.dayTree))
         {
            this._playerLayer.tree.addChild(this._playerLayer.tree.dayTree);
         }
         if(this._playerLayer.stove.dayStove && !this._playerLayer.stove.contains(this._playerLayer.stove.dayStove))
         {
            this._playerLayer.stove.addChild(this._playerLayer.stove.dayStove);
         }
         if(!this._sceneBackBox.contains(this._sceneBack))
         {
            this._sceneBackBox.addChild(this._sceneBack);
         }
         if(!this._hotSpringViewAsset.contains(this._sceneFront))
         {
            this._hotSpringViewAsset.addChildAt(this._sceneFront,0);
         }
         this._sceneFront2.x = 0.1;
         this._sceneFront2.y = 81.7;
         if(!this._hotSpringViewAsset.contains(this._sceneFront2))
         {
            this._hotSpringViewAsset.addChild(this._sceneFront2);
         }
      }
      
      private function removeSceneDay() : void
      {
         if(this._sceneFront && this._sceneFront.parent)
         {
            this._sceneFront.parent.removeChild(this._sceneFront);
         }
         this._sceneFront = null;
         if(this._sceneFront2 && this._sceneFront2.parent)
         {
            this._sceneFront2.parent.removeChild(this._sceneFront2);
         }
         this._sceneFront2 = null;
         if(this._sceneBack && this._sceneBack.parent)
         {
            this._sceneBack.parent.removeChild(this._sceneBack);
         }
         this._sceneBack = null;
         if(this._playerLayer.house.dayHouse && this._playerLayer.house.dayHouse.parent)
         {
            this._playerLayer.house.dayHouse.parent.removeChild(this._playerLayer.house.dayHouse);
         }
         if(this._playerLayer.tree.dayTree && this._playerLayer.tree.dayTree.parent)
         {
            this._playerLayer.tree.dayTree.parent.removeChild(this._playerLayer.tree.dayTree);
         }
         if(this._playerLayer.stove.dayStove && this._playerLayer.stove.dayStove.parent)
         {
            this._playerLayer.stove.dayStove.parent.removeChild(this._playerLayer.stove.dayStove);
         }
      }
      
      private function addSceneNight() : void
      {
         if(!this._sceneFront)
         {
            this._sceneFront = ClassUtils.CreatInstance("asset.hotSpring.HotSpringNightSceneFrontAsset");
         }
         if(!this._sceneFront2)
         {
            this._sceneFront2 = ClassUtils.CreatInstance("asset.hotSpring.HotSpringNightSceneFront2Asset");
         }
         if(!this._sceneBack)
         {
            this._sceneBack = ComponentFactory.Instance.creatBitmap("asset.hotSpring.HotSpringNightSceneBackAsset");
         }
         if(this._playerLayer.house.nightHouse && !this._playerLayer.house.contains(this._playerLayer.house.nightHouse))
         {
            this._playerLayer.house.addChild(this._playerLayer.house.nightHouse);
         }
         if(this._playerLayer.tree.nightTree && !this._playerLayer.tree.contains(this._playerLayer.tree.nightTree))
         {
            this._playerLayer.tree.addChild(this._playerLayer.tree.nightTree);
         }
         if(this._playerLayer.stove.nightStove && !this._playerLayer.stove.contains(this._playerLayer.stove.nightStove))
         {
            this._playerLayer.stove.addChild(this._playerLayer.stove.nightStove);
         }
         if(!this._sceneBackBox.contains(this._sceneBack))
         {
            this._sceneBackBox.addChild(this._sceneBack);
         }
         if(!this._hotSpringViewAsset.contains(this._sceneFront))
         {
            this._hotSpringViewAsset.addChildAt(this._sceneFront,0);
         }
         this._sceneFront2.x = 0.1;
         this._sceneFront2.y = 81.7;
         if(!this._hotSpringViewAsset.contains(this._sceneFront2))
         {
            this._hotSpringViewAsset.addChild(this._sceneFront2);
         }
      }
      
      private function removeSceneNight() : void
      {
         if(this._sceneFrontNight && this._sceneFrontNight.parent)
         {
            this._sceneFrontNight.parent.removeChild(this._sceneFrontNight);
         }
         this._sceneFrontNight = null;
         if(this._sceneFrontNight2 && this._sceneFrontNight2.parent)
         {
            this._sceneFrontNight2.parent.removeChild(this._sceneFrontNight2);
         }
         this._sceneFrontNight2 = null;
         if(this._sceneBackNight && this._sceneBackNight.parent)
         {
            this._sceneBackNight.parent.removeChild(this._sceneBackNight);
         }
         this._sceneBackNight = null;
         if(this._playerLayer.house.nightHouse && this._playerLayer.house.nightHouse.parent)
         {
            this._playerLayer.house.nightHouse.parent.removeChild(this._playerLayer.house.nightHouse);
         }
         if(this._playerLayer.tree.nightTree && this._playerLayer.tree.nightTree.parent)
         {
            this._playerLayer.tree.nightTree.parent.removeChild(this._playerLayer.tree.nightTree);
         }
         if(this._playerLayer.stove.nightStove && this._playerLayer.stove.nightStove.parent)
         {
            this._playerLayer.stove.nightStove.parent.removeChild(this._playerLayer.stove.nightStove);
         }
      }
      
      private function dayAndNight() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this._sceneFront)
         {
            this._sceneFront = ClassUtils.CreatInstance("asset.hotSpring.HotSpringDaySceneFrontAsset");
         }
         if(!this._sceneFront2)
         {
            this._sceneFront2 = ClassUtils.CreatInstance("asset.hotSpring.HotSpringDaySceneFront2Asset");
         }
         if(!this._sceneBack)
         {
            this._sceneBack = ComponentFactory.Instance.creatBitmap("asset.hotSpring.HotSpringDaySceneBackAsset");
         }
         if(!this._sceneFrontNight)
         {
            this._sceneFrontNight = ClassUtils.CreatInstance("asset.hotSpring.HotSpringNightSceneFrontAsset");
         }
         if(!this._sceneFrontNight2)
         {
            this._sceneFrontNight2 = ClassUtils.CreatInstance("asset.hotSpring.HotSpringNightSceneFront2Asset");
         }
         if(!this._sceneBackNight)
         {
            this._sceneBackNight = ComponentFactory.Instance.creatBitmap("asset.hotSpring.HotSpringNightSceneBackAsset");
         }
         this._sceneFront2.x = this._sceneFrontNight2.x = 0.1;
         this._sceneFront2.y = this._sceneFrontNight2.y = 81.7;
         if(this._sysDateTime >= this._dayStart && this._sysDateTime <= this._dayEnd)
         {
            if(!this._sceneBackBox.contains(this._sceneBackNight))
            {
               this._sceneBackBox.addChild(this._sceneBackNight);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFrontNight))
            {
               this._hotSpringViewAsset.addChildAt(this._sceneFrontNight,0);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFrontNight2))
            {
               this._hotSpringViewAsset.addChild(this._sceneFrontNight2);
            }
            if(!this._sceneBackBox.contains(this._sceneBack))
            {
               this._sceneBackBox.addChild(this._sceneBack);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFront))
            {
               this._hotSpringViewAsset.addChildAt(this._sceneFront,1);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFront2))
            {
               this._hotSpringViewAsset.addChild(this._sceneFront2);
            }
            if(this._playerLayer.house.nightHouse && !this._playerLayer.house.contains(this._playerLayer.house.nightHouse))
            {
               this._playerLayer.house.addChild(this._playerLayer.house.nightHouse);
            }
            if(this._playerLayer.tree.nightTree && !this._playerLayer.tree.contains(this._playerLayer.tree.nightTree))
            {
               this._playerLayer.tree.addChild(this._playerLayer.tree.nightTree);
            }
            if(this._playerLayer.stove.nightStove && !this._playerLayer.stove.contains(this._playerLayer.stove.nightStove))
            {
               this._playerLayer.stove.addChild(this._playerLayer.stove.nightStove);
            }
            this._playerLayer.house.dayHouse.y -= 1;
            this._playerLayer.house.nightHouse.y += 1;
            if(this._playerLayer.house.dayHouse && !this._playerLayer.house.contains(this._playerLayer.house.dayHouse))
            {
               this._playerLayer.house.addChild(this._playerLayer.house.dayHouse);
            }
            if(this._playerLayer.tree.dayTree && !this._playerLayer.tree.contains(this._playerLayer.tree.dayTree))
            {
               this._playerLayer.tree.addChild(this._playerLayer.tree.dayTree);
            }
            if(this._playerLayer.stove.dayStove && !this._playerLayer.stove.contains(this._playerLayer.stove.dayStove))
            {
               this._playerLayer.stove.addChild(this._playerLayer.stove.dayStove);
            }
            _loc2_ = (this._sysDateTime.getHours() - 5) * 60 - 30 + this._sysDateTime.minutes;
            _loc3_ = Number((_loc2_ / 60 * 100).toFixed(2));
            if(this._sceneFront2.daySun && this._sceneFront2.daySun.parent)
            {
               this._sceneFront2.daySun.parent.removeChild(this._sceneFront2.daySun);
            }
            this._sceneFront2.daySun = null;
            if(this._sceneFront2.dayFlower && this._sceneFront2.dayFlower.parent)
            {
               this._sceneFront2.dayFlower.parent.removeChild(this._sceneFront2.dayFlower);
            }
            this._sceneFront2.dayFlower = null;
            this._sceneFront.alpha = this._sceneFront2.alpha = this._sceneBack.alpha = this._playerLayer.house.dayHouse.alpha = this._playerLayer.tree.dayTree.alpha = this._playerLayer.stove.dayStove.alpha = _loc3_ / 100;
            this._sceneFrontNight2.nightFirefly.alpha = 1 - _loc3_ / 100;
            if(_loc3_ / 100 >= 1)
            {
               this.removeSceneNight();
            }
         }
         else if(this._sysDateTime >= this._nightStart && this._sysDateTime <= this._nightEnd)
         {
            if(!this._sceneBackBox.contains(this._sceneBack))
            {
               this._sceneBackBox.addChild(this._sceneBack);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFront))
            {
               this._hotSpringViewAsset.addChildAt(this._sceneFront,0);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFront2))
            {
               this._hotSpringViewAsset.addChild(this._sceneFront2);
            }
            if(!this._sceneBackBox.contains(this._sceneBackNight))
            {
               this._sceneBackBox.addChild(this._sceneBackNight);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFrontNight))
            {
               this._hotSpringViewAsset.addChildAt(this._sceneFrontNight,1);
            }
            if(!this._hotSpringViewAsset.contains(this._sceneFrontNight2))
            {
               this._hotSpringViewAsset.addChild(this._sceneFrontNight2);
            }
            if(this._playerLayer.house.dayHouse && !this._playerLayer.house.contains(this._playerLayer.house.dayHouse))
            {
               this._playerLayer.house.addChild(this._playerLayer.house.dayHouse);
            }
            if(this._playerLayer.tree.dayTree && !this._playerLayer.tree.contains(this._playerLayer.tree.dayTree))
            {
               this._playerLayer.tree.addChild(this._playerLayer.tree.dayTree);
            }
            if(this._playerLayer.stove.dayStove && !this._playerLayer.stove.contains(this._playerLayer.stove.dayStove))
            {
               this._playerLayer.stove.addChild(this._playerLayer.stove.dayStove);
            }
            if(this._playerLayer.house.nightHouse && !this._playerLayer.house.contains(this._playerLayer.house.nightHouse))
            {
               this._playerLayer.house.addChild(this._playerLayer.house.nightHouse);
            }
            if(this._playerLayer.tree.nightTree && !this._playerLayer.tree.contains(this._playerLayer.tree.nightTree))
            {
               this._playerLayer.tree.addChild(this._playerLayer.tree.nightTree);
            }
            if(this._playerLayer.stove.nightStove && !this._playerLayer.stove.contains(this._playerLayer.stove.nightStove))
            {
               this._playerLayer.stove.addChild(this._playerLayer.stove.nightStove);
            }
            _loc2_ = (this._sysDateTime.getHours() - 17) * 60 - 30 + this._sysDateTime.minutes;
            _loc3_ = Number((_loc2_ / 60 * 100).toFixed(2));
            if(this._sceneFront2.daySun && this._sceneFront2.daySun.parent)
            {
               this._sceneFront2.daySun.parent.removeChild(this._sceneFront2.daySun);
            }
            this._sceneFront2.daySun = null;
            if(this._sceneFrontNight2.nightFirefly && this._sceneFrontNight2.nightFirefly.parent)
            {
               this._sceneFrontNight2.nightFirefly.parent.removeChild(this._sceneFrontNight2.nightFirefly);
            }
            this._sceneFrontNight2.nightFirefly = null;
            this._sceneFrontNight.alpha = this._sceneFrontNight2.alpha = this._sceneBackNight.alpha = this._playerLayer.house.nightHouse.alpha = this._playerLayer.tree.nightTree.alpha = this._playerLayer.stove.nightStove.alpha = _loc3_ / 100;
            this._sceneFront2.dayFlower.alpha = 1 - _loc3_ / 100;
            if(_loc3_ / 100 >= 1)
            {
               this.removeSceneDay();
            }
         }
      }
      
      private function roomToolMenu(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._ShowNameBtn:
               this._isShowName = !this._isShowName;
               this._ShowNameBtn.setFrame(!!this._isShowName ? int(int(1)) : int(int(2)));
               break;
            case this._ShowPaoBtn:
               this._isChatBall = !this._isChatBall;
               this._ShowPaoBtn.setFrame(!!this._isChatBall ? int(int(1)) : int(int(2)));
               break;
            case this._ShowPlayerBtn:
               this._isShowPalyer = !this._isShowPalyer;
               this._ShowPlayerBtn.setFrame(!!this._isShowPalyer ? int(int(1)) : int(int(2)));
         }
         this.setPlayerShowItem();
      }
      
      private function setPlayerShowItem() : void
      {
         var _loc2_:HotSpringPlayer = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._playerLayer.numChildren)
         {
            _loc2_ = this._playerLayer.getChildAt(_loc1_) as HotSpringPlayer;
            if(_loc2_)
            {
               _loc2_.isShowName = this._isShowName;
               _loc2_.isChatBall = this._isChatBall;
               _loc2_.isShowPlayer = this._isShowPalyer;
               if(_loc2_.playerVO.playerInfo.ID != PlayerManager.Instance.Self.ID)
               {
                  _loc2_.character.visible = this._isShowPalyer;
               }
               _loc2_.visible = _loc2_.playerVO.playerInfo.ID != PlayerManager.Instance.Self.ID ? Boolean(Boolean(this._isShowPalyer)) : Boolean(Boolean(true));
            }
            _loc1_++;
         }
      }
      
      private function addPlayer(param1:HotSpringRoomEvent) : void
      {
         var _loc2_:PlayerVO = param1.data as PlayerVO;
         this._playerList.add(_loc2_.playerInfo.ID,_loc2_);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:HotSpringPlayer = null;
         if(!this._isPlayerListLoading)
         {
            this.playerLoad();
         }
         if(!this._hotSpringPlayerList || this._hotSpringPlayerList.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._hotSpringPlayerList.list)
         {
            _loc2_.updatePlayer();
         }
         this.BuildEntityDepth();
      }
      
      private function getPointDepth(param1:Number, param2:Number) : Number
      {
         return this._mapVO.mapWidth * param2 + param1;
      }
      
      private function BuildEntityDepth() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc1_:int = this._playerLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this._playerLayer.getChildAt(_loc2_);
            _loc4_ = this.getPointDepth(_loc3_.x,_loc3_.y);
            _loc6_ = Number.MAX_VALUE;
            _loc7_ = _loc2_ + 1;
            while(_loc7_ < _loc1_)
            {
               _loc8_ = this._playerLayer.getChildAt(_loc7_);
               _loc9_ = this.getPointDepth(_loc8_.x,_loc8_.y);
               if(_loc9_ < _loc6_)
               {
                  _loc5_ = _loc7_;
                  _loc6_ = _loc9_;
               }
               _loc7_++;
            }
            if(_loc4_ > _loc6_)
            {
               this._playerLayer.swapChildrenAt(_loc2_,_loc5_);
            }
            _loc2_++;
         }
      }
      
      private function removePlayer(param1:HotSpringRoomEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(param1.data);
         var _loc3_:HotSpringPlayer = this._hotSpringPlayerList[_loc2_] as HotSpringPlayer;
         this._hotSpringPlayerList.remove(_loc2_);
         if(this._playerList)
         {
            this._playerList.remove(_loc2_);
         }
         if(this._playerListFailure)
         {
            this._playerListFailure.remove(_loc2_);
         }
         if(this._playerListCellLoadCount)
         {
            this._playerListCellLoadCount.remove(_loc2_);
         }
         if(!_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < this._playerLayer.numChildren)
            {
               _loc3_ = this._playerLayer.getChildAt(_loc4_) as HotSpringPlayer;
               if(_loc3_ && _loc3_.playerVO.playerInfo.ID == _loc2_)
               {
                  _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(_loc3_.parent)
                  {
                     _loc3_.parent.removeChild(_loc3_);
                  }
                  _loc3_.dispose();
                  _loc3_ = null;
                  break;
               }
               _loc4_++;
            }
         }
         if(_loc3_)
         {
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.dispose();
            _loc3_ = null;
         }
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.playerPropChanged);
            StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(!this._selfPlayer)
         {
            return;
         }
         var _loc2_:Point = this._hotSpringViewAsset.globalToLocal(new Point(param1.stageX,param1.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this._sceneScene.hit(_loc2_))
            {
               this._selfPlayer.playerVO.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,_loc2_);
               this._selfPlayer.playerVO.walkPath.shift();
               this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint,this._selfPlayer.playerVO.walkPath[0]);
               this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               this._controller.roomPlayerTargetPointSend(this._selfPlayer.playerVO);
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      private function setCenter(param1:SceneCharacterEvent = null) : void
      {
         if(!stage || !this._model || !this._model.mapVO)
         {
            return;
         }
         var _loc2_:Number = -(this._selfPlayer.x - stage.stageWidth / 2);
         var _loc3_:Number = -(this._selfPlayer.y - stage.stageHeight / 2) + 50;
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < stage.stageWidth - this._model.mapVO.mapWidth)
         {
            _loc2_ = stage.stageWidth - this._model.mapVO.mapWidth;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < stage.stageHeight - this._model.mapVO.mapHeight)
         {
            _loc3_ = stage.stageHeight - this._model.mapVO.mapHeight;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         this._hotSpringViewAsset.x = _loc2_;
         this._hotSpringViewAsset.y = _loc3_;
         this._sceneBackBox.x = _loc2_ * 0.6 - 40;
         this._sceneBackBox.y = _loc3_ * 0.6 - 10;
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack" || _loc2_ == "waterFrontEyes" || _loc2_ == "waterStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      public function expUpPlayer(param1:int) : void
      {
         if(!this._selfPlayer || !this._selfPlayer.playerVO)
         {
            return;
         }
         if(!this._expUpBox)
         {
            this._expUpBox = new Sprite();
         }
         if(!this._expUpAsset)
         {
            this._expUpAsset = ComponentFactory.Instance.creatBitmap("asset.hotSpring.iconExpUPAsset");
         }
         if(!this._expUpText)
         {
            this._expUpText = ComponentFactory.Instance.creatComponentByStylename("hotSpring.room.txtExpUPAsset");
         }
         this._expUpBox.addChild(this._expUpAsset);
         this._expUpBox.addChild(this._expUpText);
         this._expUpBox.x = (this._selfPlayer.playerWitdh - 75) / 2 - this._selfPlayer.playerWitdh / 2;
         this._expUpBox.y = this._selfPlayer.playerVO.currentlyArea == 1 ? Number(Number(-this._selfPlayer.playerHeight - 30)) : Number(Number(-this._selfPlayer.playerHeight + 33));
         this._selfPlayer.addChild(this._expUpBox);
         this._expUpText.text = "EXP " + param1.toString();
         this.expUpMoviePlayer();
      }
      
      private function expUpMoviePlayer() : void
      {
         this._expUpText.y = 22;
         this._expUpText.alpha = 0;
         TweenLite.to(this._expUpText,0.4,{
            "y":0,
            "alpha":1,
            "onComplete":this.onOut
         });
         this._expUpAsset.y = 40;
         this._expUpAsset.alpha = 0;
         TweenLite.to(this._expUpAsset,0.4,{
            "y":26,
            "alpha":1,
            "delay":0.2,
            "onComplete":this.onOut1
         });
      }
      
      private function onOut() : void
      {
         TweenLite.to(this._expUpText,0.4,{
            "y":-20,
            "alpha":0,
            "delay":1
         });
      }
      
      private function onOut1() : void
      {
         TweenLite.to(this._expUpAsset,0.4,{
            "y":0,
            "alpha":0,
            "delay":0.9,
            "onComplete":this.removeExpUpMovie
         });
      }
      
      private function removeExpUpMovie() : void
      {
         if(this._expUpBox && this._expUpBox.parent)
         {
            this._expUpBox.parent.removeChild(this._expUpBox);
         }
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
      }
      
      public function hide() : void
      {
         this._controller.removeChild(this);
      }
      
      public function addTimeFrame() : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.hotSpring.continu"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         ObjectUtils.disposeObject(alert);
         if(alert.parent)
         {
            alert.parent.removeChild(alert);
         }
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.addTime();
         }
      }
      
      private function addTime() : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Money < 100)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         this._controller.hotAddtime();
      }
      
      private function _responseI(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      public function dispose() : void
      {
         var _loc1_:PlayerVO = null;
         var _loc2_:PlayerVO = null;
         var _loc3_:HotSpringPlayer = null;
         var _loc4_:HotSpringPlayer = null;
         TweenLite.killTweensOf(this._expUpText);
         TweenLite.killTweensOf(this._expUpAsset);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this._ShowNameBtn.removeEventListener(MouseEvent.CLICK,this.roomToolMenu);
         this._ShowPaoBtn.removeEventListener(MouseEvent.CLICK,this.roomToolMenu);
         this._ShowPlayerBtn.removeEventListener(MouseEvent.CLICK,this.roomToolMenu);
         if(this._selfPlayer)
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(this._selfPlayer)
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         this._model.removeEventListener(HotSpringRoomEvent.ROOM_PLAYER_ADD,this.addPlayer);
         this._model.removeEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE,this.removePlayer);
         HotSpringManager.instance.removeEventListener(HotSpringRoomEvent.ROOM_PLAYER_REMOVE,this.removePlayer);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.playerPropChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,this.roomTimeUpdate);
         removeEventListener(Event.ADDED_TO_STAGE,this.__onStageAddInitMapPath);
         this._playerListFailure.clear();
         this._playerListFailure = null;
         this._playerListCellLoadCount.clear();
         this._playerListCellLoadCount = null;
         if(this._ShowNameBtn)
         {
            ObjectUtils.disposeObject(this._ShowNameBtn);
         }
         this._ShowNameBtn = null;
         if(this._ShowPaoBtn)
         {
            ObjectUtils.disposeObject(this._ShowPaoBtn);
         }
         this._ShowPaoBtn = null;
         if(this._ShowPlayerBtn)
         {
            ObjectUtils.disposeObject(this._ShowPlayerBtn);
         }
         this._ShowPlayerBtn = null;
         if(this._countDown)
         {
            ObjectUtils.disposeObject(this._countDown);
         }
         this._countDown = null;
         if(this._countDownTxt)
         {
            ObjectUtils.disposeObject(this._countDownTxt);
         }
         this._countDownTxt = null;
         if(this._roomNumTxt)
         {
            ObjectUtils.disposeObject(this._roomNumTxt);
         }
         this._roomNumTxt = null;
         ObjectUtils.disposeObject(this._grade);
         this._grade = null;
         ObjectUtils.disposeObject(_waterArea);
         _waterArea = null;
         ObjectUtils.disposeObject(this._roomNum);
         this._roomNum = null;
         if(this._sceneScene)
         {
            this._sceneScene.dispose();
         }
         this._sceneScene = null;
         if(this._roomMenuView)
         {
            if(this._roomMenuView.parent)
            {
               this._roomMenuView.parent.removeChild(this._roomMenuView);
            }
            this._roomMenuView.dispose();
         }
         this._roomMenuView = null;
         if(this._chatFrame && this._chatFrame.parent)
         {
            this._chatFrame.parent.removeChild(this._chatFrame);
         }
         this._chatFrame = null;
         if(this._sceneFront && this._sceneFront.parent)
         {
            this._sceneFront.parent.removeChild(this._sceneFront);
         }
         this._sceneFront = null;
         if(this._sceneFront2 && this._sceneFront2.parent)
         {
            this._sceneFront2.parent.removeChild(this._sceneFront2);
         }
         this._sceneFront2 = null;
         ObjectUtils.disposeObject(this._sceneBack);
         this._sceneBack = null;
         if(this._sceneFrontNight && this._sceneFrontNight.parent)
         {
            this._sceneFrontNight.parent.removeChild(this._sceneFrontNight);
         }
         this._sceneFrontNight = null;
         if(this._sceneFrontNight2 && this._sceneFrontNight2.parent)
         {
            this._sceneFrontNight2.parent.removeChild(this._sceneFrontNight2);
         }
         this._sceneFrontNight2 = null;
         ObjectUtils.disposeObject(this._sceneBackNight);
         this._sceneBackNight = null;
         if(this._hotSpringViewAsset.maskPath && this._hotSpringViewAsset.maskPath.parent)
         {
            this._hotSpringViewAsset.maskPath.parent.removeChild(this._hotSpringViewAsset.maskPath);
         }
         if(this._hotSpringViewAsset.layerWater && this._hotSpringViewAsset.layerWater.parent)
         {
            this._hotSpringViewAsset.layerWater.parent.removeChild(this._hotSpringViewAsset.layerWater);
         }
         if(this._sceneBackBox && this._sceneBackBox.parent)
         {
            this._sceneBackBox.parent.removeChild(this._sceneBackBox);
         }
         this._sceneBackBox = null;
         if(this._mouseMovie && this._mouseMovie.parent)
         {
            this._mouseMovie.parent.removeChild(this._mouseMovie);
         }
         this._mouseMovie = null;
         while(this._model.roomPlayerList && this._model.roomPlayerList.list.length > 0)
         {
            _loc1_ = this._model.roomPlayerList.list[0] as PlayerVO;
            if(_loc1_)
            {
               _loc1_.dispose();
            }
            _loc1_ = null;
            this._model.roomPlayerList.list.shift();
         }
         if(this._model.roomPlayerList)
         {
            this._model.roomPlayerList.clear();
         }
         while(this._playerList && this._playerList.length > 0)
         {
            _loc2_ = this._playerList.list[0] as PlayerVO;
            if(_loc2_)
            {
               _loc2_.dispose();
            }
            _loc2_ = null;
            this._playerList.list.shift();
         }
         this._playerList.clear();
         this._playerList = null;
         if(this._selfPlayer)
         {
            if(this._selfPlayer.parent)
            {
               this._selfPlayer.parent.removeChild(this._selfPlayer);
            }
            this._selfPlayer.dispose();
         }
         this._selfPlayer = null;
         if(this._hotSpringPlayerList)
         {
            while(this._hotSpringPlayerList.length > 0)
            {
               _loc3_ = this._hotSpringPlayerList.list[0] as HotSpringPlayer;
               if(_loc3_)
               {
                  _loc3_.dispose();
               }
               _loc3_ = null;
               this._hotSpringPlayerList.list.shift();
            }
            this._hotSpringPlayerList.clear();
         }
         this._hotSpringPlayerList = null;
         if(this._playerLayer)
         {
            while(this._playerLayer.numChildren > 0)
            {
               _loc4_ = this._playerLayer.getChildAt(0) as HotSpringPlayer;
               if(_loc4_)
               {
                  _loc4_.dispose();
               }
               _loc4_ = null;
               this._playerLayer.removeChildAt(0);
            }
         }
         if(this._playerLayer && this._playerLayer.parent)
         {
            this._playerLayer.parent.removeChild(this._playerLayer);
         }
         this._playerLayer = null;
         if(this._boxButton)
         {
            ObjectUtils.disposeObject(this._boxButton);
         }
         this._boxButton = null;
         while(this._playerWalkPath && this._playerWalkPath.length > 0)
         {
            this._playerWalkPath[0] = null;
            this._playerWalkPath.shift();
         }
         this._playerWalkPath = null;
         if(this._currentLoadingPlayer)
         {
            this._currentLoadingPlayer.dispose();
         }
         this._currentLoadingPlayer = null;
         ObjectUtils.disposeObject(this._expUpBox);
         this._expUpBox = null;
         ObjectUtils.disposeObject(this._expUpAsset);
         this._expUpAsset = null;
         ObjectUtils.disposeObject(this._expUpText);
         this._expUpText = null;
         if(this._hotSpringViewAsset && this._hotSpringViewAsset.parent)
         {
            this._hotSpringViewAsset.parent.removeChild(this._hotSpringViewAsset);
         }
         this._hotSpringViewAsset = null;
         this._defaultPoint = null;
         this._mapVO = null;
         CacheSysManager.unlock(CacheConsts.ALERT_IN_HOTSPRING);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_HOTSPRING);
      }
   }
}
