package ddt.manager
{
   import ddt.interfaces.IProcessObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ProcessManager
   {
      
      private static var _ins:ProcessManager;
       
      
      private var _objects:Vector.<IProcessObject>;
      
      private var _startup:Boolean = false;
      
      private var _shape:Shape;
      
      private var _elapsed:int;
      
      private var _virtualTime:int;
      
      public function ProcessManager()
      {
         this._objects = new Vector.<IProcessObject>();
         this._shape = new Shape();
         super();
      }
      
      public static function get Instance() : ProcessManager
      {
         return _ins = _ins || new ProcessManager();
      }
      
      public function addObject(param1:IProcessObject) : IProcessObject
      {
         if(!param1.onProcess)
         {
            param1.onProcess = true;
            this._objects.push(param1);
            this.startup();
         }
         return param1;
      }
      
      public function removeObject(param1:IProcessObject) : IProcessObject
      {
         var _loc2_:int = 0;
         if(param1.onProcess)
         {
            param1.onProcess = false;
            _loc2_ = this._objects.indexOf(param1);
            if(_loc2_ >= 0)
            {
               this._objects.splice(_loc2_,1);
            }
         }
         return param1;
      }
      
      public function startup() : void
      {
         if(!this._startup)
         {
            this._elapsed = getTimer();
            this._shape.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._startup = true;
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc4_:IProcessObject = null;
         var _loc2_:int = getTimer();
         var _loc3_:Number = _loc2_ - this._elapsed;
         for each(_loc4_ in this._objects)
         {
            _loc4_.process(_loc3_);
         }
         this._elapsed = _loc2_;
      }
      
      public function shutdown() : void
      {
         this._shape.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._startup = false;
      }
      
      public function get running() : Boolean
      {
         return this._startup;
      }
   }
}
