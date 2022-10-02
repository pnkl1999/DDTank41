package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   
   public class SetPassFrame2 extends Frame
   {
       
      
      private var _backBtn1:TextButton;
      
      private var _bagLockedController:BagLockedController;
      
      private var _bag_Combox1:ComboBox;
      
      private var _bag_Combox2:ComboBox;
      
      private var _nextBtn2:TextButton;
      
      private var _subtitle:Image;
      
      private var _textInfo2_1:FilterFrameText;
      
      private var _textInfo2_2:FilterFrameText;
      
      private var _textInfo2_3:FilterFrameText;
      
      private var _textInfo2_4:FilterFrameText;
      
      private var _textInfo2_5:FilterFrameText;
      
      private var _textInfo2_6:FilterFrameText;
      
      private var _textinput2_1:TextInput;
      
      private var _textinput2_2:TextInput;
      
      private var _titText2_0:FilterFrameText;
      
      private var _textInfo2_7:FilterFrameText;
      
      private var _isSkip:Boolean;
      
      public function SetPassFrame2()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(this._nextBtn2.enable)
            {
               this.__nextBtn2Click(null);
            }
         }
      }
      
      public function set bagLockedController(param1:BagLockedController) : void
      {
         this._bagLockedController = param1;
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         this._bagLockedController = null;
         ObjectUtils.disposeObject(this._subtitle);
         this._subtitle = null;
         ObjectUtils.disposeObject(this._titText2_0);
         this._titText2_0 = null;
         ObjectUtils.disposeObject(this._textInfo2_1);
         this._textInfo2_1 = null;
         ObjectUtils.disposeObject(this._textInfo2_2);
         this._textInfo2_2 = null;
         ObjectUtils.disposeObject(this._textInfo2_3);
         this._textInfo2_3 = null;
         ObjectUtils.disposeObject(this._textInfo2_4);
         this._textInfo2_4 = null;
         ObjectUtils.disposeObject(this._textInfo2_5);
         this._textInfo2_5 = null;
         ObjectUtils.disposeObject(this._textInfo2_6);
         this._textInfo2_6 = null;
         ObjectUtils.disposeObject(this._textInfo2_7);
         this._textInfo2_7 = null;
         ObjectUtils.disposeObject(this._textinput2_1);
         this._textinput2_1 = null;
         ObjectUtils.disposeObject(this._textinput2_2);
         this._textinput2_2 = null;
         ObjectUtils.disposeObject(this._bag_Combox1);
         this._bag_Combox1 = null;
         ObjectUtils.disposeObject(this._bag_Combox2);
         this._bag_Combox2 = null;
         ObjectUtils.disposeObject(this._backBtn1);
         this._backBtn1 = null;
         ObjectUtils.disposeObject(this._nextBtn2);
         this._nextBtn2 = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._textinput2_1.setFocus();
         if(this._bagLockedController.bagLockedInfo.questionOne.length > 0 || this._bagLockedController.bagLockedInfo.isSelectCustomQuestion1 == true)
         {
            this._bag_Combox1.textField.text = this._bagLockedController.bagLockedInfo.questionOne;
         }
         if(this._bagLockedController.bagLockedInfo.questionTwo.length > 0 || this._bagLockedController.bagLockedInfo.isSelectCustomQuestion2 == true)
         {
            this._bag_Combox2.textField.text = this._bagLockedController.bagLockedInfo.questionTwo;
         }
         if(this._bagLockedController.bagLockedInfo.answerOne.length > 0)
         {
            this._textinput2_1.text = this._bagLockedController.bagLockedInfo.answerOne;
         }
         if(this._bagLockedController.bagLockedInfo.answerTwo.length > 0)
         {
            this._textinput2_2.text = this._bagLockedController.bagLockedInfo.answerTwo;
         }
         if(this._textinput2_1.text.length > 0 && this._textinput2_2.text.length > 0)
         {
            this._nextBtn2.enable = true;
            this._isSkip = true;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.guide");
         this._subtitle = ComponentFactory.Instance.creat("baglocked.subtitle");
         addToContent(this._subtitle);
         this._titText2_0 = ComponentFactory.Instance.creat("baglocked.text2_0");
         this._titText2_0.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.titText2");
         addToContent(this._titText2_0);
         this._textInfo2_1 = ComponentFactory.Instance.creat("baglocked.text2_1");
         this._textInfo2_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question1");
         addToContent(this._textInfo2_1);
         this._textInfo2_2 = ComponentFactory.Instance.creat("baglocked.text2_2");
         this._textInfo2_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer1");
         addToContent(this._textInfo2_2);
         this._textInfo2_3 = ComponentFactory.Instance.creat("baglocked.text2_3");
         this._textInfo2_3.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.inputTextInfo1");
         addToContent(this._textInfo2_3);
         this._textInfo2_4 = ComponentFactory.Instance.creat("baglocked.text2_4");
         this._textInfo2_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question2");
         addToContent(this._textInfo2_4);
         this._textInfo2_5 = ComponentFactory.Instance.creat("baglocked.text2_5");
         this._textInfo2_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer2");
         addToContent(this._textInfo2_5);
         this._textInfo2_6 = ComponentFactory.Instance.creat("baglocked.text2_6");
         this._textInfo2_6.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.inputTextInfo1");
         addToContent(this._textInfo2_6);
         this._textInfo2_7 = ComponentFactory.Instance.creat("baglocked.text2_7");
         this._textInfo2_7.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.textInfo2_7");
         addToContent(this._textInfo2_7);
         this._textinput2_1 = ComponentFactory.Instance.creat("baglocked.textInput2_1");
         addToContent(this._textinput2_1);
         this._textinput2_2 = ComponentFactory.Instance.creat("baglocked.textInput2_2");
         addToContent(this._textinput2_2);
         this._backBtn1 = ComponentFactory.Instance.creat("baglocked.backBtn1");
         this._backBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
         addToContent(this._backBtn1);
         this._nextBtn2 = ComponentFactory.Instance.creat("baglocked.nextBtn2");
         this._nextBtn2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         addToContent(this._nextBtn2);
         this._bag_Combox1 = ComponentFactory.Instance.creat("baglocked.bag_Combox1");
         this._bag_Combox1.selctedPropName = "text";
         this._bag_Combox1.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
         this._bag_Combox1.beginChanges();
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question1"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question2"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question3"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question4"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question5"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question6"));
         this._bag_Combox1.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.customer"));
         this._bag_Combox1.listPanel.list.updateListView();
         this._bag_Combox1.commitChanges();
         this._bag_Combox2 = ComponentFactory.Instance.creat("baglocked.bag_Combox2");
         this._bag_Combox2.selctedPropName = "text";
         this._bag_Combox2.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
         this._bag_Combox2.beginChanges();
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question1"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question2"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question3"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question4"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question5"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.question6"));
         this._bag_Combox2.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.customer"));
         this._bag_Combox2.listPanel.list.updateListView();
         this._bag_Combox2.commitChanges();
         addToContent(this._bag_Combox2);
         addToContent(this._bag_Combox1);
         this._textinput2_1.textField.tabIndex = 0;
         this._textinput2_2.textField.tabIndex = 1;
         this._textinput2_1.text = "";
         this._textinput2_2.text = "";
         this._nextBtn2.enable = false;
         this.addEvent();
      }
      
      private function __backBtn1Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.bagLockedInfo.questionOne = this._bag_Combox1.textField.text;
         this._bagLockedController.bagLockedInfo.questionTwo = this._bag_Combox2.textField.text;
         this._bagLockedController.bagLockedInfo.answerOne = this._textinput2_1.text;
         this._bagLockedController.bagLockedInfo.answerTwo = this._textinput2_2.text;
         this._bagLockedController.openSetPassFrame1();
         this._bagLockedController.closeSetPassFrame2();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.bagLockedInfo = null;
               this._bagLockedController.close();
         }
      }
      
      private function __listItemClick(param1:Event) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         SoundManager.instance.play("008");
         var _loc2_:ComboBox = param1.currentTarget as ComboBox;
         if(_loc2_.currentSelectedIndex == _loc2_.listPanel.vectorListModel.elements.length - 1)
         {
            stage.focus = _loc2_.textField;
            _loc2_.textField.type = TextFieldType.INPUT;
            _loc2_.textField.autoSize = "none";
            _loc2_.textField.maxChars = 14;
            _loc2_.textField.width = 200;
            _loc2_.textField.text = "";
            _loc2_.textField.selectable = true;
            _loc2_.textField.wordWrap = false;
            _loc2_.textField.multiline = false;
            _loc3_ = true;
         }
         else
         {
            _loc2_.textField.type = TextFieldType.DYNAMIC;
            _loc2_.textField.selectable = false;
            _loc2_.textField.mouseEnabled = false;
         }
         _loc4_ = true;
         if(_loc2_ == this._bag_Combox1)
         {
            this._bagLockedController.bagLockedInfo.isSelectCustomQuestion1 = _loc3_;
            this._bagLockedController.bagLockedInfo.isSelectQuestion1 = _loc4_;
         }
         else
         {
            this._bagLockedController.bagLockedInfo.isSelectCustomQuestion2 = _loc3_;
            this._bagLockedController.bagLockedInfo.isSelectQuestion2 = _loc4_;
         }
      }
      
      private function __nextBtn2Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._bagLockedController.bagLockedInfo.isSelectQuestion1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.selectQustion"));
            return;
         }
         if(!this._bagLockedController.bagLockedInfo.isSelectQuestion2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.selectQustion"));
            return;
         }
         if(StringUtils.trim(this._bag_Combox1.textField.text) == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputCompletely"));
            return;
         }
         if(StringUtils.trim(this._bag_Combox2.textField.text) == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputCompletely"));
            return;
         }
         if(this._bag_Combox1.textField.text == this._bag_Combox2.textField.text)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.cantRepeat"));
            return;
         }
         this._bagLockedController.bagLockedInfo.questionOne = this._bag_Combox1.textField.text;
         this._bagLockedController.bagLockedInfo.questionTwo = this._bag_Combox2.textField.text;
         this._bagLockedController.bagLockedInfo.answerOne = this._textinput2_1.text;
         this._bagLockedController.bagLockedInfo.answerTwo = this._textinput2_2.text;
         this._bagLockedController.openSetPassFrame3();
         this._bagLockedController.closeSetPassFrame2();
      }
      
      private function __textChange(param1:Event) : void
      {
         var _loc2_:String = this._textinput2_1.text;
         var _loc3_:String = this._textinput2_2.text;
         if(StringUtils.trim(_loc2_) != "" && StringUtils.trim(_loc3_) != "")
         {
            this._nextBtn2.enable = true;
         }
         else
         {
            this._nextBtn2.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textinput2_1.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textinput2_2.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textinput2_1.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textinput2_2.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._backBtn1.addEventListener(MouseEvent.CLICK,this.__backBtn1Click);
         this._nextBtn2.addEventListener(MouseEvent.CLICK,this.__nextBtn2Click);
         this._bag_Combox1.addEventListener(InteractiveEvent.STATE_CHANGED,this.__listItemClick);
         this._bag_Combox2.addEventListener(InteractiveEvent.STATE_CHANGED,this.__listItemClick);
         this._bag_Combox1.addEventListener(MouseEvent.CLICK,this.__ComboxClick);
         this._bag_Combox2.addEventListener(MouseEvent.CLICK,this.__ComboxClick);
      }
      
      private function __ComboxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textinput2_1.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textinput2_2.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textinput2_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textinput2_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._backBtn1.removeEventListener(MouseEvent.CLICK,this.__backBtn1Click);
         this._nextBtn2.removeEventListener(MouseEvent.CLICK,this.__nextBtn2Click);
         this._bag_Combox1.removeEventListener(Event.CHANGE,this.__listItemClick);
         this._bag_Combox2.removeEventListener(Event.CHANGE,this.__listItemClick);
         this._bag_Combox1.removeEventListener(MouseEvent.CLICK,this.__ComboxClick);
         this._bag_Combox2.removeEventListener(MouseEvent.CLICK,this.__ComboxClick);
      }
   }
}
