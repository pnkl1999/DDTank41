package newChickenBox.data
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class NewChickenBoxGoodsTempInfo extends InventoryItemInfo
   {
       
      
      public var Position:int;
      
      public var IsSelected:Boolean;
      
      public var IsSeeded:Boolean;
      
      public var info:ItemTemplateInfo;
      
      public function NewChickenBoxGoodsTempInfo()
      {
         super();
      }
   }
}
