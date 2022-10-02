package noviceactivity
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import firstRecharge.FirstRechargeManager;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class NoviceActivityManager extends EventDispatcher
   {
      
      public static const UPDATE_MESSAGE:String = "update_message";
      
      private static var _instance:NoviceActivityManager;
      
      private static var _instanceClass:NoviceActivityManagerInstanceClass;
      
      private static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
       
      
      public var isOpen:Boolean;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public var list:Array;
      
      public var recordList:Array;
      
      private var _icon:MovieClip;
      
      private var _frame:NoviceActivityFrame;
      
      private var _currentRightType:int = 1;
      
      public var startDate:Date;
      
      public var endDate:Date;
      
      public function NoviceActivityManager(param1:NoviceActivityManagerInstanceClass, param2:IEventDispatcher = null)
      {
         super(param2);
         this.initEvent();
      }
      
      public static function get instance() : NoviceActivityManager
      {
         if(_instance == null)
         {
            _instanceClass = new NoviceActivityManagerInstanceClass();
            _instance = new NoviceActivityManager(_instanceClass);
         }
         return _instance;
      }
      
      public function get currentRightType() : int
      {
         return this._currentRightType;
      }
      
      public function set currentRightType(param1:int) : void
      {
         this._currentRightType = param1;
      }
      
      public function setList(param1:NoviceActivityAnalyzer) : void
      {
         this.list = param1.activityInfos;
         FirstRechargeManager.instance.setAwardList(param1.firstrechargeawards);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NOVICEACTIVITY_MESSAGE,this.__updateNovice);
      }
      
      private function __updateNovice(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:NoviceActivityInfo = null;
         var _loc5_:int = 0;
         if(this.recordList == null)
         {
            this.recordList = [];
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               _loc4_ = new NoviceActivityInfo();
               this.recordList.push(_loc4_);
               _loc3_++;
            }
         }
         _loc2_ = param1.pkg as PackageIn;
         switch(_loc2_.readInt())
         {
            case 0:
				try{
					_loc5_ = _loc2_.readInt();
					this.recordList[_loc5_ - 1].conditions = _loc2_.readInt();
					this.recordList[_loc5_ - 1].awardGot = _loc2_.readInt();
					this.startDate = _loc2_.readDate();
					this.endDate = _loc2_.readDate();
					this.endDate.date -= 1;
					this.changeRightView(this._currentRightType);
				}
				catch (e:*){
					SocketManager.Instance.out.sendErrorMsg("err:" + e);
				}				
               break;
            case 1:
               this.isOpen = _loc2_.readBoolean();
               this.removeIcon();
         }
      }
      
      public function addIcon() : void
      {
         this.loadNoviceActivityModule(this.showNoviceActivityIcon);
      }
      
      public function addIconNoviceActivity() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIMITACTIVITY,true);
      }
      
      public function removeIcon() : void
      {
         if(this._icon)
         {
            if(this._icon.parent)
            {
               this._icon.parent.removeChild(this._icon);
               this._icon = null;
            }
         }
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showNoviceActivityFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NOVICEACTIVITY);
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NOVICEACTIVITY)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NOVICEACTIVITY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function checkTime() : Boolean
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         if(this.startDate && this.endDate)
         {
            _loc1_ = TimeManager.Instance.Now();
            _loc2_ = this.endDate;
            if(_loc1_.getTime() >= this.startDate.getTime() && _loc1_.getTime() < _loc2_.getTime() + 24 * 60 * 60 * 1000)
            {
               return true;
            }
         }
         return false;
      }
      
      public function canGetAward(param1:int, param2:int) : Boolean
      {
         return (param1 >> param2 & 1) == 0;
      }
      
      public function changeRightView(param1:int) : void
      {
         var _loc2_:NoviceActivityInfo = null;
         var _loc3_:NoviceActivityInfo = null;
         if(this._frame)
         {
            this._currentRightType = param1;
            _loc2_ = this.recordList[param1 - 1];
            _loc3_ = this.list[param1 - 1];
            this._frame.setRightView(_loc2_,_loc3_);
         }
      }
      
      public function showNoviceActivityIcon() : void
      {
         this._icon = ClassUtils.CreatInstance("asset.novice.hall.icon");
         LayerManager.Instance.addToLayer(this._icon,LayerManager.GAME_DYNAMIC_LAYER);
         PositionUtils.setPos(this._icon,"noviceactivity.hall.icon.pos");
         this._icon.buttonMode = true;
      }
      
      public function showNoviceActivityFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("novicecitivity.NoviceActivity.mainframe");
         this._frame.show();
      }
      
      public function loadNoviceActivityModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NOVICEACTIVITY);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NOVICEACTIVITY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NOVICEACTIVITY)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

class NoviceActivityManagerInstanceClass
{
    
   
   function NoviceActivityManagerInstanceClass()
   {
      super();
   }
}
