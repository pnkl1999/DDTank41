package times.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesPicGroup extends Sprite implements Disposeable
   {
       
      
      private var _pics:Vector.<TimesPicBase>;
      
      private var _infos:Vector.<TimesPicInfo>;
      
      private var _currentIdx:int;
      
      private var _maxIdx:int;
      
      private var _picType:String;
      
      private var _timer:Timer;
      
      public function TimesPicGroup(param1:Vector.<TimesPicInfo>)
      {
         super();
         this._infos = param1;
         this.init();
         this.initEvent();
      }
      
      public function init() : void
      {
         this._pics = new Vector.<TimesPicBase>();
         this._timer = new Timer(5000);
         this._maxIdx = this._infos.length;
         var _loc1_:int = 0;
         while(_loc1_ < this._maxIdx)
         {
            this._pics.push(new TimesPicBase(this._infos[_loc1_]));
            this._pics[_loc1_].load();
            _loc1_++;
         }
         addChild(this._pics[this._currentIdx]);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onPicClick);
         if(this._infos && this._infos[0] && this._infos[0].type == TimesPicInfo.BIG)
         {
            addEventListener(MouseEvent.ROLL_OVER,this.__onMouseOver);
            addEventListener(MouseEvent.ROLL_OUT,this.__onMouseOut);
            this._timer.addEventListener(TimerEvent.TIMER,this.__onTick);
            this._timer.start();
         }
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         if(this._timer && !this._timer.running)
         {
            this._timer.start();
         }
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         if(this._timer && this._timer.running)
         {
            this._timer.stop();
         }
      }
      
      private function __onPicClick(param1:MouseEvent) : void
      {
         if(this._infos[this._currentIdx].type == TimesPicInfo.BIG || this._infos[this._currentIdx].type == TimesPicInfo.SMALL)
         {
            TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,this._infos[this._currentIdx]));
         }
      }
      
      private function __onTick(param1:TimerEvent) : void
      {
         if(this._currentIdx == this._maxIdx - 1)
         {
            this.currentIdx = 0;
         }
         else
         {
            ++this.currentIdx;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get currentIdx() : int
      {
         return this._currentIdx;
      }
      
      public function set currentIdx(param1:int) : void
      {
         if(contains(this._pics[this._currentIdx]))
         {
            removeChild(this._pics[this._currentIdx]);
         }
         this._currentIdx = param1;
         this._timer.reset();
         this._timer.start();
         this.load(this._currentIdx);
         addChild(this._pics[this._currentIdx]);
      }
      
      public function get currentInfo() : TimesPicInfo
      {
         return this._infos[this._currentIdx];
      }
      
      public function set picType(param1:String) : void
      {
         this._picType = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._maxIdx)
         {
            this._infos[_loc2_].type = param1;
            _loc2_++;
         }
      }
      
      public function load(param1:int) : void
      {
         this.tryLoad(param1);
         this.tryLoad(param1 + 1);
         this.tryLoad(param1 + 2);
      }
      
      private function tryLoad(param1:int) : void
      {
         if(param1 >= this._pics.length)
         {
            return;
         }
         if(param1 < this._pics.length && this._pics[param1])
         {
            this._pics[param1].load();
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onPicClick);
         if(this._infos && this._infos[0] && this._infos[0].type == TimesPicInfo.BIG)
         {
            removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseOut);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._pics.length)
         {
            ObjectUtils.disposeObject(this._pics[_loc1_]);
            this._pics[_loc1_] = null;
            _loc1_++;
         }
         this._infos = null;
         this._pics = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTick);
            this._timer = null;
         }
      }
   }
}
