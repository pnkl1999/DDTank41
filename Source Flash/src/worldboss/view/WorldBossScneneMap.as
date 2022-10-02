package worldboss.view
{
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossRoomModel;
   import worldboss.player.PlayerVO;
   import worldboss.player.WorldRoomPlayer;
   
   public class WorldBossScneneMap extends Sprite implements Disposeable
   {
      
      public static const SCENE_ALLOW_FIRES:int = 6;
       
      
      private const CLICK_INTERVAL:Number = 200;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      public var selfPlayer:WorldRoomPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _mouseMovie:MovieClip;
      
      private var _currentLoadingPlayer:WorldRoomPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:WorldBossRoomModel;
      
      private var _worldboss:MovieClip;
      
      private var _worldboss_mc:MovieClip;
      
      private var _worldboss_sky:MovieClip;
      
      private var armyPos:Point;
      
      private var decorationLayer:Sprite;
      
      private var r:int = 250;
      
      private var auto:Point;
      
      private var autoMove:Boolean = false;
      
      private var clickAgain:Boolean = false;
      
      private var _entering:Boolean = false;
      
      private var _frame_name:String = "stand";
      
      protected var reference:WorldRoomPlayer;
      
      public function WorldBossScneneMap(param1:WorldBossRoomModel, param2:SceneScene, param3:DictionaryData, param4:Sprite, param5:Sprite, param6:Sprite = null, param7:Sprite = null, param8:Sprite = null)
      {
         super();
         this._model = param1;
         this.sceneScene = param2;
         this._data = param3;
         if(param4 == null)
         {
            this.bgLayer = new Sprite();
         }
         else
         {
            this.bgLayer = param4;
         }
         this.meshLayer = param5 == null ? new Sprite() : param5;
         this.meshLayer.alpha = 0;
         this.articleLayer = param6 == null ? new Sprite() : param6;
         this.decorationLayer = param8 == null ? new Sprite() : param8;
         this.skyLayer = param7 == null ? new Sprite() : param7;
         this.decorationLayer.mouseEnabled = false;
         this.decorationLayer.mouseChildren = false;
         this.addChild(this.bgLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.decorationLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
         this.initBoss();
      }
      
      private function initBoss() : void
      {
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this._worldboss = this.skyLayer.getChildByName("worldboss_mc") as MovieClip;
            this._worldboss.addEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
            this._worldboss.buttonMode = true;
            this._worldboss_mc = this.bgLayer.getChildByName("worldboss") as MovieClip;
            this._worldboss_sky = this.bgLayer.getChildByName("worldboss_sky") as MovieClip;
            this.armyPos = new Point(this.bgLayer.getChildByName("armyPos").x,this.bgLayer.getChildByName("armyPos").y);
         }
         if(WorldBossManager.Instance.bossInfo.fightOver)
         {
            this._worldboss.parent.removeChild(this._worldboss);
            this._worldboss_mc.parent.removeChild(this._worldboss_mc);
            this._worldboss_sky.visible = false;
            this.removePrompt();
         }
      }
      
      private function _enterWorldBossGame(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this.autoMove || this.selfPlayer.playerVO.playerStauts != 1 || !this.selfPlayer.getCanAction())
         {
            return;
         }
         if(this.checkCanStartGame() && getTimer() - this._lastClick > this._clickInterval)
         {
            SoundManager.instance.play("008");
            this._mouseMovie.gotoAndStop(1);
            this._lastClick = getTimer();
            if(this.checkDistance())
            {
               WorldBossManager.Instance.buyBuff();
               this.CreateStartGame();
            }
            else if(this.auto && !this.sceneScene.hit(this.auto))
            {
               this.autoMove = true;
               this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
               this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint,this.auto);
               this.selfPlayer.playerVO.walkPath.shift();
               this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.playerVO.walkPath[0]);
               this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
            }
         }
      }
      
      private function checkDistance() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = this.selfPlayer.x - this.armyPos.x;
         var _loc2_:Number = this.selfPlayer.y - this.armyPos.y;
         if(Math.pow(_loc1_,2) + Math.pow(_loc2_,2) > Math.pow(this.r,2))
         {
            _loc3_ = Math.atan2(_loc2_,_loc1_);
            this.auto = new Point(this.armyPos.x,this.armyPos.y);
            this.auto.x += (_loc1_ > 0 ? 1 : -1) * Math.abs(Math.cos(_loc3_) * this.r);
            this.auto.y += (_loc2_ > 0 ? 1 : -1) * Math.abs(Math.sin(_loc3_) * this.r);
            return false;
         }
         return true;
      }
      
      private function checkCanStartGame() : Boolean
      {
         var _loc1_:Boolean = true;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function set enterIng(param1:Boolean) : void
      {
         this._entering = param1;
      }
      
      public function removePrompt() : void
      {
         if(this.bgLayer.getChildByName("prompt"))
         {
            this.bgLayer.removeChild(this.bgLayer.getChildByName("prompt"));
         }
      }
      
      private function CreateStartGame() : void
      {
         if(this._entering)
         {
            return;
         }
         if(WorldBossManager.Instance.bossInfo.need_ticket_count == 0)
         {
            this._entering = true;
            this.startGame();
            return;
         }
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worldboss.tickets.propInfo",WorldBossManager.Instance.bossInfo.need_ticket_count),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(WorldBossManager.Instance.bossInfo.ticketID) > 0)
               {
                  this.startGame();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.tickets.none"),0,true);
                  this.autoMove = false;
               }
               _loc2_.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               _loc2_.dispose();
               this.autoMove = false;
         }
      }
      
      private function startGame() : void
      {
         SocketManager.Instance.out.createUserGuide(14);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.STOPFIGHT,this.__stopFight);
      }
      
      private function __stopFight(param1:Event) : void
      {
         this.enterIng = false;
      }
      
      private function __arrive(param1:SceneCharacterEvent) : void
      {
         if(this.autoMove)
         {
            WorldBossManager.Instance.buyBuff();
            this.CreateStartGame();
         }
      }
      
      public function gameOver() : void
      {
         this._worldboss.mouseEnabled = false;
         this._worldboss.removeEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
         if(!WorldBossManager.Instance.bossInfo.isLiving)
         {
            this._worldboss_mc.gotoAndPlay("out");
         }
         else
         {
            this._worldboss_mc.gotoAndPlay("outB");
         }
         this._worldboss_sky.visible = false;
         this.removePrompt();
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      public function set sceneMapVO(param1:SceneMapVO) : void
      {
         this._sceneMapVO = param1;
      }
      
      protected function init() : void
      {
         this._characters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.worldboss.room.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this.last_click = 0;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL,this.__onRoomFull);
      }
      
      private function __onRoomFull(param1:WorldBossRoomEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.room.roomFull"),0,true);
         this._entering = false;
      }
      
      private function menuChange(param1:WorldBossRoomEvent) : void
      {
         switch(param1.type)
         {
            case WorldBossRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var _loc1_:WorldRoomPlayer = null;
         for each(_loc1_ in this._characters)
         {
            _loc1_.isShowName = this._model.playerNameVisible;
         }
      }
      
      protected function updateMap(param1:Event) : void
      {
         var _loc2_:WorldRoomPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
            _loc2_.isShowName = this._model.playerNameVisible;
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(!this.selfPlayer || this.selfPlayer.playerVO.playerStauts != 1 || !this.selfPlayer.getCanAction())
         {
            return;
         }
         _loc2_ = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.autoMove = false;
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(_loc2_))
            {
               this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint,_loc2_);
               this.selfPlayer.playerVO.walkPath.shift();
               this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.playerVO.walkPath[0]);
               this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      public function sendMyPosition(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc2_.push(int(param1[_loc3_].x),int(param1[_loc3_].y));
            _loc3_++;
         }
         var _loc4_:String = _loc2_.toString();
         SocketManager.Instance.out.sendWorldBossRoomMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         var _loc3_:WorldRoomPlayer = null;
         if(this._characters[param1])
         {
            _loc3_ = this._characters[param1] as WorldRoomPlayer;
            if(!_loc3_.getCanAction())
            {
               _loc3_.playerVO.playerStauts = 1;
               _loc3_.setStatus();
            }
            _loc3_.playerVO.walkPath = param2;
            _loc3_.playerWalk(param2);
         }
      }
      
      public function updatePlayersStauts(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:WorldRoomPlayer = null;
         if(this._characters[param1])
         {
            _loc4_ = this._characters[param1] as WorldRoomPlayer;
            if(param2 == 1 && _loc4_.playerVO.playerStauts == 3)
            {
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
               _loc4_.setStatus();
            }
            else if(param2 == 2)
            {
               if(!_loc4_.getCanAction())
               {
                  _loc4_.playerVO.playerStauts = 1;
                  _loc4_.setStatus();
               }
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.isReadyFight = true;
               _loc4_.addEventListener(WorldBossRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
               _loc4_.playerVO.walkPath = [param3];
               _loc4_.playerWalk([param3]);
            }
            else
            {
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.setStatus();
            }
         }
      }
      
      public function __otherPlayrStartFight(param1:WorldBossRoomEvent) : void
      {
         var _loc2_:WorldRoomPlayer = param1.currentTarget as WorldRoomPlayer;
         _loc2_.removeEventListener(WorldBossRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
         _loc2_.sceneCharacterDirection = SceneCharacterDirection.getDirection(_loc2_.playerPoint,this.armyPos);
         _loc2_.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         _loc2_.isReadyFight = false;
         _loc2_.setStatus();
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         if(this.selfPlayer.playerVO.playerStauts == 3)
         {
            this.selfPlayer.playerVO.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this._entering = false;
         }
         this.selfPlayer.playerVO.playerStauts = param1;
         this.selfPlayer.setStatus();
         SocketManager.Instance.out.sendWorldBossRoomStauts(param1);
         this.checkGameOver();
      }
      
      public function checkSelfStatus() : int
      {
         return this.selfPlayer.playerVO.playerStauts;
      }
      
      public function playerRevive(param1:int) : void
      {
         var _loc2_:WorldRoomPlayer = null;
         if(this._characters[param1])
         {
            _loc2_ = this._characters[param1] as WorldRoomPlayer;
            _loc2_.revive();
            this.selfPlayer.playerVO.playerStauts = 1;
            this._entering = false;
         }
      }
      
      private function worldBoss_mc_gotoAndplay() : void
      {
         this._worldboss_mc.gotoAndPlay(this._frame_name);
      }
      
      private function checkGameOver() : Boolean
      {
         if(WorldBossManager.Instance.bossInfo.fightOver && this._worldboss)
         {
            this._worldboss.mouseEnabled = false;
            this._worldboss.removeEventListener(MouseEvent.CLICK,this._enterWorldBossGame);
            if(!WorldBossManager.Instance.bossInfo.isLiving)
            {
               this._frame_name = "out";
            }
            else if(WorldBossManager.Instance.bossInfo.getLeftTime() == 0)
            {
               this._frame_name = "outB";
            }
            setTimeout(this.worldBoss_mc_gotoAndplay,1500);
            this._worldboss_sky.visible = false;
         }
         return WorldBossManager.Instance.bossInfo.fightOver;
      }
      
      public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.reference)
         {
            _loc2_ = -(this.reference.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this.reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         else
         {
            _loc2_ = -(WorldBossManager.Instance.bossInfo.playerDefaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(WorldBossManager.Instance.bossInfo.playerDefaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW)
         {
            _loc2_ = MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH)
         {
            _loc3_ = MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
         var _loc4_:Point = this.globalToLocal(new Point(700,300));
         this._worldboss_sky.x = _loc4_.x;
         this._worldboss_sky.y = _loc4_.y;
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:PlayerVO = null;
         if(!this.selfPlayer)
         {
            _loc1_ = WorldBossManager.Instance.bossInfo.myPlayerVO;
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new WorldRoomPlayer(_loc1_,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(param1:WorldRoomPlayer) : void
      {
         if(param1 == null)
         {
            if(this.reference)
            {
               this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.reference = null;
            }
            return;
         }
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this.reference = param1;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerVO = param1.data as PlayerVO;
         this._currentLoadingPlayer = new WorldRoomPlayer(_loc2_,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(param1:WorldRoomPlayer, param2:Boolean) : void
      {
         if(!this.articleLayer || !param1)
         {
            return;
         }
         this._currentLoadingPlayer = null;
         param1.sceneScene = this.sceneScene;
         param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
         if(!this.selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            param1.playerVO.playerPos = param1.playerVO.playerPos;
            this.selfPlayer = param1;
            this.articleLayer.addChild(this.selfPlayer);
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this.selfPlayer.setStatus();
            this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         else
         {
            this.articleLayer.addChild(param1);
         }
         param1.playerPoint = param1.playerVO.playerPos;
         param1.sceneCharacterStateType = "natural";
         this._characters.add(param1.playerVO.playerInfo.ID,param1);
         param1.isShowName = this._model.playerNameVisible;
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as PlayerVO).playerInfo.ID;
         var _loc3_:WorldRoomPlayer = this._characters[_loc2_] as WorldRoomPlayer;
         this._characters.remove(_loc2_);
         if(_loc3_)
         {
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            _loc3_.dispose();
         }
         _loc3_ = null;
      }
      
      protected function BuildEntityDepth() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc1_:int = this.articleLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this.articleLayer.getChildAt(_loc2_);
            _loc4_ = this.getPointDepth(_loc3_.x,_loc3_.y);
            _loc6_ = Number.MAX_VALUE;
            _loc7_ = _loc2_ + 1;
            while(_loc7_ < _loc1_)
            {
               _loc8_ = this.articleLayer.getChildAt(_loc7_);
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
               this.articleLayer.swapChildrenAt(_loc2_,_loc5_);
            }
            _loc2_++;
         }
      }
      
      protected function getPointDepth(param1:Number, param2:Number) : Number
      {
         return this.sceneMapVO.mapW * param2 + param1;
      }
      
      protected function removeEvent() : void
      {
         this._model.removeEventListener(WorldBossRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(WorldBossRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         if(this.reference)
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(this.selfPlayer)
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL,this.__onRoomFull);
      }
      
      public function dispose() : void
      {
         var p:WorldRoomPlayer = null;
         var i:int = 0;
         var player:WorldRoomPlayer = null;
         this.removeEvent();
         this._data.clear();
         this._data = null;
         this._sceneMapVO = null;
         for each(p in this._characters)
         {
            if(p.parent)
            {
               p.parent.removeChild(p);
            }
            p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            p.dispose();
            p = null;
         }
         this._characters.clear();
         this._characters = null;
         if(this.articleLayer)
         {
            i = this.articleLayer.numChildren;
            while(i > 0)
            {
               player = this.articleLayer.getChildAt(i - 1) as WorldRoomPlayer;
               if(player)
               {
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(player.parent)
                  {
                     player.parent.removeChild(player);
                  }
                  player.dispose();
               }
               player = null;
               try
               {
                  this.articleLayer.removeChildAt(i - 1);
               }
               catch(e:RangeError)
               {
               }
               i--;
            }
            if(this.articleLayer && this.articleLayer.parent)
            {
               this.articleLayer.parent.removeChild(this.articleLayer);
            }
         }
         this.articleLayer = null;
         if(this.selfPlayer)
         {
            if(this.selfPlayer.parent)
            {
               this.selfPlayer.parent.removeChild(this.selfPlayer);
            }
            this.selfPlayer.dispose();
         }
         this.selfPlayer = null;
         if(this._currentLoadingPlayer)
         {
            if(this._currentLoadingPlayer.parent)
            {
               this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
            }
            this._currentLoadingPlayer.dispose();
         }
         this._currentLoadingPlayer = null;
         if(this._mouseMovie && this._mouseMovie.parent)
         {
            this._mouseMovie.parent.removeChild(this._mouseMovie);
         }
         this._mouseMovie = null;
         if(this.meshLayer && this.meshLayer.parent)
         {
            this.meshLayer.parent.removeChild(this.meshLayer);
         }
         this.meshLayer = null;
         if(this.bgLayer && this.bgLayer.parent)
         {
            this.bgLayer.parent.removeChild(this.bgLayer);
         }
         this.bgLayer = null;
         if(this.skyLayer && this.skyLayer.parent)
         {
            this.skyLayer.parent.removeChild(this.skyLayer);
         }
         this.skyLayer = null;
         this.sceneScene = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
