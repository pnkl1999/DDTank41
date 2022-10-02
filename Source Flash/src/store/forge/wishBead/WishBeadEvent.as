package store.forge.wishBead
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class WishBeadEvent extends Event
   {
       
      
      public var info:InventoryItemInfo;
      
      public var moveType:int;
      
      public function WishBeadEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
