package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IDropListCell;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerState;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PlayerStateItem extends Sprite implements IDropListCell, Disposeable
   {
       
      
      private var _date:PlayerState;
      
      private var _stateID:int;
      
      private var _icon:Bitmap;
      
      private var _overBg:Bitmap;
      
      private var _stateName:FilterFrameText;
      
      private var _selected:Boolean;
      
      public function PlayerStateItem()
      {
         super();
         buttonMode = true;
         this.initView();
      }
      
      private function initView() : void
      {
         graphics.beginFill(16777215,0);
         graphics.drawRect(0,0,80,22);
         graphics.endFill();
         this._overBg = ComponentFactory.Instance.creatBitmap("sset.IM.stateItemOverBgAsset");
         addChild(this._overBg);
         this._overBg.visible = false;
         this._stateName = ComponentFactory.Instance.creatComponentByStylename("IM.stateItem.stateName");
         addChild(this._stateName);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      public function getCellValue() : *
      {
         return this._date;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._date = param1;
         this.update();
      }
      
      private function update() : void
      {
         if(this._icon == null)
         {
            this._icon = this.creatIcon();
            addChild(this._icon);
            this._icon.x = 0;
            this._icon.y = 1;
         }
         this._stateName.text = this._date.convertToString();
      }
      
      private function __out(param1:MouseEvent) : void
      {
         this._overBg.visible = false;
      }
      
      private function __over(param1:MouseEvent) : void
      {
         this._overBg.visible = true;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      private function creatIcon() : Bitmap
      {
         switch(this._date.StateID)
         {
            case PlayerState.ONLINE:
               return ComponentFactory.Instance.creatBitmap("asset.IM.onlineIconAsset");
            case PlayerState.AWAY:
               return ComponentFactory.Instance.creatBitmap("asset.IM.awayIconAsset");
            case PlayerState.BUSY:
               return ComponentFactory.Instance.creatBitmap("asset.IM.busyIconAsset");
            case PlayerState.NO_DISTRUB:
               return ComponentFactory.Instance.creatBitmap("asset.IM.noDistrubIconAsset");
            case PlayerState.SHOPPING:
               return ComponentFactory.Instance.creatBitmap("asset.IM.shoppingIconAsset");
            default:
               return null;
         }
      }
      
      override public function get height() : Number
      {
         return 22;
      }
      
      override public function get width() : Number
      {
         return 80;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = null;
         ObjectUtils.disposeObject(this._stateName);
         this._stateName = null;
         this._date = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
