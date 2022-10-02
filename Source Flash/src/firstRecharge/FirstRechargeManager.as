package firstRecharge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class FirstRechargeManager extends EventDispatcher
   {
      
      public static const update_event:String = "update_event";
      
      private static var _instance:FirstRechargeManager;
      
      private static var _instanceClass:firstRechargeInstanceClass;
       
      
      public const FIRSTRECHARGE_TYPE:int = 1;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _icon:MovieClip;
      
      private var _frame:FirstRechargeFrame;
      
      public var awardList:Array;
      
      public var isRecharged:Boolean = false;
      
      public var isGetAward:Boolean = false;
      
      public function FirstRechargeManager(param1:firstRechargeInstanceClass, param2:IEventDispatcher = null)
      {
         super(param2);
         this.initEvent();
      }
      
      public static function get instance() : FirstRechargeManager
      {
         if(_instance == null)
         {
            _instanceClass = new firstRechargeInstanceClass();
            _instance = new FirstRechargeManager(_instanceClass);
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIRSTRECHARGE_MESSAGE,this.__updateFirstrecharge);
      }
      
      private function __updateFirstrecharge(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         this.isRecharged = _loc2_.readBoolean();
         this.isGetAward = _loc2_.readBoolean();
         dispatchEvent(new Event(update_event));
      }
      
      public function setAwardList(param1:Array) : void
      {
         this.awardList = param1;
      }
      
      public function addIcon() : void
      {
         if(this.isGetAward == false)
         {
            this.loadFirstRechargeModule(this.doShowLeagueShopFrame);
         }
      }
      
      public function removeIcon() : void
      {
         if(this._icon && this._icon.parent)
         {
            this._icon.parent.removeChild(this._icon);
            this._icon.removeEventListener(MouseEvent.CLICK,this.__showFirstRechargeFrame);
            this._icon = null;
         }
      }
      
      private function doShowLeagueShopFrame() : void
      {
         this._icon = ClassUtils.CreatInstance("asset.firstrecharge.hall.icon");
         LayerManager.Instance.addToLayer(this._icon,LayerManager.GAME_DYNAMIC_LAYER);
         PositionUtils.setPos(this._icon,"firstrecharge.hall.icon.pos");
         this._icon.buttonMode = true;
         this._icon.addEventListener(MouseEvent.CLICK,this.__showFirstRechargeFrame);
      }
      
      private function __showFirstRechargeFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.FirstRechargeMainFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function loadFirstRechargeModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIRSTRECHARGE);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FIRSTRECHARGE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FIRSTRECHARGE)
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

class firstRechargeInstanceClass
{
    
   
   function firstRechargeInstanceClass()
   {
      super();
   }
}
