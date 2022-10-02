package league.manager
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.bagStore.BagStore;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import league.view.LeagueStartNoticeView;
   import road7th.comm.PackageIn;
   
   public class LeagueManager extends EventDispatcher
   {
      
      private static var _instance:LeagueManager;
       
      
      public var maxCount:int = 30;
      
      public var restCount:int = 10;
      
      public var militaryRank:int = -1;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var timeOutNumber:uint;
      
      public var isOpen:Boolean = false;
      
      private var _lsnView:LeagueStartNoticeView;
      
      public var addLeaIcon:Function;
      
      public var deleteLeaIcon:Function;
      
      public function LeagueManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : LeagueManager
      {
         if(_instance == null)
         {
            _instance = new LeagueManager();
         }
         return _instance;
      }  
      
      public function loadLeagueModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LEAGUE);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEAGUE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEAGUE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      public function initLeagueStartNoticeEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE,this.onLeagueNotice);
      }
      
      private function onLeagueNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         if(_loc3_ == 1)
         {
            this.restCount = _loc2_.readInt();
            this.maxCount = _loc2_.readInt();
            this.isOpen = true;
            if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON_LIST || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.LOGIN)
            {
               if(BagStore.instance.storeOpenAble)
               {
                  return;
               }
               this.timeOutNumber = setTimeout(this.showLeagueStartNoticeView,1000);
            }
            if(this.addLeaIcon != null)
            {
               this.addLeaIcon();
            }
         }
         else if(_loc3_ == 2)
         {
            this.restCount = -1;
            this.maxCount = -1;
            this.isOpen = false;
            if(this.deleteLeaIcon != null)
            {
               this.deleteLeaIcon();
            }
         }
         else if(_loc3_ == 3)
         {
            this.restCount = _loc2_.readInt();
         }
      }
      
      private function showLeagueStartNoticeView() : void
      {
         this._lsnView = ComponentFactory.Instance.creat("league.leagueStartNoticeView");
         this._lsnView.show();
         clearTimeout(this.timeOutNumber);
      }
   }
}
