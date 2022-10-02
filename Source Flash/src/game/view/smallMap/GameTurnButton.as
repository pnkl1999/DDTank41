package game.view.smallMap
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import road7th.utils.MovieClipWrapper;
   
   public class GameTurnButton extends TextButton
   {
       
      
      private var _turnShine:MovieClipWrapper;
      
      private var _container:DisplayObjectContainer;
      
      public var isFirst:Boolean = true;
      
      public function GameTurnButton(param1:DisplayObjectContainer)
      {
         this._container = param1;
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:MovieClip = null;
         super.init();
         _loc1_ = ComponentFactory.Instance.creat("asset.game.smallmap.TurnShine");
         _loc1_.x = 29;
         _loc1_.y = 9;
         this._turnShine = new MovieClipWrapper(_loc1_);
      }
      
      public function shine() : void
      {
         if(parent == null && this._container)
         {
            this._container.addChild(this);
         }
         if(this._turnShine && this._turnShine.movie)
         {
            addChildAt(this._turnShine.movie,0);
            this._turnShine.addEventListener(Event.COMPLETE,this.__shineComplete);
            this._turnShine.gotoAndPlay(1);
         }
      }
      
      private function __shineComplete(param1:Event) : void
      {
         this._turnShine.removeEventListener(Event.COMPLETE,this.__shineComplete);
         if(this._turnShine.movie.parent)
         {
            this._turnShine.movie.parent.removeChild(this._turnShine.movie);
         }
      }
      
      override public function get width() : Number
      {
         if(_back)
         {
            return _back.width;
         }
         return 60;
      }
      
      override public function dispose() : void
      {
         this._container = null;
         if(this._turnShine)
         {
            this._turnShine.removeEventListener(Event.COMPLETE,this.__shineComplete);
            ObjectUtils.disposeObject(this._turnShine);
            this._turnShine = null;
         }
         super.dispose();
      }
   }
}
