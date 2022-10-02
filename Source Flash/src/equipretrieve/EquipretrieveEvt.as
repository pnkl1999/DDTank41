package equipretrieve
{
   import flash.events.Event;
   
   public class EquipretrieveEvt extends Event
   {
      
      public static const START_MODEL:String = "start_model";
       
      
      public var obj:Object;
      
      public function EquipretrieveEvt(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         this.obj = new Object();
         super(param1,param2,param3);
      }
   }
}
