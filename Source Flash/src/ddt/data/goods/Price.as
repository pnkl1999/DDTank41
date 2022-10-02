package ddt.data.goods
{
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class Price
   {
      
      public static const MONEY:int = -1;
      
      public static const GOLD:int = -2;
      
      public static const GESTE:int = -3;
      
      public static const GIFT:int = -4;
      
      public static const MEDAL:int = -5;
      
      public static const SCORE:int = -6;
	  
	  public static const WORLDBOSS_SCORE:int = -7;
      
      public static const PETSCORE:int = -8;
      
      public static const HARD_CURRENCY:int = -900;
      
      public static const MONEYTOSTRING:String = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
      
      public static const GOLDTOSTRING:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold");
      
      public static const GESTETOSTRING:String = LanguageMgr.GetTranslation("gongxun");
      
      public static const GIFTTOSTRING:String = LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken");
      
      public static const SCORETOSTRING:String = LanguageMgr.GetTranslation("tank.gameover.takecard.score");
      
      public static const PETSCORETOSTRING:String = LanguageMgr.GetTranslation("ddt.farm.petScore");
      
      public static const HARD_CURRENCY_TO_STRING:String = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
       
      
      private var _value:int;
      
      private var _unit:int;
      
      public function Price(param1:int, param2:int)
      {
         super();
         this._value = param1;
         this._unit = param2;
      }
      
      public function clone() : Price
      {
         return new Price(this._value,this._unit);
      }
      
      public function get Value() : int
      {
         return this._value;
      }
      
      public function get Unit() : int
      {
         return this._unit;
      }
      
      public function get UnitToString() : String
      {
         if(this._unit == MONEY)
         {
            return MONEYTOSTRING;
         }
         if(this._unit == GOLD)
         {
            return GOLDTOSTRING;
         }
         if(this._unit == GESTE)
         {
            return GESTETOSTRING;
         }
         if(this._unit == GIFT)
         {
            return GIFTTOSTRING;
         }
         if(this._unit == SCORE || this._unit == WORLDBOSS_SCORE)
         {
            return SCORETOSTRING;
         }
         if(this._unit == PETSCORE)
         {
            return PETSCORETOSTRING;
         }
         if(this._unit == HARD_CURRENCY)
         {
            return HARD_CURRENCY_TO_STRING;
         }
         if(ItemManager.Instance.getTemplateById(this._unit))
         {
            return ItemManager.Instance.getTemplateById(this._unit).Name;
         }
         return LanguageMgr.GetTranslation("wrongUnit");
      }
   }
}
