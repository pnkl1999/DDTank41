package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.view.cardCollect.CardSelectItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class CardSelect extends ChatBasePanel implements Disposeable
   {
       
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<CardSelectItem>;
      
      private var _cardIdVec:Vector.<int>;
      
      public function CardSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<CardSelectItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.CardListBg");
         this._list = new VBox();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("CardBagView.cardselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var _loc3_:CardSelectItem = null;
         var _loc1_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new CardSelectItem();
            _loc3_.info = _loc1_[_loc2_];
            _loc3_.addEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            this._itemList.push(_loc3_);
            this._list.addChild(_loc3_);
            _loc2_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(param1:CardEvent) : void
      {
         var _loc4_:SetsInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:int = param1.data.id;
         var _loc3_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for each(_loc4_ in _loc3_)
         {
            if(int(_loc4_.ID) == _loc2_)
            {
               this._cardIdVec = _loc4_.cardIdVec;
               break;
            }
         }
         if(this._cardIdVec != null)
         {
            this.moveAllCard();
         }
      }
      
      private function moveAllCard() : void
      {
         var _loc5_:DictionaryData = null;
         var _loc6_:CardInfo = null;
         var _loc7_:CardInfo = null;
         var _loc8_:int = 0;
         var _loc9_:CardInfo = null;
         var _loc1_:Vector.<CardInfo> = new Vector.<CardInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < this._cardIdVec.length)
         {
            _loc5_ = PlayerManager.Instance.Self.cardBagDic;
            _loc6_ = null;
            for each(_loc7_ in _loc5_)
            {
               if(_loc7_.TemplateID == this._cardIdVec[_loc2_])
               {
                  _loc6_ = _loc7_;
                  break;
               }
            }
            if(_loc6_ != null)
            {
               if(_loc6_.templateInfo.Property8 == "1")
               {
                  _loc1_.unshift(_loc6_);
               }
               else
               {
                  _loc1_.push(_loc6_);
               }
            }
            _loc2_++;
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noHaveCard"));
            return;
         }
         if(_loc1_[0].templateInfo.Property8 != "1")
         {
            _loc1_.unshift(_loc1_[0]);
         }
         var _loc3_:Array = this.sortPlaceSelf();
         var _loc4_:Vector.<CardInfo> = this.findCardsOutSelf(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < 5 && _loc2_ < _loc1_.length && _loc4_.length > 0)
         {
            _loc8_ = _loc3_[_loc2_];
            if(this.findCardInSelf(_loc8_,_loc1_))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
            }
            else
            {
               _loc9_ = _loc4_.shift();
               SocketManager.Instance.out.sendMoveCards(_loc9_.Place,_loc8_);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
            }
            _loc2_++;
         }
      }
      
      private function sortPlaceSelf() : Array
      {
         var _loc3_:CardInfo = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         if(PlayerManager.Instance.Self.cardEquipDic.length == 0)
         {
            return [0,1,2];
         }
         for each(_loc3_ in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(_loc3_.Count < 0 || _loc3_.templateInfo.Property8 == "1")
            {
               _loc1_.push(_loc3_.Place);
            }
            else
            {
               _loc2_.push(_loc3_.Place);
            }
         }
         return _loc1_.concat(_loc2_);
      }
      
      private function findCardInSelf(param1:int, param2:Vector.<CardInfo>) : Boolean
      {
         var _loc3_:CardInfo = null;
         var _loc4_:CardInfo = null;
         for each(_loc3_ in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(_loc3_.Count > -1 && _loc3_.Place == param1)
            {
               for each(_loc4_ in param2)
               {
                  if(_loc3_.TemplateID == _loc4_.TemplateID)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function findCardsOutSelf(param1:Vector.<CardInfo>) : Vector.<CardInfo>
      {
         var _loc3_:CardInfo = null;
         var _loc2_:Vector.<CardInfo> = new Vector.<CardInfo>();
         for each(_loc3_ in param1)
         {
            if(!this.findInfoBytemplateID(_loc3_.TemplateID,PlayerManager.Instance.Self.cardEquipDic))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function findInfoBytemplateID(param1:int, param2:Object) : Boolean
      {
         var _loc3_:CardInfo = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.Count > -1 && _loc3_.TemplateID == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function __hideThis(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this._panel.vScrollbar))
         {
            return;
         }
         SoundManager.instance.play("008");
         setVisible = false;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._panel)
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].removeEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
         this._itemList = null;
      }
   }
}
