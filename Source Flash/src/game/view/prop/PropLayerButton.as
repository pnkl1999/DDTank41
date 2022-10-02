package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PropLayerButton extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _background:ScaleFrameImage;
      
      private var _shine:Bitmap;
      
      private var _tipData:String;
      
      private var _mode:int;
      
      private var _mouseOver:Boolean = false;
      
      private var _tipDirction:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function PropLayerButton(param1:int)
      {
         super();
         this._mode = param1;
         this.configUI();
         this.addEvent();
         buttonMode = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._shine && this._shine.parent)
         {
            this._shine.parent.removeChild(this._shine);
         }
         this._mouseOver = false;
      }
      
      public function set enabled(param1:Boolean) : void
      {
      }
      
      public function get enabled() : Boolean
      {
         return true;
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         if(this._shine)
         {
            addChild(this._shine);
         }
         this._mouseOver = true;
      }
      
      private function configUI() : void
      {
         this._background = ComponentFactory.Instance.creatComponentByStylename("asset.game.prop.ModeBack");
         addChild(this._background);
         this.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.proplayer" + this._mode);
         DisplayUtils.setFrame(this._background,this._mode);
         this._shine = ComponentFactory.Instance.creatBitmap("asset.game.prop.ModeShine");
         ShowTipManager.Instance.addTip(this);
         this._shine.y = -3;
         this._shine.x = -3;
      }
      
      public function setMode(param1:int) : void
      {
         this.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.proplayer" + param1);
         DisplayUtils.setFrame(this._background,param1);
         if(this._mouseOver)
         {
            ShowTipManager.Instance.showTip(this);
         }
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         this.removeEvent();
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
         }
         if(this._shine)
         {
            ObjectUtils.disposeObject(this._shine);
            this._shine = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1.toString();
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirction;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirction = param1;
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
   }
}
