package auctionHouse.model
{
   import auctionHouse.AuctionState;
   import auctionHouse.event.AuctionHouseEvent;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   [Event(name="changeState",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="getGoodCategory",type="auctionHouse.event.event.AuctionHouseEvent")]
   [Event(name="deleteAuction",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="addAuction",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="updatePage",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="browseTypeChange",type="auctionHouse.event.AuctionHouseEvent")]
   public class AuctionHouseModel extends EventDispatcher
   {
      
      public static var searchType:int;
      
      public static var SINGLE_PAGE_NUM:int = 20;
      
      public static var _dimBooble:Boolean;
       
      
      private var _state:String;
      
      private var _categorys:Vector.<CateCoryInfo>;
      
      private var _myAuctionData:DictionaryData;
      
      private var _sellTotal:int;
      
      private var _sellCurrent:int;
      
      private var _browseAuctionData:DictionaryData;
      
      private var _browseTotal:int;
      
      private var _browseCurrent:int = 1;
      
      private var _currentBrowseGoodInfo:CateCoryInfo;
      
      private var _buyAuctionData:DictionaryData;
      
      private var _buyTotal:int;
      
      private var _buyCurrent:int = 1;
      
      public function AuctionHouseModel(param1:IEventDispatcher = null)
      {
         this._categorys = new Vector.<CateCoryInfo>();
         super(param1);
         this._state = AuctionState.BROWSE;
         this._myAuctionData = new DictionaryData();
         this._browseAuctionData = new DictionaryData();
         this._buyAuctionData = new DictionaryData();
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.CHANGE_STATE));
      }
      
      public function get category() : Vector.<CateCoryInfo>
      {
         return this._categorys.slice(0);
      }
      
      public function set category(param1:Vector.<CateCoryInfo>) : void
      {
         this._categorys = param1;
         if(param1.length != 0)
         {
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.GET_GOOD_CATEGORY));
         }
      }
      
      public function getCatecoryById(param1:int) : CateCoryInfo
      {
         var _loc2_:CateCoryInfo = null;
         for each(_loc2_ in this._categorys)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get myAuctionData() : DictionaryData
      {
         return this._myAuctionData;
      }
      
      public function addMyAuction(param1:AuctionGoodsInfo) : void
      {
         if(this._state == AuctionState.SELL)
         {
            this._myAuctionData.add(param1.AuctionID,param1);
         }
         else if(this._state == AuctionState.BROWSE)
         {
            this._browseAuctionData.add(param1.AuctionID,param1);
         }
         else if(this._state == AuctionState.BUY)
         {
            this._buyAuctionData.add(param1.AuctionID,param1);
         }
      }
      
      public function clearMyAuction() : void
      {
         this._myAuctionData.clear();
      }
      
      public function removeMyAuction(param1:AuctionGoodsInfo) : void
      {
         if(this._state == AuctionState.SELL)
         {
            this._myAuctionData.remove(param1.AuctionID);
         }
         else if(this._state == AuctionState.BROWSE)
         {
            this._browseAuctionData.remove(param1.AuctionID);
         }
         else if(this._state == AuctionState.BUY)
         {
            this._buyAuctionData.remove(param1.AuctionID);
         }
      }
      
      public function set sellTotal(param1:int) : void
      {
         this._sellTotal = param1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get sellTotal() : int
      {
         return this._sellTotal;
      }
      
      public function get sellTotalPage() : int
      {
         return Math.ceil(this._sellTotal / SINGLE_PAGE_NUM);
      }
      
      public function set sellCurrent(param1:int) : void
      {
         this._sellCurrent = param1;
      }
      
      public function get sellCurrent() : int
      {
         return this._sellCurrent;
      }
      
      public function get browseAuctionData() : DictionaryData
      {
         return this._browseAuctionData;
      }
      
      public function addBrowseAuctionData(param1:AuctionGoodsInfo) : void
      {
         this._browseAuctionData.add(param1.AuctionID,param1);
      }
      
      public function clearBrowseAuctionData() : void
      {
         this._browseAuctionData.clear();
      }
      
      public function removeBrowseAuctionData(param1:AuctionGoodsInfo) : void
      {
         this._browseAuctionData.remove(param1.AuctionID);
      }
      
      public function set browseTotal(param1:int) : void
      {
         this._browseTotal = param1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get browseTotal() : int
      {
         return this._browseTotal;
      }
      
      public function get browseTotalPage() : int
      {
         return Math.ceil(this._browseTotal / SINGLE_PAGE_NUM);
      }
      
      public function set browseCurrent(param1:int) : void
      {
         this._browseCurrent = param1;
      }
      
      public function get browseCurrent() : int
      {
         return this._browseCurrent;
      }
      
      public function get currentBrowseGoodInfo() : CateCoryInfo
      {
         return this._currentBrowseGoodInfo;
      }
      
      public function set currentBrowseGoodInfo(param1:CateCoryInfo) : void
      {
         this._currentBrowseGoodInfo = param1;
         this._browseCurrent = 1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.BROWSE_TYPE_CHANGE));
      }
      
      public function get buyAuctionData() : DictionaryData
      {
         return this._buyAuctionData;
      }
      
      public function addBuyAuctionData(param1:AuctionGoodsInfo) : void
      {
         this._buyAuctionData.add(param1.AuctionID,param1);
      }
      
      public function removeBuyAuctionData(param1:AuctionGoodsInfo) : void
      {
         this._buyAuctionData.remove(param1);
      }
      
      public function clearBuyAuctionData() : void
      {
         this._buyAuctionData.clear();
      }
      
      public function set buyTotal(param1:int) : void
      {
         this._buyTotal = param1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get buyTotal() : int
      {
         return this._buyTotal;
      }
      
      public function get buyTotalPage() : int
      {
         return Math.ceil(this._buyTotal / 50);
      }
      
      public function set buyCurrent(param1:int) : void
      {
         this._buyCurrent = param1;
      }
      
      public function get buyCurrent() : int
      {
         return this._buyCurrent;
      }
      
      public function dispose() : void
      {
         this._categorys = new Vector.<CateCoryInfo>();
         if(this._myAuctionData)
         {
            this._myAuctionData.clear();
         }
         this._myAuctionData = null;
         if(this._browseAuctionData)
         {
            this._browseAuctionData.clear();
         }
         this._browseAuctionData = null;
         if(this._buyAuctionData)
         {
            this._buyAuctionData.clear();
         }
         this._buyAuctionData = null;
      }
   }
}
