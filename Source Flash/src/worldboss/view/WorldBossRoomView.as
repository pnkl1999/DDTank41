package worldboss.view
{
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.model.WorldBossRoomModel;
   
   public class WorldBossRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [1738,1300];
       
      
      private var _contoller:WorldBossRoomController;
      
      private var _model:WorldBossRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:WorldBossScneneMap;
      
      private var _chatFrame:ChatView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _bossHP:WorldBossHPScript;
      
      private var _totalContainer:WorldBossRoomTotalInfoView;
      
      private var _resurrectFrame:WorldBossResurrectView;
      
      private var _buffIcon:WorldBossBuffIcon;
      
      private var _buffIconArr:Array;
      
      private var _timer:Timer;
      
      private var _diff:int;
      
      public function WorldBossRoomView(param1:WorldBossRoomController, param2:WorldBossRoomModel)
      {
         this._buffIconArr = new Array();
         super();
         this._contoller = param1;
         this._model = param2;
         this.initialize();
      }
      
      public static function getImagePath(param1:int) : String
      {
         return PathManager.solveWorldbossBuffPath() + param1 + ".png";
      }
      
      public function show() : void
      {
         this._contoller.addChild(this);
      }
      
      private function initialize() : void
      {
         SoundManager.instance.playMusic("worldbossroom-" + WorldBossManager.Instance.BossResourceId);
         this._sceneScene = new SceneScene();
         this._roomMenuView = ComponentFactory.Instance.creat("worldboss.room.menuView");
         addChild(this._roomMenuView);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
         this._bossHP = ComponentFactory.Instance.creat("worldboss.room.bossHP");
		 this._bossHP.visible = true;
         addChild(this._bossHP);
         this.refreshHpScript();
         this._diff = !!WorldBossManager.Instance.bossInfo.fightOver ? int(0) : int(WorldBossManager.Instance.bossInfo.getLeftTime());
         this._totalContainer = ComponentFactory.Instance.creat("worldboss.room.infoView");
         addChildAt(this._totalContainer,0);
         this._totalContainer.updata_yourSelf_damage();
         this._totalContainer.setTimeCount(this._diff);
         this._buffIcon = ComponentFactory.Instance.creat("worldboss.room.buffIcon");
         addChild(this._buffIcon);
         this._buffIcon.visible = !WorldBossManager.Instance.bossInfo.fightOver;
         this._buffIcon.addEventListener(Event.CHANGE,this.showBuff);
         this.setMap();
         ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         //this._chatFrame.moreButtonState = false;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._timer = new Timer(1000,this._diff);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timeOne);
         this._timer.start();
      }
      
      public function refreshHpScript() : void
      {
         if(!this._bossHP)
         {
            return;
         }
         if(WorldBossManager.Instance.isShowBlood && !WorldBossManager.Instance.bossInfo.fightOver)
         {
            this._bossHP.visible = true;
            this._bossHP.refreshBossName();
            this._bossHP.refreshBlood();
         }
         else
         {
            this._bossHP.visible = true;
         }
      }
      
      public function setViewAgain() : void
      {
         SoundManager.instance.playMusic("worldbossroom-" + WorldBossManager.Instance.BossResourceId);
         ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._totalContainer.updata_yourSelf_damage();
         this._sceneMap.enterIng = false;
         this._sceneMap.removePrompt();
         this._buffIcon.visible = !WorldBossManager.Instance.bossInfo.fightOver;
         this.refreshHpScript();
      }
      
      public function __timeOne(param1:TimerEvent) : void
      {
         --this._diff;
         if(this._diff < 0)
         {
            this.timeComplete();
         }
         else
         {
            this._totalContainer.setTimeCount(this._diff);
         }
      }
      
      public function timeComplete() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timeOne);
         if(this._timer.running)
         {
            this._timer.reset();
         }
         if(WorldBossManager.Instance.bossInfo.isLiving && this._bossHP)
         {
            removeChild(this._bossHP);
            this._bossHP.dispose();
            this._bossHP = null;
         }
      }
      
      public function setMap(param1:Point = null) : void
      {
         this.clearMap();
         var _loc2_:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this.getMapRes()) as Class)() as MovieClip;
         var _loc3_:Sprite = _loc2_.getChildByName("articleLayer") as Sprite;
         var _loc4_:Sprite = _loc2_.getChildByName("worldbossMouse") as Sprite;
         var _loc5_:Sprite = _loc2_.getChildByName("mesh") as Sprite;
         var _loc6_:Sprite = _loc2_.getChildByName("bg") as Sprite;
         var _loc7_:Sprite = _loc2_.getChildByName("bgSize") as Sprite;
         var _loc8_:Sprite = _loc2_.getChildByName("decoration") as Sprite;
         if(_loc7_)
         {
            MAP_SIZEII[0] = _loc7_.width;
            MAP_SIZEII[1] = _loc7_.height;
         }
         else
         {
            MAP_SIZEII[0] = _loc6_.width;
            MAP_SIZEII[1] = _loc6_.height;
         }
         this._sceneScene.setHitTester(new PathMapHitTester(_loc5_));
         if(!this._sceneMap)
         {
            this._sceneMap = new WorldBossScneneMap(this._model,this._sceneScene,this._model.getPlayers(),_loc6_,_loc5_,_loc3_,_loc4_,_loc8_);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(param1)
         {
            this._sceneMap.sceneMapVO.defaultPos = param1;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
         SocketManager.Instance.out.sendAddPlayer(WorldBossManager.Instance.bossInfo.myPlayerVO.playerPos);
         if(WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD > 0)
         {
            this.showResurrectFrame(WorldBossManager.Instance.bossInfo.myPlayerVO.reviveCD);
         }
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         _loc1_.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         _loc1_.mapW = MAP_SIZEII[0];
         _loc1_.mapH = MAP_SIZEII[1];
         _loc1_.defaultPos = ComponentFactory.Instance.creatCustomObject("worldboss.RoomView.sceneMapVOPosII");
         return _loc1_;
      }
      
      public function clearBuff() : void
      {
         var _loc1_:BuffItem = null;
         while(this._buffIconArr.length > 0)
         {
            _loc1_ = this._buffIconArr[0] as BuffItem;
            this._buffIconArr.shift();
            removeChild(_loc1_);
            _loc1_.dispose();
         }
      }
      
      public function showBuff(param1:Event = null) : void
      {
         var _loc3_:BuffItem = null;
         this.clearBuff();
         var _loc2_:int = 0;
         while(_loc2_ < WorldBossManager.Instance.bossInfo.myPlayerVO.buffs.length)
         {
            _loc3_ = new BuffItem(WorldBossManager.Instance.bossInfo.myPlayerVO.buffs[_loc2_]);
            this._buffIconArr.push(_loc3_);
            addChild(_loc3_);
            _loc3_.y = 540;
            _loc3_.x = 440 + this._buffIconArr.length * 60;
            _loc2_++;
         }
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         if(this._sceneMap)
         {
            this._sceneMap.movePlayer(param1,param2);
         }
      }
      
      public function updatePlayerStauts(param1:int, param2:int, param3:Point = null) : void
      {
         if(this._sceneMap)
         {
            this._sceneMap.updatePlayersStauts(param1,param2,param3);
         }
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         this._sceneMap.updateSelfStatus(param1);
      }
      
      public function checkSelfStatus() : void
      {
         if(this._sceneMap.checkSelfStatus() == 3 || !WorldBossManager.Instance.bossInfo.fightOver && WorldBossManager.IsSuccessStartGame)
         {
            this.showResurrectFrame(WorldBossManager.Instance.bossInfo.timeCD);
            if(WorldBossBuyBuffFrame.IsAutoShow)
            {
               this._buffIcon.bugBuff();
            }
         }
         else
         {
            this._sceneMap.updateSelfStatus(1);
         }
      }
      
      private function showResurrectFrame(param1:int) : void
      {
         this._resurrectFrame = new WorldBossResurrectView(param1);
         PositionUtils.setPos(this._resurrectFrame,"worldRoom.resurrectView.pos");
         addChild(this._resurrectFrame);
         this._resurrectFrame.addEventListener(Event.COMPLETE,this.__resurrectTimeOver);
         this._roomMenuView.visible = false;
      }
      
      public function playerRevive(param1:int) : void
      {
         if(this._sceneMap.selfPlayer && param1 == this._sceneMap.selfPlayer.ID)
         {
            if(this._resurrectFrame)
            {
               this.removeFrame();
            }
            if(this._roomMenuView)
            {
               this._roomMenuView.visible = true;
            }
         }
         this._sceneMap.playerRevive(param1);
      }
      
      private function __resurrectTimeOver(param1:Event = null) : void
      {
         this.removeFrame();
         this._roomMenuView.visible = true;
         this._sceneMap.updateSelfStatus(1);
      }
      
      private function removeFrame() : void
      {
         if(this._resurrectFrame)
         {
            this._resurrectFrame.removeEventListener(Event.COMPLETE,this.__resurrectTimeOver);
            if(this._resurrectFrame.parent)
            {
               removeChild(this._resurrectFrame);
            }
            this._resurrectFrame.dispose();
            this._resurrectFrame = null;
         }
      }
      
      private function _leaveRoom(param1:Event) : void
      {
         StateManager.setState(StateType.WORLDBOSS_AWARD);
         this._contoller.dispose();
      }
      
      public function gameOver() : void
      {
         this._sceneMap.gameOver();
         this._buffIcon.visible = false;
         this._totalContainer.restTimeInfo();
      }
      
      public function updataRanking(param1:Array) : void
      {
         this._totalContainer.updataRanking(param1);
      }
      
      public function getMapRes() : String
      {
         return "tank.WorldBoss.Map-" + WorldBossManager.Instance.BossResourceId;
      }
      
      private function clearMap() : void
      {
         if(this._sceneMap)
         {
            if(this._sceneMap.parent)
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function dispose() : void
      {
         WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timeOne);
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         this._buffIcon = null;
         this._roomMenuView = null;
         this._totalContainer = null;
         this._bossHP = null;
         this._resurrectFrame = null;
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
      }
   }
}
