package ddt.data.goods
{
   import ddt.data.EquipType;
   import ddt.manager.ItemManager;
   import flash.utils.Dictionary;
   
   public class ItemPrice
   {
       
      
      private var _prices:Dictionary;
      
      private var _pricesArr:Array;
      
      public function ItemPrice(param1:Price, param2:Price, param3:Price)
      {
         super();
         this._pricesArr = [];
         this._prices = new Dictionary();
         this.addPrice(param1);
         this.addPrice(param2);
         this.addPrice(param3);
      }
      
      public function addPrice(param1:Price) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._pricesArr.push(param1);
         if(this._prices[param1.UnitToString] == null)
         {
            this._prices[param1.UnitToString] = param1.Value;
         }
         else
         {
            this._prices[param1.UnitToString] += param1.Value;
         }
      }
      
      public function addItemPrice(param1:ItemPrice) : void
      {
         var _loc2_:Price = null;
         for each(_loc2_ in param1.pricesArr)
         {
            this.addPrice(_loc2_);
         }
      }
      
      public function multiply(param1:int) : ItemPrice
      {
         if(param1 <= 0)
         {
            throw new Error("Multiply Invalide value!");
         }
         var _loc2_:ItemPrice = this.clone();
         var _loc3_:int = 0;
         while(_loc3_ < param1 - 1)
         {
            _loc2_.addItemPrice(_loc2_.clone());
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function clone() : ItemPrice
      {
         return new ItemPrice(this._pricesArr[0],this._pricesArr[1],this._pricesArr[2]);
      }
      
      public function get pricesArr() : Array
      {
         return this._pricesArr;
      }
      
      public function get moneyValue() : int
      {
         if(this._prices[Price.MONEYTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.MONEYTOSTRING];
      }
      
      public function get ddtPetScoreValue() : int
      {
         if(this._prices[Price.PETSCORETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.PETSCORETOSTRING];
      }
      
      public function get goldValue() : int
      {
         if(this._prices[Price.GOLDTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.GOLDTOSTRING];
      }
      
      public function get gesteValue() : int
      {
         if(this._prices[Price.GESTETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.GESTETOSTRING];
      }
      
      public function get giftValue() : int
      {
         if(this._prices[Price.GIFTTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.GIFTTOSTRING];
      }
      
      public function get scoreValue() : int
      {
         if(this._prices[Price.SCORETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.SCORETOSTRING];
      }
      
      public function get hardCurrencyValue() : int
      {
         if(this._prices[Price.HARD_CURRENCY_TO_STRING] == null)
         {
            return 0;
         }
         return this._prices[Price.HARD_CURRENCY_TO_STRING];
      }
      
      public function get medalValue() : int
      {
         return this.getOtherValue(EquipType.MEDAL);
      }
      
      public function getOtherValue(param1:int) : int
      {
         var _loc2_:String = ItemManager.Instance.getTemplateById(param1).Name;
         if(this._prices[_loc2_] == null)
         {
            return 0;
         }
         return this._prices[_loc2_];
      }
      
      public function get IsValid() : Boolean
      {
         return this._pricesArr.length > 0;
      }
      
      public function get IsMixed() : Boolean
      {
         var _loc2_:* = null;
         var _loc1_:int = 0;
         for(_loc2_ in this._prices)
         {
            if(this._prices[_loc2_] > 0)
            {
               _loc1_++;
            }
         }
         return _loc1_ > 1;
      }
      
      public function get PriceType() : int
      {
         if(!this.IsMixed)
         {
            if(this.moneyValue > 0)
            {
               return Price.MONEY;
            }
            if(this.goldValue > 0)
            {
               return Price.GOLD;
            }
            if(this.gesteValue > 0)
            {
               return Price.GESTE;
            }
            if(this.giftValue > 0)
            {
               return Price.GIFT;
            }
            if(this.scoreValue > 0)
            {
               return Price.SCORE;
            }
            if(this.hardCurrencyValue > 0)
            {
               return Price.HARD_CURRENCY;
            }
            return -5;
         }
         return 0;
      }
      
      public function get IsMoneyType() : Boolean
      {
         return !this.IsMixed && this.moneyValue > 0;
      }
      
      public function get IsGoldType() : Boolean
      {
         return !this.IsMixed && this.goldValue > 0;
      }
      
      public function get IsGesteType() : Boolean
      {
         return !this.IsMixed && this.gesteValue > 0;
      }
      
      public function get IsGiftType() : Boolean
      {
         return !this.IsMixed && this.giftValue > 0;
      }
      
      public function get IsMedalType() : Boolean
      {
         return !this.IsMixed && !this.IsMoneyType && !this.IsGoldType && !this.IsGesteType && !this.IsGiftType;
      }
      
      public function toString() : String
      {
         var _loc2_:* = null;
         var _loc1_:String = "";
         if(this.moneyValue > 0)
         {
            _loc1_ += this.moneyValue.toString() + Price.MONEYTOSTRING;
         }
         if(this.goldValue > 0)
         {
            _loc1_ += this.goldValue.toString() + Price.GOLDTOSTRING;
         }
         if(this.gesteValue > 0)
         {
            _loc1_ += this.gesteValue.toString() + Price.GESTETOSTRING;
         }
         if(this.giftValue > 0)
         {
            _loc1_ += this.giftValue.toString() + Price.GIFTTOSTRING;
         }
         if(this.ddtPetScoreValue > 0)
         {
            _loc1_ += this.ddtPetScoreValue.toString() + Price.PETSCORETOSTRING;
         }
         for(_loc2_ in this._prices)
         {
            if(_loc2_ != Price.MONEYTOSTRING && _loc2_ != Price.GOLDTOSTRING && _loc2_ != Price.GESTETOSTRING && _loc2_ != Price.GIFTTOSTRING && _loc2_ != Price.PETSCORETOSTRING)
            {
               _loc1_ += this._prices[_loc2_].toString() + _loc2_;
            }
         }
         return _loc1_;
      }
   }
}
