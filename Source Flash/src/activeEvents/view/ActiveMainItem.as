package activeEvents.view
{
   import activeEvents.ActiveConductEvent;
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActiveMainItem extends Sprite implements Disposeable
   {
       
      
      private var _info:ActiveEventsInfo;
      
      private var _isSelect:Boolean = false;
      
      private var _itemBg:Bitmap;
      
      private var _iconHot:Bitmap;
      
      private var _iconNew:Bitmap;
      
      private var _text:FilterFrameText;
      
      public function ActiveMainItem()
      {
         super();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this.removeEvent();
         this._info = null;
         this._itemBg = null;
         this._text = null;
         this._iconNew = null;
         this._iconHot = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get info() : ActiveEventsInfo
      {
         return this._info;
      }
      
      public function set info(param1:ActiveEventsInfo) : void
      {
         this._info = param1;
         this.init();
         this.setText();
      }
      
      public function set selectState(param1:Boolean) : void
      {
         this._itemBg.visible = param1;
         this._isSelect = param1;
         this.setText();
      }
      
      public function setText() : void
      {
         if(!this._info)
         {
            return;
         }
         this._text.text = this._info.Title;
         if(this._isSelect)
         {
            this._text.setFrame(2);
         }
         else
         {
            this._text.setFrame(1);
         }
         this.updatIconPos();
      }
      
      private function updatIconPos() : void
      {
         if(this._text.width < 190)
         {
            this._iconHot.x = this._iconNew.x = this._text.x + this._text.width;
            this._iconHot.y = this._text.y - 5;
            this._iconNew.y = this._iconHot.y + 10;
         }
         else
         {
            this._iconHot.x = this._iconNew.x = this._text.width / 2 - 30;
            this._iconHot.y = this._text.y + this._text.height / 2;
            this._iconNew.y = this._iconHot.y + 10;
         }
      }
      
      private function _mouseClickHd(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._itemBg.visible = true;
         this._isSelect = true;
         this._text.setFrame(2);
         this.updatIconPos();
         dispatchEvent(new ActiveConductEvent(ActiveConductEvent.ONLINK,this._info));
      }
      
      private function _mouseOutHd(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            this._itemBg.visible = false;
            this._text.setFrame(1);
            this.updatIconPos();
            this.setText();
         }
      }
      
      private function _mouseOverHd(param1:MouseEvent) : void
      {
         this._itemBg.visible = true;
         this._text.setFrame(2);
         this.updatIconPos();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this._mouseOverHd);
         addEventListener(MouseEvent.MOUSE_OUT,this._mouseOutHd);
         addEventListener(MouseEvent.CLICK,this._mouseClickHd);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._mouseOverHd);
         removeEventListener(MouseEvent.MOUSE_OUT,this._mouseOutHd);
         removeEventListener(MouseEvent.CLICK,this._mouseClickHd);
      }
      
      private function init() : void
      {
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,270,40);
         graphics.endFill();
         buttonMode = true;
         this._itemBg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.btnBg");
         this._itemBg.visible = false;
         addChild(this._itemBg);
         this._iconHot = ComponentFactory.Instance.creatBitmap("asset.activeEvents.iconHot");
         addChild(this._iconHot);
         this._iconNew = ComponentFactory.Instance.creatBitmap("asset.activeEvents.iconNew");
         addChild(this._iconNew);
         this._text = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeTitleText");
         addChild(this._text);
         this.addEvent();
         if(this._info.Type == 1)
         {
            this._iconNew.visible = false;
            this._iconHot.visible = true;
         }
         else if(this._info.Type == 2)
         {
            this._iconNew.visible = true;
            this._iconHot.visible = false;
         }
         else
         {
            this._iconHot.visible = false;
            this._iconNew.visible = false;
         }
      }
   }
}
