package character.action
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class BaseAction implements IAction, IEventDispatcher
   {
      
      public static const BASE:int = -1;
      
      public static const SIMPLE_ACTION:int = 0;
      
      public static const COMPLEX_ACTION:int = 1;
      
      public static const MOVIE_ACTION:int = 2;
       
      
      protected var _asset:DisplayObject;
      
      protected var _nextAction:String;
      
      protected var _name:String;
      
      protected var _priority:uint;
      
      protected var _len:int;
      
      protected var _endStop:Boolean;
      
      protected var _sound:String = "";
      
      protected var _type:int;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function BaseAction(name:String = "", nextAction:String = "", priority:uint = 0, endStop:Boolean = false)
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this._type = BASE;
         this._name = name;
         this._nextAction = nextAction;
         this._priority = priority;
         this._endStop = endStop;
      }
      
      public function get len() : int
      {
         return this._len;
      }
      
      public function get isEnd() : Boolean
      {
         return true;
      }
      
      private function set _3373707name(value:String) : void
      {
         this._name = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      private function set _1794985207nextAction(value:String) : void
      {
         this._nextAction = value;
      }
      
      public function get nextAction() : String
      {
         return this._nextAction;
      }
      
      private function set _1165461084priority(value:uint) : void
      {
         this._priority = value;
      }
      
      public function get priority() : uint
      {
         return this._priority;
      }
      
      public function get asset() : DisplayObject
      {
         return this._asset;
      }
      
      public function reset() : void
      {
      }
      
      public function dispose() : void
      {
         this._asset = null;
      }
      
      public function toXml() : XML
      {
         var result:XML = <action/>;
         result.@type = this._type;
         result.@name = this._name;
         result.@next = this._nextAction;
         result.@priority = this._priority;
         result.@endStop = this._endStop;
         result.@sound = this._sound;
         return result;
      }
      
      public function get endStop() : Boolean
      {
         return this._endStop;
      }
      
      private function set _1607262339endStop(value:Boolean) : void
      {
         this._endStop = value;
      }
      
      public function get sound() : String
      {
         return this._sound;
      }
      
      private function set _109627663sound(value:String) : void
      {
         this._sound = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set nextAction(param1:String) : void
      {
         var _loc2_:Object = this.nextAction;
         if(_loc2_ !== param1)
         {
            this._1794985207nextAction = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nextAction",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set sound(param1:String) : void
      {
         var _loc2_:Object = this.sound;
         if(_loc2_ !== param1)
         {
            this._109627663sound = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sound",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set priority(param1:uint) : void
      {
         var _loc2_:Object = this.priority;
         if(_loc2_ !== param1)
         {
            this._1165461084priority = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"priority",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set endStop(param1:Boolean) : void
      {
         var _loc2_:Object = this.endStop;
         if(_loc2_ !== param1)
         {
            this._1607262339endStop = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endStop",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this.name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}
