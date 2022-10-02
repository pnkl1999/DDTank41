package game.view.control
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import game.model.LocalPlayer;
   
   public class FightControlBar implements Disposeable
   {
      
      public static const LIVE:int = 0;
      
      public static const SOUL:int = 1;
       
      
      private var _statePool:Object;
      
      private var _self:LocalPlayer;
      
      private var _state:int;
      
      private var _container:DisplayObjectContainer;
      
      private var _current:ControlState;
      
      private var _next:ControlState;
      
      public function FightControlBar(param1:LocalPlayer, param2:DisplayObjectContainer)
      {
         this._statePool = new Object();
         this._self = param1;
         this._container = param2;
         this.configUI();
         this.addEvent();
         super();
      }
      
      private static function getFightControlState(param1:int, param2:LocalPlayer) : ControlState
      {
         switch(param1)
         {
            case LIVE:
               return new LiveState(param2);
            case SOUL:
               return new SoulState(param2);
            default:
               return null;
         }
      }
      
      private function configUI() : void
      {
      }
      
      private function addEvent() : void
      {
      }
      
      private function __die(param1:LivingEvent) : void
      {
         this.setState(SOUL);
      }
      
      private function removeEvent() : void
      {
      }
      
      public function setState(param1:int) : ControlState
      {
         var _loc2_:ControlState = null;
         if(!this.hasState(param1))
         {
            _loc2_ = getFightControlState(param1,this._self);
            this._statePool[String(param1)] = this._next = _loc2_;
         }
         else
         {
            this._next = this._statePool[String(param1)];
         }
         if(this._current != null)
         {
            this._current.leaving(this.leavingComplete);
         }
         else
         {
            this.enterNext(this._next);
         }
         return this._current;
      }
      
      private function hasState(param1:int) : Boolean
      {
         return this._statePool.hasOwnProperty(String(param1));
      }
      
      private function enterNext(param1:ControlState) : void
      {
         this._current = param1;
         this._current.enter(this._container);
         this._next = null;
      }
      
      private function __stateClicked(param1:MouseEvent) : void
      {
         this.setState(SOUL);
      }
      
      private function leavingComplete() : void
      {
         this.enterNext(this._next);
      }
      
      private function enterComplete() : void
      {
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         for(_loc1_ in this._statePool)
         {
            ObjectUtils.disposeObject(this._statePool[_loc1_]);
            delete this._statePool[_loc1_];
         }
      }
   }
}
