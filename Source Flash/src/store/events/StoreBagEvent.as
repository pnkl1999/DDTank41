package store.events
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class StoreBagEvent extends Event
   {
      
      public static const BUYSYMBOL:String = "buySymbol";
      
      public static const STRNGTH_TRAN:String = "strengthTran";
      
      public static const REMOVE:String = "storeBagRemove";
      
      public static const UPDATE:String = "update";
      
      public static const AUTOLINK:String = "autoLink";
       
      
      public var pos:int;
      
      public var data:InventoryItemInfo;
      
      public function StoreBagEvent(param1:String, param2:int, param3:InventoryItemInfo, param4:Boolean = false, param5:Boolean = true)
      {
         super(param1,param4,cancelable);
         this.pos = param2;
         this.data = param3;
      }
   }
}
