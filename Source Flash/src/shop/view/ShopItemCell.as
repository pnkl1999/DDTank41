package shop.view
{
   import bagAndInfo.cell.BaseCell;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ShopItemCell extends BaseCell
   {
       
      
      private var _shopItemInfo:ShopCarItemInfo;
      
      protected var _cellSize:uint = 70;
      
      public function ShopItemCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(param1:ShopCarItemInfo) : void
      {
         this._shopItemInfo = param1;
      }
      
      public function set cellSize(param1:uint) : void
      {
         this._cellSize = param1;
         this.updateSize(_pic);
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         var _loc2_:Number = NaN;
         PositionUtils.setPos(param1,"shop.ItemCellStartPos");
         if(param1.height >= this._cellSize && this._cellSize >= param1.width || param1.height >= param1.width && param1.width >= this._cellSize || this._cellSize >= param1.height && param1.height >= param1.width)
         {
            _loc2_ = param1.height / this._cellSize;
         }
         else
         {
            _loc2_ = param1.width / this._cellSize;
         }
         param1.height /= _loc2_;
         param1.width /= _loc2_;
         param1.x += (this._cellSize - param1.width) / 2;
         param1.y += (this._cellSize - param1.height) / 2;
      }
      
      override protected function createLoading() : void
      {
         super.createLoading();
         this.updateSize(_loadingasset);
      }
      
      override public function dispose() : void
      {
         this._shopItemInfo = null;
         super.dispose();
      }
   }
}
