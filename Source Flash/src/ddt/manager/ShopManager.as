package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import gemstone.GemstoneManager;
   
   public class ShopManager extends EventDispatcher
   {
      
      private static var _instance:ShopManager;
       
      
      public var initialized:Boolean = false;
      
      private var _shopGoods:DictionaryData;
      
      private var _shopSortList:Dictionary;
      
      private var _shopRealTimesDisCountGoods:Dictionary;
      
      public function ShopManager(param1:SingletonEnfocer)
      {
         super();
      }
      
      public static function get Instance() : ShopManager
      {
         if(_instance == null)
         {
            _instance = new ShopManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      public function setup(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
         this.initialized = true;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT,this.__updateGoodsCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,this.__updateGoodsDisCount);
      }
      
      public function updateShopGoods(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
      }
      
      public function sortShopItems(param1:ShopItemSortAnalyzer) : void
      {
         this._shopSortList = param1.shopSortedGoods;
      }
      
      public function getResultPages(param1:int, param2:int = 8) : int
      {
         var _loc3_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         return int(Math.ceil(_loc3_.length / param2));
      }
      
      public function buyIt(param1:Array) : Array
      {
         var _loc8_:ShopCarItemInfo = null;
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.Gold;
         var _loc5_:int = _loc2_.Money;
         var _loc6_:int = _loc2_.Gift;
         var _loc7_:int = _loc2_.medal;
         for each(_loc8_ in param1)
         {
            if(_loc4_ >= _loc8_.getItemPrice(_loc8_.currentBuyType).goldValue && _loc5_ >= _loc8_.getItemPrice(_loc8_.currentBuyType).moneyValue && _loc6_ >= _loc8_.getItemPrice(_loc8_.currentBuyType).giftValue && _loc7_ >= _loc8_.getItemPrice(_loc8_.currentBuyType).medalValue)
            {
               _loc4_ -= _loc8_.getItemPrice(_loc8_.currentBuyType).goldValue;
               _loc5_ -= _loc8_.getItemPrice(_loc8_.currentBuyType).moneyValue;
               _loc6_ -= _loc8_.getItemPrice(_loc8_.currentBuyType).giftValue;
               _loc7_ -= _loc8_.getItemPrice(_loc8_.currentBuyType).medalValue;
               _loc3_.push(_loc8_);
            }
         }
         return _loc3_;
      }
      
      public function giveGift(param1:Array, param2:SelfInfo) : Array
      {
         var _loc5_:ItemPrice = null;
         var _loc6_:ShopCarItemInfo = null;
         var _loc3_:Array = [];
         var _loc4_:int = param2.Money;
         for each(_loc6_ in param1)
         {
            _loc5_ = _loc6_.getItemPrice(_loc6_.currentBuyType);
            if(_loc4_ >= _loc5_.moneyValue && _loc5_.giftValue == 0 && _loc5_.goldValue == 0 && _loc5_.getOtherValue(EquipType.MEDAL) == 0)
            {
               _loc4_ -= _loc5_.moneyValue;
               _loc3_.push(_loc6_);
            }
         }
         return _loc3_;
      }
      
      private function __updateGoodsCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:ShopItemInfo = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:ShopItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = StateManager.currentStateType == StateType.CONSORTIA ? int(int(2)) : int(int(1));
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = this.getShopItemByGoodsID(_loc10_);
            if(_loc12_ && _loc3_ == 1)
            {
               _loc12_.LimitCount = _loc11_;
            }
            _loc5_++;
         }
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc13_ = _loc2_.readInt();
            _loc14_ = _loc2_.readInt();
            _loc15_ = this.getShopItemByGoodsID(_loc13_);
            if(_loc15_ && _loc3_ == 2 && _loc6_ == PlayerManager.Instance.Self.ConsortiaID)
            {
               _loc15_.LimitCount = _loc14_;
            }
            _loc8_++;
         }
         var _loc9_:int = _loc2_.readInt();
		 GemstoneManager.Instance.upDataFitCount();
      }
      
      public function getShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.GoodsID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getCloneShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc2_:ShopItemInfo = null;
         for each(_loc3_ in this._shopGoods)
         {
            if(_loc3_.GoodsID == param1)
            {
               _loc2_ = new ShopItemInfo(_loc3_.GoodsID,_loc3_.GoodsID);
               ObjectUtils.copyProperties(_loc2_,_loc3_);
               break;
            }
         }
         return _loc2_;
      }
      
      public function getValidSortedGoodsByType(param1:int, param2:int, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc5_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         var _loc6_:int = Math.ceil(_loc5_.length / param3);
         if(param2 > 0 && param2 <= _loc6_)
         {
            _loc7_ = 0 + param3 * (param2 - 1);
            _loc8_ = Math.min(_loc5_.length - _loc7_,8);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc4_.push(_loc5_[_loc7_ + _loc9_]);
               _loc9_++;
            }
         }
         return this.usediscountgoods(_loc4_);
      }
      
      public function getGoodsByType(param1:int) : Vector.<ShopItemInfo>
      {
         return this.usediscountgoods(this._shopSortList[param1] as Vector.<ShopItemInfo>);
      }
      
      public function getValidGoodByType(param1:int) : Vector.<ShopItemInfo>
      {
         var _loc4_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc3_:Vector.<ShopItemInfo> = this._shopSortList[param1];
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isValid)
            {
               _loc2_.push(_loc4_);
            }
         }
         return this.usediscountgoods(_loc2_);
      }
      
      public function consortiaShopLevelTemplates(param1:int) : Vector.<ShopItemInfo>
      {
         return this.usediscountgoods(this._shopSortList[ShopType.GUILD_SHOP_1 + param1 - 1] as Vector.<ShopItemInfo>);
      }
      
      public function canAddPrice(param1:int) : Boolean
      {
         if(!this.getGoodsByTemplateID(param1) || !this.getGoodsByTemplateID(param1).IsContinue)
         {
            return false;
         }
         if(this.getShopRechargeItemByTemplateId(param1).length <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function getShopRechargeItemByTemplateId(param1:int) : Array
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = this._shopSortList[ShopType.RECHARGE];
         var _loc3_:Array = [];
         for each(_loc4_ in this._shopSortList[ShopType.RECHARGE])
         {
            if(_loc4_.TemplateID == param1 && _loc4_.IsContinue)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length > 0)
         {
            return _loc3_;
         }
         for each(_loc5_ in this._shopGoods)
         {
            if(_loc5_.TemplateID == param1 && _loc5_.getItemPrice(1).moneyValue > 0 && _loc5_.IsContinue)
            {
               _loc3_.push(_loc5_);
            }
         }
         for each(_loc6_ in this._shopGoods)
         {
            if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).giftValue > 0 && _loc6_.IsContinue)
            {
               _loc3_.push(_loc6_);
            }
         }
		 for each(var item7:ShopItemInfo in this._shopGoods)
		 {
			 if(item7.TemplateID == param1 && item7.getItemPrice(1).medalValue > 0 && item7.IsContinue)
			 {
				 _loc3_.push(item7);
			 }
		 }
         return this.usediscountgoodsByArr(_loc3_);
      }
      
      public function getMoneyShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).moneyValue > 0)
                  {
                     return this.usediscountGoodsByID(_loc6_);
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).moneyValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_);
                  }
               }
            }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateIDForGiftSystem(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getGoodsByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getGiftShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1)
                  {
                     if(_loc6_.getItemPrice(1).giftValue > 0)
                     {
                        return this.usediscountGoodsByID(_loc6_);
                     }
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).giftValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_);
                  }
               }
            }
         }
         return null;
      }
      
      private function getType(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         if(param1 is Array)
         {
            for each(_loc3_ in param1)
            {
               _loc2_ = _loc2_.concat(this.getType(_loc3_));
            }
         }
         else
         {
            _loc2_.push(param1);
         }
         return _loc2_;
      }
      
      public function getMedalShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).medalValue > 0)
                  {
                     return this.usediscountGoodsByID(_loc6_);
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).medalValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_) as ShopItemInfo;
                  }
               }
            }
         }
         return null;
      }
      
      public function getGoldShopItemByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopSortList[ShopType.ROOM_PROP])
         {
            if(_loc2_.TemplateID == param1)
            {
               if(_loc2_.isValid)
               {
                  return this.usediscountGoodsByID(_loc2_) as ShopItemInfo;
               }
            }
         }
         return null;
      }
      
      public function moneyGoods(param1:Array, param2:SelfInfo) : Array
      {
         var _loc4_:ItemPrice = null;
         var _loc5_:ShopCarItemInfo = null;
         var _loc3_:Array = [];
         for each(_loc5_ in param1)
         {
            _loc4_ = _loc5_.getItemPrice(_loc5_.currentBuyType);
            if(_loc4_.moneyValue > 0)
            {
               _loc3_.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      public function buyLeastGood(param1:Array, param2:SelfInfo) : Boolean
      {
         var _loc3_:ShopCarItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(param2.Gold >= _loc3_.getItemPrice(_loc3_.currentBuyType).goldValue && param2.Money >= _loc3_.getItemPrice(_loc3_.currentBuyType).moneyValue && param2.Gift >= _loc3_.getItemPrice(_loc3_.currentBuyType).giftValue && param2.medal >= _loc3_.getItemPrice(_loc3_.currentBuyType).getOtherValue(EquipType.MEDAL))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getDesignatedAllShopItem(param1:Array) : Vector.<ShopItemInfo>
      {
         var _loc4_:int = 0;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = int(param1[_loc3_]);
            _loc2_ = _loc2_.concat(this.getGoodsByType(_loc4_));
            _loc3_++;
         }
         return this.usediscountgoods(_loc2_);
      }
      
      public function fuzzySearch(param1:Vector.<ShopItemInfo>, param2:String) : Vector.<ShopItemInfo>
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:ShopItemInfo = null;
         var _loc3_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc4_ in param1)
         {
            if(_loc4_.isValid && _loc4_.TemplateInfo)
            {
               _loc5_ = _loc4_.TemplateInfo.Name.indexOf(param2);
               if(_loc5_ > -1)
               {
                  _loc6_ = true;
                  for each(_loc7_ in _loc3_)
                  {
                     if(_loc7_.GoodsID == _loc4_.GoodsID)
                     {
                        _loc6_ = false;
                     }
                  }
                  if(_loc6_)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
            }
         }
         return this.usediscountgoods(_loc3_);
      }
      
      private function usediscountgoods(param1:Vector.<ShopItemInfo>) : Vector.<ShopItemInfo>
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = param1.concat();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            for each(_loc5_ in this._shopRealTimesDisCountGoods)
            {
               if(_loc5_.isValid && _loc4_.GoodsID == _loc5_.GoodsID)
               {
                  _loc2_[_loc3_] = _loc5_;
                  break;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function usediscountgoodsByArr(param1:Array) : Array
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc2_:Array = param1.concat();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            for each(_loc5_ in this._shopRealTimesDisCountGoods)
            {
               if(_loc5_.isValid && _loc4_.GoodsID == _loc5_.GoodsID)
               {
                  _loc2_[_loc3_] = _loc5_;
                  break;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function usediscountGoodsByID(param1:ShopItemInfo) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopRealTimesDisCountGoods)
         {
            if(_loc2_.isValid && param1.GoodsID == _loc2_.GoodsID)
            {
               return _loc2_;
            }
         }
         return param1;
      }
      
      private function __updateGoodsDisCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["rnd"] = Math.random();
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         _loc3_.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount,false);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function updateRealTimesItemsByDisCount(param1:ShopItemDisCountAnalyzer) : void
      {
         this._shopRealTimesDisCountGoods = param1.shopDisCountGoods;
      }
      
      public function getShopItemByTemplateID(param1:int, param2:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         switch(param2)
         {
            case 1:
               for each(_loc3_ in this._shopGoods)
               {
                  if(_loc3_.TemplateID == param1 && _loc3_.getItemPrice(1).hardCurrencyValue > 0)
                  {
                     if(_loc3_.isValid)
                     {
                        return _loc3_;
                     }
                  }
               }
               break;
            case 2:
               for each(_loc4_ in this._shopGoods)
               {
                  if(_loc4_.TemplateID == param1 && _loc4_.getItemPrice(1).gesteValue > 0)
                  {
                     if(_loc4_.isValid)
                     {
                        return _loc4_;
                     }
                  }
               }
               break;
            case 3:
               return this.getMoneyShopItemByTemplateID(param1);
            case 5:
               for each(_loc5_ in this._shopGoods)
               {
                  if(_loc5_.TemplateID == param1 && _loc5_.getItemPrice(1).scoreValue > 0)
                  {
                     if(_loc5_.isValid)
                     {
                        return _loc5_;
                     }
                  }
               }
         }
         return null;
      }
	  
	  public function getDisCountValidGoodByType(param1:int) : Vector.<ShopItemInfo>
	  {
		  var loc3:DictionaryData = null;
		  var loc4:ShopItemInfo = null;
		  var loc5:ShopItemInfo = null;
		  var loc6:ShopItemInfo = null;
		  var loc7:ShopItemInfo = null;
		  var loc2:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
		  if(param1 != 1)
		  {
			  loc3 = this._shopRealTimesDisCountGoods[param1];
			  if(loc3)
			  {
				  for each(loc4 in loc3.list)
				  {
					  if(loc4.isValid && loc4.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
					  {
						  loc2.push(loc4);
					  }
				  }
			  }
			  return loc2;
		  }
		  if(param1 == 1)
		  {
			  loc3 = this._shopRealTimesDisCountGoods[param1];
			  if(loc3)
			  {
				  for each(loc5 in loc3.list)
				  {
					  if(loc5.isValid && loc5.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
					  {
						  loc2.push(loc5);
					  }
				  }
			  }
			  loc3 = this._shopRealTimesDisCountGoods[8];
			  if(loc3)
			  {
				  for each(loc6 in loc3.list)
				  {
					  if(loc6.isValid && loc6.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
					  {
						  loc2.push(loc6);
					  }
				  }
			  }
			  loc3 = this._shopRealTimesDisCountGoods[9];
			  if(loc3)
			  {
				  for each(loc7 in loc3.list)
				  {
					  if(loc7.isValid && loc7.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
					  {
						  loc2.push(loc7);
					  }
				  }
			  }
			  return loc2;
		  }
		  return loc2;
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
