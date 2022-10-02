package farm
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.analyzer.FarmFriendListAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.analyzer.SuperPetFoodPriceAnalyzer;
   import farm.control.*;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import farm.view.*;
   import farm.viewx.FarmBuyFieldView;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class FarmModelController extends EventDispatcher
   {
      
      private static var _instance:FarmModelController;
       
      
      private var _model:FarmModel;
      
      private var _timer:Timer;
      
      private var _canGoFarm:Boolean = true;
      
      private var _landInfoVector:Vector.<FieldVO>;
      
      public var gropPrice:int;
      
      public var midAutumnFlag:Boolean;
      
      public function FarmModelController()
      {
         super();
      }
      
      public static function get instance() : FarmModelController
      {
         return _instance = _instance || new FarmModelController();
      }
      
      public function setup() : void
      {
         this._model = new FarmModel();
         this._landInfoVector = new Vector.<FieldVO>();
         this.initEvent();
         FarmComposeHouseController.instance().setup();
      }
      
      public function get model() : FarmModel
      {
         return this._model;
      }
      
      public function stopTimer() : void
      {
         if(this._timer)
         {
            this._timer.stop();
         }
         this._canGoFarm = true;
      }
      
      public function startTimer() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__timerhandler);
         }
         this._timer.reset();
         this._timer.start();
      }
      
      public function sendEnterFarmPkg(param1:int) : void
      {
         SocketManager.Instance.out.enterFarm(param1);
         if(param1 == PlayerManager.Instance.Self.ID)
         {
            this.startTimer();
         }
      }
      
      public function arrange() : void
      {
         SocketManager.Instance.out.arrange(this._model.currentFarmerId);
      }
      
      public function goFarm(param1:int, param2:String) : void
      {
         if(PlayerManager.Instance.Self.ID == param1 && PlayerManager.Instance.Self.Grade < 25)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarm.need20"));
            return;
         }
         if(this._canGoFarm)
         {
            this._model.currentFarmerName = param2;
            this.sendEnterFarmPkg(param1);
            this._canGoFarm = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.internal"));
         }
      }
      
      public function sowSeed(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.seeding(param1,param2);
      }
      
      public function accelerateField(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.doMature(param1,param2,param3);
      }
      
      public function getHarvest(param1:int) : void
      {
         SocketManager.Instance.out.toGather(this.model.currentFarmerId,param1);
      }
      
      public function payField(param1:Array, param2:int, param3:Boolean) : void
      {
         SocketManager.Instance.out.toSpread(param1,param2,param3);
      }
      
      public function updateFriendListStolen() : void
      {
         FarmModelController.instance.updateSetupFriendListStolen(this.model.currentFarmerId);
      }
      
      public function setupFoodComposeList(param1:FoodComposeListAnalyzer) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.FOOD_COMPOSE_LISE_READY));
      }
      
      public function killCrop(param1:int) : void
      {
         SocketManager.Instance.out.toKillCrop(param1);
      }
      
      public function farmHelperSetSwitch(param1:Array, param2:Boolean) : void
      {
         SocketManager.Instance.out.toFarmHelper(param1,param2);
      }
      
      public function helperRenewMoney(param1:int, param2:Boolean) : void
      {
         SocketManager.Instance.out.toHelperRenewMoney(param1,param2);
      }
      
      public function exitFarm(param1:int) : void
      {
         SocketManager.Instance.out.exitFarm(param1);
      }
      
      public function openPayFieldFrame(param1:int) : void
      {
         var _loc2_:FarmBuyFieldView = new FarmBuyFieldView(param1);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_LAND_INFO,this.__onFarmLandInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_FARM,this.__onEnterFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD,this.__gainFieldHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING,this.__onSeeding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PAY_FIELD,this.__payField);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DO_MATURE,this.__onDoMature);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_SWITCH,this.__onHelperSwitch);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KILL_CROP,this.__onKillCrop);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_PAY,this.__onHelperPay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_FARM,this.__onExitFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,this.__updateBuyExpExpNum);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,this.__arrangeFriendFarmHandler);
      }
      
      private function __arrangeFriendFarmHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.arrange" + _loc2_));
         if(_loc2_ == 0)
         {
            this._model.isArrange = true;
         }
         else
         {
            this._model.isArrange = false;
         }
         dispatchEvent(new FarmEvent(FarmEvent.ARRANGE_FRIEND_FARM));
      }
      
      protected function __onFarmLandInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:FieldVO = null;
         if(this._landInfoVector.length > 0)
         {
            this._landInfoVector = new Vector.<FieldVO>();
         }
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new FieldVO();
            _loc5_.fieldID = _loc2_.readInt();
            _loc5_.seedID = _loc2_.readInt();
            _loc5_.plantTime = _loc2_.readDate();
            _loc2_.readInt();
            _loc5_.AccelerateTime = _loc2_.readInt();
            this._landInfoVector.push(_loc5_);
            _loc4_++;
         }
         this.midAutumnFlag = _loc2_.readBoolean();
         this.model.selfFieldsInfo = this._landInfoVector;
      }
      
      protected function __updateBuyExpExpNum(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.buyExpRemainNum = _loc2_.readInt();
         dispatchEvent(new FarmEvent(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM));
      }
      
      private function __timerhandler(param1:TimerEvent) : void
      {
         this._timer.currentCount % 120 == 0;
         if(this._timer.currentCount % 120 == 0)
         {
         }
         if(this._timer.currentCount % 60 == 0)
         {
            dispatchEvent(new FarmEvent(FarmEvent.FRUSH_FIELD));
         }
         if(this._timer.currentCount % 2 == 0)
         {
            this._canGoFarm = true;
         }
      }
      
      private function __onEnterFarm(param1:CrazyTankSocketEvent) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Date = null;
         var _loc14_:Date = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:FieldVO = null;
         var _loc19_:FieldVO = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new Vector.<FieldVO>();
         var _loc2_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc2_.readInt();
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Date = _loc2_.readDate();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         var _loc9_:int = _loc2_.readInt();
         this.model.helperArray = new Array();
         this.model.helperArray.push(_loc3_);
         this.model.helperArray.push(_loc4_);
         this.model.helperArray.push(_loc5_);
         this.model.helperArray.push(_loc6_);
         this.model.helperArray.push(_loc7_);
         this.model.helperArray.push(_loc8_);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = _loc2_.readInt();
            _loc12_ = _loc2_.readInt();
            _loc13_ = _loc2_.readDate();
            _loc14_ = _loc2_.readDate();
            _loc15_ = _loc2_.readInt();
            _loc16_ = _loc2_.readInt();
            _loc17_ = _loc2_.readInt();
            if(this.model.getfieldInfoById(_loc11_) == null)
            {
               _loc18_ = new FieldVO();
               _loc18_.fieldID = _loc11_;
               _loc18_.seedID = _loc12_;
               _loc18_.payTime = _loc13_;
               _loc18_.plantTime = _loc14_;
               _loc18_.fieldValidDate = _loc16_;
               _loc18_.AccelerateTime = _loc17_;
               _loc18_.gainCount = _loc15_;
               _loc18_.autoSeedID = _loc4_;
               _loc18_.isAutomatic = _loc3_;
               this.model.fieldsInfo.push(_loc18_);
            }
            else
            {
               _loc19_ = this.model.getfieldInfoById(_loc11_);
               _loc19_.seedID = _loc12_;
               _loc19_.payTime = _loc13_;
               _loc19_.plantTime = _loc14_;
               _loc19_.fieldValidDate = _loc16_;
               _loc19_.AccelerateTime = _loc17_;
               _loc19_.gainCount = _loc15_;
               _loc19_.autoSeedID = _loc4_;
               _loc19_.isAutomatic = _loc3_;
            }
            _loc10_++;
         }
         if(this._model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.gropPrice = _loc2_.readInt();
            this._model.payFieldMoney = _loc2_.readUTF();
            this._model.payAutoMoney = _loc2_.readUTF();
            this._model.autoPayTime = _loc2_.readDate();
            this._model.autoValidDate = _loc2_.readInt();
            this._model.vipLimitLevel = _loc2_.readInt();
            this._model.selfFieldsInfo = this._model.fieldsInfo.concat();
            this._model.isAutoId = _loc4_;
            this._model.buyExpRemainNum = _loc2_.readInt();
            PlayerManager.Instance.Self.isFarmHelper = _loc3_;
         }
         else
         {
            this._model.isArrange = _loc2_.readBoolean();
         }
         StateManager.setState(StateType.FARM);
         dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
      }
      
      private function __gainFieldHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FieldVO = null;
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            this.model.gainFieldId = param1.pkg.readInt();
            _loc2_ = this.model.getfieldInfoById(this.model.gainFieldId);
            _loc2_.seedID = param1.pkg.readInt();
            _loc2_.plantTime = param1.pkg.readDate();
            _loc2_.gainCount = param1.pkg.readInt();
            _loc2_.AccelerateTime = param1.pkg.readInt();
            dispatchEvent(new FarmEvent(FarmEvent.GAIN_FIELD));
         }
      }
      
      private function __payField(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Date = null;
         var _loc8_:Date = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:FieldVO = null;
         var _loc13_:FieldVO = null;
         var _loc2_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc2_.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readDate();
            _loc8_ = _loc2_.readDate();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            if(this.model.getfieldInfoById(_loc5_) == null)
            {
               _loc12_ = new FieldVO();
               _loc12_.fieldID = _loc5_;
               _loc12_.seedID = _loc6_;
               _loc12_.payTime = _loc7_;
               _loc12_.plantTime = _loc8_;
               _loc12_.fieldValidDate = _loc10_;
               _loc12_.AccelerateTime = _loc11_;
               _loc12_.gainCount = _loc9_;
               this.model.fieldsInfo.push(_loc12_);
            }
            else
            {
               _loc13_ = this.model.getfieldInfoById(_loc5_);
               _loc13_.seedID = _loc6_;
               _loc13_.payTime = _loc7_;
               _loc13_.plantTime = _loc8_;
               _loc13_.fieldValidDate = _loc10_;
               _loc13_.AccelerateTime = _loc11_;
               _loc13_.gainCount = _loc9_;
            }
            dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.payField.success"));
            _loc4_++;
         }
      }
      
      private function __onSeeding(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Date = _loc2_.readDate();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         var _loc9_:FieldVO = this.model.getfieldInfoById(_loc3_);
         _loc9_.seedID = _loc4_;
         _loc9_.plantTime = _loc5_;
         _loc9_.gainCount = _loc7_;
         this.model.seedingFieldInfo = _loc9_;
         dispatchEvent(new FarmEvent(FarmEvent.HAS_SEEDING));
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.seeding.success"));
      }
      
      private function __onDoMature(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc5_:FieldVO = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.pkg.readBoolean();
            if(_loc3_)
            {
               this.model.matureId = param1.pkg.readInt();
               _loc5_ = this.model.getfieldInfoById(this.model.matureId);
               _loc5_.gainCount = param1.pkg.readInt();
               _loc5_.AccelerateTime = param1.pkg.readInt();
               dispatchEvent(new FarmEvent(FarmEvent.ACCELERATE_FIELD));
            }
            _loc4_++;
         }
      }
      
      private function __onKillCrop(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FieldVO = null;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            this.model.killCropId = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = this.model.getfieldInfoById(this.model.killCropId);
            _loc5_.seedID = _loc3_;
            _loc5_.AccelerateTime = _loc4_;
            dispatchEvent(new FarmEvent(FarmEvent.KILLCROP_FIELD));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.fail"));
         }
      }
      
      private function __onHelperSwitch(param1:CrazyTankSocketEvent) : void
      {
         this.model.helperArray = new Array();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Date = param1.pkg.readDate();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = param1.pkg.readInt();
         this.model.helperArray.push(_loc2_);
         this.model.helperArray.push(_loc3_);
         this.model.helperArray.push(_loc4_);
         this.model.helperArray.push(_loc5_);
         this.model.helperArray.push(_loc6_);
         this.model.helperArray.push(_loc7_);
         PlayerManager.Instance.Self.isFarmHelper = _loc2_;
         if(_loc2_)
         {
            dispatchEvent(new FarmEvent(FarmEvent.BEGIN_HELPER));
         }
         else
         {
            dispatchEvent(new FarmEvent(FarmEvent.STOP_HELPER));
         }
      }
      
      private function __onHelperPay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Date = param1.pkg.readDate();
         var _loc3_:int = param1.pkg.readInt();
         this.model.autoPayTime = _loc2_;
         this.model.autoValidDate = _loc3_;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirmPnlSuccess"));
         this.model.dispatchEvent(new FarmEvent(FarmEvent.PAY_HELPER));
      }
      
      private function __onExitFarm(param1:CrazyTankSocketEvent) : void
      {
      }
      
      public function updateSetupFriendListLoader() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc1_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("FarmGetUserFieldInfos.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc2_.analyzer = new FarmFriendListAnalyzer(this.setupFriendList);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      public function updateSetupFriendListStolen(param1:int) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc2_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc2_["friendID"] = param1;
         _loc2_["rnd"] = Math.random();
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("FarmGetUserFieldInfosSingle.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc3_.analyzer = new FarmFriendListAnalyzer(this.setupFriendStolen);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function creatSuperPetFoodPriceList() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(SuperPetFoodPriceAnalyzer.Path),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSpuerPetFoodPricetListComposeListFail");
         _loc1_.analyzer = new SuperPetFoodPriceAnalyzer(this.setupSuperPetFoodPriceList);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__onloadSpuerPetFoodPricetListComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      protected function __onloadSpuerPetFoodPricetListComplete(param1:LoaderEvent) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupSuperPetFoodPriceList(param1:SuperPetFoodPriceAnalyzer) : void
      {
         this.model.priceList = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupFriendList(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateList = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIEND_INFO_READY));
      }
      
      public function setupFriendStolen(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateListStolenInfo = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIENDLIST_UPDATESTOLEN));
      }
      
      public function getCurrentMoney() : int
      {
         var _loc1_:int = 21 - this.model.buyExpRemainNum;
         var _loc2_:int = 0;
         while(_loc2_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc2_].Count == _loc1_)
            {
               return this.model.priceList[_loc2_].Money;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getCurrentSuperPetFoodPriceInfo() : SuperPetFoodPriceInfo
      {
         var _loc1_:int = 21 - this.model.buyExpRemainNum;
         var _loc2_:int = 0;
         while(_loc2_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc2_].Count == _loc1_)
            {
               return this.model.priceList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
