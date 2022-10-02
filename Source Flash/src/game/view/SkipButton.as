package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SkipButton extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _back:Bitmap;
      
      private var _shine:Bitmap;
      
      private var _tipData:String;
      
      private var _enabled:Boolean = true;
      
      public function SkipButton()
      {
         super();
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.mark.SkipBack");
         addChild(this._back);
         this._shine = ComponentFactory.Instance.creatBitmap("asset.game.mark.SkipShine");
         buttonMode = true;
         mouseChildren = false;
         this._tipData = LanguageMgr.GetTranslation("tank.game.SelfMark.Skip");
         ShowTipManager.Instance.addTip(this);
         this.addEvent();
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
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(this._enabled)
            {
               filters = null;
            }
            else
            {
               filters = ComponentFactory.Instance.creatFilters("grayFilter");
               if(this._shine.parent)
               {
                  this._shine.parent.removeChild(this._shine);
               }
            }
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._shine.parent)
         {
            this._shine.parent.removeChild(this._shine);
         }
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         if(this._enabled)
         {
            this._shine.x = -3;
            this._shine.y = -3;
            addChild(this._shine);
         }
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         this.removeEvent();
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
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
      }
      
      public function get tipDirctions() : String
      {
         return "7";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 4;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 4;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "ddt.view.tips.OneLineTip";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
   }
}
