package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.enthrall.EnthrallView;
   import ddt.view.enthrall.Validate17173;
   import ddt.view.enthrall.ValidateFrame;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class EnthrallManager
   {
      
      private static var _instance:EnthrallManager;
      
      public static var STATE_1:int = 1 * 60;
      
      public static var STATE_2:int = 2 * 60;
      
      public static var STATE_3:int = 3 * 60;
      
      public static var STATE_4:int = 5 * 60;
       
      
      private var _view:EnthrallView;
      
      private var _timer:Timer;
      
      private var _timer1:Timer;
      
      private var _loadedTime:int = 0;
      
      private var _showEnthrallLight:Boolean = false;
      
      private var _popCIDChecker:Boolean = false;
      
      private var _enthrallSwicth:Boolean;
      
      private var _hasApproved:Boolean;
      
      private var _isMinor:Boolean;
      
      private var _interfaceID:int;
      
      private var validateFrame:ValidateFrame;
      
      private var inited:Boolean;
      
      public function EnthrallManager(param1:SingletonEnfocer)
      {
         super();
         this.inited = false;
         this._timer = new Timer(60000);
         this._timer1 = new Timer(1000);
      }
      
      public static function getInstance() : EnthrallManager
      {
         if(_instance == null)
         {
            _instance = new EnthrallManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.inited = true;
         this._view = ComponentFactory.Instance.creat("EnthrallViewSprite");
         this._view.manager = this;
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timer1.addEventListener(TimerEvent.TIMER,this.__timer1Handler);
         this._timer.start();
      }
      
      private function __timerHandler(param1:TimerEvent) : void
      {
         ++this._loadedTime;
         TimeManager.Instance.totalGameTime += 1;
         this.checkState();
      }
      
      private function checkState() : void
      {
         if(this._enthrallSwicth == false)
         {
            return;
         }
         if(TimeManager.Instance.totalGameTime == STATE_1)
         {
            if(this._view.parent)
            {
               this.remind(LanguageMgr.GetTranslation("tank.manager.enthrallRemind1"));
            }
         }
         if(TimeManager.Instance.totalGameTime == STATE_2)
         {
            this.remind(LanguageMgr.GetTranslation("tank.manager.enthrallRemind2"));
         }
         if(TimeManager.Instance.totalGameTime == STATE_3)
         {
            if(this._view.parent)
            {
               this.remind(LanguageMgr.GetTranslation("tank.manager.enthrallRemind3"));
            }
         }
         if(TimeManager.Instance.totalGameTime == STATE_4)
         {
            if(this._view.parent)
            {
               this.remind(LanguageMgr.GetTranslation("tank.manager.enthrallRemind4"));
            }
            else
            {
               this.remind(LanguageMgr.GetTranslation("tank.manager.enthrallRemind5"));
            }
         }
      }
      
      private function remind(param1:String) : void
      {
         ChatManager.Instance.sysChatYellow(param1);
      }
      
      public function updateLight() : void
      {
         this._view.update();
      }
      
      private function __timer1Handler(param1:TimerEvent) : void
      {
         if(!this._popCIDChecker)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            this.showCIDCheckerFrame();
            this._timer1.stop();
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CID_CHECK,this.changeCIDChecker);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTHRALL_LIGHT,this.readStates);
      }
      
      private function changeCIDChecker(param1:CrazyTankSocketEvent) : void
      {
         if(!this.inited)
         {
            this.init();
         }
         var _loc2_:PackageIn = param1.pkg;
         this._popCIDChecker = _loc2_.readBoolean();
         if(this._popCIDChecker)
         {
            this._timer1.start();
         }
         else
         {
            this.closeCIDCheckerFrame();
         }
      }
      
      private function readStates(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._enthrallSwicth = _loc2_.readBoolean();
         this._interfaceID = _loc2_.readInt();
         this._hasApproved = _loc2_.readBoolean();
         this._isMinor = _loc2_.readBoolean();
         this.updateEnthrallView();
      }
      
      public function updateEnthrallView() : void
      {
         if(!this._enthrallSwicth)
         {
            this.hideEnthrallLight();
            return;
         }
         if(this._hasApproved && !this._isMinor)
         {
            this.hideEnthrallLight();
            return;
         }
         if(!this.inited)
         {
            this.init();
         }
         if(this._enthrallSwicth)
         {
            if(this._hasApproved && !this._isMinor)
            {
               this.hideEnthrallLight();
            }
            else
            {
               this.showEnthrallLight();
            }
         }
         else
         {
            this.hideEnthrallLight();
         }
         this._view.changeBtn(false);
         this._view.changeToGameState(false);
         this._view.changeBtn(false);
         switch(StateManager.currentStateType)
         {
            case StateType.MAIN:
               this._view.changeBtn(!this._hasApproved);
               return;
            case StateType.TRAINER:
               this._view.changeToGameState(true);
               return;
            default:
               return;
         }
      }
      
      private function closeCIDCheckerFrame() : void
      {
         this.validateFrame.hide();
      }
      
      public function showCIDCheckerFrame() : void
      {
         if(this.interfaceID != 0)
         {
            LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("EnthrallValidateFrame17173") as Validate17173,LayerManager.GAME_DYNAMIC_LAYER,true,0,false);
            return;
         }
         if(!this.validateFrame || !this.validateFrame.parent)
         {
            this.validateFrame = ComponentFactory.Instance.creat("EnthrallValidateFrame");
         }
         LayerManager.Instance.addToLayer(this.validateFrame,LayerManager.GAME_DYNAMIC_LAYER,true,0,false);
      }
      
      public function showEnthrallLight() : void
      {
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_TOP_LAYER,false,0,false);
         this.updateLight();
      }
      
      public function hideEnthrallLight() : void
      {
         if(this._view && this._view.parent)
         {
            this._view.parent.removeChild(this._view);
         }
      }
      
      public function gameState(param1:Number) : void
      {
         this._view.x = param1 - 100;
         this._view.y = 15;
      }
      
      public function outGame() : void
      {
         this._view.x = 110;
         this._view.y = 5;
      }
      
      public function get enthrallSwicth() : Boolean
      {
         return this._enthrallSwicth;
      }
      
      public function get isEnthrall() : Boolean
      {
         return this.enthrallSwicth && (!this._hasApproved || this._isMinor);
      }
      
      public function get interfaceID() : int
      {
         if(!this._interfaceID)
         {
            return 0;
         }
         return this._interfaceID;
      }
   }
}

class SingletonEnfocer
{
    
   
   function SingletonEnfocer()
   {
      super();
   }
}
