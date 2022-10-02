package littleGame.events
{
   import flash.events.Event;
   
   public class ScheduleEvent extends Event
   {
      
      public static const Complete:String = "complete";
       
      
      private var _paras:Array;
      
      public function ScheduleEvent(type:String, ... arg)
      {
         this._paras = arg;
         super(type);
      }
      
      public function get paras() : Array
      {
         return this._paras;
      }
   }
}
