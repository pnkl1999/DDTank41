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
   
   public class UpdatePassFrame extends Frame
   {
       
      
      private var _bagLockedController:BagLockedController;
      
      private var _deselectBtn5:TextButton;
      
      private var _text5_1:FilterFrameText;
      
      private var _text5_2:FilterFrameText;
      
      private var _text5_3:FilterFrameText;
      
      private var _text5_4:FilterFrameText;
      
      private var _text5_5:FilterFrameText;
      
      private var _textInput5_1:TextInput;
      
      private var _textInput5_2:TextInput;
      
      private var _textInput5_3:TextInput;
      
      private var _updateBtn:TextButton;
      
      public function UpdatePassFrame()
      {
         super();
      }
      
      public function __onTextEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            if(this._updateBtn.enable)
            {
               this.__updateBtnClick(null);
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
         ObjectUtils.disposeObject(this._text5_1);
         this._text5_1 = null;
         ObjectUtils.disposeObject(this._text5_2);
         this._text5_2 = null;
         ObjectUtils.disposeObject(this._text5_3);
         this._text5_3 = null;
         ObjectUtils.disposeObject(this._text5_4);
         this._text5_4 = null;
         ObjectUtils.disposeObject(this._text5_5);
         this._text5_5 = null;
         ObjectUtils.disposeObject(this._textInput5_1);
         this._textInput5_1 = null;
         ObjectUtils.disposeObject(this._textInput5_2);
         this._textInput5_2 = null;
         ObjectUtils.disposeObject(this._textInput5_3);
         this._textInput5_3 = null;
         ObjectUtils.disposeObject(this._updateBtn);
         this._updateBtn = null;
         ObjectUtils.disposeObject(this._deselectBtn5);
         this._deselectBtn5 = null;
         super.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._text5_5.text = LanguageMgr.GetTranslation("baglocked.DelPassFrame.operationAlertInfo",PlayerManager.Instance.Self.leftTimes);
         setTimeout(this._textInput5_1.setFocus,100);
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modifyTitle");
         this._text5_1 = ComponentFactory.Instance.creat("baglocked.text5_1");
         this._text5_1.text = LanguageMgr.GetTranslation("baglocked.UpdatePassFrame.Text5");
         addToContent(this._text5_1);
         this._text5_2 = ComponentFactory.Instance.creat("baglocked.text5_2");
         this._text5_2.text = LanguageMgr.GetTranslation("baglocked.UpdatePassFrame.Text6");
         addToContent(this._text5_2);
         this._text5_3 = ComponentFactory.Instance.creat("baglocked.text5_3");
         this._text5_3.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo2");
         addToContent(this._text5_3);
         this._text5_4 = ComponentFactory.Instance.creat("baglocked.text5_4");
         this._text5_4.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo3");
         addToContent(this._text5_4);
         this._text5_5 = ComponentFactory.Instance.creat("baglocked.text5_5");
         addToContent(this._text5_5);
         this._textInput5_1 = ComponentFactory.Instance.creat("baglocked.textInput5_1");
         addToContent(this._textInput5_1);
         this._textInput5_2 = ComponentFactory.Instance.creat("baglocked.textInput5_2");
         addToContent(this._textInput5_2);
         this._textInput5_3 = ComponentFactory.Instance.creat("baglocked.textInput5_3");
         addToContent(this._textInput5_3);
         this._updateBtn = ComponentFactory.Instance.creat("baglocked.updateBtn");
         this._updateBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modifyBtn");
         addToContent(this._updateBtn);
         this._deselectBtn5 = ComponentFactory.Instance.creat("baglocked.deselectBtn5");
         this._deselectBtn5.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._deselectBtn5);
         this._textInput5_1.textField.tabIndex = 0;
         this._textInput5_2.textField.tabIndex = 1;
         this._textInput5_3.textField.tabIndex = 2;
         this._updateBtn.enable = false;
         this.addEvent();
      }
      
      private function __deselectBtn5Click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.closeUpdatePassFrame();
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
         if(this._textInput5_1.textField.length >= 6 && this._textInput5_2.textField.length >= 6 && this._textInput5_3.textField.length >= 6 && PlayerManager.Instance.Self.leftTimes > 0)
         {
            this._updateBtn.enable = true;
         }
         else
         {
            this._updateBtn.enable = false;
         }
      }
      
      private function __updateBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.play("008");
         if(this._textInput5_2.text == this._textInput5_3.text)
         {
            if(PlayerManager.Instance.Self.leftTimes <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.operationTimesOut"));
               this._updateBtn.enable = false;
               return;
            }
            --PlayerManager.Instance.Self.leftTimes;
            _loc2_ = PlayerManager.Instance.Self.leftTimes <= 0 ? "0" : String(PlayerManager.Instance.Self.leftTimes);
            this._text5_5.text = LanguageMgr.GetTranslation("baglocked.DelPassFrame.operationAlertInfo",_loc2_);
            this._bagLockedController.bagLockedInfo.psw = this._textInput5_1.text;
            this._bagLockedController.bagLockedInfo.newPwd = this._textInput5_2.text;
            this._bagLockedController.updatePassFrameController();
            this.refreshBtnsState();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.diffrent"));
         }
      }
      
      private function __updateSuccessHandler(param1:BagEvent) : void
      {
         this._bagLockedController.closeUpdatePassFrame();
      }
      
      private function refreshBtnsState() : void
      {
         if(PlayerManager.Instance.Self.leftTimes <= 0)
         {
            this._updateBtn.enable = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput5_1.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_1.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput5_2.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_2.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput5_3.textField.addEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_3.textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._updateBtn.addEventListener(MouseEvent.CLICK,this.__updateBtnClick);
         this._deselectBtn5.addEventListener(MouseEvent.CLICK,this.__deselectBtn5Click);
         PlayerManager.Instance.Self.addEventListener(BagEvent.UPDATE_SUCCESS,this.__updateSuccessHandler);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput5_1.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_1.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput5_2.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_2.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._textInput5_3.textField.removeEventListener(Event.CHANGE,this.__textChange);
         this._textInput5_3.textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextEnter);
         this._updateBtn.removeEventListener(MouseEvent.CLICK,this.__updateBtnClick);
         this._deselectBtn5.removeEventListener(MouseEvent.CLICK,this.__deselectBtn5Click);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.UPDATE_SUCCESS,this.__updateSuccessHandler);
      }
   }
}
