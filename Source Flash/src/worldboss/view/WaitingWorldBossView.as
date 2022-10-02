package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import par.ParticleManager;
   import worldboss.event.WorldBossRoomEvent;
   
   public class WaitingWorldBossView extends Component
   {
       
      
      private const WAITING_TIME:int = 20;
      
      private var _bg:Sprite;
      
      private var _loadingArr:Array;
      
      private var _loadingText:FilterFrameText;
      
      private var _timeText:FilterFrameText;
      
      private var _waitTimer:Timer;
      
      private var _currentCountDown:int = 20;
      
      private var _loadingIdx:int = 0;
      
      private var _frame:int;
      
      public function WaitingWorldBossView()
      {
         this._loadingArr = ["loading","loading.","loading..","loading..."];
         super();
         ParticleManager.initPartical(PathManager.FLASHSITE);
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._waitTimer = new Timer(1000,this.WAITING_TIME);
         this._waitTimer.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this._waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
      }
      
      protected function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
         this._waitTimer.stop();
         this.visible = false;
      }
      
      protected function __onTimerComplete(param1:TimerEvent) : void
      {
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ENTER_GAME_TIME_OUT));
      }
      
      protected function __onTimer(param1:TimerEvent) : void
      {
         --this._currentCountDown;
         this._timeText.text = this._currentCountDown.toString();
      }
      
      private function initView() : void
      {
         this._bg = new Sprite();
         this._bg.graphics.beginFill(0,0.6);
         this._bg.graphics.drawRect(0,0,1000,600);
         this._bg.graphics.endFill();
         this._loadingText = ComponentFactory.Instance.creatComponentByStylename("worldBoss.WaitingView.loadingText");
         this._loadingText.text = this._loadingArr[0];
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("worldBoss.WaitingView.timeText");
         this._timeText.text = this.WAITING_TIME.toString();
         addChild(this._bg);
         addChild(this._loadingText);
         addChild(this._timeText);
      }
      
      private function removeEvent() : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         this._waitTimer.stop();
         this._waitTimer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      public function start() : void
      {
         this._waitTimer.reset();
         this._waitTimer.start();
         this._frame = 0;
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         ++this._frame;
         if(this._frame >= 10)
         {
            this._loadingIdx = (this._loadingIdx + 1) % this._loadingArr.length;
            this._loadingText.text = this._loadingArr[this._loadingIdx];
            this._frame = 0;
         }
      }
      
      public function stop() : void
      {
         this._waitTimer.stop();
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._loadingText = null;
         this._timeText = null;
         this._waitTimer = null;
      }
   }
}
