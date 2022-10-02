package ddt.view.chat.chatBall
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ChatBallBase extends Sprite
   {
       
      
      protected var POP_REPEAT:int = 1;
      
      protected var POP_DELAY:int = 2300;
      
      protected var paopaoMC:MovieClip;
      
      protected var _popupTimer:Timer;
      
      protected var _chatballBackground:ChatBallBackground;
      
      protected var _field:ChatBallTextAreaBase;
      
      public function ChatBallBase()
      {
         super();
         this._popupTimer = new Timer(this.POP_DELAY,this.POP_REPEAT);
         this.hide();
      }
      
      public function setText(param1:String, param2:int = 0) : void
      {
      }
      
      protected function get field() : ChatBallTextAreaBase
      {
         return this._field;
      }
      
      public function set direction(param1:Point) : void
      {
         this.paopao.direction = param1;
         this.fitSize(this.field);
      }
      
      public function set directionX(param1:Number) : void
      {
         this.direction = new Point(param1,this.paopao.direction.y);
      }
      
      public function set directionY(param1:Number) : void
      {
         this.direction = new Point(this.paopao.direction.x,param1);
      }
      
      protected function get paopao() : ChatBallBackground
      {
         return this._chatballBackground;
      }
      
      protected function fitSize(param1:MovieClip) : void
      {
         this.paopao.fitSize(new Point(param1.width,param1.height));
         param1.x = this.paopao.textArea.x;
         param1.y = this.paopao.textArea.y;
         if(this.paopao.textArea.width / param1.width > this.paopao.textArea.height / param1.height)
         {
            param1.x = this.paopao.textArea.x + (this.paopao.textArea.width - param1.width) / 2;
         }
         else
         {
            param1.y = this.paopao.textArea.y + (this.paopao.textArea.height - param1.height) / 2;
         }
         addChild(param1);
      }
      
      protected function beginPopDelay() : void
      {
         this._popupTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer,false,0,true);
         this._popupTimer.reset();
         this._popupTimer.start();
      }
      
      protected function __onPopupTimer(param1:TimerEvent) : void
      {
         this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
         this._popupTimer.stop();
         this.hide();
      }
      
      public function hide() : void
      {
         visible = false;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function show() : void
      {
         visible = true;
      }
      
      public function clear() : void
      {
         this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
         this._popupTimer.stop();
      }
      
      public function dispose() : void
      {
         if(this._popupTimer)
         {
            this._popupTimer.stop();
            this._popupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onPopupTimer);
            this._popupTimer = null;
         }
         if(this.paopao && this.paopao.parent)
         {
            this.removeChild(this.paopao);
         }
         if(this._field)
         {
            this._field.dispose();
         }
         this._field = null;
         if(this._chatballBackground)
         {
            this._chatballBackground.dispose();
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
