package equipretrieve.effect
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filters.GlowFilter;
   
   public dynamic class GlowFilterAnimation extends EventDispatcher
   {
       
      
      private var _blurFilter:GlowFilter;
      
      private var _view:DisplayObject;
      
      private var _movieArr:Array;
      
      private var _nowMovieID:int = 0;
      
      private var _overHasFilter:Boolean;
      
      public function GlowFilterAnimation(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function start(param1:DisplayObject, param2:Boolean = false, param3:uint = 16711680, param4:Number = 1.0, param5:Number = 6.0, param6:Number = 6.0, param7:Number = 2, param8:int = 1, param9:Boolean = false, param10:Boolean = false) : void
      {
         this._movieArr = new Array();
         this._blurFilter = new GlowFilter(param3,param4,param5,param6,param7,param8,param9,param10);
         this._view = param1;
         this._overHasFilter = param2;
      }
      
      public function addMovie(param1:Number, param2:Number, param3:int, param4:int = 2) : void
      {
         var _loc5_:Object = new Object();
         _loc5_.blurX = param1;
         _loc5_.blurY = param2;
         _loc5_.strength = param4;
         _loc5_.time = param3;
         _loc5_.blurSpeedX = 0;
         _loc5_.blurSpeedY = 0;
         this._movieArr.push(_loc5_);
      }
      
      public function movieStart() : void
      {
         if(this._movieArr == null || this._movieArr.length < 1 || this._view == null)
         {
            return;
         }
         this._nowMovieID = 0;
         this._refeshSpeed();
         this._view.addEventListener(Event.ENTER_FRAME,this._inframe);
      }
      
      private function _inframe(param1:Event) : void
      {
         this._blurFilter.blurX += this._movieArr[this._nowMovieID].blurSpeedX;
         this._blurFilter.blurY += this._movieArr[this._nowMovieID].blurSpeedY;
         this._view.filters = [this._blurFilter];
         this._movieArr[this._nowMovieID].time -= 1;
         if(this._movieArr[this._nowMovieID].time == 0)
         {
            if(this._nowMovieID < this._movieArr.length - 1)
            {
               this._nowMovieID += 1;
               this._refeshSpeed();
            }
            else
            {
               this._view.removeEventListener(Event.ENTER_FRAME,this._inframe);
               this._movieOver();
            }
         }
      }
      
      private function _refeshSpeed() : void
      {
         this._movieArr[this._nowMovieID].blurSpeedX = (this._movieArr[this._nowMovieID].blurX - this._blurFilter.blurX) / this._movieArr[this._nowMovieID].time;
         this._movieArr[this._nowMovieID].blurSpeedY = (this._movieArr[this._nowMovieID].blurY - this._blurFilter.blurY) / this._movieArr[this._nowMovieID].time;
      }
      
      private function _movieOver() : void
      {
         if(this._overHasFilter == false)
         {
            this._view.filters = null;
         }
         this._blurFilter = null;
         this._view = null;
         this._movieArr = null;
         this._nowMovieID = 0;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
