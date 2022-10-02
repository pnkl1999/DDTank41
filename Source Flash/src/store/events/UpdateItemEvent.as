package store.events
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class UpdateItemEvent extends Event
   {
      
      public static const UPDATEITEMEVENT:String = "updateItemEvent";
       
      
      public var pos:int;
      
      public var item:InventoryItemInfo;
      
      public function UpdateItemEvent(param1:String, param2:int, param3:InventoryItemInfo, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.pos = param2;
         this.item = param3;
      }
   }
}
