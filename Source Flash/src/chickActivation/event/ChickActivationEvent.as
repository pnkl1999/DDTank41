package chickActivation.event
{
   import flash.events.Event;
   
   public class ChickActivationEvent extends Event
   {
      
      public static const UPDATE_DATA:String = "updateData";
      
      public static const CLICK_LEVELPACKS:String = "clickLevelPacks";
      
      public static const GET_REWARD:String = "getReward";
       
      
      public var resultData:Object;
      
      public function ChickActivationEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         this.resultData = param2;
         super(param1,param3,param4);
      }
   }
}
