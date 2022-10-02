package roomList.pvpRoomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class RoomListCreateRoomView extends BaseAlerFrame implements Disposeable
   {
      
      public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
       
      
      protected var _athleticsBg:Bitmap;
      
      protected var _athleticsBtn:SimpleBitmapButton;
      
      protected var _bg:Bitmap;
      
      protected var _checkBox:SelectedCheckButton;
      
      protected var _createRoomBitmap:Bitmap;
      
      protected var _explainTxt:FilterFrameText;
      
      protected var _exploreBtn:SimpleBitmapButton;
      
      protected var _passBtn:SimpleBitmapButton;
      
      protected var _passTxt:TextInput;
      
      protected var _roomModelBitmap:Bitmap;
      
      protected var _textBG:ScaleFrameImage;
      
      protected var _textbg:Bitmap;
      
      protected var _alertInfo:AlertInfo;
      
      public function RoomListCreateRoomView()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      protected function initContainer() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.titleText");
         info = this._alertInfo;
         this._roomModelBitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.roomModelText");
         addToContent(this._roomModelBitmap);
         this._createRoomBitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.CreateRoomText");
         addToContent(this._createRoomBitmap);
         this._textBG = ComponentFactory.Instance.creat("roomList.pvpRoomList.textBg");
         this._textBG.setFrame(2);
         addToContent(this._textBG);
         this._explainTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.ExplainText");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215);
         _loc1_.graphics.drawRect(this._explainTxt.x,this._explainTxt.y,this._explainTxt.width,this._explainTxt.height);
         _loc1_.graphics.endFill();
         addToContent(_loc1_);
         this._explainTxt.text = PREWORD[int(Math.random() * PREWORD.length)];
         addToContent(this._explainTxt);
         this._passTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.passText");
         this._passTxt.text = "";
         this._passTxt.textField.restrict = "0-9 A-Z a-z";
         this._passTxt.visible = false;
         addToContent(this._passTxt);
         this._exploreBtn = ComponentFactory.Instance.creat("roomList.pvpRoomList.exploreBtn");
         addToContent(this._exploreBtn);
         this._athleticsBg = ComponentFactory.Instance.creatBitmap("asset.roomList.athletics");
         addToContent(this._athleticsBg);
         this._athleticsBtn = ComponentFactory.Instance.creat("roomList.pvpRoomList.LightAthleticsBtn");
         this._athleticsBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         addToContent(this._athleticsBtn);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomList.bg_01");
         addToContent(this._bg);
         this._textbg = ComponentFactory.Instance.creatBitmap("asset.roomList.explainText_2");
         addToContent(this._textbg);
         this._checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.simpleSelectBtn");
         addToContent(this._checkBox);
         this._passBtn = ComponentFactory.Instance.creat("roomList.pvpRoomList.passBtn");
         addToContent(this._passBtn);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CREATE_ROOM_SURE_TIP))
         {
            NewHandContainer.Instance.showArrow(ArrowType.WAIT_GAME,-45,"trainer.creatRoomSureArrowPos","asset.trainer.clickTipAsset","trainer.creatRoomSureTipPos");
         }
      }
      
      private function initEvent() : void
      {
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._passBtn.addEventListener(MouseEvent.CLICK,this.__passBtnClick);
         this._passTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.__passKeyDown);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hide();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      protected function __passBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkBox.selected = !this._checkBox.selected;
         this.upadtePassTextBg();
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.upadtePassTextBg();
      }
      
      private function __passKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.submit();
         }
      }
      
      private function upadtePassTextBg() : void
      {
         if(this._checkBox.selected)
         {
            this._textBG.setFrame(1);
            this._passTxt.visible = true;
            this._passTxt.setFocus();
         }
         else
         {
            this._textBG.setFrame(2);
            this._passTxt.visible = false;
         }
      }
      
      protected function submit() : void
      {
         if(FilterWordManager.IsNullorEmpty(this._explainTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            SoundManager.instance.play("008");
         }
         else if(FilterWordManager.isGotForbiddenWords(this._explainTxt.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            SoundManager.instance.play("008");
         }
         else if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            SoundManager.instance.play("008");
         }
         else
         {
            GameInSocketOut.sendCreateRoom(this._explainTxt.text,0,3,!!this._checkBox.selected ? this._passTxt.text : "");
            SocketManager.Instance.out.syncWeakStep(Step.CREATE_ROOM_TIP);
            SocketManager.Instance.out.syncWeakStep(Step.CREATE_ROOM_SURE_TIP);
            this.hide();
         }
      }
      
      protected function hide() : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.WAIT_GAME);
         if(this._checkBox)
         {
            this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         }
         if(this._passBtn)
         {
            this._passBtn.removeEventListener(MouseEvent.CLICK,this.__passBtnClick);
         }
         if(this._passTxt)
         {
            this._passTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.__passKeyDown);
         }
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         ObjectUtils.disposeObject(this._athleticsBg);
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._createRoomBitmap);
         ObjectUtils.disposeObject(this._roomModelBitmap);
         ObjectUtils.disposeObject(this._textbg);
         ObjectUtils.disposeObject(this._athleticsBtn);
         ObjectUtils.disposeObject(this._checkBox);
         ObjectUtils.disposeObject(this._explainTxt);
         ObjectUtils.disposeObject(this._exploreBtn);
         ObjectUtils.disposeObject(this._passBtn);
         ObjectUtils.disposeObject(this._passTxt);
         ObjectUtils.disposeObject(this._textBG);
         this._alertInfo = null;
         this._checkBox = null;
         this._passBtn = null;
         this._passTxt = null;
         this._athleticsBg = null;
         this._bg = null;
         this._createRoomBitmap = null;
         this._roomModelBitmap = null;
         this._textbg = null;
         this._athleticsBtn = null;
         this._explainTxt = null;
         this._exploreBtn = null;
         this._textBG = null;
         super.dispose();
      }
      
      private function beforeUserGuide55() : void
      {
         this._checkBox.selected = true;
         this._passTxt.visible = true;
         this._passTxt.text = String(Math.random() * 1000).substr(0,6);
         this._passTxt.enable = false;
      }
   }
}
