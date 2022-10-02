package church.view.menu
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class MenuItem extends Sprite implements Disposeable
   {
       
      
      private var _textFormat1:TextFormat;
      
      private var _textFormat2:TextFormat;
      
      private var _label:FilterFrameText;
      
      private var _bg:ScaleFrameImage;
      
      protected var _enable:Boolean = false;
      
      public function MenuItem(param1:String = "")
      {
         super();
         this._bg = ComponentFactory.Instance.creat("church.room.listGuestListMenuItemBgAsset");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._label = ComponentFactory.Instance.creat("church.room.listGuestListMenuItemInfoAsset");
         this._label.text = !!Boolean(param1) ? param1 : "";
         addChild(this._label);
         this._textFormat1 = ComponentFactory.Instance.model.getSet("church.textFormat14");
         this._textFormat2 = ComponentFactory.Instance.model.getSet("church.textFormat15");
         mouseChildren = false;
         buttonMode = true;
         useHandCursor = true;
         this.enable = true;
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function __rollOver(param1:MouseEvent) : void
      {
         this._bg.setFrame(2);
      }
      
      private function __rollOut(param1:MouseEvent) : void
      {
         this._bg.setFrame(1);
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(this._enable)
         {
            dispatchEvent(new Event("menuClick"));
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(this._enable != param1)
         {
            this._enable = param1;
            mouseEnabled = param1;
            this._bg.setFrame(1);
            if(param1)
            {
               this._label.setTextFormat(this._textFormat1);
            }
            else
            {
               this._label.setTextFormat(this._textFormat2);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._textFormat1 = null;
         this._textFormat2 = null;
         if(this._label)
         {
            if(this._label.parent)
            {
               this._label.parent.removeChild(this._label);
            }
            this._label.dispose();
         }
         this._label = null;
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
