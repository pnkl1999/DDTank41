package church.view.churchFire
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChurchFireEffectPlayer extends Sprite
   {
      
      public static const FIER_TIMER:int = 3500;
       
      
      private var _fireTemplateID:int;
      
      private var _fireMovie:MovieClip;
      
      private var _playerFramesCount:int = 0;
      
      private var _playerTimer:Timer;
      
      public var owerID:int;
      
      public function ChurchFireEffectPlayer(param1:int)
      {
         this._fireTemplateID = param1;
         this.addFire();
         super();
      }
      
      private function addFire() : void
      {
         var _loc1_:String = "";
         switch(this._fireTemplateID)
         {
            case 21002:
               _loc1_ = "tank.church.fireAcect.FireItemAccect02";
               break;
            case 21006:
               _loc1_ = "tank.church.fireAcect.FireItemAccect06";
         }
         if(!_loc1_ || _loc1_ == "" || _loc1_.length <= 0)
         {
            return;
         }
         var _loc2_:Class = ClassUtils.uiSourceDomain.getDefinition(_loc1_) as Class;
         if(_loc2_)
         {
            this._fireMovie = new _loc2_() as MovieClip;
            if(this._fireMovie)
            {
               addChild(this._fireMovie);
            }
         }
      }
      
      public function firePlayer(param1:Boolean = true) : void
      {
         if(param1)
         {
            SoundManager.instance.play("117");
         }
         if(this._fireMovie)
         {
            this._fireMovie.gotoAndPlay(1);
            this._fireMovie.addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
            this._playerFramesCount = 0;
            this._playerTimer = new Timer(FIER_TIMER,0);
            this._playerTimer.start();
            this._playerTimer.addEventListener(TimerEvent.TIMER,this.timerHander);
         }
         else
         {
            this.removeFire();
         }
      }
      
      public function removeFire() : void
      {
         if(this._fireMovie)
         {
            if(this._fireMovie.parent)
            {
               this._fireMovie.parent.removeChild(this._fireMovie);
            }
            this._fireMovie.removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
            this._fireMovie = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function timerHander(param1:TimerEvent) : void
      {
         if(this._playerTimer)
         {
            this._playerTimer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._playerTimer.stop();
            this._playerTimer = null;
         }
         this.removeFire();
      }
      
      private function enterFrameHander(param1:Event) : void
      {
         ++this._playerFramesCount;
         if(this._playerFramesCount >= this._fireMovie.totalFrames)
         {
            this.removeFire();
         }
      }
      
      public function dispose() : void
      {
         if(this._fireMovie)
         {
            this._fireMovie.removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         }
         this._fireMovie = null;
         if(this._playerTimer)
         {
            this._playerTimer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._playerTimer.stop();
         }
         this._playerTimer = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
