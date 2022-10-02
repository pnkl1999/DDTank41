package times.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Circ;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesThumbnailPoint extends Sprite implements ISelectable, ITipedDisplay, Disposeable
   {
      
      public static const THUMBNAIL_POINT_MAIN:int = 0;
      
      public static const THUMBNAIL_POINT_CATEGORY:int = 1;
      
      public static const THUMBNAIL_POINT_NORMAL:int = 2;
       
      
      private var _controller:TimesController;
      
      private var _point:MovieClip;
      
      private var _info:TimesPicInfo;
      
      private var _type:int;
      
      private var _selected:Boolean;
      
      private var _tipData:Object;
      
      private var _tipDirections:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _lineLite:TimelineLite;
      
      public function TimesThumbnailPoint(param1:TimesPicInfo)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._controller = TimesController.Instance;
         buttonMode = true;
         this._point = ComponentFactory.Instance.creat("asset.times.ThumbnailPoint");
         addEventListener(MouseEvent.CLICK,this.__pointClick);
         addEventListener(MouseEvent.ROLL_OVER,this.__overEffect);
         addEventListener(MouseEvent.ROLL_OUT,this.__outEffect);
         addChild(this._point);
         ShowTipManager.Instance.addTip(this);
         mouseChildren = false;
      }
      
      public function pointPlay(param1:Object) : void
      {
         this._point.gotoAndPlay(param1);
      }
      
      public function pointStop(param1:Object) : void
      {
         this._point.gotoAndStop(param1);
      }
      
      private function __overEffect(param1:MouseEvent) : void
      {
         if(this._lineLite == null)
         {
            this._lineLite = new TimelineLite();
            this._lineLite.append(new TweenLite(this,0.2,{
               "x":"-3",
               "y":"-3",
               "scaleX":1.5,
               "scaleY":1.5,
               "ease":Circ.easeOut
            }));
         }
         if(this._selected)
         {
            return;
         }
         this._lineLite.play();
         this.pointPlay("rollOver");
      }
      
      private function __outEffect(param1:MouseEvent) : void
      {
         if(this._selected)
         {
            return;
         }
         this._lineLite.reverse();
         this.pointPlay("rollOut");
      }
      
      private function __pointClick(param1:MouseEvent) : void
      {
         this._controller.dispatchEvent(new TimesEvent(TimesEvent.PLAY_SOUND));
         if(this._info)
         {
            this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,this._info));
         }
         else
         {
            this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_HOME_PAGE));
         }
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         if(this._lineLite == null)
         {
            this._lineLite = new TimelineLite();
            this._lineLite.append(new TweenLite(this,0.2,{
               "x":"-3",
               "y":"-3",
               "scaleX":1.5,
               "scaleY":1.5,
               "ease":Circ.easeOut
            }));
         }
         this._selected = param1;
         if(this._selected)
         {
            this._lineLite.play();
            this.pointStop("selected");
         }
         else
         {
            this._lineLite.reverse();
            this.pointPlay("rollOut");
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function get tipData() : Object
      {
         this._tipData.bitmapDatas = this._controller.thumbnailLoaders;
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirections;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirections = param1;
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
      
      public function dispose() : void
      {
         if(this._lineLite)
         {
            this._lineLite.kill();
         }
         this._lineLite = null;
         removeEventListener(MouseEvent.CLICK,this.__pointClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.__overEffect);
         removeEventListener(MouseEvent.ROLL_OUT,this.__outEffect);
         ShowTipManager.Instance.removeTip(this);
         if(this._point)
         {
            removeChild(this._point);
            this._point = null;
         }
         this._info = null;
         if(this._tipData && this._tipData.bitmapData)
         {
            this._tipData.bitmapData.dispose();
            this._tipData.bitmapData = null;
         }
         this._tipData = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
