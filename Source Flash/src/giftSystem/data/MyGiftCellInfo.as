package giftSystem.data
{
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   
   public class MyGiftCellInfo
   {
       
      
      public var amount:int = 0;
      
      public var TemplateID:int = 0;
      
      public function MyGiftCellInfo()
      {
         super();
      }
      
      public function get info() : ShopItemInfo
      {
         return ShopManager.Instance.getMoneyShopItemByTemplateIDForGiftSystem(this.TemplateID);
      }
   }
}
