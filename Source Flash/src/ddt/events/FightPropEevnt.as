package ddt.events
{
   import flash.events.Event;
   
   public class FightPropEevnt extends Event
   {
      
      public static const MODECHANGED:String = "mode_Changed";
      
      public static const USEPROP:String = "use";
      
      public static const DELETEPROP:String = "delete";
      
      public static const ENABLEDCHANGED:String = "enabled_Changed";
       
      
      public function FightPropEevnt(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
