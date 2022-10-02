package giftSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.display.Sprite;
   import giftSystem.element.GiftGoodItem;
   
   public class GiftGoodsListView extends Sprite implements Disposeable
   {
       
      
      private var _containerAll:VBox;
      
      private var _container:Vector.<HBox>;
      
      public function GiftGoodsListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._container = new Vector.<HBox>();
         this._containerAll = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.containerAll");
         addChild(this._containerAll);
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc5_:GiftGoodItem = null;
         this.clear();
         this._container = new Vector.<HBox>();
         var _loc2_:int = 0;
         var _loc3_:int = param1.length < 6 ? int(int(param1.length)) : int(int(6));
         var _loc4_:int = 0;
         while(_loc4_ < 6)
         {
            if(_loc4_ % 2 == 0)
            {
               _loc2_ = _loc4_ / 2;
               this._container[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.container");
               this._containerAll.addChild(this._container[_loc2_]);
            }
            _loc5_ = new GiftGoodItem();
            if(_loc4_ < _loc3_)
            {
               _loc5_.info = param1[_loc4_];
            }
            this._container[_loc2_].addChild(_loc5_);
            _loc4_++;
         }
      }
      
      private function clear() : void
      {
         var _loc1_:int = 0;
         ObjectUtils.disposeAllChildren(this._containerAll);
         if(this._container.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               this._container[_loc1_] = null;
               _loc1_++;
            }
         }
         this._container = null;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         if(this._containerAll)
         {
            ObjectUtils.disposeObject(this._containerAll);
         }
         this._containerAll = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
