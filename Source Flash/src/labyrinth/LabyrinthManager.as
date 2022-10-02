package labyrinth
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLVariables;
   import game.GameManager;
   import game.model.MissionAgainInfo;
   import labyrinth.data.CleanOutInfo;
   import labyrinth.data.LabyrinthModel;
   import labyrinth.data.LabyrinthPackageType;
   import labyrinth.data.RankingAnalyzer;
   import labyrinth.view.LabyrinthFrame;
   import labyrinth.view.LabyrinthTryAgain;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class LabyrinthManager extends EventDispatcher
   {
      
      public static const UPDATE_INFO:String = "updateInfo";
      
      public static const UPDATE_REMAIN_TIME:String = "updateRemainTime";
      
      public static const RANKING_LOAD_COMPLETE:String = "rankingLoadComplete";
      
      public static const LABYRINTH_CHAT:String = "LabyrinthChat";
      
      private static var _instance:LabyrinthManager;
       
      
      private var _UILoadComplete:Boolean = false;
      
      private var _loadProgress:int = 0;
      
      private var labyrinthFrame:LabyrinthFrame;
      
      private var _model:LabyrinthModel;
      
      public var buyFrameEnable:Boolean = true;
      
      private var tryagain:LabyrinthTryAgain;
      
      private var _callback:Function;
      
      public function LabyrinthManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this._model = new LabyrinthModel();
         this.initEvent();
      }
      
      public static function get Instance() : LabyrinthManager
      {
         if(_instance == null)
         {
            _instance = new LabyrinthManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         RoomManager.Instance.addEventListener(RoomEvent.START_LABYRINTH,this.__sendStart);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.REQUEST_UPDATE_EVENT,this.__onUpdataInfo);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.PUSH_CLEAN_OUT_INFO_EVENT,this.__onUpdataCleanOutInfo);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.CLEAN_OUT_EVENT,this.__onRemainCleanOutTime);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.TRY_AGAIN_EVENT,this.__onTryAgain);
      }
      
      protected function __onTryAgain(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:MissionAgainInfo = new MissionAgainInfo();
         _loc2_.value = param1.pkg.readInt();
         _loc2_.host = PlayerManager.Instance.Self.NickName;
         this.tryagain = new LabyrinthTryAgain(_loc2_,false);
         PositionUtils.setPos(this.tryagain,"dt.labyrinth.LabyrinthFrame.TryAgainPos");
         this.tryagain.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         this.tryagain.addEventListener(GameEvent.GIVEUP,this.__giveup);
         LayerManager.Instance.addToLayer(this.tryagain,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         this.hideLabyrinthFrame();
      }
      
      protected function __giveup(param1:GameEvent) : void
      {
         SocketManager.Instance.out.labyrinthTryAgain(false,param1.data);
         this.disposeTryAgain();
         this._model.tryAgainComplete = false;
      }
      
      protected function __tryAgain(param1:GameEvent) : void
      {
         SocketManager.Instance.out.labyrinthTryAgain(true,param1.data);
         this.disposeTryAgain();
         this._model.tryAgainComplete = true;
      }
      
      private function disposeTryAgain() : void
      {
         this.tryagain.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         this.tryagain.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         ObjectUtils.disposeObject(this.tryagain);
         this.tryagain = null;
      }
      
      protected function __onRemainCleanOutTime(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.remainTime = _loc2_.readInt();
         this._model.currentRemainTime = _loc2_.readInt();
         dispatchEvent(new Event(UPDATE_REMAIN_TIME));
      }
      
      protected function __onUpdataCleanOutInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:CleanOutInfo = new CleanOutInfo();
         _loc3_.FamRaidLevel = _loc2_.readInt();
         _loc3_.exp = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc6_["TemplateID"] = _loc2_.readInt();
            _loc6_["num"] = _loc2_.readInt();
            _loc3_.TemplateIDs.push(_loc6_);
            _loc5_++;
         }
         _loc3_.HardCurrency = _loc2_.readInt();
         if(this._model.cleanOutInfos[_loc3_.FamRaidLevel])
         {
            this._model.cleanOutInfos.remove(_loc3_.FamRaidLevel);
            delete this._model.cleanOutInfos[_loc3_.FamRaidLevel];
         }
         this._model.cleanOutInfos.add(_loc3_.FamRaidLevel,_loc3_);
      }
      
      protected function __onUpdataInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.myProgress = _loc2_.readInt();
         this._model.currentFloor = _loc2_.readInt();
         this._model.completeChallenge = _loc2_.readBoolean();
         this._model.remainTime = _loc2_.readInt();
         this._model.accumulateExp = _loc2_.readInt();
         this._model.cleanOutAllTime = _loc2_.readInt();
         this._model.cleanOutGold = _loc2_.readInt();
         this._model.myRanking = _loc2_.readInt();
         this._model.isDoubleAward = _loc2_.readBoolean();
         this._model.isInGame = _loc2_.readBoolean();
         this._model.isCleanOut = _loc2_.readBoolean();
         this._model.serverMultiplyingPower = _loc2_.readBoolean();
         dispatchEvent(new Event(UPDATE_INFO));
      }
      
      protected function __sendStart(param1:Event) : void
      {
         GameInSocketOut.sendGameStart();
      }
      
      protected function __startLoading(param1:Event) : void
      {
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            StateManager.getInGame_Step_6 = true;
            if(GameManager.Instance.Current == null)
            {
               return;
            }
            LayerManager.Instance.clearnGameDynamic();
            StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
            StateManager.getInGame_Step_7 = true;
         }
      }
      
      public function enterGame() : void
      {
         SocketManager.Instance.out.enterUserGuide(0,RoomInfo.LANBYRINTH_ROOM);
      }
      
      public function show() : void
      {
         this._callback = this.show;
         if(this._UILoadComplete)
         {
            this.labyrinthFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.labyrinthFrame");
            this.labyrinthFrame.show();
            this.labyrinthFrame.addEventListener(FrameEvent.RESPONSE,this.__labyrinthFrameEvent);
         }
         else
         {
            this.loadUIModule();
         }
      }
      
      public function get model() : LabyrinthModel
      {
         return this._model;
      }
      
      public function set model(param1:LabyrinthModel) : void
      {
         this._model = param1;
      }
      
      protected function __labyrinthFrameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.hideLabyrinthFrame();
         }
      }
      
      private function hideLabyrinthFrame() : void
      {
         if(this.labyrinthFrame)
         {
            this.labyrinthFrame.removeEventListener(FrameEvent.RESPONSE,this.__labyrinthFrameEvent);
            this.labyrinthFrame.dispose();
            this.labyrinthFrame = null;
         }
      }
      
      public function loadRankingList() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("WarriorFamRankList.xml"),BaseLoader.TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWarriorFamRankListFailure");
         _loc2_.analyzer = new RankingAnalyzer(this.openRankingFrame);
      }
      
      private function openRankingFrame(param1:RankingAnalyzer) : void
      {
         this._model.rankingList = param1.list;
         dispatchEvent(new Event(RANKING_LOAD_COMPLETE));
      }
      
      public function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LABYRINTH);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SHOP);
         }
      }
      
      protected function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LABYRINTH || param1.module == UIModuleTypes.SHOP)
         {
            ++this._loadProgress;
            if(this._loadProgress >= 2)
            {
               this._UILoadComplete = true;
            }
         }
         if(this._UILoadComplete)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            if(this._callback != null)
            {
               this._callback();
            }
         }
      }
      
      public function get UILoadComplete() : Boolean
      {
         return this._UILoadComplete;
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      public function chat() : void
      {
         dispatchEvent(new Event(LABYRINTH_CHAT));
      }
   }
}
