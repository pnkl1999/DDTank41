package ddt.events
{
   import flash.events.Event;
   
   public class GoodsEvent extends Event
   {
      
      public static const PROPERTY_CHANGE:String = "propertyChange";
       
      
      public var property:String = "";
      
      public var value:*;
      
      public function GoodsEvent(param1:String, param2:String = "", param3:* = null, param4:Boolean = false, param5:Boolean = false)
      {
         this.property = param2;
         this.value = param3;
         super(param1,param4,param5);
      }
   }
}
