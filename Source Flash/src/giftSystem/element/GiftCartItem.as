package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import shop.view.ShopItemCell;
   
   public class GiftCartItem extends Sprite implements Disposeable
   {
       
      
      private var _BG:Bitmap;
      
      private var _itemCell:ShopItemCell;
      
      private var _name:FilterFrameText;
      
      private var _info:ShopItemInfo;
      
      private var _chooseNum:ChooseNum;
      
      public function GiftCartItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.shop.CartItem11");
         this._name = ComponentFactory.Instance.creatComponentByStylename("GiftCartItem.name");
         this._chooseNum = ComponentFactory.Instance.creatCustomObject("chooseNum");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,48,48);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 47;
         PositionUtils.setPos(this._itemCell,"GiftCartItem.cellPos");
         addChild(this._BG);
         addChild(this._itemCell);
         addChild(this._name);
         addChild(this._chooseNum);
      }
      
      public function get number() : int
      {
         return this._chooseNum.number;
      }
      
      public function set info(param1:ShopItemInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         this.upView();
      }
      
      private function upView() : void
      {
         this._itemCell.info = this._info.TemplateInfo;
         this._name.text = this._info.TemplateInfo.Name;
      }
      
      private function initEvent() : void
      {
         this._chooseNum.addEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
      }
      
      private function __numberChange(param1:Event) : void
      {
         dispatchEvent(new Event(ChooseNum.NUMBER_IS_CHANGE));
      }
      
      private function removeEvent() : void
      {
         this._chooseNum.removeEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._itemCell)
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._chooseNum)
         {
            ObjectUtils.disposeObject(this._chooseNum);
         }
         this._chooseNum = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
