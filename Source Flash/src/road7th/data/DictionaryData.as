package road7th.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   [Event(name="add",type="DictionaryEvent")]
   [Event(name="update",type="DictionaryEvent")]
   [Event(name="remove",type="DictionaryEvent")]
   [Event(name="clear",type="DictionaryEvent")]
   public dynamic class DictionaryData extends Dictionary implements IEventDispatcher
   {
       
      
      private var _dispatcher:EventDispatcher;
      
      private var _array:Array;
      
      private var _fName:String;
      
      private var _value:Object;
      
      public function DictionaryData(param1:Boolean = false)
      {
         super(param1);
         this._dispatcher = new EventDispatcher(this);
         this._array = [];
      }
      
      public function get length() : int
      {
         return this._array.length;
      }
      
      public function get list() : Array
      {
         return this._array;
      }
      
      public function filter(param1:String, param2:Object) : Array
      {
         this._fName = param1;
         this._value = param2;
         return this._array.filter(this.filterCallBack);
      }
      
      private function filterCallBack(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1[this._fName] == this._value;
      }
      
      public function add(param1:*, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(this[param1] == null)
         {
            this[param1] = param2;
            this._array.push(param2);
            this.dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,param2));
         }
         else
         {
            _loc3_ = this[param1];
            this[param1] = param2;
            _loc4_ = this._array.indexOf(_loc3_);
            if(_loc4_ > -1)
            {
               this._array.splice(_loc4_,1);
            }
            this._array.push(param2);
            this.dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,param2));
         }
      }
      
      public function hasKey(param1:*) : Boolean
      {
         return this[param1] != null;
      }
      
      public function remove(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = this[param1];
         if(_loc2_ != null)
         {
            this[param1] = null;
            delete this[param1];
            _loc3_ = this._array.indexOf(_loc2_);
            if(_loc3_ > -1)
            {
               this._array.splice(_loc3_,1);
            }
            this.dispatchEvent(new DictionaryEvent(DictionaryEvent.REMOVE,_loc2_));
         }
      }
      
      public function setData(param1:DictionaryData) : void
      {
         var _loc2_:* = null;
         this.cleardata();
         for(_loc2_ in param1)
         {
            this[_loc2_] = param1[_loc2_];
            this._array.push(param1[_loc2_]);
         }
      }
      
      public function clear() : void
      {
         this.cleardata();
         this.dispatchEvent(new DictionaryEvent(DictionaryEvent.CLEAR));
      }
      
      public function slice(param1:int = 0, param2:int = 166777215) : Array
      {
         return this._array.slice(param1,param2);
      }
      
      public function concat(param1:Array) : Array
      {
         return this._array.concat(param1);
      }
      
      private function cleardata() : void
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in this)
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc3_ in _loc1_)
         {
            this[_loc3_] = null;
            delete this[_loc3_];
         }
         this._array = [];
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._dispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._dispatcher.willTrigger(param1);
      }
   }
}
