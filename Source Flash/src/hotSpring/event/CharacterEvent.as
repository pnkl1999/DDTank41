package hotSpring.event
{
   import flash.events.Event;
   
   public class CharacterEvent extends Event
   {
      
      public static const MOVEMENT:String = "movement";
      
      public static const ARRIVED_NEXT_STEP:String = "arrived next step";
      
      public static const ACTION_CHANGE:String = "action change";
       
      
      public var _object:Object;
      
      public function CharacterEvent(param1:String, param2:Object)
      {
         super(param1);
         this._object = param2;
      }
   }
}
