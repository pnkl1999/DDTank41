package littleGame
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import littleGame.events.LittleGameSocketEvent;
   import littleGame.model.Scenario;
   import littleGame.view.LittleGameOptionView;
   
   public class LittleHall extends BaseStateView
   {
       
      
      private var _game:Scenario;
      
      private var _optionView:LittleGameOptionView;
      
      private var _gameLoader:LittleGameLoader;
      
      public function LittleHall()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         this._optionView = new LittleGameOptionView();
         addChild(this._optionView);
         ChatManager.Instance.state = 26;
         ChatManager.Instance.view.visible = true;
         ChatManager.Instance.chatDisabled = false;
         addChild(ChatManager.Instance.view);
         this.addEvent();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         super.enter(param1,param2);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         KeyboardShortcutsManager.Instance.cancelForbidden();
         if(this._optionView)
         {
            ObjectUtils.disposeObject(this._optionView);
         }
         this._optionView = null;
         super.leaving(param1);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener("startload",this.__loadGame);
         SocketManager.Instance.addEventListener("gamestart",this.__gameStart);
      }
      
      private function __gameStart(param1:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.enterGame(this._game,param1.pkg);
         StateManager.setState("littleGame",this._game);
         this._game = null;
      }
      
      private function __loadGame(param1:LittleGameSocketEvent) : void
      {
         this._game = LittleGameManager.Instance.createGame(param1.pkg);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.addEventListener("close",this.__loadClose);
         UIModuleSmallLoading.Instance.show();
         this._gameLoader = new LittleGameLoader(this._game);
         this._gameLoader.addEventListener("complete",this.__gameComplete);
         this._gameLoader.addEventListener("progress",this.__gameLoaderProgress);
         this._gameLoader.startup();
      }
      
      private function __gameLoaderProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = this._gameLoader.progress;
      }
      
      private function __loadClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__loadClose);
         this._gameLoader.shutdown();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener("startload",this.__loadGame);
         SocketManager.Instance.removeEventListener("gamestart",this.__gameStart);
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__loadClose);
      }
      
      private function __gameComplete(param1:LoaderEvent) : void
      {
         var _loc2_:LittleGameLoader = param1.currentTarget as LittleGameLoader;
         _loc2_.removeEventListener("complete",this.__gameComplete);
         _loc2_.removeEventListener("progress",this.__gameLoaderProgress);
         this._game.gameLoader = _loc2_;
         this._game.grid = _loc2_.grid;
         this._game.grid.calculateLinks(0);
         UIModuleSmallLoading.Instance.hide();
         LittleGameManager.Instance.loadComplete();
      }
      
      override public function getType() : String
      {
         return "littleHall";
      }
   }
}
