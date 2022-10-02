package road7th.utils
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="complete",type="flash.events.Event")]
   public class MovieClipWrapper extends EventDispatcher implements Disposeable
   {
       
      
      private var _movie:MovieClip;
      
      public var repeat:Boolean;
      
      private var autoDisappear:Boolean;
      
      private var _isDispose:Boolean = false;
      
      private var _x:int = 0;
      
      private var _y:int = 0;
      
      private var _endFrame:int = -1;
      
      public function MovieClipWrapper(param1:MovieClip, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this._movie = param1;
         this.repeat = param4;
         this.autoDisappear = param3;
         if(!param2)
         {
            this._movie.stop();
            this._movie.addEventListener(Event.ADDED_TO_STAGE,this.__onAddStage);
         }
         else
         {
            this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         }
      }
      
      private function __onAddStage(param1:Event) : void
      {
         this._movie.gotoAndStop(1);
      }
      
      public function set x(param1:int) : void
      {
         this._x = param1;
         if(this.movie)
         {
            this.movie.x = param1;
         }
      }
      
      public function set y(param1:int) : void
      {
         this._y = param1;
         if(this.movie)
         {
            this.movie.y = param1;
         }
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function gotoAndPlay(param1:Object) : void
      {
         this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._movie.gotoAndPlay(param1);
      }
      
      public function gotoAndStop(param1:Object) : void
      {
         this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._movie.gotoAndStop(param1);
      }
      
      public function addFrameScriptAt(param1:Number, param2:Function) : void
      {
         if(param1 == this._movie.framesLoaded)
         {
            throw new Error("You can\'t add scprit at that frame,The MovieClipWrapper used for COMPLETE event!");
         }
         this._movie.addFrameScript(param1,param2);
      }
      
      public function play() : void
      {
         this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._movie.play();
         if(this._movie.framesLoaded <= 1)
         {
            this.stop();
         }
      }
      
      public function get movie() : MovieClip
      {
         return this._movie;
      }
      
      public function stop() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         if(this.autoDisappear)
         {
            this.dispose();
         }
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._movie.currentFrame == this._endFrame || this._movie.currentFrame == this._movie.totalFrames)
         {
            this.__endFrame();
         }
      }
      
      private function __endFrame() : void
      {
         if(this.repeat)
         {
            this._movie.gotoAndPlay(1);
         }
         else
         {
            this.stop();
         }
      }
      
      public function set endFrame(param1:int) : void
      {
         this._endFrame = param1;
      }
      
      public function dispose() : void
      {
         if(!this._isDispose)
         {
            this._movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
            this._movie.removeEventListener(Event.ADDED_TO_STAGE,this.__onAddStage);
            if(this._movie.parent)
            {
               this._movie.parent.removeChild(this._movie);
            }
            this._movie.stop();
            this._movie = null;
            this._isDispose = true;
         }
      }
   }
}
