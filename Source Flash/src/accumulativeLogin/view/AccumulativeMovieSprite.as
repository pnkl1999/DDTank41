package accumulativeLogin.view
{
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AccumulativeMovieSprite extends Sprite implements ITipedDisplay, Disposeable
   {
       
      
      private var _state:int;
      
      private var _movieClip:MovieClip;
      
      private var _tipData:Object;
      
      private var _tipDirection:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _data:AccumulativeLoginRewardData;
      
      public function AccumulativeMovieSprite(param1:String)
      {
         super();
         this.tipStyle = "core.GoodsTip";
         this.tipDirctions = "4,1,0,5,2";
         mouseChildren = true;
         mouseEnabled = false;
         buttonMode = true;
         this._movieClip = ComponentFactory.Instance.creat(param1);
         this._movieClip.gotoAndStop(1);
         addChild(this._movieClip);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         removeChild(this._movieClip);
         this._movieClip = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
         this._movieClip.gotoAndStop(this._state);
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function get data() : AccumulativeLoginRewardData
      {
         return this._data;
      }
      
      public function set data(param1:AccumulativeLoginRewardData) : void
      {
         this._data = param1;
      }
   }
}
