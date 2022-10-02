package roomLoading
{
   import ddt.manager.ChatManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import game.GameManager;
   import game.model.GameInfo;
   import room.RoomManager;
   import roomLoading.view.RoomLoadingView;
   
   public class RoomLoadingState extends BaseStateView
   {
       
      
      private var _current:GameInfo;
      
      private var _loadingView:RoomLoadingView;
      
      public function RoomLoadingState()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._current = param2 as GameInfo;
         this._loadingView = new RoomLoadingView(this._current);
         addChild(this._loadingView);
         ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
         ChatManager.Instance.view.visible = true;
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.hide();
         RoomManager.Instance.current.resetStates();
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendPlayerState(2);
         }
         else
         {
            GameInSocketOut.sendPlayerState(0);
         }
         EffortMovieClipManager.Instance.stop();
         ChatManager.Instance.setFocus();
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         if(this._loadingView)
         {
            this._loadingView.dispose();
            this._loadingView = null;
         }
         this._current = null;
         if(StateManager.isExitRoom(param1.getType()))
         {
            GameInSocketOut.sendGamePlayerExit();
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         MainToolBar.Instance.enableAll();
         super.leaving(param1);
      }
      
      override public function getType() : String
      {
         return StateType.ROOM_LOADING;
      }
   }
}
