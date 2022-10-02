package ddt.view.academyCommon.academyRequest
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.MouseEvent;
   
   public class AcademyRequestMasterFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const MAX_CHAES:int = 30;
       
      
      protected var _inputText:FilterFrameText;
      
      protected var _explainText:FilterFrameText;
      
      protected var _inputBG:ScaleBitmapImage;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _playerInfo:BasePlayer;
      
      protected var _isSelection:Boolean = false;
      
      public function AcademyRequestMasterFrame()
      {
         super();
         this.initContent();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function initContent() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.title");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.submitLabel");
         this._alertInfo.showCancel = false;
         info = this._alertInfo;
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.inputBg");
         addToContent(this._inputBG);
         this._inputText = ComponentFactory.Instance.creat("academyCommon.academyRequest.inputxt");
         this._inputText.maxChars = MAX_CHAES;
         this._inputText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.account");
         addToContent(this._inputText);
         this._explainText = ComponentFactory.Instance.creat("academyCommon.academyRequest.explainText");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.explainText");
         addToContent(this._explainText);
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(this._inputText)
         {
            this._inputText.addEventListener(MouseEvent.CLICK,this.__onInpotClick);
         }
      }
      
      protected function __onInpotClick(param1:MouseEvent) : void
      {
         if(!this._isSelection)
         {
            this._inputText.setSelection(0,this._inputText.text.length);
            this._isSelection = true;
         }
         else
         {
            this._inputText.setFocus();
            this._isSelection = false;
         }
      }
      
      public function setInfo(param1:BasePlayer) : void
      {
         this._playerInfo = param1;
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hide();
         }
      }
      
      protected function submit() : void
      {
         if(this._playerInfo.playerState.StateID == PlayerState.OFFLINE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.state"));
            this.hide();
            return;
         }
         if(FilterWordManager.isGotForbiddenWords(this._inputText.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo1"));
            return;
         }
         SocketManager.Instance.out.sendAcademyApprentice(this._playerInfo.ID,this._inputText.text);
         this.hide();
      }
      
      protected function hide() : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(this._inputText)
         {
            this._inputText.removeEventListener(MouseEvent.CLICK,this.__onInpotClick);
            ObjectUtils.disposeObject(this._inputText);
            this._inputText = null;
         }
         if(this._explainText)
         {
            ObjectUtils.disposeObject(this._explainText);
            this._explainText = null;
         }
         if(this._inputBG)
         {
            ObjectUtils.disposeObject(this._inputBG);
            this._inputBG = null;
         }
         super.dispose();
      }
   }
}
