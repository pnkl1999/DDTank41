package ddt.view.caddyII
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class CaddyEvent extends Event
   {
      
      public static const UPDATE_BADLUCK:String = "update_badLuck";
       
      
      public var point:Point;
      
      public var lastTime:String;
      
      public var info:InventoryItemInfo;
      
      public var itemTemplateInfo:ItemTemplateInfo;
      
      public var dataList:Vector.<Object>;
      
      public function CaddyEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
