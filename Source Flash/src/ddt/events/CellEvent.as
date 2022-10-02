package ddt.events
{
   import flash.events.Event;
   
   public class CellEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "itemclick";
      
      public static const DOUBLE_CLICK:String = "doubleclick";
      
      public static const LOCK_CHANGED:String = "lockChanged";
      
      public static const DRAGSTART:String = "dragStart";
      
      public static const DRAGSTOP:String = "dragStop";
      
      public static const BAG_CLOSE:String = "bagClose";
       
      
      public var data:Object;
      
      public var ctrlKey:Boolean;
      
      public function CellEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         this.data = param2;
         this.ctrlKey = param5;
         super(param1,param3,param4);
      }
   }
}
