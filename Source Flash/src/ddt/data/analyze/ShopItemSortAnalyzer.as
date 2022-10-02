package ddt.data.analyze
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ShopItemSortAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      public var shopSortedGoods:Dictionary;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemSortAnalyzer(param1:Function)
      {
         super(param1);
         this.shopSortedGoods = new Dictionary();
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this._shoplist = this._xml.Store..Item;
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
         var _loc5_:ShopItemInfo = null;
         var _loc6_:BaseAlerFrame = null;
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
               _loc3_ = int(this._shoplist[this.index].@Type);
               _loc4_ = int(this._shoplist[this.index].@ShopId);
               _loc5_ = ShopManager.Instance.getShopItemByGoodsID(_loc4_);
               if(_loc5_ != null)
               {
                  this.addToList(_loc3_,_loc5_);
               }
               else
               {
                  _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.DataError.NoGood") + _loc4_);
                  _loc6_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
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
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.target);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
      }
      
      private function addToList(param1:int, param2:ShopItemInfo) : void
      {
         var _loc3_:Vector.<ShopItemInfo> = this.shopSortedGoods[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<ShopItemInfo>();
            this.shopSortedGoods[param1] = _loc3_;
         }
         _loc3_.push(param2);
      }
   }
}
