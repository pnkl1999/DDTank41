package ddt.data.goods
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.utils.DateUtils;
   
   public class ShopItemInfo extends EventDispatcher
   {
      
      public static const DAY:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
      
      public static const AMOUNT:String = LanguageMgr.GetTranslation("ge");
      
      public static const FOREVER:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
       
      
      public var ShopID:int;
      
      public var GoodsID:int;
      
      public var TemplateID:int;
      
      public var BuyType:int;
      
      public var Sort:int;
      
      public var IsBind:int;
      
      public var Label:int;
      
      public var IsCheap:Boolean;
      
      public var Beat:Number;
      
      public var AUnit:int;
      
      public var APrice1:int;
      
      public var AValue1:int;
      
      public var APrice2:int;
      
      public var AValue2:int;
      
      public var APrice3:int;
      
      public var AValue3:int;
      
      public var BUnit:int;
      
      public var BPrice1:int;
      
      public var BValue1:int;
      
      public var BPrice2:int;
      
      public var BValue2:int;
      
      public var BPrice3:int;
      
      public var BValue3:int;
      
      public var IsContinue:Boolean;
      
      public var CUnit:int;
      
      public var CPrice1:int;
      
      public var CValue1:int;
      
      public var CPrice2:int;
      
      public var CValue2:int;
      
      public var CPrice3:int;
      
      public var CValue3:int;
      
      public var StartDate:String;
      
      public var EndDate:String;
      
      private var _templateInfo:ItemTemplateInfo;
      
      private var _itemPrice:ItemPrice;
      
      private var _count:int = -1;
      
      private var _limitGrade:int;
	  
	  public var isDiscount:int = 1;
      
      public function ShopItemInfo(param1:int, param2:int)
      {
         super();
         this.GoodsID = param1;
         this.TemplateID = param2;
      }
      
      public function get isValid() : Boolean
      {
         var _loc1_:Date = DateUtils.decodeDated(this.StartDate);
         var _loc2_:Date = DateUtils.decodeDated(this.EndDate);
         if(TimeManager.Instance.Now().time < _loc2_.time && TimeManager.Instance.Now().time >= _loc1_.time)
         {
            return true;
         }
         return false;
      }
      
      public function set TemplateInfo(param1:ItemTemplateInfo) : void
      {
         this._templateInfo = param1;
      }
      
      public function get TemplateInfo() : ItemTemplateInfo
      {
         if(this._templateInfo == null)
         {
            return ItemManager.Instance.getTemplateById(this.TemplateID);
         }
         return this._templateInfo;
      }
      
      public function getItemPrice(param1:int) : ItemPrice
      {
         switch(param1)
         {
            case 1:
               return new ItemPrice(this.AUnit == -1 ? null : new Price(this.AValue1 * this.Beat,this.APrice1),this.AUnit == -1 ? null : new Price(this.AValue2 * this.Beat,this.APrice2),this.AUnit == -1 ? null : new Price(this.AValue3 * this.Beat,this.APrice3));
            case 2:
               return new ItemPrice(this.BUnit == -1 ? null : new Price(this.BValue1 * this.Beat,this.BPrice1),this.BUnit == -1 ? null : new Price(this.BValue2 * this.Beat,this.BPrice2),this.BUnit == -1 ? null : new Price(this.BValue3 * this.Beat,this.BPrice3));
            case 3:
               return new ItemPrice(this.CUnit == -1 ? null : new Price(this.CValue1 * this.Beat,this.CPrice1),this.CUnit == -1 ? null : new Price(this.CValue2 * this.Beat,this.CPrice2),this.CUnit == -1 ? null : new Price(this.CValue3 * this.Beat,this.CPrice3));
            default:
               return new ItemPrice(new Price(this.AValue1,this.APrice1),new Price(this.AValue2,this.APrice2),new Price(this.AValue3,this.APrice3));
         }
      }
      
      public function isFreeShopItem() : Boolean
      {
         if(this.getItemPrice(1).toString() == "" && this.getItemPrice(2).toString() == "" && this.getItemPrice(3).toString() == "")
         {
            return true;
         }
         return false;
      }
      
      public function getTimeToString(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return this.AUnit == 0 ? FOREVER : this.AUnit.toString() + this.buyTypeToString;
            case 2:
               return this.BUnit == 0 ? FOREVER : this.BUnit.toString() + this.buyTypeToString;
            case 3:
               return this.CUnit == 0 ? FOREVER : this.CUnit.toString() + this.buyTypeToString;
            default:
               return "";
         }
      }
      
      public function get buyTypeToString() : String
      {
         if(this.BuyType == 0)
         {
            return DAY;
         }
         return AMOUNT;
      }
      
      public function get LimitCount() : int
      {
         return this._count;
      }
      
      public function get isFree() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ += this.getItemPrice(_loc2_).moneyValue;
            _loc1_ += this.getItemPrice(_loc2_).goldValue;
            _loc1_ += this.getItemPrice(_loc2_).medalValue;
            _loc1_ += this.getItemPrice(_loc2_).giftValue;
            _loc2_++;
         }
         return _loc1_ <= 0;
      }
      
      public function set LimitCount(param1:int) : void
      {
         if(this._count == param1)
         {
            return;
         }
         this._count = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function CloneShopItem() : ShopItemInfo
      {
         var _loc1_:ShopItemInfo = null;
         _loc1_ = new ShopItemInfo(this.GoodsID,this.GoodsID);
         ObjectUtils.copyProperties(_loc1_,this);
         return _loc1_;
      }
      
      public function get LimitGrade() : int
      {
         return this._limitGrade;
      }
      
      public function set LimitGrade(param1:int) : void
      {
         this._limitGrade = param1;
      }
   }
}
