package equipretrieve.effect
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class AnimationControl extends EventDispatcher
   {
       
      
      private var _movieArr:Array;
      
      private var _movieokNum:int = 0;
      
      private var _movieokTotal:int = 0;
      
      public function AnimationControl(param1:IEventDispatcher = null)
      {
         this._movieArr = new Array();
         super(param1);
      }
      
      public function addMovies(param1:EventDispatcher) : void
      {
         this._movieArr.push(param1);
      }
      
      public function startMovie() : void
      {
         this._movieokTotal = this._movieArr.length;
         var _loc1_:int = 0;
         while(_loc1_ < this._movieokTotal)
         {
            this._movieArr[_loc1_].movieStart();
            this._movieArr[_loc1_].addEventListener(Event.COMPLETE,this._movieArrComplete);
            _loc1_++;
         }
      }
      
      private function _movieArrComplete(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.COMPLETE,this._movieArrComplete);
         this._movieokNum += 1;
         if(this._movieokNum == this._movieokTotal)
         {
            this._movieArr = null;
            this._movieokNum = 0;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}
