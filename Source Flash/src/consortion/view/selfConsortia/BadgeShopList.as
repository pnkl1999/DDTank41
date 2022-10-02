package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import consortion.data.BadgeInfo;
   import flash.display.Sprite;
   
   public class BadgeShopList extends Sprite implements Disposeable
   {
       
      
      private var _items:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function BadgeShopList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._items = new Array();
         this._list = new VBox();
         this._panel = ComponentFactory.Instance.creat("consortion.badgeShop.panel");
         this._panel.setView(this._list);
         addChild(this._panel);
      }
      
      public function setList(param1:Array) : void
      {
         var _loc2_:BadgeShopItem = null;
         var _loc3_:BadgeInfo = null;
         var _loc4_:BadgeShopItem = null;
         for each(_loc2_ in this._items)
         {
            _loc2_.dispose();
         }
         this._items = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new BadgeShopItem(_loc3_);
            this._list.addChild(_loc4_);
            this._items.push(_loc4_);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BadgeShopItem = null;
         for each(_loc1_ in this._items)
         {
            _loc1_.dispose();
         }
         this._items = null;
         this._list.dispose();
         this._list = null;
         this._panel.dispose();
         this._panel = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
