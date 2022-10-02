package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ConsortionQuitFrame extends Frame
   {
       
      
      private var _bg:MutipleImage;
      
      private var _explain:FilterFrameText;
      
      private var _input:TextInput;
      
      private var _ok:TextButton;
      
      private var _cancel:TextButton;
      
      public function ConsortionQuitFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ExitConsortiaFrame.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.bg");
         this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.explain");
         this._input = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.input");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.quitFrame.cancel");
         addToContent(this._bg);
         addToContent(this._explain);
         addToContent(this._input);
         addToContent(this._ok);
         addToContent(this._cancel);
         this._explain.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ExitConsortiaFrame.quit");
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._ok.enable = false;
         this._input.textField.maxChars = 8;
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
            this.quit();
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._input.setFocus();
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.quit();
      }
      
      private function quit() : void
      {
         if(this._input.text.toLowerCase() == "quit")
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            SocketManager.Instance.out.sendConsortiaOut(PlayerManager.Instance.Self.ID);
            ConsortionModelControl.Instance.quitConstrion = true;
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
         if(this._input.text.toLowerCase() == "quit")
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
            SoundManager.instance.play("008");
            this.quit();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._explain = null;
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
