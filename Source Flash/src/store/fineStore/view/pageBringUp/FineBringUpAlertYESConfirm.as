package store.fineStore.view.pageBringUp
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class FineBringUpAlertYESConfirm extends SimpleAlert
   {
       
      
      private var _confirmLabel:FilterFrameText;
      
      private var _confirmInput:TextInput;
      
      private var _itemNameText:FilterFrameText;
      
      private var _icon:Bitmap;
      
      public function FineBringUpAlertYESConfirm()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         enterEnable = true;
         escEnable = true;
         this._confirmLabel = ComponentFactory.Instance.creat("storeBringUp.alertYesLabel");
         this._confirmLabel.htmlText = LanguageMgr.GetTranslation("tank.view.bagII.alertConfirm");
         addToContent(this._confirmLabel);
         this._confirmInput = ComponentFactory.Instance.creat("storeBringUp.alertInput");
         addToContent(this._confirmInput);
         this._confirmInput.textField.addEventListener(Event.CHANGE,this.onInput);
         this._confirmInput.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         textStyle = "bringup.simpleAlertContentText";
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
            param1.stopPropagation();
         }
      }
      
      override public function set submitButtonStyle(param1:String) : void
      {
         if(_submitButtonStyle == param1)
         {
            return;
         }
         _submitButtonStyle = param1;
         _submitButton = ComponentFactory.Instance.creat(_submitButtonStyle);
         onPropertiesChanged(P_submitButton);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         _submitButton && false;
      }
      
      protected function onInput(param1:Event) : void
      {
         if(this._confirmInput.text.toLowerCase() == "yes")
         {
            _submitButton.enable = true;
         }
         else
         {
            _submitButton.enable = false;
         }
      }
      
      public function upadteView(param1:String, param2:String) : void
      {
         !this._itemNameText && (this._itemNameText = ComponentFactory.Instance.creat("bringup.itemNameText"));
         addToContent(this._itemNameText);
         this._itemNameText.text = param2;
         textStyle = "bringup.simpleAlertContentText";
         _textField.x = 69;
         _textField.y = 48;
         _textField.multiline = true;
         _textField.wordWrap = true;
         _textField.width = 250;
         _textField.height = 50;
         _textField.htmlText = param1;
      }
      
      public function isYesCorrect() : Boolean
      {
         return this._confirmInput.text.toLowerCase() == "yes";
      }
      
      override public function dispose() : void
      {
         this._confirmInput && this._confirmInput.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._confirmInput && this._confirmInput.textField.removeEventListener(Event.CHANGE,this.onInput);
         super.dispose();
         this._confirmInput = null;
      }
   }
}
