package store.events
{
   import ddt.data.goods.ItemTemplateInfo;
   import flash.events.Event;
   
   public class StoreDargEvent extends Event
   {
      
      public static const START_DARG:String = "startDarg";
      
      public static const STOP_DARG:String = "stopDarg";
       
      
      public var sourceInfo:ItemTemplateInfo;
      
      public function StoreDargEvent(param1:ItemTemplateInfo, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         this.sourceInfo = param1;
         super(param2,param3,param4);
      }
   }
}
