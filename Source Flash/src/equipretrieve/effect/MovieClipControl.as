package equipretrieve.effect
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MovieClipControl extends EventDispatcher
   {
       
      
      private var _movieArr:Array;
      
      private var _evtSprite:Sprite;
      
      private var _total:int;
      
      private var _currentInt:int;
      
      private var _arrInt:int;
      
      public function MovieClipControl(param1:int)
      {
         this._movieArr = new Array();
         this._evtSprite = new Sprite();
         super();
         this._total = param1;
      }
      
      public function addMovies(param1:MovieClip, param2:int, param3:int) : void
      {
         var _loc4_:Object = new Object();
         param1.visible = false;
         param1.stop();
         _loc4_.view = param1;
         _loc4_.goInt = param2;
         _loc4_.totalInt = param3 + param2;
         this._movieArr.push(_loc4_);
      }
      
      public function startMovie() : void
      {
         this._currentInt = 0;
         this._arrInt = this._movieArr.length;
         this._evtSprite.addEventListener(Event.ENTER_FRAME,this._inFrame);
      }
      
      private function _inFrame(param1:Event) : void
      {
         this._currentInt += 1;
         if(this._currentInt >= this._total)
         {
            this._allMovieClipOver();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._arrInt)
         {
            if(this._movieArr[_loc2_].goInt == this._currentInt)
            {
               this._movieArr[_loc2_].view.visible = true;
               this._movieArr[_loc2_].view.play();
            }
            else if(this._movieArr[_loc2_].totalInt == this._currentInt)
            {
               this._movieArr[_loc2_].view.visible = false;
               this._movieArr[_loc2_].view.stop();
            }
            _loc2_++;
         }
      }
      
      private function _allMovieClipOver() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this._evtSprite.removeEventListener(Event.ENTER_FRAME,this._inFrame);
         var _loc1_:int = 0;
         while(_loc1_ < this._arrInt)
         {
            this._movieArr[_loc1_].view.visible = false;
            this._movieArr[_loc1_].view.stop();
            _loc1_++;
         }
         this._removeAllView();
      }
      
      private function _removeAllView() : void
      {
         this._evtSprite = null;
         this._movieArr = null;
      }
   }
}
