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
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   
   public class BagLockedGetFrame extends Frame
   {
       
      
      private var _bagLockedController:BagLockedController;
      
      private var _certainBtn:TextButton;
      
      private var _deselectBtn:TextButton;
      
      private var _text4_0:FilterFrameText;
      
      private var _text4_1:FilterFrameText;
      
      private var _textInput4:TextInput;
      
      public function BagLockedGetFrame()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == 13)
         {
            if(this._certainBtn.enable)
            {
               this.__certainBtnClick(null);
            }
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this._bagLockedController.closeBagLockedGetFrame();
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
         ObjectUtils.disposeObject(this._text4_0);
         this._text4_0 = null;
         ObjectUtils.disposeObject(this._text4_1);
         this._text4_1 = null;
         ObjectUtils.disposeObject(this._textInput4);
         this._textInput4 = null;
         ObjectUtils.disposeObject(this._certainBtn);
         this._certainBtn = null;
         ObjectUtils.disposeObject(this._deselectBtn);
         this._deselectBtn = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__getFocus);
      }
      
      override protected function __onAddToStage(param1:Event) : void
      {
         super.__onAddToStage(param1);
         this._textInput4.setFocus();
         setTimeout(this.getFocus,100);
      }
      
      private function getFocus() : void
      {
         if(this._textInput4)
         {
            this._textInput4.setFocus();
         }
      }
      
      private function __getFocus(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(parent && this)
         {
            this._textInput4.setFocus();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.unlock");
         this._text4_0 = ComponentFactory.Instance.creat("baglocked.text4_0");
         this._text4_0.text = LanguageMgr.GetTranslation("baglocked.BagLockedGetFrame.Text4");
         addToContent(this._text4_0);
         this._text4_1 = ComponentFactory.Instance.creat("baglocked.text4_1");
         this._text4_1.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1.baglocked");
         addToContent(this._text4_1);
         this._textInput4 = ComponentFactory.Instance.creat("baglocked.textInput4");
         addToContent(this._textInput4);
         this._certainBtn = ComponentFactory.Instance.creat("baglocked.certainBtn");
         this._certainBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._certainBtn);
         this._deselectBtn = ComponentFactory.Instance.creat("baglocked.deselectBtn");
         this._deselectBtn.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._deselectBtn);
         this._textInput4.textField.tabIndex = 0;
         this._certainBtn.enable = false;
         this.addEvent();
      }
      
      private function __certainBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__getFocus);
         this._bagLockedController.bagLockedInfo.psw = this._textInput4.text;
         this._bagLockedController.BagLockedGetFrameController();
      }
      
      private function __deselectBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.closeBagLockedGetFrame();
      }
      
      private function __clearSuccessHandler(param1:BagEvent) : void
      {
         this._bagLockedController.closeBagLockedGetFrame();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.closeBagLockedGetFrame();
         }
      }
      
      private function __textChange(param1:Event) : void
      {
         if(this._textInput4.text != "")
         {
            this._certainBtn.enable = true;
         }
         else
         {
            this._certainBtn.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput4.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput4.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter,false,1000);
         this._certainBtn.addEventListener(MouseEvent.CLICK,this.__certainBtnClick);
         this._deselectBtn.addEventListener(MouseEvent.CLICK,this.__deselectBtnClick);
         PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR,this.__clearSuccessHandler);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput4.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput4.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._certainBtn.addEventListener(MouseEvent.CLICK,this.__certainBtnClick);
         this._deselectBtn.removeEventListener(MouseEvent.CLICK,this.__deselectBtnClick);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,this.__clearSuccessHandler);
      }
   }
}
