package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   
   public class GiftRecord extends Sprite implements Disposeable
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _BG:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _receivedBtn:SelectedButton;
      
      private var _sendedBtn:SelectedButton;
      
      private var _recordView:RecordParent;
      
      public function GiftRecord()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.GiftRecord.BG");
         this._receivedBtn = ComponentFactory.Instance.creatComponentByStylename("GiftRecord.receivedBtn");
         this._sendedBtn = ComponentFactory.Instance.creatComponentByStylename("GiftRecord.sendedBtn");
         this._recordView = ComponentFactory.Instance.creatCustomObject("recordParent");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._receivedBtn);
         this._btnGroup.addSelectItem(this._sendedBtn);
         this._btnGroup.selectIndex = 0;
         addChild(this._BG);
         addChild(this._receivedBtn);
         addChild(this._sendedBtn);
         addChild(this._recordView);
      }
      
      private function initEvent() : void
      {
         this._receivedBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._sendedBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changehandler);
         GiftController.Instance.addEventListener(GiftEvent.LOAD_RECORD_COMPLETE,this.__setRecordList);
      }
      
      private function removeEvent() : void
      {
         this._receivedBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._sendedBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changehandler);
         GiftController.Instance.removeEventListener(GiftEvent.LOAD_RECORD_COMPLETE,this.__setRecordList);
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         this._playerInfo = param1;
         this._recordView.playerInfo = this._playerInfo;
         this._btnGroup.selectIndex = 0;
         this.__changehandler(null);
      }
      
      private function __changehandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case RecordParent.RECEIVED:
               GiftController.Instance.loadRecord(GiftController.RECEIVEDPATH,this._playerInfo.ID);
               break;
            case RecordParent.SENDED:
               GiftController.Instance.loadRecord(GiftController.SENDEDPATH,this._playerInfo.ID);
         }
      }
      
      private function __setRecordList(param1:GiftEvent) : void
      {
         if(param1.str == GiftController.RECEIVEDPATH && this._btnGroup.selectIndex == 0 || param1.str == GiftController.SENDEDPATH && this._btnGroup.selectIndex == 1)
         {
            this._recordView.setList(GiftController.Instance.recordInfo,this._btnGroup.selectIndex);
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
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(this._receivedBtn)
         {
            ObjectUtils.disposeObject(this._receivedBtn);
         }
         this._receivedBtn = null;
         if(this._sendedBtn)
         {
            ObjectUtils.disposeObject(this._sendedBtn);
         }
         this._sendedBtn = null;
         if(this._recordView)
         {
            this._recordView.dispose();
         }
         this._recordView = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
