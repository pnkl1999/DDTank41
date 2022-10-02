package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.display.Sprite;
   
   public class ConsortionShopList extends Sprite implements Disposeable
   {
       
      
      private var _shopId:int;
      
      private var _items:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function ConsortionShopList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._items = new Array();
         this._list = ComponentFactory.Instance.creat("consortion.shop.list");
         this._panel = ComponentFactory.Instance.creat("consortion.shop.panel");
         this._panel.setView(this._list);
         addChild(this._panel);
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.clearList();
         ObjectUtils.disposeAllChildren(this);
         this._panel = null;
         this._list = null;
         this._items = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function list(param1:Vector.<ShopItemInfo>, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc6_:ConsortionShopItem = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ConsortionShopItem = null;
         this.clearList();
         this._shopId = param2 + 10;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = new ConsortionShopItem(param4);
            this._list.addChild(_loc6_);
            _loc6_.info = param1[_loc5_];
            _loc6_.neededRich = param3;
            this._items.push(_loc6_);
            _loc5_++;
         }
         if(param1.length < 6)
         {
            _loc7_ = 6 - param1.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = new ConsortionShopItem(param4);
               this._list.addChild(_loc9_);
               this._items.push(_loc9_);
               _loc8_++;
            }
         }
      }
      
      private function clearList() : void
      {
         var _loc1_:int = 0;
         if(this._items && this._list)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_].dispose();
               _loc1_++;
            }
            this._list.disposeAllChildren();
         }
         this._items = new Array();
      }
   }
}
