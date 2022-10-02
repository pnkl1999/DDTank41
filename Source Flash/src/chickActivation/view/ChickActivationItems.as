package chickActivation.view
{
   import bagAndInfo.cell.BagCell;
   import chickActivation.ChickActivationManager;
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Sprite;
   
   public class ChickActivationItems extends Sprite implements Disposeable
   {
       
      
      private var _arrData:Array;
      
      private var _items:Sprite;
      
      private var _itemsPanel:ScrollPanel;
      
      public function ChickActivationItems()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemsPanel = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.itemsScrollPanel");
         addChild(this._itemsPanel);
         this._items = new Sprite();
         this._itemsPanel.setView(this._items);
         this._itemsPanel.invalidateViewport();
      }
      
      public function update(param1:Array) : void
      {
         this._arrData = param1;
         this.updateView();
         this._itemsPanel.invalidateViewport();
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BagCell = null;
         ObjectUtils.disposeAllChildren(this._items);
         if(this._arrData)
         {
            _loc1_ = 0;
            while(_loc1_ < this._arrData.length)
            {
               _loc2_ = this.createCell(this._arrData[_loc1_]);
               _loc2_.x = _loc1_ % 5 * 105;
               _loc2_.y = int(_loc1_ / 5) * 80 + 5;
               this._items.addChild(_loc2_);
               _loc1_++;
            }
         }
      }
      
      private function createCell(param1:ChickActivationInfo) : BagCell
      {
         var _loc2_:InventoryItemInfo = ChickActivationManager.instance.model.getInventoryItemInfo(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:BagCell = new BagCell(0,_loc2_,true,ComponentFactory.Instance.creatBitmap("assets.chickActivation.itemBg"));
         _loc3_.width = 64;
         _loc3_.height = 64.1;
         _loc3_.setCount(_loc2_.Count);
         return _loc3_;
      }
      
      public function get arrData() : Array
      {
         return this._arrData;
      }
      
      public function dispose() : void
      {
         if(this._items)
         {
            ObjectUtils.disposeAllChildren(this._items);
            ObjectUtils.disposeObject(this._items);
            this._items = null;
         }
         ObjectUtils.disposeObject(this._itemsPanel);
         this._itemsPanel = null;
         this._arrData = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
