package littleGame.menu
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SwitchButton extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _fore:DisplayObject;
      
      public function SwitchButton()
      {
         super();
         buttonMode = true;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = addChild(ComponentFactory.Instance.creatComponentByStylename("littleGame.SwitchButton.back"));
         this._fore = addChild(ComponentFactory.Instance.creatBitmap("asset.littleGame.menu.switchBtn2"));
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOut(event:MouseEvent) : void
      {
         this._fore.visible = false;
      }
      
      private function __mouseOver(event:MouseEvent) : void
      {
         this._fore.visible = true;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function set mode(val:int) : void
      {
         DisplayUtils.setFrame(this._back,val);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._fore);
         this._fore = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
