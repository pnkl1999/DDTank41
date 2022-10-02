package chickActivation
{
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import chickActivation.view.ChickActivationViewFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ChickActivationManager extends EventDispatcher
   {
      
      private static var _instance:ChickActivationManager;
       
      
      private var _model:ChickActivationModel;
      
      public function ChickActivationManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : ChickActivationManager
      {
         if(_instance == null)
         {
            _instance = new ChickActivationManager();
         }
         return _instance;
      }
      
      public function get model() : ChickActivationModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new ChickActivationModel();
         this.initData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHICKACTIVATION_SYSTEM,this.__chickActivationHandler);
      }
      
      private function initData() : void
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_["0,0,1"] = 1;
         _loc1_["0,0,2"] = 1;
         _loc1_["0,0,3"] = 1;
         _loc1_["0,0,4"] = 1;
         _loc1_["0,0,5"] = 1;
         _loc1_["0,0,6"] = 1;
         _loc1_["0,0,0"] = 1;
         _loc1_["0,2,5"] = 2;
         _loc1_["0,2,6"] = 2;
         _loc1_["0,2,0"] = 2;
         _loc1_["0,1"] = 3;
         _loc1_["0,3"] = 12;
         _loc1_["1,0,1"] = 101;
         _loc1_["1,0,2"] = 101;
         _loc1_["1,0,3"] = 101;
         _loc1_["1,0,4"] = 101;
         _loc1_["1,0,5"] = 101;
         _loc1_["1,0,6"] = 101;
         _loc1_["1,0,0"] = 101;
         _loc1_["1,2,5"] = 102;
         _loc1_["1,2,6"] = 102;
         _loc1_["1,2,0"] = 102;
         _loc1_["1,1"] = 103;
         this._model.qualityDic = _loc1_;
      }
      
      private function __chickActivationHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == ChickActivationType.CHICKACTIVATION_LOGIN)
         {
            this.loginDataUpdate(_loc2_);
         }
         else if(_loc3_ == ChickActivationType.CHICKACTIVATION_UPDATE)
         {
            this.dataUpdate(_loc2_);
         }
      }
      
      private function loginDataUpdate(param1:PackageIn) : void
      {
         this.model.isKeyOpened = param1.readInt();
         this.model.keyIndex = param1.readInt();
         this.model.keyOpenedTime = param1.readDate();
         this.model.keyOpenedType = param1.readInt();
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < 12)
         {
            _loc2_.push(param1.readInt());
            _loc3_++;
         }
         this.model.gainArr = _loc2_;
         this.model.dataChange(ChickActivationEvent.UPDATE_DATA);
      }
      
      private function dataUpdate(param1:PackageIn) : void
      {
         var _loc5_:int = 0;
         this.model.isKeyOpened = param1.readInt();
         this.model.keyIndex = param1.readInt();
         this.model.keyOpenedTime = param1.readDate();
         this.model.keyOpenedType = param1.readInt();
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < 12)
         {
            _loc2_.push(param1.readInt());
            _loc3_++;
         }
         var _loc4_:int = -1;
         if(this.model.gainArr.length == 12)
         {
            _loc5_ = 0;
            while(_loc5_ < this.model.gainArr.length - 1)
            {
               if(this.model.gainArr[_loc5_] != _loc2_[_loc5_] && _loc2_[_loc5_] > 0)
               {
                  _loc4_ = _loc5_;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_ != -1)
            {
               this.model.dataChange(ChickActivationEvent.GET_REWARD,_loc4_);
            }
         }
         this.model.gainArr = _loc2_;
         this.model.dataChange(ChickActivationEvent.UPDATE_DATA);
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.itemInfoList = param1;
      }
      
      public function checkShowIcon() : void
      {
         this.model.isOpen = ServerConfigManager.instance.chickActivationIsOpen;
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHICKACTIVATION,this.model.isOpen);
      }
      
      public function showFrame() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHICKACTIVATION);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHICKACTIVATION)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         var _loc2_:ChickActivationViewFrame = null;
         if(param1.module == UIModuleTypes.CHICKACTIVATION)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ChickActivationViewFrame");
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            SocketManager.Instance.out.sendChickActivationQuery();
         }
      }
   }
}
