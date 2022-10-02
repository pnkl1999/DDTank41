package ddt.events
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class PlayerPropertyEvent extends Event
   {
      
      public static const PROPERTY_CHANGE:String = "propertychange";
       
      
      private var _changedProperties:Dictionary;
      
      private var _lastValue:Dictionary;
      
      public function PlayerPropertyEvent(param1:String, param2:Dictionary, param3:Dictionary = null)
      {
         this._changedProperties = param2;
         this._lastValue = param3;
         super(param1);
      }
      
      public function get changedProperties() : Dictionary
      {
         return this._changedProperties;
      }
      
      public function get lastValue() : Dictionary
      {
         return this._lastValue;
      }
   }
}
