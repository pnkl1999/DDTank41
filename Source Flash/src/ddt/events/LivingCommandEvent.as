package ddt.events
{
   import flash.events.Event;
   
   public class LivingCommandEvent extends Event
   {
      
      public static const COMMAND:String = "livingCommand";
       
      
      private var _cmdType:String;
      
      private var _cmdObj:Object;
      
      public function LivingCommandEvent(param1:String, param2:Object = null, param3:String = "livingCommand", param4:Boolean = false, param5:Boolean = false)
      {
         super(param3,param4,param5);
         this._cmdType = param1;
         this._cmdObj = param2;
      }
      
      public function get commandType() : String
      {
         return this._cmdType;
      }
      
      public function get object() : Object
      {
         return this._cmdObj;
      }
   }
}
