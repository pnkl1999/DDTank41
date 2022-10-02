package church.view.weddingRoom
{
   import church.controller.ChurchRoomController;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WeddingRoomMask extends Sprite
   {
       
      
      private var _controller:ChurchRoomController;
      
      private var _timer:Timer;
      
      private var _totalTimes:int = 10;
      
      private var countDownMovie:ScaleFrameImage;
      
      private var switchMovie:WeddingRoomSwitchMovie;
      
      private var _chatMsg:ChatData;
      
      public function WeddingRoomMask(param1:ChurchRoomController)
      {
         super();
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.countDownMovie = ComponentFactory.Instance.creat("church.room.startWeddingCountDownAsset");
         this.countDownMovie.setFrame(1);
         LayerManager.Instance.addToLayer(this.countDownMovie,LayerManager.GAME_TOP_LAYER);
         this._timer = new Timer(1000,11);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerAlarm);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer.start();
      }
      
      private function __timerAlarm(param1:TimerEvent) : void
      {
         --this._totalTimes;
         if(this._totalTimes % 2 && this._totalTimes >= 0)
         {
            SoundManager.instance.play("050");
         }
         this.countDownMovie.setFrame(this.countDownMovie.getFrame + 1);
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         SoundManager.instance.playMusic("3001");
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerAlarm);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.switchMovie = new WeddingRoomSwitchMovie(false);
         this.switchMovie.addEventListener(MouseEvent.CLICK,this.__click);
         this.switchMovie.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__switchComplete);
         addChild(this.switchMovie);
         this.switchMovie.playMovie();
         if(this.countDownMovie && this.countDownMovie.parent)
         {
            this.countDownMovie.parent.removeChild(this.countDownMovie);
         }
      }
      
      public function showMaskMovie() : void
      {
         this.switchMovie.playMovie();
      }
      
      private function showAlarm(param1:uint) : void
      {
         this._chatMsg = new ChatData();
         this._chatMsg.channel = ChatInputView.SYS_NOTICE;
         this._chatMsg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneMask.chatMsg.msg") + param1;
         ChatManager.Instance.chat(this._chatMsg);
      }
      
      private function __click(param1:MouseEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneMask.click"));
      }
      
      private function __switchComplete(param1:Event) : void
      {
         dispatchEvent(new Event(WeddingRoomSwitchMovie.SWITCH_COMPLETE));
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         this._chatMsg = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerAlarm);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         }
         this._timer = null;
         if(this.switchMovie)
         {
            this.switchMovie.removeEventListener(MouseEvent.CLICK,this.__click);
            this.switchMovie.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__switchComplete);
            this.switchMovie.dispose();
         }
         this.switchMovie = null;
         if(this.countDownMovie)
         {
            if(this.countDownMovie.parent)
            {
               this.countDownMovie.parent.removeChild(this.countDownMovie);
            }
            this.countDownMovie.dispose();
         }
         this.countDownMovie = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
