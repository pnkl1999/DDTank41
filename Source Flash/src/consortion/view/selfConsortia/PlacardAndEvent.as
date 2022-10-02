package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import consortion.view.selfConsortia.consortiaTask.ConsortiaTaskView;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.ConsortiaEventInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import road7th.utils.StringHelper;
   
   public class PlacardAndEvent extends Sprite implements Disposeable
   {
       
      
      private var _taskBtn:SelectedButton;
      
      private var _placardBtn:SelectedButton;
      
      private var _eventBtn:SelectedButton;
      
      private var _weekOffer:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _BG:Scale9CornerImage;
      
      private var _placard:TextArea;
      
      private var _editBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _vote:BaseButton;
      
      private var _vbox:VBox;
      
      private var _eventPanel:ScrollPanel;
      
      private var _lastPlacard:String;
      
      private var _weekOfferList:ListPanel;
      
      private var _myTaskView:ConsortiaTaskView;
      
      public function PlacardAndEvent()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.BG");
         this._taskBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.taskBtn");
         this._placardBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placard");
         this._eventBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.event");
         this._weekOffer = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.weekOffer");
         this._placard = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placardText");
         this._editBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.edit");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.cancel");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventVbox");
         this._eventPanel = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventPanel");
         this._vote = ComponentFactory.Instance.creatComponentByStylename("consortion.placardAndEvent.vote");
         this._weekOfferList = ComponentFactory.Instance.creatComponentByStylename("weekOfferList.list");
         this._myTaskView = ComponentFactory.Instance.creatCustomObject("ConsortiaTaskView");
         addChild(this._BG);
         addChild(this._taskBtn);
         addChild(this._placardBtn);
         addChild(this._eventBtn);
         addChild(this._weekOffer);
         addChild(this._placard);
         addChild(this._editBtn);
         addChild(this._cancelBtn);
         addChild(this._eventPanel);
         addChild(this._vote);
         addChild(this._myTaskView);
         this._eventPanel.setView(this._vbox);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._placardBtn);
         this._btnGroup.addSelectItem(this._eventBtn);
         this._btnGroup.addSelectItem(this._weekOffer);
         this._btnGroup.addSelectItem(this._taskBtn);
         this._btnGroup.selectIndex = 3;
         this._editBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         this.showPlacardOrEvent(this._btnGroup.selectIndex);
      }
      
      private function initEvent() : void
      {
         this._taskBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._placardBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._eventBtn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._weekOffer.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._vote.addEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__groupChangeHandler);
         this._editBtn.addEventListener(MouseEvent.CLICK,this.__editHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._placard.addEventListener(MouseEvent.MOUSE_DOWN,this.__isClearHandler);
         this._placard.textField.addEventListener(Event.CHANGE,this.__inputHandler);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__placardChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__rightChangeHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function removeEvent() : void
      {
         this._taskBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._placardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._eventBtn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         this._vote.removeEventListener(MouseEvent.CLICK,this.__voteHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__groupChangeHandler);
         this._editBtn.removeEventListener(MouseEvent.CLICK,this.__editHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._placard.removeEventListener(MouseEvent.MOUSE_DOWN,this.__isClearHandler);
         this._placard.textField.removeEventListener(Event.CHANGE,this.__inputHandler);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__placardChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__rightChangeHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function __voteHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ConsortionPollFrame = ComponentFactory.Instance.creatComponentByStylename("consortionPollFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         ConsortionModelControl.Instance.loadPollList(PlayerManager.Instance.Self.ConsortiaID);
      }
      
      private function upPlacard() : void
      {
         var _loc1_:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
         this._placard.text = _loc1_ == "" ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : _loc1_;
         this._lastPlacard = this._placard.text;
         this._editBtn.enable = this._cancelBtn.enable = false;
         this._vote.visible = PlayerManager.Instance.Self.consortiaInfo.IsVoting;
         this._placard.editable = this._editBtn.visible = this._cancelBtn.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._4_Notice) && this._btnGroup.selectIndex == 0;
      }
      
      private function __btnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __groupChangeHandler(param1:Event) : void
      {
         this.showPlacardOrEvent(this._btnGroup.selectIndex);
      }
      
      private function showPlacardOrEvent(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               if(contains(this._weekOfferList))
               {
                  removeChild(this._weekOfferList);
               }
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = true;
               this._eventPanel.visible = false;
               this._myTaskView.visible = false;
               this.upPlacard();
               break;
            case 1:
               if(contains(this._weekOfferList))
               {
                  removeChild(this._weekOfferList);
               }
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = false;
               this._eventPanel.visible = true;
               this._vote.visible = false;
               this._myTaskView.visible = false;
               ConsortionModelControl.Instance.loadEventList(ConsortionModelControl.Instance.eventListComplete,PlayerManager.Instance.Self.ConsortiaID);
               break;
            case 2:
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = false;
               this._eventPanel.visible = false;
               this._vote.visible = false;
               this._myTaskView.visible = false;
               addChild(this._weekOfferList);
               this._weekOfferList.vectorListModel.clear();
               this._weekOfferList.vectorListModel.appendAll(ConsortionModelControl.Instance.model.memberList.list);
               this._weekOfferList.vectorListModel.elements.sortOn("LastWeekRichesOffer",2 | 1 | 16);
               this._weekOfferList.list.updateListView();
               break;
            case 3:
               if(contains(this._weekOfferList))
               {
                  removeChild(this._weekOfferList);
               }
               this._placard.visible = this._editBtn.visible = this._cancelBtn.visible = false;
               this._eventPanel.visible = false;
               this._vote.visible = false;
               this._myTaskView.visible = true;
         }
      }
      
      private function __eventChangeHandler(param1:ConsortionEvent) : void
      {
         var _loc5_:EventListItem = null;
         this._vbox.disposeAllChildren();
         var _loc2_:Vector.<ConsortiaEventInfo> = ConsortionModelControl.Instance.model.eventList;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new EventListItem();
            _loc5_.info = _loc2_[_loc4_];
            this._vbox.addChild(_loc5_);
            _loc4_++;
         }
         this._eventPanel.invalidateViewport();
      }
      
      private function __editHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTF(StringHelper.trim(this._placard.textField.text));
         if(_loc2_.length > 300)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame.long"));
            return;
         }
         if(FilterWordManager.isGotForbiddenWords(this._placard.textField.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
            return;
         }
         var _loc3_:String = FilterWordManager.filterWrod(this._placard.textField.text);
         _loc3_ = StringHelper.trim(_loc3_);
         SocketManager.Instance.out.sendConsortiaUpdatePlacard(_loc3_);
         this._cancelBtn.enable = false;
         this._editBtn.enable = false;
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._placard.text = this._lastPlacard;
         this._cancelBtn.enable = false;
         this._editBtn.enable = false;
      }
      
      private function __isClearHandler(param1:MouseEvent) : void
      {
         if(this._placard.editable)
         {
            this._placard.text = this._placard.text == LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") ? "" : this._placard.text;
         }
      }
      
      private function __inputHandler(param1:Event) : void
      {
         this._cancelBtn.enable = true;
         this._editBtn.enable = true;
         StringHelper.checkTextFieldLength(this._placard.textField,200);
      }
      
      private function __placardChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[ConsortiaInfo.PLACARD] || param1.changedProperties[ConsortiaInfo.IS_VOTING])
         {
            this.upPlacard();
         }
      }
      
      private function __rightChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Right"])
         {
            this.upPlacard();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._vbox.disposeAllChildren();
         if(this._taskBtn)
         {
            ObjectUtils.disposeObject(this._taskBtn);
         }
         this._taskBtn = null;
         if(this._myTaskView)
         {
            ObjectUtils.disposeObject(this._myTaskView);
         }
         this._myTaskView = null;
         ObjectUtils.disposeAllChildren(this);
         this._placardBtn = null;
         this._eventBtn = null;
         this._BG = null;
         this._placard = null;
         this._editBtn = null;
         this._cancelBtn = null;
         this._vbox = null;
         this._vote = null;
         this._eventPanel = null;
         this._weekOfferList = null;
         this._weekOffer = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
