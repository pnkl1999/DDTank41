package store.view.storeBag
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.StoreIIEvent;
   import store.view.ConsortiaRateManager;
   
   public class StoreSingleBagListView extends StoreBagListView
   {
      
      public static const SINGLEBAG:int = 49;
       
      
      private var _categoryID:Number = -1;
      
      private var _showLight:Boolean = false;
      
      public function StoreSingleBagListView()
      {
         super();
      }
      
      override protected function createPanel() : void
      {
         panel = ComponentFactory.Instance.creat("store.bagSingleScrollPanel");
         addChild(panel);
         panel.hScrollProxy = ScrollPanel.OFF;
         panel.vScrollProxy = ScrollPanel.ON;
         ConsortiaRateManager.instance.addEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
      }
      
      private function __showLight(param1:StoreIIEvent) : void
      {
         if(param1.data)
         {
            this._categoryID = param1.data.CategoryID;
            this._showLight = param1.bool;
         }
         else
         {
            this._categoryID = -1;
            this._showLight = param1.bool;
         }
         this.showLight(this._categoryID,this._showLight);
      }
      
      private function showLight(param1:Number, param2:Boolean) : void
      {
         var _loc3_:StoreBagCell = null;
         var _loc4_:StoreBagCell = null;
         var _loc5_:StoreBagCell = null;
         for each(_loc3_ in _cells)
         {
            _loc3_.light = false;
         }
         if(param1 != -1)
         {
            for each(_loc4_ in _cells)
            {
               if(_loc4_.info && _loc4_.info.CategoryID == param1)
               {
                  _loc4_.light = param2;
               }
            }
         }
         else
         {
            for each(_loc5_ in _cells)
            {
               _loc5_.light = param2;
            }
         }
      }
      
      override public function dispose() : void
      {
         ConsortiaRateManager.instance.removeEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
         super.dispose();
      }
      
      override protected function __addGoods(param1:DictionaryEvent) : void
      {
         super.__addGoods(param1);
         this.showLight(this._categoryID,this._showLight);
      }
      
      override protected function __removeGoods(param1:StoreBagEvent) : void
      {
         super.__removeGoods(param1);
         this.showLight(this._categoryID,this._showLight);
      }
   }
}
