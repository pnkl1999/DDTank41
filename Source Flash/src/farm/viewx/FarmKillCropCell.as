package farm.viewx
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FarmKillCropCell extends BaseCell
   {
       
      
      private var _bgbmp:BaseButton;
      
      private var _invInfo:InventoryItemInfo;
      
      private var _killCropIcon:Bitmap;
      
      public function FarmKillCropCell()
      {
         buttonMode = true;
         this._bgbmp = ComponentFactory.Instance.creatComponentByStylename("farm.doKillBtn");
         this._killCropIcon = ComponentFactory.Instance.creatBitmap("assets.farm.killCropImg");
         super(this._bgbmp);
         addEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
         addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function setBtnVis(param1:Boolean) : void
      {
         this._bgbmp.enable = param1;
         if(param1 == false)
         {
            removeEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
            removeEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
            removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
            addEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
            addEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dragStart();
      }
      
      protected function __outFilter(param1:MouseEvent) : void
      {
         filters = null;
         this._bgbmp.x += 15;
      }
      
      protected function __overFilter(param1:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._bgbmp.x -= 15;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._invInfo;
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         super.info = param1;
         this._invInfo = param1;
      }
      
      private function get killCropIcon() : DisplayObject
      {
         return new Bitmap(this._killCropIcon.bitmapData.clone(),"auto",true);
      }
      
      override public function dragStart() : void
      {
         if(stage && _allowDrag)
         {
            if(DragManager.startDrag(this,this._invInfo,this.killCropIcon,stage.mouseX,stage.mouseY,DragEffect.MOVE,false,false,false,false,false,null,0,true))
            {
               locked = true;
            }
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(param1.target is FarmFieldBlock)
         {
            this.dragStart();
         }
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = _contentWidth - 20;
            param1.height = _contentHeight - 20;
            if(_picPos != null)
            {
               param1.x = _picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               param1.y = _picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - _contentHeight) / 2;
            }
         }
      }
      
      override protected function updateSizeII(param1:Sprite) : void
      {
         param1.x = 13;
         param1.y = 10;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
         removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(this._bgbmp)
         {
            ObjectUtils.disposeObject(this._bgbmp);
         }
         this._bgbmp = null;
         if(this._killCropIcon)
         {
            ObjectUtils.disposeObject(this._killCropIcon);
         }
         this._killCropIcon = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
