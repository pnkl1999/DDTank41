package fightLib.command
{
   import fightLib.FightLibCommandEvent;
   import fightLib.IFightLibCommand;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BaseFightLibCommand implements IFightLibCommand
   {
       
      
      protected var _dispather:EventDispatcher;
      
      private var _excuteFunArr:Array;
      
      protected var _completeFunArr:Array;
      
      protected var _prepareFun:Function;
      
      protected var _undoFunArr:Array;
      
      public function BaseFightLibCommand()
      {
         super();
         this._dispather = new EventDispatcher();
         this._excuteFunArr = new Array();
         this._completeFunArr = new Array();
         this._undoFunArr = new Array();
      }
      
      public function set completeFunArr(param1:Array) : void
      {
         this._completeFunArr = param1;
      }
      
      public function get completeFunArr() : Array
      {
         return this._completeFunArr;
      }
      
      public function get prepareFun() : Function
      {
         return this._prepareFun;
      }
      
      public function set prepareFun(param1:Function) : void
      {
         this._prepareFun = param1;
      }
      
      public function excute() : void
      {
         var _loc1_:Function = null;
         for each(_loc1_ in this._excuteFunArr)
         {
            _loc1_();
         }
      }
      
      public function finish() : void
      {
         var _loc1_:Function = null;
         if(this._completeFunArr == null)
         {
            return;
         }
         for each(_loc1_ in this._completeFunArr)
         {
            _loc1_();
         }
         this.dispatchEvent(new FightLibCommandEvent(FightLibCommandEvent.FINISH));
      }
      
      public function undo() : void
      {
         var _loc1_:Function = null;
         for each(_loc1_ in this._undoFunArr)
         {
            _loc1_();
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._dispather.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._dispather.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._dispather.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._dispather.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._dispather.willTrigger(param1);
      }
      
      public function get undoFunArr() : Array
      {
         return this._undoFunArr;
      }
      
      public function set undoFunArr(param1:Array) : void
      {
         this._undoFunArr = param1;
      }
      
      public function dispose() : void
      {
         this._dispather = null;
         this._excuteFunArr = null;
         this._completeFunArr = null;
         this._prepareFun = null;
         this._undoFunArr = null;
      }
      
      public function get excuteFunArr() : Array
      {
         return this._excuteFunArr;
      }
      
      public function set excuteFunArr(param1:Array) : void
      {
         this._excuteFunArr = param1;
      }
   }
}
