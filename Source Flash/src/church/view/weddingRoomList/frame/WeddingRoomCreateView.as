package church.view.weddingRoomList.frame
{
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WeddingRoomCreateView extends BaseAlerFrame
   {
       
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgLeftTop:Scale9CornerImage;
      
      private var _bgLeftBottom:Scale9CornerImage;
      
      private var _bgRight:Scale9CornerImage;
      
      private var _alertInfo:AlertInfo;
      
      private var _roomCreateRoomNameTitle:Bitmap;
      
      private var _roomCreateIntro:Bitmap;
      
      private var _roomCreateTimeTitle:Bitmap;
      
      private var _roomCreateIntroMaxChBg:Bitmap;
      
      private var _txtCreateRoomName:FilterFrameText;
      
      private var _chkCreateRoomPassword:SelectedIconButton;
      
      private var _chkCreateRoomIsGuest:SelectedIconButton;
      
      private var _txtCreateRoomPassword:TextInput;
      
      private var _roomCreateTime1SelectedBtn:SelectedButton;
      
      private var _roomCreateTime2SelectedBtn:SelectedButton;
      
      private var _roomCreateTime3SelectedBtn:SelectedButton;
      
      private var _roomCreateTimeGroup:SelectedButtonGroup;
      
      private var _roomCreateIntroMaxChLabel:FilterFrameText;
      
      private var _txtRoomCreateIntro:TextArea;
      
      private var _createRoomMoney:Array;
      
      public function WeddingRoomCreateView()
      {
         this._createRoomMoney = [2000,2700,3400];
         super();
         this.initialize();
      }
      
      public function setController(param1:ChurchRoomListController, param2:ChurchRoomListModel) : void
      {
         this._controller = param1;
         this._model = param2;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame.titleText");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bgLeftTop = ComponentFactory.Instance.creat("church.main.createRoomFrameLeftTopBg");
         addToContent(this._bgLeftTop);
         this._bgLeftBottom = ComponentFactory.Instance.creat("church.main.createRoomFrameLeftBottomBg");
         addToContent(this._bgLeftBottom);
         this._roomCreateRoomNameTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateRoomNameTitleAsset");
         addToContent(this._roomCreateRoomNameTitle);
         this._roomCreateTimeTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateTimeTitleAsset");
         addToContent(this._roomCreateTimeTitle);
         this._txtCreateRoomName = ComponentFactory.Instance.creat("church.main.txtCreateRoomName");
         this._txtCreateRoomName.text = LanguageMgr.GetTranslation("hurch.weddingRoom.frame.CreateRoomFrame.name_txt",PlayerManager.Instance.Self.NickName,PlayerManager.Instance.Self.SpouseName);
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215);
         _loc1_.graphics.drawRect(this._txtCreateRoomName.x,this._txtCreateRoomName.y,226,24);
         _loc1_.graphics.endFill();
         addToContent(_loc1_);
         addToContent(this._txtCreateRoomName);
         this._chkCreateRoomPassword = ComponentFactory.Instance.creat("church.main.chkCreateRoomPassword");
         addToContent(this._chkCreateRoomPassword);
         this._txtCreateRoomPassword = ComponentFactory.Instance.creat("church.main.txtCreateRoomPassword");
         this._txtCreateRoomPassword.displayAsPassword = true;
         this._txtCreateRoomPassword.enable = false;
         this._txtCreateRoomPassword.maxChars = 6;
         addToContent(this._txtCreateRoomPassword);
         this._chkCreateRoomIsGuest = ComponentFactory.Instance.creat("church.main.chkCreateRoomIsGuest");
         addToContent(this._chkCreateRoomIsGuest);
         this._roomCreateTime1SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTime1SelectedBtn");
         addToContent(this._roomCreateTime1SelectedBtn);
         this._roomCreateTime2SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTime2SelectedBtn");
         addToContent(this._roomCreateTime2SelectedBtn);
         this._roomCreateTime3SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTime3SelectedBtn");
         addToContent(this._roomCreateTime3SelectedBtn);
         this._roomCreateTimeGroup = new SelectedButtonGroup(false);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime1SelectedBtn);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime2SelectedBtn);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime3SelectedBtn);
         this._roomCreateTimeGroup.selectIndex = 0;
         this._roomCreateIntro = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateIntroAsset");
         addToContent(this._roomCreateIntro);
         this._roomCreateIntroMaxChBg = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateIntroMaxChBgAsset");
         addToContent(this._roomCreateIntroMaxChBg);
         this._roomCreateIntroMaxChLabel = ComponentFactory.Instance.creat("asset.church.main.roomCreateIntroMaxChLabelAsset");
         addToContent(this._roomCreateIntroMaxChLabel);
         this._bgRight = ComponentFactory.Instance.creat("church.main.createRoomFrameRightBg");
         addToContent(this._bgRight);
         var _loc2_:String = "";
         var _loc3_:String = "";
         if(PlayerManager.Instance.Self.Sex)
         {
            _loc2_ = PlayerManager.Instance.Self.NickName;
            _loc3_ = PlayerManager.Instance.Self.SpouseName;
         }
         else
         {
            _loc2_ = PlayerManager.Instance.Self.SpouseName;
            _loc3_ = PlayerManager.Instance.Self.NickName;
         }
         this._txtRoomCreateIntro = ComponentFactory.Instance.creat("church.view.weddingRoomList.frame.WeddingRoomCreateViewField");
         this._txtRoomCreateIntro.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame._remark_txt",_loc2_,_loc3_);
         this._txtRoomCreateIntro.maxChars = 300;
         addToContent(this._txtRoomCreateIntro);
         this._roomCreateIntroMaxChLabel.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare") + String(this._txtRoomCreateIntro.maxChars - this._txtRoomCreateIntro.text.length) + LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(this._bgLeftTop)
         {
            if(this._bgLeftTop.parent)
            {
               this._bgLeftTop.parent.removeChild(this._bgLeftTop);
            }
            this._bgLeftTop.dispose();
         }
         this._bgLeftTop = null;
         if(this._bgLeftBottom)
         {
            if(this._bgLeftBottom.parent)
            {
               this._bgLeftBottom.parent.removeChild(this._bgLeftBottom);
            }
            this._bgLeftBottom.dispose();
         }
         this._bgLeftBottom = null;
         if(this._roomCreateRoomNameTitle)
         {
            if(this._roomCreateRoomNameTitle.parent)
            {
               this._roomCreateRoomNameTitle.parent.removeChild(this._roomCreateRoomNameTitle);
            }
            this._roomCreateRoomNameTitle.bitmapData.dispose();
            this._roomCreateRoomNameTitle.bitmapData = null;
         }
         this._roomCreateRoomNameTitle = null;
         if(this._roomCreateIntro)
         {
            if(this._roomCreateIntro.parent)
            {
               this._roomCreateIntro.parent.removeChild(this._roomCreateIntro);
            }
            this._roomCreateIntro.bitmapData.dispose();
            this._roomCreateIntro.bitmapData = null;
         }
         this._roomCreateIntro = null;
         if(this._roomCreateIntroMaxChBg)
         {
            if(this._roomCreateIntroMaxChBg.parent)
            {
               this._roomCreateIntroMaxChBg.parent.removeChild(this._roomCreateIntroMaxChBg);
            }
            this._roomCreateIntroMaxChBg.bitmapData.dispose();
            this._roomCreateIntroMaxChBg.bitmapData = null;
         }
         this._roomCreateIntroMaxChBg = null;
         if(this._roomCreateTimeTitle)
         {
            if(this._roomCreateTimeTitle.parent)
            {
               this._roomCreateTimeTitle.parent.removeChild(this._roomCreateTimeTitle);
            }
            this._roomCreateTimeTitle.bitmapData.dispose();
            this._roomCreateTimeTitle.bitmapData = null;
         }
         this._roomCreateTimeTitle = null;
         if(this._txtCreateRoomName)
         {
            if(this._txtCreateRoomName.parent)
            {
               this._txtCreateRoomName.parent.removeChild(this._txtCreateRoomName);
            }
            this._txtCreateRoomName.dispose();
         }
         this._txtCreateRoomName = null;
         if(this._chkCreateRoomPassword)
         {
            if(this._chkCreateRoomPassword.parent)
            {
               this._chkCreateRoomPassword.parent.removeChild(this._chkCreateRoomPassword);
            }
            this._chkCreateRoomPassword.dispose();
         }
         this._chkCreateRoomPassword = null;
         if(this._txtCreateRoomPassword)
         {
            if(this._txtCreateRoomPassword.parent)
            {
               this._txtCreateRoomPassword.parent.removeChild(this._txtCreateRoomPassword);
            }
            this._txtCreateRoomPassword.dispose();
         }
         this._txtCreateRoomPassword = null;
         if(this._roomCreateTime1SelectedBtn)
         {
            if(this._roomCreateTime1SelectedBtn.parent)
            {
               this._roomCreateTime1SelectedBtn.parent.removeChild(this._roomCreateTime1SelectedBtn);
            }
            this._roomCreateTime1SelectedBtn.dispose();
         }
         this._roomCreateTime1SelectedBtn = null;
         if(this._roomCreateTime2SelectedBtn)
         {
            if(this._roomCreateTime2SelectedBtn.parent)
            {
               this._roomCreateTime2SelectedBtn.parent.removeChild(this._roomCreateTime2SelectedBtn);
            }
            this._roomCreateTime2SelectedBtn.dispose();
         }
         this._roomCreateTime2SelectedBtn = null;
         if(this._roomCreateTime3SelectedBtn)
         {
            if(this._roomCreateTime3SelectedBtn.parent)
            {
               this._roomCreateTime3SelectedBtn.parent.removeChild(this._roomCreateTime3SelectedBtn);
            }
            this._roomCreateTime3SelectedBtn.dispose();
         }
         this._roomCreateTime3SelectedBtn = null;
         if(this._roomCreateIntroMaxChLabel)
         {
            if(this._roomCreateIntroMaxChLabel.parent)
            {
               this._roomCreateIntroMaxChLabel.parent.removeChild(this._roomCreateIntroMaxChLabel);
            }
            this._roomCreateIntroMaxChLabel.dispose();
         }
         this._roomCreateIntroMaxChLabel = null;
         if(this._bgRight)
         {
            if(this._bgRight.parent)
            {
               this._bgRight.parent.removeChild(this._bgRight);
            }
            this._bgRight.dispose();
         }
         this._bgRight = null;
         this._txtRoomCreateIntro = null;
         if(this._roomCreateTimeGroup)
         {
            this._roomCreateTimeGroup.dispose();
         }
         this._roomCreateTimeGroup = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkCreateRoomPassword.addEventListener(MouseEvent.CLICK,this.onRoomPasswordCheck);
         this._txtRoomCreateIntro.addEventListener(Event.CHANGE,this.onIntroChange);
         this._chkCreateRoomIsGuest.addEventListener(MouseEvent.CLICK,this.onIsGuest);
         this._roomCreateTime1SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest);
         this._roomCreateTime2SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest);
         this._roomCreateTime3SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(this._chkCreateRoomPassword)
         {
            this._chkCreateRoomPassword.removeEventListener(MouseEvent.CLICK,this.onRoomPasswordCheck);
         }
         if(this._txtRoomCreateIntro)
         {
            this._txtRoomCreateIntro.removeEventListener(Event.CHANGE,this.onIntroChange);
         }
         if(this._chkCreateRoomIsGuest)
         {
            this._chkCreateRoomIsGuest.removeEventListener(MouseEvent.CLICK,this.onIsGuest);
         }
         if(this._roomCreateTime1SelectedBtn)
         {
            this._roomCreateTime1SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest);
         }
         if(this._roomCreateTime2SelectedBtn)
         {
            this._roomCreateTime2SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest);
         }
         if(this._roomCreateTime3SelectedBtn)
         {
            this._roomCreateTime3SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest);
         }
      }
      
      private function onIsGuest(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function onRoomPasswordCheck(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._txtCreateRoomPassword.enable = this._chkCreateRoomPassword.selected;
         if(this._txtCreateRoomPassword.enable)
         {
            this._txtCreateRoomPassword.setFocus();
         }
         else
         {
            this._txtCreateRoomPassword.text = "";
         }
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.createRoomConfirm();
         }
      }
      
      private function createRoomConfirm() : void
      {
         if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.weddingMoney[this._roomCreateTimeGroup.selectIndex])
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(!this.checkRoom())
         {
            return;
         }
         var _loc1_:ChurchRoomInfo = new ChurchRoomInfo();
         _loc1_.roomName = this._txtCreateRoomName.text;
         _loc1_.password = this._txtCreateRoomPassword.text;
         _loc1_.valideTimes = this._roomCreateTimeGroup.selectIndex + 2;
         _loc1_.canInvite = this._chkCreateRoomIsGuest.selected;
         _loc1_.discription = FilterWordManager.filterWrod(this._txtRoomCreateIntro.text);
         this._controller.createRoom(_loc1_);
         this.dispose();
      }
      
      private function checkRoom() : Boolean
      {
         if(FilterWordManager.IsNullorEmpty(this._txtCreateRoomName.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._txtCreateRoomName.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            return false;
         }
         if(this._chkCreateRoomPassword.selected && FilterWordManager.IsNullorEmpty(this._txtCreateRoomPassword.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            return false;
         }
         return true;
      }
      
      private function onIntroChange(param1:Event) : void
      {
         this._roomCreateIntroMaxChLabel.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare") + String(this._txtRoomCreateIntro.maxChars - this._txtRoomCreateIntro.text.length) + LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
