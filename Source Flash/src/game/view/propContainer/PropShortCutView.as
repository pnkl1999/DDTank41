package game.view.propContainer
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PropShortCutView extends Sprite
   {
       
      
      private var _btn0:SimpleBitmapButton;
      
      private var _btn1:SimpleBitmapButton;
      
      private var _btn2:SimpleBitmapButton;
      
      private var _index:int;
      
      public function PropShortCutView()
      {
         super();
         this._btn0 = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn1");
         addChild(this._btn0);
         this._btn1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn2");
         addChild(this._btn1);
         this._btn2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn3");
         addChild(this._btn2);
         this.addEvent();
         this.setPropCloseVisible(0,false);
         this.setPropCloseVisible(1,false);
         this.setPropCloseVisible(2,false);
      }
      
      public function setPropCloseVisible(param1:uint, param2:Boolean) : void
      {
         this["_btn" + param1.toString()].alpha = !!param2 ? 1 : 0;
      }
      
      public function setPropCloseEnabled(param1:uint, param2:Boolean) : void
      {
         this["_btn" + param1.toString()].mouseEnabled = param2;
      }
      
      private function addEvent() : void
      {
         this._btn0.addEventListener(MouseEvent.CLICK,this.__throw);
         this._btn1.addEventListener(MouseEvent.CLICK,this.__throw);
         this._btn2.addEventListener(MouseEvent.CLICK,this.__throw);
         this._btn0.addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn1.addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn2.addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn0.addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._btn1.addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._btn2.addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      private function removeEvent() : void
      {
         this._btn0.removeEventListener(MouseEvent.CLICK,this.__throw);
         this._btn1.removeEventListener(MouseEvent.CLICK,this.__throw);
         this._btn2.removeEventListener(MouseEvent.CLICK,this.__throw);
         this._btn0.removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn1.removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn2.removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         this._btn0.removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._btn1.removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._btn2.removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      private function __throw(param1:MouseEvent) : void
      {
         if((param1.target as SimpleBitmapButton).alpha == 0)
         {
            return;
         }
         switch(param1.target)
         {
            case this._btn0:
               this._index = 0;
               break;
            case this._btn1:
               this._index = 1;
               break;
            case this._btn2:
               this._index = 2;
         }
         SoundManager.instance.play("008");
         this.deleteProp();
      }
      
      private function deleteProp() : void
      {
         GameInSocketOut.sendThrowProp(this._index);
         SoundManager.instance.play("008");
         stage.focus = null;
      }
      
      private function __over(param1:MouseEvent) : void
      {
         (param1.target as SimpleBitmapButton).alpha = 1;
      }
      
      private function __out(param1:MouseEvent) : void
      {
         (param1.target as SimpleBitmapButton).alpha = 0;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._btn0.dispose();
         this._btn0 = null;
         this._btn1.dispose();
         this._btn1 = null;
         this._btn2.dispose();
         this._btn2 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
