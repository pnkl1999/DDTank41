package AvatarCollection
{
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionItemVo;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.ShopType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionManager extends EventDispatcher
   {
      
      public static const REFRESH_VIEW:String = "avatar_collection_refresh_view";
      
      private static var _instance:AvatarCollectionManager;
       
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _maleUnitList:Array;
      
      private var _femaleUnitList:Array;
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      private var _maleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _femaleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _isHasCheckedBuy:Boolean = false;
      
      public function AvatarCollectionManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : AvatarCollectionManager
      {
         if(_instance == null)
         {
            _instance = new AvatarCollectionManager();
         }
         return _instance;
      }
      
      public function get maleUnitList() : Array
      {
         return this._maleUnitList;
      }
      
      public function get femaleUnitList() : Array
      {
         return this._femaleUnitList;
      }
      
      public function getItemListById(param1:int, param2:int) : Array
      {
         if(param1 == 1)
         {
            return this._maleItemDic[param2].list;
         }
         return this._femaleItemDic[param2].list;
      }
      
      public function unitListDataSetup(param1:AvatarCollectionUnitDataAnalyzer) : void
      {
         this._maleUnitDic = param1.maleUnitDic;
         this._femaleUnitDic = param1.femaleUnitDic;
         this._maleUnitList = this._maleUnitDic.list;
         this._femaleUnitList = this._femaleUnitDic.list;
      }
      
      public function itemListDataSetup(param1:AvatarCollectionItemDataAnalyzer) : void
      {
         this._maleItemDic = param1.maleItemDic;
         this._femaleItemDic = param1.femaleItemDic;
         this._maleItemList = param1.maleItemList;
         this._femaleItemList = param1.femaleItemList;
      }
      
      public function initShopItemInfoList() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this._maleShopItemInfoList)
         {
            this._maleShopItemInfoList = new Vector.<ShopItemInfo>();
            _loc1_ = [ShopType.MONEY_M_CLOTH,ShopType.MONEY_M_HAT,ShopType.MONEY_M_GLASS,ShopType.MONEY_M_HAIR,ShopType.MONEY_M_EYES,ShopType.MONEY_M_LIANSHI];
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(_loc1_[_loc3_]));
               _loc3_++;
            }
            this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
         if(!this._femaleShopItemInfoList)
         {
            this._femaleShopItemInfoList = new Vector.<ShopItemInfo>();
            _loc4_ = [ShopType.MONEY_F_CLOTH,ShopType.MONEY_F_HAT,ShopType.MONEY_F_GLASS,ShopType.MONEY_F_HAIR,ShopType.MONEY_F_EYES,ShopType.MONEY_F_LIANSHI];
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(_loc4_[_loc6_]));
               _loc6_++;
            }
            this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
      }
      
      public function checkItemCanBuy() : void
      {
         var _loc1_:AvatarCollectionItemVo = null;
         var _loc2_:AvatarCollectionItemVo = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         if(this._isHasCheckedBuy)
         {
            return;
         }
         for each(_loc1_ in this._maleItemList)
         {
            _loc1_.canBuyStatus = 0;
            for each(_loc3_ in this._maleShopItemInfoList)
            {
               if(_loc1_.itemId == _loc3_.TemplateID)
               {
                  _loc1_.canBuyStatus = 1;
                  _loc1_.buyPrice = _loc3_.getItemPrice(1).moneyValue;
                  _loc1_.isDiscount = _loc3_.isDiscount;
                  _loc1_.goodsId = _loc3_.GoodsID;
                  break;
               }
            }
         }
         for each(_loc2_ in this._femaleItemList)
         {
            _loc2_.canBuyStatus = 0;
            for each(_loc4_ in this._femaleShopItemInfoList)
            {
               if(_loc2_.itemId == _loc4_.TemplateID)
               {
                  _loc2_.canBuyStatus = 1;
                  _loc2_.buyPrice = _loc4_.getItemPrice(1).moneyValue;
                  _loc2_.isDiscount = _loc4_.isDiscount;
                  _loc2_.goodsId = _loc4_.GoodsID;
                  break;
               }
            }
         }
         this._isHasCheckedBuy = true;
      }
      
      public function getShopItemInfoByItemId(param1:int, param2:int) : ShopItemInfo
      {
         var _loc3_:Vector.<ShopItemInfo> = null;
         var _loc4_:ShopItemInfo = null;
         if(param2 == 1)
         {
            _loc3_ = this._maleShopItemInfoList;
         }
         else
         {
            _loc3_ = this._femaleShopItemInfoList;
         }
         for each(_loc4_ in _loc3_)
         {
            if(param1 == _loc4_.TemplateID)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AVATAR_COLLECTION,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case AvatarCollectionPackageType.GET_ALL_INFO:
               this.getAllInfoHandler(_loc2_);
               break;
            case AvatarCollectionPackageType.ACTIVE:
               this.activeHandler(_loc2_);
               break;
            case AvatarCollectionPackageType.DELAY_TIME:
               this.delayTimeHandler(_loc2_);
         }
      }
      
      private function getAllInfoHandler(param1:PackageIn) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AvatarCollectionUnitVo = null;
         var _loc7_:DictionaryData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:int = param1.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readInt();
            _loc5_ = param1.readInt();
            if(_loc5_ == 1)
            {
               _loc6_ = this._maleUnitDic[_loc4_];
               _loc7_ = this._maleItemDic[_loc4_];
            }
            else
            {
               _loc6_ = this._femaleUnitDic[_loc4_];
               _loc7_ = this._femaleItemDic[_loc4_];
            }
            _loc8_ = param1.readInt();
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = param1.readInt();
               if(_loc7_[_loc10_])
               {
                  (_loc7_[_loc10_] as AvatarCollectionItemVo).isActivity = true;
               }
               _loc9_++;
            }
            _loc6_.endTime = param1.readDate();
            _loc3_++;
         }
      }
      
      private function activeHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         var _loc4_:int = param1.readInt();
         if(_loc4_ == 1)
         {
            (this._maleItemDic[_loc2_][_loc3_] as AvatarCollectionItemVo).isActivity = true;
         }
         else
         {
            (this._femaleItemDic[_loc2_][_loc3_] as AvatarCollectionItemVo).isActivity = true;
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      private function delayTimeHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         if(_loc3_ == 1)
         {
            (this._maleUnitDic[_loc2_] as AvatarCollectionUnitVo).endTime = param1.readDate();
         }
         else
         {
            (this._femaleUnitDic[_loc2_] as AvatarCollectionUnitVo).endTime = param1.readDate();
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      public function loadResModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.AVATAR_COLLECTION);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.AVATAR_COLLECTION)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.AVATAR_COLLECTION)
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
