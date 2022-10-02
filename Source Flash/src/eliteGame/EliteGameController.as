package eliteGame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import eliteGame.analyze.EliteGameScoreRankAnalyer;
   import eliteGame.info.EliteGameTopSixteenInfo;
   import eliteGame.view.EliteGamePaarungFrame;
   import eliteGame.view.EliteGamePreview;
   import eliteGame.view.EliteGameReadyFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class EliteGameController extends EventDispatcher
   {
      
      public static const ELITEGAME_CLOSE:int = 0;
      
      public static const SCORE_PHASE_30_40:int = 1;
      
      public static const CHAMPION_PHASE_30_40:int = 2;
      
      public static const SCORE_PHASE_41_50:int = 3;
      
      public static const CHAMPION_PHASE_41_50:int = 4;
      
      private static var _instance:EliteGameController;
       
      
      private var _score_30_40:int = 1;
      
      private var _champion_30_40:int = 2;
      
      private var _score_41_50:int = 4;
      
      private var _champion_41_50:int = 8;
      
      private var _eliteGameState:int = 0;
      
      private var _model:EliteGameModel;
      
      private var _timer:Timer;
      
      public var leftTime:int = 30;
      
      private var _isFirstPreview:Boolean = true;
      
      private var _readyFrame:EliteGameReadyFrame;
      
      private var _isalertReady:Boolean = false;
      
      private var _sroceRankType:int;
      
      public function EliteGameController()
      {
         super();
         this._model = new EliteGameModel();
      }
      
      public static function get Instance() : EliteGameController
      {
         if(_instance == null)
         {
            _instance = new EliteGameController();
         }
         return _instance;
      }
      
      public function get Model() : EliteGameModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_TYPE,this.__matchTypeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_PLAYER_RANK,this.__selfRankHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_RANK_START,this.__gameStartHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_RANK_DETAIL,this.__detailHandler);
      }
      
      protected function __detailHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:EliteGameTopSixteenInfo = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Vector.<EliteGameTopSixteenInfo> = new Vector.<EliteGameTopSixteenInfo>();
         var _loc6_:DictionaryData = new DictionaryData();
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = new EliteGameTopSixteenInfo();
            _loc8_.id = _loc2_.readInt();
            _loc8_.name = _loc2_.readUTF();
            _loc8_.rank = _loc2_.readInt();
            _loc5_.push(_loc8_);
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc10_ == 0 ? int(int(_loc9_ - 1)) : int(int(_loc9_));
            _loc12_ = 1;
            while(_loc12_ <= _loc11_)
            {
               if(_loc6_[_loc12_] == null)
               {
                  _loc6_[_loc12_] = new Vector.<int>();
               }
               (_loc6_[_loc12_] as Vector.<int>).push(_loc8_.id);
               _loc12_++;
            }
            _loc7_++;
         }
         if(_loc3_ == 1)
         {
            this._model.topSixteen30_40 = _loc5_;
            this._model.paarungRound30_40 = _loc6_;
         }
         else if(_loc3_ == 2)
         {
            this._model.topSixteen41_50 = _loc5_;
            this._model.paarungRound41_50 = _loc6_;
         }
         dispatchEvent(new EliteGameEvent(EliteGameEvent.TOP_SIXTEEN_READY));
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         --this.leftTime;
         if(this._timer.currentCount == 30)
         {
            this._timer.stop();
            if(StateManager.currentStateType == StateType.MATCH_ROOM)
            {
               dispatchEvent(new EliteGameEvent(EliteGameEvent.READY_TIME_OVER));
            }
            else
            {
               if(this._readyFrame)
               {
                  this._readyFrame.dispose();
               }
               this._readyFrame = null;
            }
         }
      }
      
      protected function __gameStartHandler(param1:CrazyTankSocketEvent) : void
      {
         this.alertReadyFrame();
      }
      
      protected function __selfRankHandler(param1:CrazyTankSocketEvent) : void
      {
         this._model.selfRank = param1.pkg.readInt();
         this._model.selfScore = param1.pkg.readInt();
         if(this._model.selfScore == 0)
         {
            this._model.selfScore = 1000;
         }
         dispatchEvent(new EliteGameEvent(EliteGameEvent.SELF_RANK_SCORE_READY));
      }
      
      protected function __matchTypeHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         this.eliteGameState = _loc2_;
      }
      
      public function get eliteGameState() : int
      {
         return this._eliteGameState;
      }
      
      public function set eliteGameState(param1:int) : void
      {
         if(this._eliteGameState == param1)
         {
            return;
         }
         this._eliteGameState = param1;
         dispatchEvent(new EliteGameEvent(EliteGameEvent.ELITEGAME_STATE_CHANGE));
      }
      
      public function getState() : Array
      {
         var _loc1_:Array = new Array();
         if(this._eliteGameState & this._score_30_40)
         {
            _loc1_.push(SCORE_PHASE_30_40);
         }
         if(this._eliteGameState & this._champion_30_40)
         {
            _loc1_.push(CHAMPION_PHASE_30_40);
         }
         if(this._eliteGameState & this._score_41_50)
         {
            _loc1_.push(SCORE_PHASE_41_50);
         }
         if(this._eliteGameState & this._champion_41_50)
         {
            _loc1_.push(CHAMPION_PHASE_41_50);
         }
         return _loc1_;
      }
      
      public function alertPreview() : void
      {
         var _loc1_:EliteGamePreview = null;
         if(this._isFirstPreview)
         {
            this._isalertReady = false;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ELITEGAME);
         }
         else
         {
            SocketManager.Instance.out.sendGetSelfRankSroce();
            SocketManager.Instance.out.sendGetEliteGameState();
            this.getScoreRankData();
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("eliteGamePreview");
            LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND,true);
         }
      }
      
      public function alertReadyFrame() : void
      {
         if(!StateManager.isExitGame(StateManager.currentStateType) || !StateManager.isExitRoom(StateManager.currentStateType) || StateManager.currentStateType == StateType.CHURCH_ROOM || StateManager.currentStateType == StateType.FIGHTING)
         {
            return;
         }
         this.leftTime = 30;
         if(this._isFirstPreview)
         {
            this._isalertReady = true;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ELITEGAME);
         }
         else
         {
            this._timer.reset();
            this._timer.start();
            this._readyFrame = ComponentFactory.Instance.creatComponentByStylename("eliteGameReadyFrame");
            SoundManager.instance.play("018");
            LayerManager.Instance.addToLayer(this._readyFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         }
      }
      
      public function setReadyFrame() : void
      {
         this._readyFrame = null;
      }
      
      public function alertPaarungFrame() : void
      {
         var _loc1_:EliteGamePaarungFrame = ComponentFactory.Instance.creatComponentByStylename("eliteGamePaarungFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ELITEGAME)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._isFirstPreview = false;
            if(this._isalertReady)
            {
               this.alertReadyFrame();
            }
            else
            {
               this.alertPreview();
            }
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ELITEGAME)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function joinEliteGame() : void
      {
         if(!StateManager.isExitRoom(StateManager.currentStateType))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.scoreRoom.isInRoom"));
         }
         else
         {
            GameInSocketOut.sendCreateRoom("",12,3);
         }
      }
      
      public function joinChampionEliteGame() : void
      {
         SocketManager.Instance.out.sendEliteGameStart();
         GameInSocketOut.sendCreateRoom("",13,3);
      }
      
      public function getScoreRankData() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["new"] = Math.random();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("EliteMatchPlayerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("EliteGame.loadScoreRank.fail");
         _loc2_.analyzer = new EliteGameScoreRankAnalyer(this.scroeRankLoadComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function scroeRankLoadComplete(param1:EliteGameScoreRankAnalyer) : void
      {
         this._model.scoreRankInfo = param1.scoreRankInfo;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
   }
}
