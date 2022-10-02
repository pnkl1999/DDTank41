package ddt.view.academyCommon.register
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import road7th.utils.StringHelper;
   
   public class AcademyRegisterFrame extends BaseAlerFrame implements Disposeable
   {
       
      
      private var _titleImage:ScaleFrameImage;
      
      private var _nicknameLabel:FilterFrameText;
      
      private var _nicknameField:FilterFrameText;
      
      private var _academyHonorLabel:FilterFrameText;
      
      private var _academyHonorField:FilterFrameText;
      
      private var _introductionLabel:FilterFrameText;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _checkBoxLabel:FilterFrameText;
      
      private var _introductionField:TextArea;
      
      private var _alertInfo:AlertInfo;
      
      private var _selfInfo:SelfInfo;
      
      public function AcademyRegisterFrame()
      {
         super();
         this.initContainer();
         this.iniEvent();
      }
      
      private function initContainer() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.register.TitleTxt");
         this._alertInfo.enterEnable = true;
         this._alertInfo.escEnable = true;
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._titleImage = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.title");
         this._titleImage.setFrame(1);
         addToContent(this._titleImage);
         this._nicknameLabel = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.NicknameLabel");
         this._nicknameLabel.text = LanguageMgr.GetTranslation("civil.register.NicknameLabel");
         addToContent(this._nicknameLabel);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.NicknameField");
         addToContent(this._nicknameField);
         this._academyHonorLabel = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.academyHonorLabel");
         this._academyHonorLabel.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRegisterFrame.academyHonorLabel");
         addToContent(this._academyHonorLabel);
         this._academyHonorField = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.academyHonorField");
         addToContent(this._academyHonorField);
         this._introductionLabel = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.IntroductionLabel");
         this._introductionLabel.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.register.introductionLabel");
         addToContent(this._introductionLabel);
         this._introductionField = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.IntroductionField");
         this._introductionField.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.register.introductionFieldTxt");
         addToContent(this._introductionField);
         this._checkBoxLabel = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyRegisterFrame.checkBoxLabel");
         this._checkBoxLabel.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.checkBox");
         addToContent(this._checkBoxLabel);
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.checkBoxBtn");
         addToContent(this._checkBox);
         if(AcademyManager.Instance.selfIsRegister)
         {
            this._checkBox.selected = AcademyManager.Instance.isSelfPublishEquip;
         }
         else
         {
            this._checkBox.selected = true;
         }
         this._selfInfo = PlayerManager.Instance.Self;
         this.update();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._introductionField.textField.setFocus();
         this._introductionField.textField.setSelection(this._introductionField.textField.length,this._introductionField.textField.length);
      }
      
      public function isAmend(param1:Boolean) : void
      {
         if(param1)
         {
            this._alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.register.TitleTxtII");
            info = this._alertInfo;
            if(AcademyManager.Instance.selfDescribe != "" && AcademyManager.Instance.selfDescribe)
            {
               this._introductionField.text = AcademyManager.Instance.selfDescribe;
            }
         }
         else
         {
            this._alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.register.TitleTxt");
            info = this._alertInfo;
         }
      }
      
      public function update() : void
      {
         this._nicknameField.text = this._selfInfo.NickName;
         this._academyHonorField.text = this._selfInfo.honourOfMaster;
      }
      
      private function iniEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxLabelClick);
         this._introductionField.addEventListener(TextEvent.TEXT_INPUT,this.__limit);
      }
      
      private function __limit(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._introductionField.textField,150);
      }
      
      private function __checkBoxLabelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(FilterWordManager.isGotForbiddenWords(this._introductionField.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo1"));
                  return;
               }
               SocketManager.Instance.out.sendAcademyRegister(this._selfInfo.ID,this._checkBox.selected,this._introductionField.text,AcademyManager.Instance.selfIsRegister);
               AcademyManager.Instance.selfDescribe = this._introductionField.text;
               AcademyManager.Instance.isSelfPublishEquip = this._checkBox.selected;
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         if(this._titleImage)
         {
            ObjectUtils.disposeObject(this._titleImage);
            this._titleImage = null;
         }
         if(this._nicknameLabel)
         {
            ObjectUtils.disposeObject(this._nicknameLabel);
            this._nicknameLabel = null;
         }
         if(this._nicknameField)
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
         if(this._academyHonorLabel)
         {
            ObjectUtils.disposeObject(this._academyHonorLabel);
            this._academyHonorLabel = null;
         }
         if(this._academyHonorField)
         {
            ObjectUtils.disposeObject(this._academyHonorField);
            this._academyHonorField = null;
         }
         if(this._introductionLabel)
         {
            ObjectUtils.disposeObject(this._introductionLabel);
            this._introductionLabel = null;
         }
         if(this._introductionField)
         {
            this._introductionField.removeEventListener(TextEvent.TEXT_INPUT,this.__limit);
            ObjectUtils.disposeObject(this._introductionField);
            this._introductionField = null;
         }
         if(this._checkBox)
         {
            this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxLabelClick);
            ObjectUtils.disposeObject(this._checkBox);
            this._checkBox = null;
         }
         if(this._checkBoxLabel)
         {
            this._checkBoxLabel.removeEventListener(MouseEvent.CLICK,this.__checkBoxLabelClick);
            ObjectUtils.disposeObject(this._checkBoxLabel);
            this._checkBoxLabel = null;
         }
         super.dispose();
      }
   }
}
