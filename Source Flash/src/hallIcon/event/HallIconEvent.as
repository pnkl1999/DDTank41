package hallIcon.event
{
   import flash.events.Event;
   
   public class HallIconEvent extends Event
   {
      
      public static const UPDATE_LEFTICON_VIEW:String = "updateLeftIconView";
      
      public static const UPDATE_RIGHTICON_VIEW:String = "updateRightIconView";
      
      public static const UPDATE_BATCH_RIGHTICON_VIEW:String = "updateBatchRightIconView";
      
      public static const CHECK_HALLICONEXPERIENCEOPEN:String = "checkHallIconExperienceOpen";
       
      
      public var data:Object;
      
      public function HallIconEvent(type:String, $data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = $data;
      }
   }
}
