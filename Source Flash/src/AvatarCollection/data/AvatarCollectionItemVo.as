package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   
   public class AvatarCollectionItemVo
   {
       
      
      public var id:int;
      
      public var itemId:int;
      
      public var sex:int;
      
      public var proArea:String;
      
      public var needGold:int;
      
      public var isActivity:Boolean;
      
      public var buyPrice:int = -1;
      
      public var isDiscount:int = -1;
      
      public var goodsId:int = -1;
      
      private var _canBuyStatus:int = -1;
      
      public function AvatarCollectionItemVo()
      {
         super();
      }
      
      public function get isHas() : Boolean
      {
         var _loc1_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.EQUIPBAG);
         return Boolean(_loc1_.getItemByTemplateId(this.itemId));
      }
      
      public function get itemInfo() : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(this.itemId);
      }
      
      public function get canBuyStatus() : int
      {
         var _loc1_:ShopItemInfo = null;
         if(this._canBuyStatus == -1)
         {
            _loc1_ = AvatarCollectionManager.instance.getShopItemInfoByItemId(this.itemId,this.sex);
            if(_loc1_)
            {
               this._canBuyStatus = 1;
               this.buyPrice = _loc1_.getItemPrice(1).moneyValue;
               this.isDiscount = _loc1_.isDiscount;
               this.goodsId = _loc1_.GoodsID;
            }
            else
            {
               this._canBuyStatus = 0;
            }
         }
         return this._canBuyStatus;
      }
      
      public function set canBuyStatus(param1:int) : void
      {
         this._canBuyStatus = param1;
      }
   }
}
