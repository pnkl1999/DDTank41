package cardSystem
{
   import flash.events.Event;
   
   public class CardEvent extends Event
   {
      
      public static const SETSPROP_INIT_COMPLETE:String = "setsPropIntComplete";
      
      public static const PROPLIST_INIT_COMPLETE:String = "propListInitComplete";
      
      public static const SETSSORTRULE_INIT_COMPLETE:String = "setsSortRuleInitComplete";
      
      public static const SELECT_CARDS:String = "select_cards";
       
      
      public var data:Object;
      
      public function CardEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
   }
}
