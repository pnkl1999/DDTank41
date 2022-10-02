package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class WantTakeInFrame extends Frame
   {
       
      
      private var _tip:FilterFrameText;
      
      private var _input:TextInput;
      
      private var _ok:TextButton;
      
      private var _cancel:TextButton;
      
      public function WantTakeInFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         enterEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.RecruitMemberFrame.titleText");
         this._tip = ComponentFactory.Instance.creatComponentByStylename("consortion.WantTakeInFrame.tip");
         this._input = ComponentFactory.Instance.creatComponentByStylename("consortion.WantTakeInFrame.input");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.WantTakeInFrame.ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.WantTakeInFrame.cancel");
         addToContent(this._input);
         addToContent(this._tip);
         addToContent(this._ok);
         addToContent(this._cancel);
         this._tip.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.RecruitMemberFrame.tipTxt");
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._ok.enable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._ok.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._input.addEventListener(Event.CHANGE,this.__inputChangeHandler);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._input.removeEventListener(Event.CHANGE,this.__inputChangeHandler);
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
         if(param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__clickHandler(null);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._input.setFocus();
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._input.text != "")
         {
            SocketManager.Instance.out.sendConsortiaInvate(StringHelper.trim(this._input.text));
            this.dispose();
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __inputChangeHandler(param1:Event) : void
      {
         StringHelper.checkTextFieldLength(this._input.textField,14);
         if(this._input.text != "")
         {
            this._ok.enable = true;
         }
         else
         {
            this._ok.enable = false;
         }
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__clickHandler(null);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._tip = null;
         this._input = null;
         this._ok = null;
         this._cancel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
