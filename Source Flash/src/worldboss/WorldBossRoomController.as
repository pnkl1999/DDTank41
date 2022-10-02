package worldboss
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossRoomModel;
   import worldboss.player.PlayerVO;
   import worldboss.player.RankingPersonInfo;
   import worldboss.view.WaitingWorldBossView;
   import worldboss.view.WorldBossRoomView;
   
   public class WorldBossRoomController extends BaseStateView
   {
      
      private static var _instance:WorldBossRoomController;
      
      private static var _isFirstCome:Boolean = true;
       
      
      private var _sceneModel:WorldBossRoomModel;
      
      private var _view:WorldBossRoomView;
      
      private var _waitingView:WaitingWorldBossView;
      
      public function WorldBossRoomController()
      {
         super();
      }
      
      public static function get Instance() : WorldBossRoomController
      {
         if(!_instance)
         {
            _instance = new WorldBossRoomController();
         }
         return _instance;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.WORLDBOSS_IN_ROOM);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         super.enter(param1,param2);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.hide();
         this.addEvent();
         if(_isFirstCome)
         {
            this.init();
            _isFirstCome = false;
         }
         else if(this._view)
         {
            if(WorldBossManager.IsSuccessStartGame)
            {
               WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
               this._view.clearBuff();
            }
            this.checkSelfStatus();
            this._view.setViewAgain();
         }
      }
      
      private function init() : void
      {
         this._sceneModel = new WorldBossRoomModel();
         this._view = new WorldBossRoomView(this,this._sceneModel);
         this._view.show();
         this._view.showBuff();
         this._waitingView = new WaitingWorldBossView();
         addChild(this._waitingView);
         this._waitingView.visible = false;
         this._waitingView.addEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
      }
      
      protected function __onTimeOut(param1:Event) : void
      {
         this._waitingView.stop();
         this._waitingView.visible = false;
         WorldBossManager.Instance.exitGame();
         this.checkSelfStatus();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,this.__updatePlayerStauts);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,this.__playerRevive);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.FIGHT_OVER,this.__updata);
         WorldBossManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,this.__updataRanking);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ENTERING_GAME,this.__onEnteringGame);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.GAME_INIT,this.__onGameInit);
      }
      
      protected function __onUpdateBlood(param1:Event) : void
      {
         if(this._view)
         {
            this._view.refreshHpScript();
         }
      }
      
      protected function __onGameInit(param1:Event) : void
      {
         if(this._view)
         {
            this._view.refreshHpScript();
         }
      }
      
      protected function __onEnteringGame(param1:Event) : void
      {
         this._waitingView.visible = true;
         this._waitingView.start();
      }
      
      public function checkSelfStatus() : void
      {
         this._view.checkSelfStatus();
      }
      
      public function setSelfStatus(param1:int) : void
      {
         this._view.updateSelfStatus(param1);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT,this.__removePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,this.__updatePlayerStauts);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,this.__playerRevive);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.FIGHT_OVER,this.__updata);
         WorldBossManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,this.__updataRanking);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ENTERING_GAME,this.__onEnteringGame);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.GAME_INIT,this.__onGameInit);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA,this.__onUpdateBlood);
         if(this._waitingView)
         {
            this._waitingView.removeEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
         }
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function __addPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PlayerInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PlayerVO = null;
         var _loc2_:PackageIn = param1.pkg;
         if(param1.pkg.bytesAvailable > 10)
         {
            _loc3_ = new PlayerInfo();
            _loc3_.beginChanges();
            _loc3_.Grade = _loc2_.readInt();
            _loc3_.Hide = _loc2_.readInt();
            _loc3_.Repute = _loc2_.readInt();
            _loc3_.ID = _loc2_.readInt();
            _loc3_.NickName = _loc2_.readUTF();
            _loc3_.typeVIP = _loc2_.readByte();
            _loc3_.VIPLevel = _loc2_.readInt();
            _loc3_.Sex = _loc2_.readBoolean();
            _loc3_.Style = _loc2_.readUTF();
            _loc3_.Colors = _loc2_.readUTF();
            _loc3_.Skin = _loc2_.readUTF();
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc3_.FightPower = _loc2_.readInt();
            _loc3_.WinCount = _loc2_.readInt();
            _loc3_.TotalCount = _loc2_.readInt();
            _loc3_.Offer = _loc2_.readInt();
            _loc3_.commitChanges();
            _loc6_ = new PlayerVO();
            _loc6_.playerInfo = _loc3_;
            _loc6_.playerPos = new Point(_loc4_,_loc5_);
            _loc6_.playerStauts = _loc2_.readByte();
            if(_loc3_.ID == PlayerManager.Instance.Self.ID)
            {
               return;
            }
            this._sceneModel.addPlayer(_loc6_);
         }
      }
      
      public function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         this._sceneModel.removePlayer(_loc2_);
		 //StateManager.setState(StateType.MAIN);
      }
      
      public function __movePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:Point = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = new Point(_loc6_[_loc8_],_loc6_[_loc8_ + 1]);
            _loc7_.push(_loc9_);
            _loc8_ += 2;
         }
         this._view.movePlayer(_loc2_,_loc7_);
      }
      
      public function __updatePlayerStauts(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         this._view.updatePlayerStauts(_loc3_,_loc4_,_loc5_);
         this._sceneModel.updatePlayerStauts(_loc3_,_loc4_,_loc5_);
      }
      
      private function __playerRevive(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._view.playerRevive(_loc3_);
      }
      
      public function __updata(param1:Event) : void
      {
         if(StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            this._view.gameOver();
         }
         this._view.timeComplete();
      }
      
      public function __updataRanking(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:RankingPersonInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = new Array();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new RankingPersonInfo();
            _loc6_.id = param1.pkg.readInt();
            _loc6_.name = param1.pkg.readUTF();
            _loc6_.damage = param1.pkg.readInt();
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         this._view.updataRanking(_loc3_);
      }
      
      override public function getType() : String
      {
         return StateType.WORLDBOSS_ROOM;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.leaving(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._sceneModel)
         {
            this._sceneModel.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         this._view = null;
         this._sceneModel = null;
         CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
         _isFirstCome = true;
      }
   }
}
