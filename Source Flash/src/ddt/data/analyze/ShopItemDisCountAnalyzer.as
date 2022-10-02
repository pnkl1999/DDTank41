package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ShopItemDisCountAnalyzer extends DataAnalyzer
   {
      
      public static var shopDisCountGoods_Backup:Dictionary;
      
      public static var isLoginRqest:Boolean = true;
       
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      public var shopDisCountGoods:Dictionary;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemDisCountAnalyzer(param1:Function, param2:Boolean = true)
      {
         super(param1);
         isLoginRqest = param2;
         this.shopDisCountGoods = new Dictionary();
         if(!shopDisCountGoods_Backup)
         {
            shopDisCountGoods_Backup = new Dictionary();
         }
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this._shoplist = this._xml..Item;
            this.parseShop();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function parseShop() : void
      {
         this._timer = new Timer(30);
         this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
         this._timer.start();
      }
      
      private function __partexceute(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ShopItemInfo = null;
         if(!ShopManager.Instance.initialized)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 40)
         {
            this.index++;
            if(this.index < this._shoplist.length())
            {
               _loc3_ = int(this._shoplist[this.index].@LableType);
               _loc4_ = int(this._shoplist[this.index].@ID);
               _loc5_ = Number(this._shoplist[this.index].@PriceMultiple);
               _loc6_ = this._shoplist[this.index].@StartDate;
               _loc7_ = this._shoplist[this.index].@EndDate;
               _loc8_ = ShopManager.Instance.getCloneShopItemByGoodsID(_loc4_);
               if(_loc8_ != null)
               {
                  if(this.isInDiscountGoods(_loc8_.GoodsID))
                  {
                     _loc8_ = (shopDisCountGoods_Backup[_loc8_.GoodsID] as ShopItemInfo).CloneShopItem();
                  }
                  else if(!this.isInDiscountGoods(_loc8_.GoodsID) && !isLoginRqest)
                  {
                     shopDisCountGoods_Backup[_loc4_] = ShopManager.Instance.getCloneShopItemByGoodsID(_loc4_);
                  }
                  if(isLoginRqest)
                  {
                     shopDisCountGoods_Backup[_loc4_] = ShopManager.Instance.getCloneShopItemByGoodsID(_loc4_);
                  }
                  _loc8_.AValue1 = _loc8_.AValue1 * _loc5_;
                  _loc8_.BValue1 = _loc8_.BValue1 * _loc5_;
                  _loc8_.CValue1 = _loc8_.CValue1 * _loc5_;
                  _loc8_.StartDate = _loc6_;
                  _loc8_.EndDate = _loc7_;
                  _loc8_.Label = _loc3_;
                  this.shopDisCountGoods[_loc4_] = _loc8_;
               }
               _loc2_++;
               continue;
            }
            this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
            this._timer.stop();
            this._timer = null;
            onAnalyzeComplete();
            return;
         }
      }
      
      private function isInDiscountGoods(param1:int) : Boolean
      {
         var _loc3_:ShopItemInfo = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in shopDisCountGoods_Backup)
         {
            if(_loc3_ && _loc3_.GoodsID == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
   }
}
