package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.view.club.CreateConsortionFrame;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ConsortionTrasferFrame extends Frame
   {
       
      
      private var _input:TextInput;
      
      private var _explain:FilterFrameText;
      
      private var _hint:FilterFrameText;
      
      private var _ok:TextButton;
      
      private var _cancel:TextButton;
      
      public function ConsortionTrasferFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
         this._input = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.input");
         this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.explain");
         this._hint = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.hint");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.cancel");
         addToContent(this._input);
         addToContent(this._explain);
         addToContent(this._hint);
         addToContent(this._ok);
         addToContent(this._cancel);
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._explain.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.inputName");
         this._hint.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.info");
         this._ok.enable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._input.addEventListener(Event.CHANGE,this.__changeHandler);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._input.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._input.setFocus();
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
            this.__okHandler(null);
         }
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._ok.enable = false;
         for each(_loc2_ in ConsortionModelControl.Instance.model.memberList)
         {
            if(_loc2_.NickName == this._input.text)
            {
               if(this._input.text == PlayerManager.Instance.Self.NickName)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.NickName"));
                  this._ok.enable = false;
                  this._input.text = "";
                  return;
               }
               if(_loc2_.Grade < CreateConsortionFrame.MIN_CREAT_CONSROTIA_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.Grade"));
                  this._ok.enable = false;
                  this._input.text = "";
                  return;
               }
               SocketManager.Instance.out.sendConsortiaChangeChairman(this._input.text);
               this._input.text = "";
               this.dispose();
               return;
            }
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __changeHandler(param1:Event) : void
      {
         var _loc2_:ConsortiaPlayerInfo = null;
         if(this._input.text != "")
         {
            for each(_loc2_ in ConsortionModelControl.Instance.model.memberList)
            {
               if(_loc2_.NickName == this._input.text)
               {
                  this._ok.enable = true;
                  return;
               }
            }
         }
         this._ok.enable = false;
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._ok.enable)
            {
               this.__okHandler(null);
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._input = null;
         this._explain = null;
         this._hint = null;
         this._ok = null;
         this._cancel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
