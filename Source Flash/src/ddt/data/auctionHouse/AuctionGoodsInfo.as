package ddt.data.auctionHouse
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class AuctionGoodsInfo
   {
       
      
      public var AuctionID:int;
      
      public var AuctioneerID:int;
      
      public var AuctioneerName:String;
      
      public var ItemID:int;
      
      public var BagItemInfo:InventoryItemInfo;
      
      public var PayType:int;
      
      public var Price:int;
      
      public var Rise:int;
      
      public var Mouthful:int;
      
      private var _BeginDate:String;
      
      private var _beginDateObj:Date;
      
      public var ValidDate:int;
      
      public var BuyerID:int;
      
      public var BuyerName:String;
      
      public function AuctionGoodsInfo()
      {
         super();
      }
      
      public function set BeginDate(param1:String) : void
      {
         this._BeginDate = param1;
      }
      
      public function get BeginDate() : String
      {
         return this._BeginDate;
      }
      
      public function get beginDateObj() : Date
      {
         return this._beginDateObj == null ? DateUtils.getDateByStr(this.BeginDate) : this._beginDateObj;
      }
      
      public function set beginDateObj(param1:Date) : void
      {
         this._beginDateObj = param1;
      }
      
      public function getTimeDescription() : String
      {
         var _loc1_:String = "";
         var _loc2_:Date = new Date();
         _loc2_.setTime(this.beginDateObj.getTime());
         _loc2_.hours = this.ValidDate + _loc2_.hours;
         var _loc3_:int = Math.abs(TimeManager.Instance.TotalHoursToNow(_loc2_));
         if(_loc3_ <= 1.5)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.short");
         }
         else if(_loc3_ <= 3)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.middle");
         }
         else if(_loc3_ <= 13)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.long");
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.very");
         }
         _loc2_ = null;
         return _loc1_;
      }
      
      public function getSithTimeDescription() : String
      {
         var _loc1_:String = "";
         var _loc2_:Date = new Date();
         _loc2_.setTime(this.beginDateObj.getTime());
         _loc2_.hours = this.ValidDate + _loc2_.hours;
         var _loc3_:int = Math.abs(TimeManager.Instance.TotalHoursToNow(_loc2_));
         if(_loc3_ <= 1.5)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tshort");
         }
         else if(_loc3_ <= 3)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tmiddle");
         }
         else if(_loc3_ <= 13)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tlong");
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.auctionHouse.AuctionGoodsInfo.tvery");
         }
         _loc2_ = null;
         return _loc1_;
      }
   }
}
