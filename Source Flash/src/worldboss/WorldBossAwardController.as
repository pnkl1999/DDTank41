package worldboss
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossAwardView;
   
   public class WorldBossAwardController extends BaseStateView
   {
       
      
      private var _optionView:WorldBossAwardView;
      
      private var _mapLoader:BaseLoader;
      
      public function WorldBossAwardController()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._optionView = new WorldBossAwardView();
         addChild(this._optionView);
         ChatManager.Instance.state = ChatManager.CHAT_LITTLEHALL;
         ChatManager.Instance.view.visible = true;
         ChatManager.Instance.chatDisabled = false;
         //ChatManager.Instance.view.moreButtonState = false;
         addChild(ChatManager.Instance.view);
         KeyboardShortcutsManager.Instance.forbiddenFull();
      }
      
      private function addEvent() : void
      {
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ALLOW_ENTER,this.__gotoWorldBossRoom);
      }
      
      private function __gotoWorldBossRoom(param1:WorldBossRoomEvent) : void
      {
         this._mapLoader = LoaderManager.Instance.creatLoader(WorldBossManager.Instance.mapPath,BaseLoader.MODULE_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoaderManager.Instance.startLoad(this._mapLoader);
      }
      
      private function onMapSrcLoadedComplete(param1:Event) : void
      {
         if(StateManager.getState(StateType.WORLDBOSS_ROOM) == null)
         {
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
         }
         StateManager.setState(StateType.WORLDBOSS_ROOM);
      }
      
      private function __loadingIsCloseRoom(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.WORLDBOSS_AWARD;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         KeyboardShortcutsManager.Instance.cancelForbidden();
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ALLOW_ENTER,this.__gotoWorldBossRoom);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this._optionView)
         {
            ObjectUtils.disposeObject(this._optionView);
         }
         this._optionView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
