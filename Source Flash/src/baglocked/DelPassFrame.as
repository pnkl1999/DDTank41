package baglocked
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class DelPassFrame extends Frame
   {
       
      
      private var _bagLockedController:BagLockedController;
      
      private var _delBtn:TextButton;
      
      private var _deselectBtn6:TextButton;
      
      private var _text6_1:FilterFrameText;
      
      private var _text6_2:FilterFrameText;
      
      private var _text6_3:FilterFrameText;
      
      private var _text6_4:FilterFrameText;
      
      private var _text6_5:FilterFrameText;
      
      private var _text6_6:FilterFrameText;
      
      private var _text6_7:FilterFrameText;
      
      private var _textInput6_1:TextInput;
      
      private var _textInput6_2:TextInput;
      
      public function DelPassFrame()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(this._delBtn.enable)
            {
               this.__delBtnClick(null);
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
         ObjectUtils.disposeObject(this._text6_1);
         this._text6_1 = null;
         ObjectUtils.disposeObject(this._text6_2);
         this._text6_2 = null;
         ObjectUtils.disposeObject(this._text6_3);
         this._text6_3 = null;
         ObjectUtils.disposeObject(this._text6_4);
         this._text6_4 = null;
         ObjectUtils.disposeObject(this._text6_5);
         this._text6_5 = null;
         ObjectUtils.disposeObject(this._text6_6);
         this._text6_6 = null;
         ObjectUtils.disposeObject(this._text6_7);
         this._text6_7 = null;
         ObjectUtils.disposeObject(this._textInput6_1);
         this._textInput6_1 = null;
         ObjectUtils.disposeObject(this._textInput6_2);
         this._textInput6_2 = null;
         ObjectUtils.disposeObject(this._delBtn);
         this._delBtn = null;
         ObjectUtils.disposeObject(this._deselectBtn6);
         this._deselectBtn6 = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._text6_3.text = PlayerManager.Instance.Self.questionOne;
         this._text6_6.text = PlayerManager.Instance.Self.questionTwo;
         this._text6_7.text = LanguageMgr.GetTranslation("baglocked.DelPassFrame.operationAlertInfo",PlayerManager.Instance.Self.leftTimes);
         setTimeout(this._textInput6_1.setFocus,100);
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deletePassword");
         this._text6_1 = ComponentFactory.Instance.creat("baglocked.text6_1");
         this._text6_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question1");
         addToContent(this._text6_1);
         this._text6_2 = ComponentFactory.Instance.creat("baglocked.text6_2");
         this._text6_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer1");
         addToContent(this._text6_2);
         this._text6_3 = ComponentFactory.Instance.creat("baglocked.text6_3");
         addToContent(this._text6_3);
         this._text6_4 = ComponentFactory.Instance.creat("baglocked.text6_4");
         this._text6_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.question2");
         addToContent(this._text6_4);
         this._text6_5 = ComponentFactory.Instance.creat("baglocked.text6_5");
         this._text6_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame2.answer2");
         addToContent(this._text6_5);
         this._text6_6 = ComponentFactory.Instance.creat("baglocked.text6_6");
         addToContent(this._text6_6);
         this._text6_7 = ComponentFactory.Instance.creat("baglocked.text6_7");
         addToContent(this._text6_7);
         this._textInput6_1 = ComponentFactory.Instance.creat("baglocked.textInput6_1");
         addToContent(this._textInput6_1);
         this._textInput6_2 = ComponentFactory.Instance.creat("baglocked.textInput6_2");
         addToContent(this._textInput6_2);
         this._delBtn = ComponentFactory.Instance.creat("baglocked.delBtn");
         this._delBtn.text = LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.delete");
         addToContent(this._delBtn);
         this._deselectBtn6 = ComponentFactory.Instance.creat("baglocked.deselectBtn6");
         this._deselectBtn6.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._deselectBtn6);
         this._textInput6_1.textField.tabIndex = 0;
         this._textInput6_2.textField.tabIndex = 1;
         this._textInput6_1.text = "";
         this._textInput6_2.text = "";
         this._delBtn.enable = false;
         this.addEvent();
      }
      
      private function __delBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.leftTimes <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.operationTimesOut"));
            this._delBtn.enable = false;
            return;
         }
         --PlayerManager.Instance.Self.leftTimes;
         var _loc2_:String = PlayerManager.Instance.Self.leftTimes <= 0 ? "0" : String(PlayerManager.Instance.Self.leftTimes);
         this._text6_7.text = LanguageMgr.GetTranslation("baglocked.DelPassFrame.operationAlertInfo",_loc2_);
         this._bagLockedController.bagLockedInfo.questionOne = this._text6_3.text;
         this._bagLockedController.bagLockedInfo.questionTwo = this._text6_6.text;
         this._bagLockedController.bagLockedInfo.answerOne = this._textInput6_1.text;
         this._bagLockedController.bagLockedInfo.answerTwo = this._textInput6_2.text;
         this._bagLockedController.delPassFrameController();
         this.refreshBtnsState();
      }
      
      private function refreshBtnsState() : void
      {
         if(PlayerManager.Instance.Self.leftTimes <= 0)
         {
            this._delBtn.enable = false;
         }
      }
      
      private function __deselectBtn6Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
      }
      
      private function __delPasswordHandler(param1:BagEvent) : void
      {
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
         if(this._textInput6_1.text != "" && this._textInput6_2.text != "" && PlayerManager.Instance.Self.leftTimes > 0)
         {
            this._delBtn.enable = true;
         }
         else
         {
            this._delBtn.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput6_1.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput6_1.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput6_2.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput6_2.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._delBtn.addEventListener(MouseEvent.CLICK,this.__delBtnClick);
         this._deselectBtn6.addEventListener(MouseEvent.CLICK,this.__deselectBtn6Click);
         PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL,this.__delPasswordHandler);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput6_1.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput6_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput6_2.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput6_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._delBtn.removeEventListener(MouseEvent.CLICK,this.__delBtnClick);
         this._deselectBtn6.removeEventListener(MouseEvent.CLICK,this.__deselectBtn6Click);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,this.__delPasswordHandler);
      }
   }
}
