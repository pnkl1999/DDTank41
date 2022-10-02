package calendar.view
{
   import baglocked.BaglockedManager;
   import calendar.CalendarEvent;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerPropertyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class LuckyNumBar extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _title:DisplayObject;
      
      private var _backInner:DisplayObject;
      
      private var _gridBack:DisplayObject;
      
      private var _crntNumField:FilterFrameText;
      
      private var _myNumField:FilterFrameText;
      
      private var _numBox:ComboBox;
      
      private var _model:CalendarModel;
      
      private var _myLuckyNum:int;
      
      private var _luckyShine:DisplayObject;
      
      public function LuckyNumBar(param1:CalendarModel)
      {
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.LuckyNumBack");
         addChild(this._back);
         this._backInner = ComponentFactory.Instance.creatComponentByStylename("Calendar.LuckNumBackInner");
         addChild(this._backInner);
         this._gridBack = ComponentFactory.Instance.creat("Calendar.LuckyNum.Grid");
         addChild(this._gridBack);
         this._title = ComponentFactory.Instance.creat("Calendar.LuckyNum.Title");
         addChild(this._title);
         this._crntNumField = ComponentFactory.Instance.creatComponentByStylename("Calendar.LuckyNumField");
         addChild(this._crntNumField);
         this._myNumField = ComponentFactory.Instance.creatComponentByStylename("Calendar.MyNumField");
         addChild(this._myNumField);
         this.__luckyNumChanged(null);
         this.updateMyLuckyNum();
         this._numBox = ComponentFactory.Instance.creatComponentByStylename("LuckyNumbox");
         this._numBox.tipData = LanguageMgr.GetTranslation("tank.calendar.LuckyNumBar.ChooseNote");
         addChild(this._numBox);
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._numBox.listPanel.vectorListModel.append(_loc1_);
            _loc1_++;
         }
         this._numBox.listPanel.list.updateListView();
         var _loc2_:Date = PlayerManager.Instance.Self.lastLuckyNumDate;
         var _loc3_:Date = TimeManager.Instance.Now();
         if(!(_loc2_.fullYear < _loc3_.fullYear || _loc2_.month < _loc3_.month || _loc3_.date - _loc2_.date >= 1))
         {
            this._numBox.textField.text = PlayerManager.Instance.Self.luckyNum >= 0 ? PlayerManager.Instance.Self.luckyNum.toString() : "";
         }
         this._numBox.commitChanges();
         if(PlayerManager.Instance.Self.lastLuckNum >= 0 && this._model.luckyNum >= 0 && PlayerManager.Instance.Self.lastLuckNum == this._model.luckyNum)
         {
            this._luckyShine = addChild(ComponentFactory.Instance.creat("LuckyShine"));
         }
      }
      
      private function addEvent() : void
      {
         this._numBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._model.addEventListener(CalendarEvent.LuckyNumChanged,this.__luckyNumChanged);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyChanged);
      }
      
      private function updateMyLuckyNum() : void
      {
         this._myNumField.text = PlayerManager.Instance.Self.lastLuckNum >= 0 ? PlayerManager.Instance.Self.lastLuckNum.toString() : "";
      }
      
      private function __selfPropertyChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerPropertyType.LastLuckyNum])
         {
            this.updateMyLuckyNum();
         }
      }
      
      private function __luckyNumChanged(param1:Event) : void
      {
         this._crntNumField.text = isNaN(this._model.luckyNum) || this._model.luckyNum < 0 ? "" : String(this._model.luckyNum);
      }
      
      private function removeEvent() : void
      {
         this._numBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._model.removeEventListener(CalendarEvent.LuckyNumChanged,this.__luckyNumChanged);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyChanged);
      }
      
      protected function __itemClick(param1:ListItemEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(int(this._numBox.listPanel.vectorListModel.get(param1.index)) != this._model.myLuckyNum)
         {
            if(!PlayerManager.Instance.Self.bagLocked)
            {
               this._myLuckyNum = int(this._numBox.listPanel.vectorListModel.get(param1.index));
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.calendar.LuckyNumBar.PayNote",this._myLuckyNum),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__payNoteResponse);
            }
            else
            {
               BaglockedManager.Instance.show();
            }
         }
      }
      
      private function __payNoteResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__payNoteResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 99)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
               return;
            }
            SocketManager.Instance.out.sendUserLuckyNum(this._myLuckyNum,true);
            PlayerManager.Instance.Self.luckyNum = this._myLuckyNum;
            PlayerManager.Instance.Self.lastLuckyNumDate = new Date();
            if(this._numBox)
            {
               this._numBox.textField.text = this._myLuckyNum.toString();
            }
         }
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._luckyShine);
         this._luckyShine = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._backInner);
         this._backInner = null;
         ObjectUtils.disposeObject(this._gridBack);
         this._gridBack = null;
         ObjectUtils.disposeObject(this._gridBack);
         this._gridBack = null;
         ObjectUtils.disposeObject(this._myNumField);
         this._myNumField = null;
         ObjectUtils.disposeObject(this._numBox);
         this._numBox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
