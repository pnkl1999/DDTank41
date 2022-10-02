package cardSystem.view.cardCollect
{
   import cardSystem.CardControl;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CollectBagView extends Sprite implements Disposeable
   {
      
      public static const SELECT:String = "selected";
       
      
      private var _container:VBox;
      
      private var _collectItemVector:Vector.<CollectBagItem>;
      
      private var _turnPage:CollectTurnPage;
      
      private var _currentCollectItem:CollectBagItem;
      
      public function CollectBagView()
      {
         super();
         this.initView();
      }
      
      public function get currentItemSetsInfo() : SetsInfo
      {
         return this._currentCollectItem.setsInfo;
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("CollectBagView.container");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("CollectTurnPage");
         addChild(this._container);
         addChild(this._turnPage);
         this._collectItemVector = new Vector.<CollectBagItem>(3);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._collectItemVector[_loc1_] = new CollectBagItem();
            this._container.addChild(this._collectItemVector[_loc1_]);
            _loc1_++;
         }
         this._turnPage.addEventListener(Event.CHANGE,this.__turnPage);
         this._turnPage.maxPage = Math.ceil(CardControl.Instance.model.setsSortRuleVector.length / 3);
         this._turnPage.page = 1;
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CollectBagItem = param1.currentTarget as CollectBagItem;
         this.seleted(_loc2_);
      }
      
      private function seleted(param1:CollectBagItem) : void
      {
         this._currentCollectItem = param1;
         this._currentCollectItem.seleted = true;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(this._collectItemVector[_loc2_] != this._currentCollectItem)
            {
               this._collectItemVector[_loc2_].seleted = false;
            }
            _loc2_++;
         }
         dispatchEvent(new Event(SELECT));
      }
      
      private function setPage(param1:int) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         var _loc2_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc3_:int = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            if((param1 - 1) * 3 + _loc4_ < _loc3_)
            {
               this._collectItemVector[_loc4_].setsInfo = _loc2_[(param1 - 1) * 3 + _loc4_];
               this._collectItemVector[_loc4_].setSetsDate(CardControl.Instance.model.getSetsCardFromCardBag(_loc2_[(param1 - 1) * 3 + _loc4_].ID));
               this._collectItemVector[_loc4_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc4_].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc4_].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
            else
            {
               this._collectItemVector[_loc4_].setsInfo = null;
               this._collectItemVector[_loc4_].mouseEnabled = false;
               this._collectItemVector[_loc4_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc4_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc4_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
            _loc4_++;
         }
         this.seleted(this._collectItemVector[0]);
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as CollectBagItem).filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as CollectBagItem).filters = null;
      }
      
      private function removeEvent() : void
      {
         this._turnPage.removeEventListener(Event.CHANGE,this.__turnPage);
      }
      
      protected function __turnPage(param1:Event) : void
      {
         this.setPage(this._turnPage.page);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this._collectItemVector[_loc1_])
            {
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
               this._collectItemVector[_loc1_].dispose();
            }
            this._collectItemVector[_loc1_] = null;
            _loc1_++;
         }
         this._currentCollectItem = null;
         if(this._turnPage)
         {
            this._turnPage.dispose();
         }
         this._turnPage = null;
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
