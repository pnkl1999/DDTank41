package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import baglocked.BaglockedManager;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import calendar.view.goodsExchange.GoodsExchangeView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ActivityState extends Sprite implements ICalendar
   {
      
      public static const PICC_PRICE:int = 10000;
       
      
      private var _back:DisplayObject;
      
      private var _scrollList:ScrollPanel;
      
      private var _content:VBox;
      
      private var _detail:ActivityDetail;
      
      private var _goodsExchange:GoodsExchangeView;
      
      private var _titleField:FilterFrameText;
      
      private var _buttonBack:DisplayObject;
      
      private var _getButton:BaseButton;
      
      private var _backButton:BaseButton;
      
      private var _piccBtn:BaseButton;
      
      private var _activityInfo:ActiveEventsInfo;
      
      public function ActivityState(param1:CalendarModel)
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.StateBack");
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.TitleField");
         addChild(this._titleField);
         this._detail = ComponentFactory.Instance.creatCustomObject("ActivityDetail");
         this._buttonBack = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.ButtonBack");
         addChild(this._buttonBack);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.GetButton");
         addChild(this._getButton);
         this._backButton = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.BackButton");
         addChild(this._backButton);
         this._piccBtn = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.piccBtn");
         addChild(this._piccBtn);
         this._content = ComponentFactory.Instance.creatComponentByStylename("calendar.view.ActivityState.vbox");
         this._content.addChild(this._detail);
         this._scrollList = ComponentFactory.Instance.creatComponentByStylename("Calendar.ActivityDetailList");
         this._scrollList.setView(this._content);
         addChild(this._scrollList);
      }
      
      private function addEvent() : void
      {
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._backButton.addEventListener(MouseEvent.CLICK,this.__back);
         this._piccBtn.addEventListener(MouseEvent.CLICK,this.__piccHandler);
         this._detail.getInputField().textField.addEventListener(Event.CHANGE,this.__inputChanged);
      }
      
      protected function __piccHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ActivityState.confirm.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money >= PICC_PRICE)
            {
               SocketManager.Instance.out.sendPicc(this._activityInfo.ActiveID,PICC_PRICE);
            }
            else
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __inputChanged(param1:Event) : void
      {
         if(this._detail.getInputField().text != "" && this._detail.getInputField().text != null)
         {
            this._getButton.enable = true;
         }
         else
         {
            this._getButton.enable = false;
         }
      }
      
      private function __back(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().closeActivity();
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         var _loc2_:BaseLoader = null;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._activityInfo.ActiveType == ActiveEventsInfo.COMMON)
         {
            if(this._detail.getInputField().text == "" && this._activityInfo.HasKey == 1)
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               _loc3_.info.showCancel = false;
               return;
            }
            _loc2_ = CalendarManager.getInstance().reciveActivityAward(this._activityInfo,this._detail.getInputField().text);
            _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         }
         else
         {
            this._goodsExchange.sendGoods();
         }
         this._getButton.enable = !this._activityInfo.isAttend;
         this._detail.getInputField().text = "";
      }
      
      private function __activityLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         this._getButton.enable = !this._activityInfo.isAttend;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         this._getButton.enable = !this._activityInfo.isAttend;
      }
      
      public function setData(param1:* = null) : void
      {
         this._activityInfo = param1 as ActiveEventsInfo;
         if(this._activityInfo)
         {
            this._piccBtn.visible = false;
            this._titleField.text = this._activityInfo.Title;
            this._detail.setData(this._activityInfo);
            this._content.height = this._detail.height;
            if(this._activityInfo.HasKey == 1 || this._activityInfo.HasKey == 2 || this._activityInfo.HasKey == 3 || this._activityInfo.HasKey == 6)
            {
               this._getButton.visible = true;
               this._getButton.enable = !this._activityInfo.isAttend;
            }
            else
            {
               this._getButton.visible = false;
            }
            if(this._activityInfo.ActiveType == ActiveEventsInfo.COMMON || this._activityInfo.ActiveType == ActiveEventsInfo.PICC)
            {
               this.hideGoodsExchangeView();
               if(this._activityInfo.ActiveType == ActiveEventsInfo.PICC)
               {
                  this._getButton.visible = false;
                  this._piccBtn.visible = true;
               }
            }
            else
            {
               this.showGoodsExchangeView();
            }
         }
         this._scrollList.invalidateViewport();
      }
      
      private function showGoodsExchangeView() : void
      {
         if(!this._goodsExchange)
         {
            this._goodsExchange = new GoodsExchangeView();
            PositionUtils.setPos(this._goodsExchange,"CalendarGrid.GoodsExchangeView.GoodsExchangeViewPos");
            this._goodsExchange.setData(this._activityInfo);
            this._content.addChild(this._goodsExchange);
         }
         else
         {
            this._goodsExchange.setData(this._activityInfo);
         }
      }
      
      private function hideGoodsExchangeView() : void
      {
         if(this._goodsExchange)
         {
            ObjectUtils.disposeObject(this._goodsExchange);
            this._goodsExchange = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._backButton.removeEventListener(MouseEvent.CLICK,this.__back);
         this._piccBtn.removeEventListener(MouseEvent.CLICK,this.__piccHandler);
         this._detail.getInputField().textField.removeEventListener(Event.CHANGE,this.__inputChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._piccBtn);
         this._piccBtn = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._buttonBack);
         this._buttonBack = null;
         ObjectUtils.disposeObject(this._getButton);
         this._getButton = null;
         ObjectUtils.disposeObject(this._backButton);
         this._backButton = null;
         ObjectUtils.disposeObject(this._detail);
         this._detail = null;
         ObjectUtils.disposeObject(this._scrollList);
         this._scrollList = null;
         ObjectUtils.disposeObject(this._goodsExchange);
         this._goodsExchange = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
