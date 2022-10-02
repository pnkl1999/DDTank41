package cardSystem.view.cardBag
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CardBagView extends Sprite implements Disposeable
   {
       
      
      private var _sortBtn:BaseButton;
      
      private var _collectBtn:BaseButton;
      
      private var _BG:Bitmap;
      
      private var _title:Bitmap;
      
      private var _bagList:OutMainListPanel;
      
      public function CardBagView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.cardBag.BG");
         this._title = ComponentFactory.Instance.creatBitmap("asset.cardBag.word");
         this._sortBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.sortbtn");
         this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.collectBtn");
         this._bagList = ComponentFactory.Instance.creatComponentByStylename("cardSyste.cardBagList");
         addChild(this._BG);
         addChild(this._title);
         addChild(this._sortBtn);
         addChild(this._collectBtn);
         addChild(this._bagList);
         this._bagList.vectorListModel.appendAll(CardControl.Instance.model.getBagListData());
         DragManager.ListenWheelEvent(this._bagList.onMouseWheel);
         DragManager.changeCardState(CardControl.Instance.setSignLockedCardNone);
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._sortBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._sortBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __collectHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CardControl.Instance.showCollectView();
      }
      
      private function __upData(param1:DictionaryEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(int(_loc2_.Place / 4 - 2)) : int(int(_loc2_.Place / 4 - 1));
         var _loc4_:int = _loc2_.Place % 4 == 0 ? int(int(4)) : int(int(_loc2_.Place % 4));
         if(this._bagList.vectorListModel.elements[_loc3_] == null)
         {
            _loc5_ = new Array();
            _loc5_[0] = _loc3_ + 1;
            _loc5_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.append(_loc5_);
         }
         else
         {
            _loc6_ = this._bagList.vectorListModel.elements[_loc3_] as Array;
            _loc6_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.replaceAt(_loc3_,_loc6_);
         }
      }
      
      private function __remove(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(int(_loc2_.Place / 4 - 2)) : int(int(_loc2_.Place / 4 - 1));
         var _loc4_:int = _loc2_.Place % 4 == 0 ? int(int(4)) : int(int(_loc2_.Place % 4));
         var _loc5_:Array = this._bagList.vectorListModel.elements[_loc3_] as Array;
         _loc5_[_loc4_] = null;
         this._bagList.vectorListModel.replaceAt(_loc3_,_loc5_);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:DictionaryData = null;
         var _loc8_:CardInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc3_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].cardIdVec;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = PlayerManager.Instance.Self.cardBagDic;
               for each(_loc8_ in _loc7_)
               {
                  if(_loc8_.TemplateID == _loc5_[_loc6_])
                  {
                     _loc2_.push(_loc8_.Place);
                     break;
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
         SocketManager.Instance.out.sendSortCards(_loc2_);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         DragManager.removeListenWheelEvent();
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._sortBtn)
         {
            ObjectUtils.disposeObject(this._sortBtn);
         }
         this._sortBtn = null;
         if(this._collectBtn)
         {
            ObjectUtils.disposeObject(this._collectBtn);
         }
         this._collectBtn = null;
         if(this._bagList)
         {
            this._bagList.dispose();
         }
         this._bagList = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
