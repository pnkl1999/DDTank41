package civil.view
{
   import civil.CivilModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import road7th.utils.StringHelper;
   
   public class CivilRegisterFrame extends Frame implements Disposeable
   {
      
      public static const Modify:int = 1;
      
      public static const Creat:int = 0;
      
      private static var _firstOpen:Boolean;
       
      
      private var _model:CivilModel;
      
      private var _state:int;
      
      private var _titleImage:ScaleFrameImage;
      
      private var _nicknameLabel:FilterFrameText;
      
      private var _nicknameField:FilterFrameText;
      
      private var _matrimonyLabel:FilterFrameText;
      
      private var _introductionLabel:FilterFrameText;
      
      private var _matrimonyField:FilterFrameText;
      
      private var _introductionField:TextArea;
      
      private var _publicEquipButton:SelectedCheckButton;
      
      private var _submitButton:TextButton;
      
      private var _cancelButton:TextButton;
      
      private var _isPublishEquip:Boolean;
      
      private var _introduction:String;
      
      public function CivilRegisterFrame()
      {
         super();
         this.configUI();
         this.addEvent();
         this.selfInfo();
         this.getSelfInfoForFirstIn();
      }
      
      public function get model() : CivilModel
      {
         return this._model;
      }
      
      public function set model(param1:CivilModel) : void
      {
         this._model = param1;
         this.updateView();
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         titleText = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.titleText");
         if(this._state != param1)
         {
            this._state = param1;
            if(this._state == Creat)
            {
               DisplayUtils.setFrame(this._titleImage,1);
            }
            else if(this._state == Modify)
            {
               DisplayUtils.setFrame(this._titleImage,2);
               titleText = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.modify");
            }
         }
      }
      
      private function updateView() : void
      {
         this._nicknameField.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsMarried)
         {
            this._matrimonyField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married");
         }
         else
         {
            this._matrimonyField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
         }
         if(PlayerManager.Instance.Self.MarryInfoID <= 0 || !PlayerManager.Instance.Self.MarryInfoID)
         {
            this.state = Creat;
            this._introductionField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text");
            this._publicEquipButton.selected = true;
         }
         else
         {
            this.state = Modify;
            this._introductionField.text = PlayerManager.Instance.Self.Introduction;
            this._publicEquipButton.selected = PlayerManager.Instance.Self.IsPublishEquit;
         }
      }
      
      private function configUI() : void
      {
         this._titleImage = ComponentFactory.Instance.creatComponentByStylename("civil.register.RegisterTitle");
         DisplayUtils.setFrame(this._titleImage,1);
         addToContent(this._titleImage);
         this._nicknameLabel = ComponentFactory.Instance.creatComponentByStylename("civil.register.NicknameLabel");
         this._nicknameLabel.text = LanguageMgr.GetTranslation("civil.register.NicknameLabel");
         addToContent(this._nicknameLabel);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("civil.register.NicknameField");
         addToContent(this._nicknameField);
         this._matrimonyLabel = ComponentFactory.Instance.creatComponentByStylename("civil.register.MatrimonyLabel");
         this._matrimonyLabel.text = LanguageMgr.GetTranslation("civil.register.MatrimonyLabel");
         addToContent(this._matrimonyLabel);
         this._matrimonyField = ComponentFactory.Instance.creatComponentByStylename("civil.register.MatrimonyField");
         addToContent(this._matrimonyField);
         this._introductionLabel = ComponentFactory.Instance.creatComponentByStylename("civil.register.IntroductionLabel");
         this._introductionLabel.text = LanguageMgr.GetTranslation("civil.register.IntroductionLabel");
         addToContent(this._introductionLabel);
         this._introductionField = ComponentFactory.Instance.creatComponentByStylename("civil.register.IntroductionField");
         addToContent(this._introductionField);
         this._publicEquipButton = ComponentFactory.Instance.creatComponentByStylename("civil.register.PublicEquipButton");
         this._publicEquipButton.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.checkBox");
         addToContent(this._publicEquipButton);
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("civil.register.SubmitButton");
         this._submitButton.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._submitButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("civil.register.CancelButton");
         this._cancelButton.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._cancelButton);
      }
      
      private function addEvent() : void
      {
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCloseClick);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__onSubmitClick);
         this._publicEquipButton.addEventListener(MouseEvent.CLICK,this.__onPublicEquipClick);
         addEventListener(FrameEvent.RESPONSE,this.__response);
         PlayerManager.Instance.addEventListener(PlayerManager.CIVIL_SELFINFO_CHANGE,this.__getSelfInfo);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._introductionField.textField.addEventListener(TextEvent.TEXT_INPUT,this.__limit);
         addEventListener(Event.ADDED_TO_STAGE,this.__toStage);
      }
      
      private function __toStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__toStage);
         StageReferance.stage.focus = this._introductionField.textField;
      }
      
      private function removeEvent() : void
      {
         if(this._cancelButton)
         {
            this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
         }
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.__onSubmitClick);
         }
         if(this._introductionField)
         {
            this._introductionField.textField.removeEventListener(TextEvent.TEXT_INPUT,this.__limit);
         }
         if(this._publicEquipButton)
         {
            this._publicEquipButton.removeEventListener(MouseEvent.CLICK,this.__onPublicEquipClick);
         }
         PlayerManager.Instance.removeEventListener(PlayerManager.CIVIL_SELFINFO_CHANGE,this.__getSelfInfo);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__toStage);
      }
      
      private function __onPublicEquipClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
               this.__onCloseClick(null);
               break;
            case FrameEvent.ENTER_CLICK:
               this.__onSubmitClick(null);
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["IsPublishEquit"])
         {
            this._publicEquipButton.selected = PlayerManager.Instance.Self.IsPublishEquit;
         }
         else if(param1.changedProperties["Introduction"])
         {
            this._introductionField.text = PlayerManager.Instance.Self.Introduction;
            this._introductionField.textField.setSelection(this._introductionField.textField.length,this._introductionField.textField.length);
         }
      }
      
      private function __getSelfInfo(param1:Event) : void
      {
         this.selfInfo();
      }
      
      private function __limit(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._introductionField.textField,300);
      }
      
      private function __onSubmitClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isPublishEquip = this._publicEquipButton.selected;
         if(FilterWordManager.isGotForbiddenWords(this._introductionField.text))
         {
            this.__onCloseClick(null);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.checkIntro"));
            return;
         }
         this._introduction = this._introductionField.text;
         if(this._state == Creat)
         {
            this._model.registed = true;
            SocketManager.Instance.out.sendRegisterInfo(PlayerManager.Instance.Self.ID,this._isPublishEquip,this._introduction);
         }
         else
         {
            SocketManager.Instance.out.sendModifyInfo(this._isPublishEquip,this._introduction);
         }
         this._model.updateBtn();
         this.selfInfo();
         this.__onCloseClick(null);
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(param1);
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function getSelfInfoForFirstIn() : void
      {
         if(PlayerManager.Instance.Self.MarryInfoID != 0 && !_firstOpen)
         {
            SocketManager.Instance.out.sendForMarryInfo(PlayerManager.Instance.Self.MarryInfoID);
            _firstOpen = true;
         }
      }
      
      private function selfInfo() : void
      {
         if(PlayerManager.Instance.Self.MarryInfoID != 0)
         {
            this._publicEquipButton.selected = PlayerManager.Instance.Self.IsPublishEquit;
            this._introductionField.text = PlayerManager.Instance.Self.Introduction;
            this._introductionField.textField.setSelection(this._introductionField.textField.length,this._introductionField.textField.length);
         }
         else
         {
            this._publicEquipButton.selected = true;
            this._introductionField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text");
            this._introductionField.textField.setSelection(this._introductionField.textField.length,this._introductionField.textField.length);
         }
         if(PlayerManager.Instance.Self.IsMarried)
         {
            this._matrimonyField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married");
         }
         else
         {
            this._matrimonyField.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
         }
         this._publicEquipButton.selected = PlayerManager.Instance.Self.IsPublishEquit;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
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
         if(this._matrimonyLabel)
         {
            ObjectUtils.disposeObject(this._matrimonyLabel);
            this._matrimonyLabel = null;
         }
         if(this._introductionLabel)
         {
            ObjectUtils.disposeObject(this._introductionLabel);
            this._introductionLabel = null;
         }
         if(this._matrimonyField)
         {
            ObjectUtils.disposeObject(this._matrimonyField);
            this._matrimonyField = null;
         }
         if(this._introductionField)
         {
            ObjectUtils.disposeObject(this._introductionField);
            this._introductionField = null;
         }
         if(this._publicEquipButton)
         {
            ObjectUtils.disposeObject(this._publicEquipButton);
            this._publicEquipButton = null;
         }
         if(this._submitButton)
         {
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
         }
         if(this._cancelButton)
         {
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         super.dispose();
      }
   }
}
