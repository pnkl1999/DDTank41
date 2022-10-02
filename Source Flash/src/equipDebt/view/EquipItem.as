package equipDebt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class EquipItem extends Sprite implements Disposeable
   {
       
      
      protected var _bg:Bitmap;
      
      private var _cell:EquipCell;
      
      private var _nameText:TextField;
      
      public function EquipItem()
      {
         super();
         this.setViewOne();
      }
      
      private function setViewOne() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.shop.CartItem");
         this._cell = ComponentFactory.Instance.creatCustomObject("equipDebt.view.EquipCell");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("equipDebt.view._nameText");
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._nameText);
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         this._cell.info = param1;
         this._nameText.text = param1.Name;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._cell.dispose();
         this._bg = null;
         this._cell = null;
         this._nameText = null;
      }
   }
}
