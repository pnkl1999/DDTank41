package farm
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class FarmModel extends EventDispatcher
   {
       
      
      public var payFieldMoney:String;
      
      public var payAutoMoney:String;
      
      public var autoPayTime:Date;
      
      public var autoValidDate:int;
      
      public var vipLimitLevel:int;
      
      private var _stopTime:Date;
      
      private var _isArrange:Boolean;
      
      public var helperArray:Array;
      
      private var _currentFarmerId:int;
      
      public var currentFarmerName:String;
      
      public var fieldsInfo:Vector.<FieldVO>;
      
      public var seedingFieldInfo:FieldVO;
      
      public var selfFieldsInfo:Vector.<FieldVO>;
      
      public var gainFieldId:int;
      
      public var payFieldIDs:Array;
      
      public var matureId:int;
      
      public var killCropId:int;
      
      public var isAutoId:int;
      
      public var batchFieldIDArray:Array;
      
      public var foodComposeList:Vector.<FoodComposeListTemplateInfo>;
      
      private var _friendStateList:DictionaryData;
      
      private var _friendStateListStolenInfo:DictionaryData;
      
      private var _buyExpRemainNum:int;
      
      private var _priceList:Vector.<SuperPetFoodPriceInfo>;
      
      public function FarmModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get payFieldDiscount() : int
      {
         if(this.payFieldMoney.split("|")[2])
         {
            return parseInt(this.payFieldMoney.split("|")[2]);
         }
         return 100;
      }
      
      public function get payFieldMoneyToWeek() : int
      {
         return parseInt(this.payFieldMoney.split("|")[0].split(",")[1]);
      }
      
      public function get payFieldTimeToWeek() : int
      {
         return parseInt(this.payFieldMoney.split("|")[0].split(",")[0]);
      }
      
      public function get payFieldMoneyToMonth() : int
      {
         return parseInt(this.payFieldMoney.split("|")[1].split(",")[1]);
      }
      
      public function get payFieldTimeToMonth() : int
      {
         return parseInt(this.payFieldMoney.split("|")[1].split(",")[0]);
      }
      
      public function get payAutoMoneyToWeek() : int
      {
         return parseInt(this.payAutoMoney.split("|")[0].split(",")[1]);
      }
      
      public function get payAutoTimeToWeek() : int
      {
         return parseInt(this.payAutoMoney.split("|")[0].split(",")[0]);
      }
      
      public function get payAutoMoneyToMonth() : int
      {
         return parseInt(this.payAutoMoney.split("|")[1].split(",")[1]);
      }
      
      public function get payAutoTimeToMonth() : int
      {
         return parseInt(this.payAutoMoney.split("|")[1].split(",")[0]);
      }
      
      public function get isArrange() : Boolean
      {
         return this._isArrange;
      }
      
      public function set isArrange(param1:Boolean) : void
      {
         this._isArrange = param1;
      }
      
      public function get isHelperMay() : Boolean
      {
         return (TimeManager.Instance.Now().time - this.autoPayTime.time) / 3600000 <= this.autoValidDate;
      }
      
      public function get stopTime() : Date
      {
         this._stopTime = new Date();
         var _loc1_:Number = this.autoPayTime.time + this.autoValidDate * 60 * 60 * 1000;
         this._stopTime.setTime(_loc1_);
         return this._stopTime;
      }
      
      public function get currentFarmerId() : int
      {
         return this._currentFarmerId;
      }
      
      public function set currentFarmerId(param1:int) : void
      {
         this._currentFarmerId = param1;
      }
      
      public function getfieldInfoById(param1:int) : FieldVO
      {
         var _loc2_:FieldVO = null;
         for each(_loc2_ in this.fieldsInfo)
         {
            if(_loc2_.fieldID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get friendStateList() : DictionaryData
      {
         if(this._friendStateList == null)
         {
            this._friendStateList = new DictionaryData();
         }
         return this._friendStateList;
      }
      
      public function set friendStateList(param1:DictionaryData) : void
      {
         this._friendStateList = param1;
      }
      
      public function get friendStateListStolenInfo() : DictionaryData
      {
         if(this._friendStateListStolenInfo == null)
         {
            this._friendStateListStolenInfo = new DictionaryData();
         }
         return this._friendStateListStolenInfo;
      }
      
      public function set friendStateListStolenInfo(param1:DictionaryData) : void
      {
         this._friendStateListStolenInfo = param1;
      }
      
      public function findItemInfo(param1:int, param2:int) : InventoryItemInfo
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(param1);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.TemplateID == param2)
            {
               _loc3_ = _loc5_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getSeedCountByID(param1:int) : int
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.TemplateID == param1)
            {
               _loc2_ += _loc4_.Count;
            }
         }
         return _loc2_;
      }
      
      public function get buyExpRemainNum() : int
      {
         return this._buyExpRemainNum;
      }
      
      public function set buyExpRemainNum(param1:int) : void
      {
         this._buyExpRemainNum = param1;
      }
      
      public function get priceList() : Vector.<SuperPetFoodPriceInfo>
      {
         return this._priceList;
      }
      
      public function set priceList(param1:Vector.<SuperPetFoodPriceInfo>) : void
      {
         this._priceList = param1;
      }
   }
}
