package ddt.view.scenePathSearcher
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SceneMTween extends EventDispatcher
   {
      
      public static const FINISH:String = "finish";
      
      public static const CHANGE:String = "change";
      
      public static const START:String = "start";
      
      public static const STOP:String = "stop";
       
      
      private var _obj:DisplayObject;
      
      private var _prop:String;
      
      private var _prop2:String;
      
      private var _isPlaying:Boolean;
      
      private var _finish:Number;
      
      private var _finish2:Number;
      
      private var vectors:Number;
      
      private var vectors2:Number;
      
      private var currentCount:Number;
      
      private var repeatCount:Number;
      
      private var _time:Number;
      
      public function SceneMTween(param1:DisplayObject)
      {
         super();
         this._obj = param1;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this._obj[this._prop] += this.vectors / this.repeatCount;
         if(this._prop2)
         {
            this._obj[this._prop2] += this.vectors2 / this.repeatCount;
         }
         ++this.currentCount;
         if(this.currentCount >= this.repeatCount)
         {
            this.stop();
            this._obj[this._prop] = this._finish;
            if(this._prop2)
            {
               this._obj[this._prop2] = this._finish2;
            }
            dispatchEvent(new Event(FINISH));
         }
         dispatchEvent(new Event(CHANGE));
      }
      
      public function start(param1:Number, param2:String, param3:Number, param4:String = null, param5:Number = 0) : void
      {
         if(this._isPlaying)
         {
            this.stop();
         }
         this._time = param1;
         this._prop = param2;
         this._finish = param3;
         this._finish2 = param5;
         this._prop2 = param4;
         this.currentCount = 0;
         this.vectors = this._finish - this._obj[this._prop];
         if(this._prop2)
         {
            this.vectors2 = this._finish2 - this._obj[this._prop2];
         }
         else
         {
            this._finish2 = 0;
         }
         this.startGo();
      }
      
      public function startGo() : void
      {
         if(this._isPlaying)
         {
            this.stop();
         }
         this.repeatCount = this._time / 1000 * 25;
         this._obj.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._obj.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._isPlaying = true;
         dispatchEvent(new Event(START));
      }
      
      public function stop() : void
      {
         this._obj.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._isPlaying = false;
         dispatchEvent(new Event(STOP));
      }
      
      public function dispose() : void
      {
         this.stop();
         this._obj = null;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function set time(param1:Number) : void
      {
         this._time = param1;
      }
   }
}
