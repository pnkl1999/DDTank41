package shop.view
{
   import bagAndInfo.cell.BaseCell;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import shop.ShopEvent;
   
   public class ShopPlayerCell extends BaseCell
   {
       
      
      private var _shopItemInfo:ShopCarItemInfo;
      
      public function ShopPlayerCell(param1:DisplayObject)
      {
         super(param1);
      }
      
      public function set shopItemInfo(param1:ShopCarItemInfo) : void
      {
         if(param1 == null)
         {
            super.info = null;
         }
         else
         {
            super.info = param1.TemplateInfo;
         }
         this._shopItemInfo = param1;
         locked = false;
         if(param1 is ShopCarItemInfo)
         {
            setColor(ShopCarItemInfo(param1).Color);
         }
         dispatchEvent(new ShopEvent(ShopEvent.ITEMINFO_CHANGE,null,null));
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function setSkinColor(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         if(this.shopItemInfo && EquipType.hasSkin(this.shopItemInfo.CategoryID))
         {
            _loc2_ = this.shopItemInfo.Color.split("|");
            _loc3_ = "";
            if(_loc2_.length > 2)
            {
               _loc3_ = _loc2_[0] + "|" + param1 + "|" + _loc2_[2];
            }
            else
            {
               _loc3_ = _loc2_[0] + "|" + param1 + "|" + _loc2_[1];
            }
            this.shopItemInfo.Color = _loc3_;
            setColor(_loc3_);
         }
      }
      
      override public function dispose() : void
      {
         if(locked)
         {
            if(_info != null && _info is InventoryItemInfo)
            {
               PlayerManager.Instance.Self.Bag.unlockItem(_info as InventoryItemInfo);
            }
            locked = false;
         }
         this._shopItemInfo = null;
         super.dispose();
      }
   }
}
