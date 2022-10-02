package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class GlowPropButton extends PropButton
   {
       
      
      private var _overGraphics:DisplayObject;
      
      public function GlowPropButton()
      {
         super();
         this.addEvent();
      }
      
      override protected function addChildren() : void
      {
         if(!_back)
         {
            _back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.prop_up");
            addChild(_back);
         }
         if(!this._overGraphics)
         {
            this._overGraphics = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.prop_over");
            this._overGraphics.visible = false;
            addChild(this._overGraphics);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         this._overGraphics.visible = true;
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         this._overGraphics.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._overGraphics)
         {
            ObjectUtils.disposeObject(this._overGraphics);
            this._overGraphics = null;
         }
         super.dispose();
      }
   }
}
