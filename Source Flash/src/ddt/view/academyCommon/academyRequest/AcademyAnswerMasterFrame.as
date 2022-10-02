package ddt.view.academyCommon.academyRequest
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class AcademyAnswerMasterFrame extends AcademyRequestMasterFrame implements Disposeable
   {
      
      public static const BINGIN_INDEX:int = 8;
       
      
      protected var _messageText:FilterFrameText;
      
      protected var _uid:int;
      
      protected var _name:String;
      
      protected var _message:String;
      
      protected var _nameLabel:TextFormat;
      
      protected var _lookBtn:BaseButton;
      
      protected var _cancelBtn:BaseButton;
      
      public function AcademyAnswerMasterFrame()
      {
         super();
      }
      
      override public function show() : void
      {
         SoundManager.instance.play("008");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override protected function initContent() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame.title");
         _alertInfo.showCancel = _alertInfo.showSubmit = _alertInfo.enterEnable = this.enterEnable = false;
         info = _alertInfo;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos");
         _inputBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.inputBg");
         addToContent(_inputBG);
         _inputBG.y = _loc1_.x;
         this._messageText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.MessageText");
         addToContent(this._messageText);
         this._messageText.y = _loc1_.y;
         _explainText = ComponentFactory.Instance.creat("academyCommon.academyRequest.explainText");
         addToContent(_explainText);
         this._nameLabel = ComponentFactory.Instance.model.getSet("academyCommon.academyRequest.explainNameTextTF");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.LookButton");
         addToContent(this._lookBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRequestApprenticeFrame.submitButton");
         addToContent(this._cancelBtn);
      }
      
      override protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this.__onLookBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
      }
      
      protected function __onCancelBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.submit();
      }
      
      protected function __onLookBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.lookUpEquip();
      }
      
      override protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               this.lookUpEquip();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
               break;
            case FrameEvent.CANCEL_CLICK:
               this.submit();
         }
      }
      
      public function setMessage(param1:int, param2:String, param3:String) : void
      {
         this._uid = param1;
         this._name = param2;
         this._message = param3;
         this.update();
      }
      
      protected function update() : void
      {
         this._messageText.text = this._message;
         _explainText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyAnswerMasterFrame.AnswerMaster",this._name);
         _explainText.setTextFormat(this._nameLabel,BINGIN_INDEX,this._name.length + BINGIN_INDEX);
      }
      
      protected function lookUpEquip() : void
      {
         PlayerInfoViewControl.viewByID(this._uid,PlayerManager.Instance.Self.ZoneID);
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyMasterConfirm(true,this._uid);
         this.dispose();
      }
      
      override protected function hide() : void
      {
         SocketManager.Instance.out.sendAcademyMasterConfirm(false,this._uid);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this._messageText)
         {
            ObjectUtils.disposeObject(this._messageText);
            this._messageText = null;
         }
         if(this._lookBtn)
         {
            this._lookBtn.removeEventListener(MouseEvent.CLICK,this.__onLookBtnClick);
            ObjectUtils.disposeObject(this._lookBtn);
            this._lookBtn = null;
         }
         if(this._cancelBtn)
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
            ObjectUtils.disposeObject(this._cancelBtn);
            this._lookBtn = null;
         }
         this._nameLabel = null;
         super.dispose();
      }
   }
}
