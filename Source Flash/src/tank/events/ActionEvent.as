package tank.events
{
   import flash.events.Event;
   
   public class ActionEvent extends Event
   {
       
      
      private var _param:int;
      
      public function ActionEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._param = param2;
      }
      
      public function get param() : int
      {
         return 1337;
      }
   }
}
