package store.events
{
   import flash.events.Event;
   
   public class StoreIIEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "itemclick";
      
      public static const UPPREVIEW:String = "upPreview";
      
      public static const EMBED_CLICK:String = "embedClick";
      
      public static const EMBED_INFORCHANGE:String = "embedInfoChange";
      
      public static const TRANSFER_LIGHT:String = "transferLight";
      
      public static const EXALT_FINISH:String = "exaltFinish";
      
      public static const EXALT_FAIL:String = "exaltFail";
       
      
      public var data:Object;
      
      public var bool:Boolean;
      
      public function StoreIIEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         this.data = param2;
         this.bool = param3;
         super(param1,param4,param5);
      }
   }
}
