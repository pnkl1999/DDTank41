package ddt.events
{
   import flash.events.Event;
   
   public class StartupEvent extends Event
   {
      
      public static const CORE_LOAD_COMPLETE:String = "coreUILoadComplete";
      
      public static const CORE_SETUP_COMPLETE:String = "coreSetupLoadComplete";
      
      public static const ROLE_DATE_COMPLETE:String = "roleDataComplete";
       
      
      public function StartupEvent(param1:String)
      {
         super(param1);
      }
   }
}
