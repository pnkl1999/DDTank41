package store.view.strength.vo
{
   import flash.events.EventDispatcher;
   
   public class ItemStrengthenGoodsInfo extends EventDispatcher
   {
       
      
      public var ID:int;
      
      public var CurrentEquip:int;
      
      public var Level:int;
      
      public var GainEquip:int;
      
      public var OriginalEquip:int;
      
      public function ItemStrengthenGoodsInfo()
      {
         super();
      }
   }
}
