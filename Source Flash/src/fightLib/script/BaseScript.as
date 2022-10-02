package fightLib.script
{
   import fightLib.FightLibCommandEvent;
   import fightLib.IFightLibCommand;
   import fightLib.command.BaseFightLibCommand;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BaseScript extends EventDispatcher
   {
       
      
      protected var _type:int;
      
      protected var _commonds:Array;
      
      protected var _index:int;
      
      protected var _initialized:Boolean;
      
      protected var _isPaused:Boolean;
      
      protected var _currentCommand:IFightLibCommand;
      
      protected var _host:Object;
      
      private var _hasRestarted:Boolean;
      
      public function BaseScript(param1:Object)
      {
         super();
         this._host = param1;
         this._initialized = false;
         this._commonds = new Array();
         this.initializeScript();
      }
      
      protected function initializeScript() : void
      {
         this._initialized = true;
      }
      
      public function start() : void
      {
         if(this._initialized)
         {
            this.initEvents();
            this._index = 0;
            this.next();
            return;
         }
         throw new Error("在脚本初始化前调用脚本");
      }
      
      public function restart() : void
      {
         var _loc1_:IFightLibCommand = null;
         for each(_loc1_ in this._commonds)
         {
            _loc1_.undo();
         }
         this.removeEvents();
         this._isPaused = false;
         this._currentCommand = null;
         this.start();
         this._hasRestarted = true;
      }
      
      public function next() : void
      {
         if(this._index < this._commonds.length)
         {
            this._commonds[this._index++].excute();
         }
         else
         {
            this.finish();
         }
      }
      
      private function initEvents() : void
      {
         var _loc1_:IFightLibCommand = null;
         for each(_loc1_ in this._commonds)
         {
            _loc1_.addEventListener(FightLibCommandEvent.FINISH,this.__finishHandler);
            _loc1_.addEventListener(FightLibCommandEvent.WAIT,this.__waitHandler);
         }
      }
      
      private function removeEvents() : void
      {
         var _loc1_:IFightLibCommand = null;
         for each(_loc1_ in this._commonds)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.__finishHandler);
            _loc1_.removeEventListener(Event.DEACTIVATE,this.__waitHandler);
         }
      }
      
      protected function __finishHandler(param1:Event) : void
      {
         if(!this._isPaused)
         {
            this.next();
         }
      }
      
      protected function __waitHandler(param1:Event) : void
      {
         this.pause();
      }
      
      public function finish() : void
      {
         this._index = 0;
         this.removeEvents();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function pause() : void
      {
         this._isPaused = true;
         this._currentCommand = this._commonds[this._index - 1];
      }
      
      public function continueScript() : void
      {
         this._isPaused = false;
         if(this._currentCommand)
         {
            this._currentCommand.finish();
         }
      }
      
      public function get hasRestarted() : Boolean
      {
         return this._hasRestarted;
      }
      
      public function dispose() : void
      {
         var _loc1_:BaseFightLibCommand = null;
         this._host = null;
         for each(_loc1_ in this._commonds)
         {
            _loc1_.dispose();
         }
         this._commonds = null;
         this._currentCommand = null;
      }
   }
}
