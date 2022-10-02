package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.data.MyGiftCellInfo;
   import road7th.data.DictionaryEvent;
   
   public class GiftAndRecord extends Sprite implements Disposeable
   {
      
      public static const MYGIFT:int = 0;
      
      public static const GIFTRECORD:int = 1;
       
      
      private var _BG:Scale9CornerImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _myGiftBtn:SelectedButton;
      
      private var _giftRecordBtn:SelectedButton;
      
      private var _myGiftView:MyGiftView;
      
      private var _giftRecord:GiftRecord;
      
      private var _info:PlayerInfo;
      
      public function GiftAndRecord()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("GiftAndRecord.BG");
         this._myGiftBtn = ComponentFactory.Instance.creatComponentByStylename("GiftAndRecord.myGiftBtn");
         this._giftRecordBtn = ComponentFactory.Instance.creatComponentByStylename("GiftAndRecord.recordBtn");
         addChild(this._BG);
         addChild(this._myGiftBtn);
         addChild(this._giftRecordBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._myGiftBtn);
         this._btnGroup.addSelectItem(this._giftRecordBtn);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      private function initEvent() : void
      {
         this._myGiftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftRecordBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         PlayerManager.Instance.addEventListener(PlayerManager.GIFT_INFO_CHANGE,this.__upMyGiftView);
      }
      
      private function removeEvent() : void
      {
         this._myGiftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftRecordBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         PlayerManager.Instance.removeEventListener(PlayerManager.GIFT_INFO_CHANGE,this.__upMyGiftView);
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upData);
            PlayerManager.Instance.removeEventListener(DictionaryEvent.ADD,this.__addItem);
            PlayerManager.Instance.removeEventListener(DictionaryEvent.UPDATE,this.__upItem);
         }
      }
      
      private function __upMyGiftView(param1:Event) : void
      {
         if(this._myGiftView && this._info)
         {
            this._myGiftView.setList(this._info.myGiftData);
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case MYGIFT:
               this.showMyGiftView();
               break;
            case GIFTRECORD:
               this.showGiftRecord();
         }
      }
      
      private function showMyGiftView() : void
      {
         if(this._myGiftView == null)
         {
            this._myGiftView = ComponentFactory.Instance.creatCustomObject("myGiftView");
            addChild(this._myGiftView);
         }
         if(this._info)
         {
            this._myGiftView.setList(this._info.myGiftData);
         }
         this._myGiftView.visible = true;
         if(this._giftRecord)
         {
            this._giftRecord.visible = false;
         }
      }
      
      private function showGiftRecord() : void
      {
         if(this._giftRecord == null)
         {
            this._giftRecord = ComponentFactory.Instance.creatCustomObject("giftRecord");
            addChild(this._giftRecord);
         }
         if(this._info)
         {
            this._giftRecord.playerInfo = this._info;
         }
         this._giftRecord.visible = true;
         if(this._myGiftView)
         {
            this._myGiftView.visible = false;
         }
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         if(this._myGiftView)
         {
            this._myGiftView.setList(this._info.myGiftData);
            if(this._info.ID == PlayerManager.Instance.Self.ID)
            {
               this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upData);
               PlayerManager.Instance.addEventListener(DictionaryEvent.ADD,this.__addItem);
               PlayerManager.Instance.addEventListener(DictionaryEvent.UPDATE,this.__upItem);
            }
         }
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      private function __upItem(param1:DictionaryEvent) : void
      {
         this._myGiftView.upItem(param1.data as MyGiftCellInfo);
      }
      
      private function __addItem(param1:DictionaryEvent) : void
      {
         this._myGiftView.addItem(param1.data as MyGiftCellInfo);
      }
      
      private function __upData(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["myGiftData"])
         {
            this._myGiftView.setList(this._info.myGiftData);
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._myGiftBtn)
         {
            ObjectUtils.disposeObject(this._myGiftBtn);
         }
         this._myGiftBtn = null;
         if(this._giftRecordBtn)
         {
            ObjectUtils.disposeObject(this._giftRecordBtn);
         }
         this._giftRecordBtn = null;
         if(this._btnGroup)
         {
            this._btnGroup.dispose();
         }
         this._btnGroup = null;
         if(this._myGiftView)
         {
            this._myGiftView.dispose();
         }
         this._myGiftView = null;
         if(this._giftRecord)
         {
            this._giftRecord.dispose();
         }
         this._giftRecord = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
