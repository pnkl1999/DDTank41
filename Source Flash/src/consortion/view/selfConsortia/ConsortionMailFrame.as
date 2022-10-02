package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import consortion.ConsortionModelControl;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   
   public class ConsortionMailFrame extends Frame
   {
      
      public static const MAIL_PAY:int = 1000;
       
      
      private var _bg:MovieClip;
      
      private var _topWord:Bitmap;
      
      private var _explain:Bitmap;
      
      private var _send:TextButton;
      
      private var _close:TextButton;
      
      private var _recevier:FilterFrameText;
      
      private var _topic:TextInput;
      
      private var _content:TextArea;
      
      public function ConsortionMailFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.mailFrame.title");
         this._bg = ClassUtils.CreatInstance("asset.consortion.mail.bg") as MovieClip;
         this._topWord = ComponentFactory.Instance.creatBitmap("asset.consortion.mail.topword");
         this._explain = ComponentFactory.Instance.creatBitmap("asset.consortion.mail.explain");
         this._send = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.send");
         this._close = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.close");
         this._recevier = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.recevier");
         this._topic = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.title");
         this._content = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.content");
         this._content.textField.maxChars = 200;
         addToContent(this._bg);
         addToContent(this._topWord);
         addToContent(this._explain);
         addToContent(this._send);
         addToContent(this._close);
         addToContent(this._recevier);
         addToContent(this._topic);
         addToContent(this._content);
         PositionUtils.setPos(this._bg,"consortion.mailFrame.bgPos");
         this._send.text = LanguageMgr.GetTranslation("send");
         this._close.text = LanguageMgr.GetTranslation("cancel");
         this._recevier.text = LanguageMgr.GetTranslation("ddt.consortion.mailFrame.all");
         this._topic.textField.maxChars = 16;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._content.textField.addEventListener(TextEvent.TEXT_INPUT,this._contentInputHandler);
         this._send.addEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_MAIL,this.__consortionMailResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._content.textField.removeEventListener(TextEvent.TEXT_INPUT,this._contentInputHandler);
         this._send.removeEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTION_MAIL,this.__consortionMailResponse);
      }
      
      private function __consortionMailResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.success"));
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.consortiaInfo.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.consortiaInfo.ConsortiaID);
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.fail"));
            this._send.enable = true;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function _contentInputHandler(param1:TextEvent) : void
      {
         if(this._content.text.length > 300)
         {
            param1.preventDefault();
         }
      }
      
      private function __sendHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < MAIL_PAY)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.noEnagth"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._topic.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.topic"));
            return;
         }
         if(this._content.text.length > 300)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.contentLength"));
            return;
         }
         var _loc2_:String = FilterWordManager.filterWrod(this._topic.text);
         var _loc3_:String = FilterWordManager.filterWrod(this._content.text);
         SocketManager.Instance.out.sendConsortionMail(_loc2_,_loc3_);
         this._send.enable = false;
      }
      
      private function __closeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._topWord = null;
         this._explain = null;
         this._send = null;
         this._close = null;
         this._recevier = null;
         this._topic = null;
         this._content = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
