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
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class SetPassFrameNew extends Frame
   {
       
      
      private var _bagLockedController:BagLockedController;
      
      private var _completeBtn7:TextButton;
      
      private var _subtitle:Image;
      
      private var _text7_0:FilterFrameText;
      
      private var _text7_1:FilterFrameText;
      
      private var _text7_2:FilterFrameText;
      
      private var _text7_3:FilterFrameText;
      
      private var _text7_4:FilterFrameText;
      
      private var _text7_5:FilterFrameText;
      
      private var _textInput7_1:TextInput;
      
      private var _textInput7_2:TextInput;
      
      public function SetPassFrameNew()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(this._completeBtn7.enable)
            {
               this.__completeBtn7Click(null);
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
         ObjectUtils.disposeObject(this._text7_0);
         this._text7_0 = null;
         ObjectUtils.disposeObject(this._text7_1);
         this._text7_1 = null;
         ObjectUtils.disposeObject(this._text7_2);
         this._text7_2 = null;
         ObjectUtils.disposeObject(this._text7_3);
         this._text7_3 = null;
         ObjectUtils.disposeObject(this._text7_4);
         this._text7_4 = null;
         ObjectUtils.disposeObject(this._text7_5);
         this._text7_5 = null;
         ObjectUtils.disposeObject(this._textInput7_1);
         this._textInput7_1 = null;
         ObjectUtils.disposeObject(this._textInput7_2);
         this._textInput7_2 = null;
         ObjectUtils.disposeObject(this._completeBtn7);
         this._completeBtn7 = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         setTimeout(this._textInput7_1.setFocus,100);
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagLockedBtn");
         this._subtitle = ComponentFactory.Instance.creat("baglocked.subtitle");
         addToContent(this._subtitle);
         this._text7_0 = ComponentFactory.Instance.creat("baglocked.text7_0");
         this._text7_0.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.setted");
         addToContent(this._text7_0);
         this._text7_1 = ComponentFactory.Instance.creat("baglocked.text7_1");
         this._text7_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1");
         addToContent(this._text7_1);
         this._text7_2 = ComponentFactory.Instance.creat("baglocked.text7_2");
         this._text7_2.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo2");
         addToContent(this._text7_2);
         this._text7_3 = ComponentFactory.Instance.creat("baglocked.text7_3");
         this._text7_3.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo3");
         addToContent(this._text7_3);
         this._text7_4 = ComponentFactory.Instance.creat("baglocked.text7_4");
         this._text7_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo2");
         addToContent(this._text7_4);
         this._text7_5 = ComponentFactory.Instance.creat("baglocked.text7_5");
         this._text7_5.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo4");
         addToContent(this._text7_5);
         this._textInput7_1 = ComponentFactory.Instance.creat("baglocked.textInput7_1");
         addToContent(this._textInput7_1);
         this._textInput7_2 = ComponentFactory.Instance.creat("baglocked.textInput7_2");
         addToContent(this._textInput7_2);
         this._completeBtn7 = ComponentFactory.Instance.creat("baglocked.completeBtn7");
         this._completeBtn7.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete");
         addToContent(this._completeBtn7);
         this._textInput7_1.textField.tabIndex = 0;
         this._textInput7_2.textField.tabIndex = 1;
         this._completeBtn7.enable = false;
         this.addEvent();
      }
      
      private function __completeBtn7Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._textInput7_1.text == this._textInput7_2.text)
         {
            this._bagLockedController.bagLockedInfo.psw = this._textInput7_1.text;
            this._bagLockedController.setPassFrameNewController();
            this._bagLockedController.closeSetPassFrameNew();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.diffrent"));
         }
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
         if(this._textInput7_1.textField.length >= 6 && this._textInput7_2.textField.length >= 6)
         {
            this._completeBtn7.enable = true;
         }
         else
         {
            this._completeBtn7.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput7_1.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput7_1.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput7_2.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput7_2.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._completeBtn7.addEventListener(MouseEvent.CLICK,this.__completeBtn7Click);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput7_1.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput7_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput7_2.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput7_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._completeBtn7.removeEventListener(MouseEvent.CLICK,this.__completeBtn7Click);
      }
   }
}
