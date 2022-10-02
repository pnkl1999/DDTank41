package shop
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ShopModel extends EventDispatcher
   {
      
      private static var DEFAULT_MAN_STYLE:String = "1101,2101,3101,4101,5101,6101,7001,13101,15001";
      
      private static var DEFAULT_WOMAN_STYLE:String = "1201,2201,3201,4201,5201,6201,7002,13201,15001";
      
      public static const SHOP_CART_MAX_LENGTH:uint = 20;
       
      
      public var leftCarList:Array;
      
      public var leftManList:Array;
      
      public var leftWomanList:Array;
      
      private var _bodyThings:DictionaryData;
      
      private var _carList:Array;
      
      private var _currentGift:int;
      
      private var _currentGold:int;
      
      private var _currentMedal:int;
      
      private var _currentMoney:int;
      
      private var _totalGold:int;
      
      private var _totalMedal:int;
      
      private var _totalMoney:int;
      
      private var _defaultModel:int;
      
      private var _manMemoryList:Array;
      
      private var _manModel:PlayerInfo;
      
      private var _manTempList:Array;
      
      private var _womanMemoryList:Array;
      
      private var _womanModel:PlayerInfo;
      
      private var _womanTempList:Array;
      
      private var _manHistoryList:Array;
      
      private var _womanHistoryList:Array;
      
      private var _self:SelfInfo;
      
      private var _sex:Boolean;
      
      private var _totalGift:int;
      
      private var maleCollocation:Array;
      
      private var femaleCollocation:Array;
      
      public function ShopModel()
      {
         this.leftCarList = [];
         this.leftManList = [];
         this.leftWomanList = [];
         super();
         this._self = PlayerManager.Instance.Self;
         this._womanModel = new PlayerInfo();
         this._manModel = new PlayerInfo();
         this._womanTempList = [];
         this._manTempList = [];
         this._carList = [];
         this._manMemoryList = [];
         this._womanMemoryList = [];
         this._manHistoryList = [];
         this._womanHistoryList = [];
         this._totalGold = 0;
         this._totalMoney = 0;
         this._totalGift = 0;
         this._totalMedal = 0;
         this._defaultModel = 1;
         this.init();
         this.fittingSex = this._self.Sex;
         this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__styleChange);
         this._self.Bag.addEventListener(BagEvent.UPDATE,this.__bagChange);
         this.initRandom();
      }
      
      public function removeLatestItem() : void
      {
         var _loc4_:Array = null;
         var _loc5_:ShopCarItemInfo = null;
         var _loc6_:Array = null;
         var _loc7_:ShopCarItemInfo = null;
         var _loc8_:int = 0;
         var _loc1_:Array = !!this._sex ? this._manTempList : this._womanTempList;
         if(this.currentHistoryList.length > 0)
         {
            _loc4_ = this.currentHistoryList.pop();
            for each(_loc5_ in _loc4_)
            {
               this.removeTempEquip(_loc5_);
            }
         }
         var _loc3_:int = this.currentHistoryList.length - 1;
         while(_loc3_ > -1)
         {
            _loc6_ = this.currentHistoryList[_loc3_];
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = this.currentTempListHasItem(_loc7_.TemplateInfo.CategoryID);
               if(_loc8_ <= -1)
               {
                  this.currentTempList.push(_loc7_);
                  dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,_loc7_));
                  _loc7_.addEventListener(Event.CHANGE,this.__onItemChange);
               }
            }
            _loc3_--;
         }
         this.updateCost();
      }
      
      private function currentTempListHasItem(param1:int) : int
      {
         var _loc3_:ShopCarItemInfo = null;
         var _loc2_:Array = this.currentTempList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.TemplateInfo.CategoryID == param1)
            {
               return _loc2_.indexOf(_loc3_);
            }
         }
         return -1;
      }
      
      public function get currentHistoryList() : Array
      {
         return !!this._sex ? this._manHistoryList : this._womanHistoryList;
      }
      
      private function initRandom() : void
      {
         this.maleCollocation = [];
         this.femaleCollocation = [];
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_CLOTH));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_HAT));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_GLASS));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_HAIR));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_EYES));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_WING));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_LIANSHI));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_CLOTH));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_HAT));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_GLASS));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_HAIR));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_EYES));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_WING));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_LIANSHI));
      }
      
      public function random() : void
      {
         var _loc3_:Vector.<ShopItemInfo> = null;
         var _loc4_:int = 0;
         var _loc1_:Array = !!this._sex ? this.maleCollocation : this.femaleCollocation;
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = Math.floor(Math.random() * _loc3_.length);
            _loc2_.push(this.fillToShopCarInfo(_loc3_[_loc4_]));
         }
         this.addTempEquip(_loc2_);
         this.updateCost();
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function isCarListMax() : Boolean
      {
         return this._carList.length + this._manTempList.length + this._womanTempList.length >= SHOP_CART_MAX_LENGTH;
      }
      
      public function addTempEquip(param1:*) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:int = 0;
         var _loc7_:ShopCarItemInfo = null;
         var _loc8_:int = 0;
         var _loc9_:ShopCarItemInfo = null;
         var _loc2_:Boolean = this.isCarListMax();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
            return _loc2_;
         }
         if(param1 is Array)
         {
            _loc3_ = param1 as Array;
            _loc4_ = [];
            for each(_loc5_ in _loc3_)
            {
               _loc6_ = this.currentTempListHasItem(_loc5_.TemplateInfo.CategoryID);
               if(_loc6_ > -1)
               {
                  this.currentTempList.splice(_loc6_,1);
               }
               _loc7_ = this.fillToShopCarInfo(_loc5_);
               _loc7_.dressing = true;
               _loc7_.ModelSex = this.currentModel.Sex;
               this.currentTempList.push(_loc7_);
               dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,_loc7_));
               this.updateCost();
               _loc7_.addEventListener(Event.CHANGE,this.__onItemChange);
               _loc4_.push(_loc7_);
            }
            this.currentHistoryList.push(_loc4_);
         }
         else
         {
            _loc8_ = this.currentTempListHasItem(param1.TemplateInfo.CategoryID);
            if(_loc8_ > -1)
            {
               this.currentTempList.splice(_loc8_,1);
            }
            _loc9_ = this.fillToShopCarInfo(param1);
            _loc9_.dressing = true;
            _loc9_.ModelSex = this.currentModel.Sex;
            this.currentTempList.push(_loc9_);
            dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,_loc9_));
            this.updateCost();
            _loc9_.addEventListener(Event.CHANGE,this.__onItemChange);
            this.currentHistoryList.push([_loc9_]);
         }
         return !_loc2_;
      }
      
      public function addToShoppingCar(param1:ShopCarItemInfo) : void
      {
         if(this.isCarListMax())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
            return;
         }
         if(this.isOverCount(param1))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         this._carList.push(param1);
         this.updateCost();
         param1.addEventListener(Event.CHANGE,this.__onItemChange);
         dispatchEvent(new ShopEvent(ShopEvent.ADD_CAR_EQUIP,param1));
      }
      
      private function __onItemChange(param1:Event) : void
      {
         this.updateCost();
      }
      
      public function isOverCount(param1:ShopItemInfo) : Boolean
      {
         var _loc5_:ShopCarItemInfo = null;
         var _loc2_:uint = 0;
         var _loc3_:Array = this.allItems;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_] as ShopCarItemInfo;
            if(param1.TemplateID == _loc5_.TemplateID)
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_ >= param1.LimitCount && param1.LimitCount != -1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      public function get allItems() : Array
      {
         return this._carList.concat(this._manTempList).concat(this._womanTempList);
      }
      
      public function get allItemsCount() : int
      {
         return this._carList.length + this._manTempList.length + this._womanTempList.length;
      }
      
      public function calcPrices(param1:Array) : Array
      {
         var _loc2_:ItemPrice = new ItemPrice(null,null,null);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            _loc2_.addItemPrice(param1[_loc7_].getCurrentPrice());
            _loc7_++;
         }
         _loc3_ = _loc2_.goldValue;
         _loc4_ = _loc2_.moneyValue;
         _loc5_ = _loc2_.giftValue;
         _loc6_ = _loc2_.getOtherValue(EquipType.MEDAL);
         return [_loc3_,_loc4_,_loc5_,_loc6_];
      }
      
      public function canBuyLeastOneGood(param1:Array) : Boolean
      {
         return ShopManager.Instance.buyLeastGood(param1,this._self);
      }
      
      public function canChangSkin() : Boolean
      {
         var _loc1_:Array = this.currentTempList;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].CategoryID == EquipType.FACE)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function checkMoney(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         if(param1 > 0 && param1 > this._self.Money)
         {
            return false;
         }
         if(param2 > 0 && param2 > this._self.Gold)
         {
            return false;
         }
         if(param3 > 0 && param3 > this._self.Gift)
         {
            return false;
         }
         if(param4 > 0 && param4 > this._self.medal)
         {
            return false;
         }
         return true;
      }
      
      public function clearAllitems() : void
      {
         this._carList = [];
         this._defaultModel = 1;
         this._manTempList = [];
         this._womanTempList = [];
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         this.init();
      }
      
      public function clearCurrentTempList(param1:int = 0) : void
      {
         var _loc2_:Array = null;
         if(param1 == 0)
         {
            _loc2_ = !!this._sex ? this._manTempList : this._womanTempList;
            _loc2_.splice(0,_loc2_.length);
         }
         else if(param1 == 1)
         {
            this._manTempList.splice(0,this._manTempList.length);
         }
         else if(param1 == 2)
         {
            this._womanTempList.splice(0,this._womanTempList.length);
         }
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         this.init();
      }
      
      public function clearLeftList() : void
      {
         this.leftCarList = [];
         this.leftManList = [];
         this.leftWomanList = [];
      }
      
      public function get currentGift() : int
      {
         var _loc1_:Array = this.calcPrices(this.currentTempList);
         this._currentGift = _loc1_[2];
         return this._currentGift;
      }
      
      public function get currentGold() : int
      {
         var _loc1_:Array = this.calcPrices(this.currentTempList);
         this._currentGold = _loc1_[0];
         return this._currentGold;
      }
      
      public function get currentLeftList() : Array
      {
         return !!this._sex ? this.leftManList : this.leftWomanList;
      }
      
      public function get currentMedal() : int
      {
         var _loc1_:Array = this.calcPrices(this.currentTempList);
         this._currentMedal = _loc1_[3];
         return this._currentMedal;
      }
      
      public function get currentMemoryList() : Array
      {
         return !!this.currentModel.Sex ? this._manMemoryList : this._womanMemoryList;
      }
      
      public function get currentModel() : PlayerInfo
      {
         return !!this._sex ? this._manModel : this._womanModel;
      }
      
      public function get currentMoney() : int
      {
         var _loc1_:Array = this.calcPrices(this.currentTempList);
         this._currentMoney = _loc1_[1];
         return this._currentMoney;
      }
      
      public function get currentSkin() : String
      {
         var _loc1_:Array = this.currentTempList;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].CategoryID == EquipType.FACE)
            {
               return _loc1_[_loc2_].skin;
            }
            _loc2_++;
         }
         return "";
      }
      
      public function get currentTempList() : Array
      {
         return !!this._sex ? this._manTempList : this._womanTempList;
      }
      
      public function dispose() : void
      {
         this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__styleChange);
         this._self.Bag.removeEventListener(BagEvent.UPDATE,this.__bagChange);
         this._womanModel = null;
         this._manModel = null;
         this._carList = null;
         this.leftCarList = null;
         this.leftManList = null;
         this.leftWomanList = null;
         this.maleCollocation = null;
         this.femaleCollocation = null;
      }
      
      public function get fittingSex() : Boolean
      {
         return this._sex;
      }
      
      public function set fittingSex(param1:Boolean) : void
      {
         var _loc2_:ShopEvent = null;
         if(this._sex != param1)
         {
            this._sex = param1;
            _loc2_ = new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE,"sexChange");
            dispatchEvent(_loc2_);
         }
      }
      
      public function hasFreeItems() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.allItems.length)
         {
            if(ShopCarItemInfo(this.allItems[_loc1_]).isFreeShopItem())
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get isSelfModel() : Boolean
      {
         return this._sex == this._self.Sex;
      }
      
      public function get manModelInfo() : PlayerInfo
      {
         return this._manModel;
      }
      
      public function pickOutLeftItems(param1:Array) : void
      {
      }
      
      public function removeFromShoppingCar(param1:ShopCarItemInfo) : void
      {
         this.removeTempEquip(param1);
         var _loc2_:int = this._carList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._carList.splice(_loc2_,1);
            this.updateCost();
            param1.removeEventListener(Event.CHANGE,this.__onItemChange);
            dispatchEvent(new ShopEvent(ShopEvent.REMOVE_CAR_EQUIP,param1));
         }
      }
      
      public function removeItem(param1:ShopCarItemInfo) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(this._carList.indexOf(param1) != -1)
         {
            this._carList.splice(this._carList.indexOf(param1),1);
            return;
         }
         for each(_loc2_ in this._manTempList)
         {
            if(_loc2_.indexOf(param1) > -1)
            {
               if(_loc2_.length > 1)
               {
                  _loc2_.splice(_loc2_.indexOf(param1),1);
               }
               else
               {
                  this._manTempList.splice(this._manTempList.indexOf(_loc2_),1);
               }
            }
         }
         for each(_loc3_ in this._womanTempList)
         {
            if(_loc3_.indexOf(param1) > -1)
            {
               if(_loc3_.length > 1)
               {
                  _loc3_.splice(_loc3_.indexOf(param1),1);
               }
               else
               {
                  this._womanTempList.splice(this._womanTempList.indexOf(_loc3_),1);
               }
            }
         }
      }
      
      public function removeTempEquip(param1:ShopCarItemInfo) : void
      {
         var _loc3_:PlayerInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:int = this._manTempList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._manTempList.splice(_loc2_,1);
            _loc3_ = this._manModel;
         }
         else
         {
            _loc2_ = this._womanTempList.indexOf(param1);
            if(_loc2_ != -1)
            {
               this._womanTempList.splice(_loc2_,1);
               _loc3_ = this._womanModel;
            }
         }
         if(_loc3_)
         {
            _loc4_ = _loc3_.Bag.items[param1.place];
            if(_loc4_)
            {
               if(_loc4_.CategoryID >= 1 && _loc4_.CategoryID <= 6 || param1.CategoryID == EquipType.SUITS || param1.CategoryID == EquipType.WING)
               {
                  _loc3_.setPartStyle(param1.CategoryID,param1.TemplateInfo.NeedSex,_loc4_.TemplateID,_loc4_.Color);
               }
               if(param1.CategoryID == EquipType.FACE)
               {
                  _loc3_.Skin = this._self.Skin;
               }
            }
            else if(EquipType.dressAble(param1.TemplateInfo))
            {
               _loc3_.setPartStyle(param1.CategoryID,param1.TemplateInfo.NeedSex);
               if(param1.CategoryID == EquipType.FACE)
               {
                  _loc3_.Skin = "";
               }
            }
            dispatchEvent(new ShopEvent(ShopEvent.REMOVE_TEMP_EQUIP,param1,_loc3_));
         }
         this.updateCost();
         param1.removeEventListener(Event.CHANGE,this.__onItemChange);
         if(this.currentTempList.length > 0)
         {
            this.setSelectedEquip(this.currentTempList[this.currentTempList.length - 1]);
         }
      }
      
      public function restoreAllItemsOnBody() : void
      {
         var _loc1_:Array = null;
         if(this.currentModel.Sex == this._self.Sex && this.currentTempList.length > 0 || this.currentModel.Bag.items != this._bodyThings)
         {
            _loc1_ = !!this._sex ? this._manTempList : this._womanTempList;
            _loc1_.splice(0,_loc1_.length);
            this.init();
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
            this.updateCost();
            dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         }
      }
      
      public function revertToDefalt() : void
      {
         this.clearAllItemsOnBody();
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
      }
      
      public function setSelectedEquip(param1:ShopCarItemInfo) : void
      {
         var _loc2_:Array = null;
         if(param1 is ShopCarItemInfo)
         {
            _loc2_ = this.currentTempList;
            if(_loc2_.indexOf(param1) > -1)
            {
               _loc2_.splice(_loc2_.indexOf(param1),1);
               _loc2_.push(param1);
            }
            dispatchEvent(new ShopEvent(ShopEvent.SELECTEDEQUIP_CHANGE,param1));
         }
      }
      
      public function get totalGift() : int
      {
         return this._totalGift;
      }
      
      public function get totalGold() : int
      {
         return this._totalGold;
      }
      
      public function get totalMedal() : int
      {
         return this._totalMedal;
      }
      
      public function get totalMoney() : int
      {
         return this._totalMoney;
      }
      
      public function updateCost() : void
      {
         this._totalGold = 0;
         this._totalMoney = 0;
         this._totalGift = 0;
         this._totalMedal = 0;
         var _loc1_:Array = this.calcPrices(this._carList);
         this._totalGold += _loc1_[0];
         this._totalMoney += _loc1_[1];
         this._totalGift += _loc1_[2];
         this._totalMedal += _loc1_[3];
         _loc1_ = this.calcPrices(this._womanTempList);
         this._totalGold += _loc1_[0];
         this._totalMoney += _loc1_[1];
         this._totalGift += _loc1_[2];
         this._totalMedal += _loc1_[3];
         _loc1_ = this.calcPrices(this._manTempList);
         this._totalGold += _loc1_[0];
         this._totalMoney += _loc1_[1];
         this._totalGift += _loc1_[2];
         this._totalMedal += _loc1_[3];
         dispatchEvent(new ShopEvent(ShopEvent.COST_UPDATE));
      }
      
      public function get womanModelInfo() : PlayerInfo
      {
         return this._womanModel;
      }
      
      private function __bagChange(param1:BagEvent) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.Place <= 30)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            return;
         }
         var _loc5_:PlayerInfo = !!this._self.Sex ? this._manModel : this._womanModel;
         if(this._self.Sex)
         {
            this._manModel.Bag.items = this._self.Bag.items;
         }
         else
         {
            this._womanModel.Bag.items = this._self.Bag.items;
         }
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
      }
      
      private function __styleChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:PlayerInfo = null;
         if(this.currentModel && param1.changedProperties[PlayerInfo.STYLE])
         {
            this._defaultModel = 1;
            _loc2_ = !!this._self.Sex ? this._manModel : this._womanModel;
            if(this._self.Sex)
            {
               this._manModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
               this._manModel.Bag.items = this._self.Bag.items;
            }
            else
            {
               this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
               this._womanModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.Bag.items = this._self.Bag.items;
            }
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
         }
      }
      
      private function clearAllItemsOnBody() : void
      {
         this.saveTriedList();
         this.currentModel.Bag.items = new DictionaryData();
         var _loc1_:Array = !!this._sex ? this._manTempList : this._womanTempList;
         _loc1_.splice(0,_loc1_.length);
         if(this.currentModel.Sex)
         {
            this.currentModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
         }
         else
         {
            this.currentModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
      }
      
      private function fillToShopCarInfo(param1:ShopItemInfo) : ShopCarItemInfo
      {
         var _loc2_:ShopCarItemInfo = new ShopCarItemInfo(param1.GoodsID,param1.TemplateID);
         ObjectUtils.copyProperties(_loc2_,param1);
         return _loc2_;
      }
      
      private function findEquip(param1:Number, param2:Array) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].TemplateID == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function init() : void
      {
         this.initBodyThing();
         if(this._self.Sex)
         {
            if(this._defaultModel == 1)
            {
               this._manModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._manModel.Bag.items = this._bodyThings;
            }
            else
            {
               this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
               this._manModel.Bag.items = new DictionaryData();
            }
            this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
         else
         {
            this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
            if(this._defaultModel == 1)
            {
               this._womanModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.Bag.items = this._bodyThings;
            }
            else
            {
               this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
               this._womanModel.Bag.items = new DictionaryData();
            }
         }
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
      }
      
      private function initBodyThing() : void
      {
         var _loc1_:InventoryItemInfo = null;
         this._bodyThings = new DictionaryData();
         for each(_loc1_ in this._self.Bag.items)
         {
            if(_loc1_.Place <= 30)
            {
               this._bodyThings.add(_loc1_.Place,_loc1_);
            }
         }
      }
      
      private function saveTriedList() : void
      {
         if(this.currentModel.Sex)
         {
            this._manMemoryList = this.currentTempList.concat();
         }
         else
         {
            this._womanMemoryList = this.currentTempList.concat();
         }
      }
      
      public function getBagItems(param1:int, param2:Boolean = false) : int
      {
         var _loc3_:Array = [0,2,4,11,1,3,5,13];
         if(!param2)
         {
            return _loc3_[param1] != null ? int(int(_loc3_[param1])) : int(int(-1));
         }
         return _loc3_.indexOf(param1);
      }
   }
}
