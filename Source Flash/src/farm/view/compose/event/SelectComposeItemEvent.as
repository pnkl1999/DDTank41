package farm.view.compose.event
{
   import flash.events.Event;
   
   public class SelectComposeItemEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "itemclick";
      
      public static const COMPOSE_COUNT:String = "compose_count";
      
      public static const KILLCROP_SHOW:String = "killcropshow";
      
      public static const KILLCROP_CLICK:String = "killcropClick";
      
      public static const KILLCROP_ICON:String = "killcropIcon";
      
      public static const SELECT_FOOD:String = "selectFood";
      
      public static const SELECT_SEED:String = "selectSeed";
      
      public static const SELECT_FERTILIZER:String = "selectFertilizer";
      
      public static const SELECT_ALL:String = "selectall";
       
      
      public var data:Object;
      
      public function SelectComposeItemEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
   }
}
