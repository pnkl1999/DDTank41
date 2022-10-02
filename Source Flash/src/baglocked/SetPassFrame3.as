package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class SetPassFrame3 extends Frame
   {
       
      
      private var _backBtn1:TextButton;
      
      private var _bagLockedController:BagLockedController;
      
      private var _completeBtn:TextButton;
      
      private var _subtitle:Image;
      
      private var _textInfo3_1:FilterFrameText;
      
      private var _textInfo3_2:FilterFrameText;
      
      private var _textInfo3_3:FilterFrameText;
      
      private var _textInfo3_4:FilterFrameText;
      
      private var _textInfo3_5:FilterFrameText;
      
      private var _textInfo3_6:FilterFrameText;
      
      private var _textInfo3_7:FilterFrameText;
      
      private var _textinput3_1:TextInput;
      
      private var _textinput3_2:TextInput;
      
      private var _titText3_0:FilterFrameText;
      
      public function SetPassFrame3()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(this._completeBtn.enable)
            {
               this.__completeBtnClick(null);
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
         ObjectUtils.disposeObject(this._titText3_0);
         this._titText3_0 = null;
         ObjectUtils.disposeObject(this._textInfo3_1);
         this._textInfo3_1 = null;
         ObjectUtils.disposeObject(this._textInfo3_2);
         this._textInfo3_2 = null;
         ObjectUtils.disposeObject(this._textInfo3_3);
         this._textInfo3_3 = null;
         ObjectUtils.disposeObject(this._textInfo3_4);
         this._textInfo3_4 = null;
         ObjectUtils.disposeObject(this._textInfo3_5);
         this._textInfo3_5 = null;
         ObjectUtils.disposeObject(this._textInfo3_6);
         this._textInfo3_6 = null;
         ObjectUtils.disposeObject(this._textInfo3_7);
         this._textInfo3_7 = null;
         ObjectUtils.disposeObject(this._textinput3_1);
         this._textinput3_1 = null;
         ObjectUtils.disposeObject(this._textinput3_2);
         this._textinput3_2 = null;
         ObjectUtils.disposeObject(this._backBtn1);
         this._backBtn1 = null;
         ObjectUtils.disposeObject(this._completeBtn);
         this._completeBtn = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._textInfo3_3.text = this._bagLockedController.bagLockedInfo.questionOne;
         this._textInfo3_6.text = this._bagLockedController.bagLockedInfo.questionTwo;
         this._textinput3_1.setFocus();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.guide");
         this._subtitle = ComponentFactory.Instance.creat("baglocked.subtitle");
         addToContent(this._subtitle);
         this._titText3_0 = ComponentFactory.Instance.creat("baglocked.text3_0");
         this._titText3_0.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame3.titText3");
         addToContent(this._titText3_0);
         this._textInfo3_1 = ComponentFactory.Instance.creat("baglocked.text3_1");
         this._textInfo3_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question1");
         addToContent(this._textInfo3_1);
         this._textInfo3_2 = ComponentFactory.Instance.creat("baglocked.text3_2");
         this._textInfo3_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer1");
         addToContent(this._textInfo3_2);
         this._textInfo3_3 = ComponentFactory.Instance.creat("baglocked.text3_3");
         addToContent(this._textInfo3_3);
         this._textInfo3_4 = ComponentFactory.Instance.creat("baglocked.text3_4");
         this._textInfo3_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question2");
         addToContent(this._textInfo3_4);
         this._textInfo3_5 = ComponentFactory.Instance.creat("baglocked.text3_5");
         this._textInfo3_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer2");
         addToContent(this._textInfo3_5);
         this._textInfo3_6 = ComponentFactory.Instance.creat("baglocked.text3_6");
         addToContent(this._textInfo3_6);
         this._textInfo3_7 = ComponentFactory.Instance.creat("baglocked.text3_7");
         this._textInfo3_7.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame3.textInfo3_7");
         addToContent(this._textInfo3_7);
         this._textinput3_1 = ComponentFactory.Instance.creat("baglocked.textInput3_1");
         addToContent(this._textinput3_1);
         this._textinput3_2 = ComponentFactory.Instance.creat("baglocked.textInput3_2");
         addToContent(this._textinput3_2);
         this._backBtn1 = ComponentFactory.Instance.creat("baglocked.backBtn1");
         this._backBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.preview");
         addToContent(this._backBtn1);
         this._completeBtn = ComponentFactory.Instance.creat("baglocked.completeBtn");
         this._completeBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete");
         addToContent(this._completeBtn);
         this._completeBtn.enable = false;
         this._textinput3_1.textField.tabIndex = 0;
         this._textinput3_2.textField.tabIndex = 1;
         this._textinput3_1.text = "";
         this._textinput3_2.text = "";
         this.addEvent();
      }
      
      private function __backBtn1Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.openSetPassFrame2();
         this._bagLockedController.closeSetPassFrame3();
      }
      
      private function __completeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._textinput3_1.text != this._bagLockedController.bagLockedInfo.answerOne)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.answerDiffer"));
            return;
         }
         if(this._textinput3_2.text != this._bagLockedController.bagLockedInfo.answerTwo)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.answerDiffer"));
            return;
         }
         PlayerManager.Instance.Self.questionOne = this._bagLockedController.bagLockedInfo.questionOne;
         PlayerManager.Instance.Self.questionTwo = this._bagLockedController.bagLockedInfo.questionTwo;
         this._bagLockedController.setPassComplete();
         this._bagLockedController.close();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.close();
         }
      }
      
      private function __textChange(param1:Event) : void
      {
         if(this._textinput3_1.text != "" && this._textinput3_2.text != "")
         {
            this._completeBtn.enable = true;
         }
         else
         {
            this._completeBtn.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textinput3_1.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textinput3_2.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textinput3_1.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textinput3_2.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._backBtn1.addEventListener(MouseEvent.CLICK,this.__backBtn1Click);
         this._completeBtn.addEventListener(MouseEvent.CLICK,this.__completeBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textinput3_1.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textinput3_2.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textinput3_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textinput3_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._backBtn1.removeEventListener(MouseEvent.CLICK,this.__backBtn1Click);
         this._completeBtn.removeEventListener(MouseEvent.CLICK,this.__completeBtnClick);
      }
   }
}
