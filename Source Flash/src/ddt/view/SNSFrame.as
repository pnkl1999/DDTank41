package ddt.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLVariables;
   
   public class SNSFrame extends BaseAlerFrame
   {
       
      
      private var _inputBG:Bitmap;
      
      private var _SNSFrameBg1:Scale9CornerImage;
      
      private var _shareBtn:TextButton;
      
      private var _visibleBtn:SelectedCheckButton;
      
      private var _text:FilterFrameText;
      
      private var _textinput:FilterFrameText;
      
      private var _alertInfo:AlertInfo;
      
      private var _textInputBgPoint:Point;
      
      private var _inputText:TextArea;
      
      public var typeId:int;
      
      public var backgroundServerTxt:String;
      
      public function SNSFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.SnsFrame.titleText"),LanguageMgr.GetTranslation("ddt.view.SnsFrame.shareBtnText"),LanguageMgr.GetTranslation("cancel"),true,true);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._inputBG = ComponentFactory.Instance.creatBitmap("ddt.view.SNSFrameBg");
         addToContent(this._inputBG);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.inputText");
         addToContent(this._inputText);
         this._textInputBgPoint = ComponentFactory.Instance.creatCustomObject("core.SNSFramePoint");
         this._inputText.x = this._textInputBgPoint.x;
         this._inputText.y = this._textInputBgPoint.y;
         if(this._inputText)
         {
            StageReferance.stage.focus = this._inputText.textField;
         }
         this._text = ComponentFactory.Instance.creat("core.SNSFrameViewText");
         this.addToContent(this._text);
         this._visibleBtn = ComponentFactory.Instance.creatComponentByStylename("core.SNSFrameCheckBox");
         this._visibleBtn.text = LanguageMgr.GetTranslation("ddt.view.SnsFrame.visibleBtnText");
         this._visibleBtn.selected = SharedManager.Instance.autoSnsSend;
         this.addToContent(this._visibleBtn);
      }
      
      private function _getStr() : String
      {
         var _loc1_:String = "";
         switch(this.typeId)
         {
            case 1:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextI");
               break;
            case 2:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextII");
               break;
            case 3:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIII");
               break;
            case 4:
            case 6:
            case 7:
            case 8:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
               break;
            case 5:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextV");
               break;
            case 9:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVI");
               break;
            case 10:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVII");
               break;
            case 11:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVIII");
               break;
            default:
               _loc1_ = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
         }
         return _loc1_;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._inputText.addEventListener(MouseEvent.CLICK,this._clickInputText);
         this._visibleBtn.addEventListener(MouseEvent.CLICK,this.__visibleBtnClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this._clickStage);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._inputText.removeEventListener(MouseEvent.CLICK,this._clickInputText);
         if(this._visibleBtn)
         {
            this._visibleBtn.removeEventListener(MouseEvent.CLICK,this.__visibleBtnClick);
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this._clickStage);
      }
      
      private function _clickInputText(param1:MouseEvent) : void
      {
         this._inputText.removeEventListener(MouseEvent.CLICK,this._clickInputText);
         this._inputText.text = "";
      }
      
      private function _clickStage(param1:MouseEvent) : void
      {
         if(this._inputText.text == "" && StageReferance.stage.focus != this._inputText.textField)
         {
            this._inputText.text = this._getStr();
         }
      }
      
      protected function __shareBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendDynamic();
      }
      
      protected function __visibleBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoSnsSend = this._visibleBtn.selected;
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               dispatchEvent(new Event("close"));
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sendDynamic();
               dispatchEvent(new Event("submit"));
         }
      }
      
      public function set receptionistTxt(param1:String) : void
      {
         if(this._text.text == param1)
         {
            return;
         }
         this._text.text = param1;
      }
      
      public function show() : void
      {
         if(SharedManager.Instance.allowSnsSend || !PathManager.CommunityExist())
         {
            this.dispose();
            return;
         }
         if(AcademyManager.Instance.isFighting())
         {
            return;
         }
         if(SharedManager.Instance.autoSnsSend)
         {
            this.sendDynamic();
         }
         else
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         if(this._inputText)
         {
            this._inputText.text = this._getStr();
         }
      }
      
      private function sendDynamic() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.typeId = this.typeId;
         _loc1_.playerTest = this._getStr();
         switch(_loc1_.typeId)
         {
            case 6:
            case 7:
            case 8:
               _loc1_.typeId = 4;
               break;
            case 9:
            case 10:
            case 11:
               _loc1_.typeId -= 3;
         }
         _loc1_.serverId = ServerManager.Instance.AgentID;
         _loc1_.fuid = PlayerManager.Instance.Account.Account;
         _loc1_.inviteCaption = this.backgroundServerTxt;
         if(this._inputText)
         {
            _loc1_.playerTest = this._inputText.text;
         }
         _loc1_.ran = Math.random();
         SocketManager.Instance.out.sendSnsMsg(this.typeId);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getSnsPath(),BaseLoader.REQUEST_LOADER,_loc1_);
         LoaderManager.Instance.startLoad(_loc2_);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.succeed"));
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         this._inputText = null;
         ObjectUtils.disposeObject(this._textinput);
         this._textinput = null;
         ObjectUtils.disposeObject(this._shareBtn);
         this._shareBtn = null;
         ObjectUtils.disposeObject(this._visibleBtn);
         this._visibleBtn = null;
         ObjectUtils.disposeObject(this._inputBG);
         this._inputBG = null;
         ObjectUtils.disposeObject(this._SNSFrameBg1);
         this._SNSFrameBg1 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
