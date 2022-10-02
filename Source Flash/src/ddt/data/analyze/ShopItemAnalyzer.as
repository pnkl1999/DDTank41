package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ShopItemAnalyzer extends DataAnalyzer
   {
       
      
      public var shopinfolist:DictionaryData;
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this.shopinfolist = new DictionaryData();
            this._shoplist = this._xml.Store..Item;
            this.parseShop(null);
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function parseShop(param1:Event) : void
      {
         this._timer = new Timer(30);
         this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
         this._timer.start();
      }
      
      private function __partexceute(param1:TimerEvent) : void
      {
         var _loc3_:ShopItemInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < 40)
         {
            this.index++;
            if(this.index < this._shoplist.length())
            {
               _loc3_ = new ShopItemInfo(int(this._shoplist[this.index].@ID),int(this._shoplist[this.index].@TemplateID));
               ObjectUtils.copyPorpertiesByXML(_loc3_,this._shoplist[this.index]);
               this.shopinfolist.add(_loc3_.GoodsID,_loc3_);
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
   }
}
