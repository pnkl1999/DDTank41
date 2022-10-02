package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LittleSoundButton extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _state:int = -1;
      
      public function LittleSoundButton()
      {
         super();
         buttonMode = true;
         mouseChildren = false;
         this.configUI();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOut(event:MouseEvent) : void
      {
         filters = null;
      }
      
      private function __mouseOver(event:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("littleGame.SoundBack");
         addChild(this._back);
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(value:int) : void
      {
         if(this._state == value)
         {
            return;
         }
         this._state = value;
         DisplayUtils.setFrame(this._back,this._state);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
   }
}
