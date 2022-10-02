package ddt.states
{
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.StateManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FadingBlock extends Sprite
   {
       
      
      private var _func:Function;
      
      private var _life:Number;
      
      private var _exected:Boolean;
      
      private var _nextView:BaseStateView;
      
      private var _showLoading:Function;
      
      private var _newStart:Boolean;
      
      private var _showed:Boolean;
      
      private var _canSave:Boolean;
      
      public function FadingBlock(param1:Function, param2:Function)
      {
         super();
         this._func = param1;
         this._showLoading = param2;
         this._life = 0;
         this._newStart = true;
         this._canSave = true;
         graphics.beginFill(0);
         graphics.drawRect(0,0,1008,608);
         graphics.endFill();
      }
      
      public function setNextState(param1:BaseStateView) : void
      {
         this._nextView = param1;
         this._canSave = StateManager.currentStateType != StateType.LOGIN;
      }
      
      public function update() : void
      {
         if(parent == null)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,0,false);
         }
         if(this._newStart)
         {
            if(!StateManager.isShowFadingAnimation)
            {
               this._func();
               if(parent)
               {
                  parent.removeChild(this);
               }
               dispatchEvent(new Event(Event.COMPLETE));
               this._nextView.fadingComplete();
               return;
            }
            alpha = 0;
            this._life = 0;
            this._exected = false;
            this._showed = false;
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
         else
         {
            this._life = 1;
            alpha = this._life;
            this._exected = false;
         }
         this._newStart = false;
      }
      
      public function stopImidily() : void
      {
         parent.removeChild(this);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._newStart = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function set executed(param1:Boolean) : void
      {
         this._exected = param1;
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this._life < 1)
         {
            this._life += 0.16;
            alpha = this._life;
         }
         else if(this._life < 2)
         {
            _loc2_ = getTimer();
            if(this._canSave)
            {
               LoaderSavingManager.saveFilesToLocal();
            }
            _loc2_ = getTimer() - _loc2_;
            _loc3_ = _loc2_ / 40 * 0.1;
            this._life += _loc3_ < 0.1 ? 0.1 : _loc3_;
            if(this._life > 2)
            {
               this._life = 2.01;
            }
            if(!this._exected)
            {
               this._exected = true;
               alpha = 1;
               this._func();
            }
         }
         else if(this._life >= 2)
         {
            this._life += 0.16;
            alpha = 3 - this._life;
            if(alpha < 0.2)
            {
               if(parent)
               {
                  parent.removeChild(this);
               }
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
               this._newStart = true;
               dispatchEvent(new Event(Event.COMPLETE));
               this._nextView.fadingComplete();
            }
         }
      }
   }
}
