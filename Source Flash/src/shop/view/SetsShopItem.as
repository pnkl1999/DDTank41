package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class SetsShopItem extends ShopCartItem
   {
       
      
      private var _checkBox:SelectedCheckButton;
      
      public function SetsShopItem()
      {
         super();
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("SetsShopItemCheckBox");
         this._checkBox.addEventListener(Event.SELECT,this.__selectedChanged);
         addChildAt(this._checkBox,getChildIndex(_bg) + 1);
         _closeBtn.visible = false;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._checkBox.removeEventListener(Event.CHANGE,this.__selectedChanged);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         dispatchEvent(new Event(Event.SELECT));
      }
      
      override protected function drawBackground() : void
      {
         _bg = ComponentFactory.Instance.creatBitmap("asset.shop.SetsCartItemBg");
         addChild(_bg);
      }
      
      override protected function drawCellField() : void
      {
         super.drawCellField();
         PositionUtils.setPos(_cell,"shop.SetsShopCellPoint");
      }
      
      override protected function drawNameField() : void
      {
         _itemName = ComponentFactory.Instance.creatComponentByStylename("shop.SetsShopItemName");
         addChild(_itemName);
      }
      
      public function get selected() : Boolean
      {
         return this._checkBox.selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._checkBox.selected = param1;
      }
   }
}
