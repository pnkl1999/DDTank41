package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import ddt.data.player.PlayerState;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PlayerStateManager
   {
      
      private static const AWAY_TIME:int = 300;
      
      private static var _instance:PlayerStateManager;
       
      
      private var _timer:Timer;
      
      public function PlayerStateManager(param1:SingleTonForce)
      {
         super();
      }
      
      public static function get Instance() : PlayerStateManager
      {
         if(_instance == null)
         {
            _instance = new PlayerStateManager(new SingleTonForce());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._timer = new Timer(AWAY_TIME * 1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerComplete);
         this._timer.start();
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.onStageClick,false,int.MAX_VALUE);
      }
      
      private function timerComplete(param1:TimerEvent) : void
      {
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.AWAY);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
      }
      
      private function onStageClick(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.playerState.StateID == PlayerState.AWAY)
         {
            PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE,PlayerState.AUTO);
            SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         }
         this._timer.reset();
         this._timer.start();
      }
   }
}

class SingleTonForce
{
    
   
   function SingleTonForce()
   {
      super();
   }
}
