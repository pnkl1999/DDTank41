package ddt.view.chat
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import road7th.utils.StringHelper;
   
   public class ChatBugleInputFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textTitle:Bitmap;
      
      private var _remainTxt:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _remainStr:String;
      
      public var templateID:int;
      
      public function ChatBugleInputFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameBg");
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameTextBg");
         this._textTitle = ComponentFactory.Instance.creatBitmap("asset.chat.BugleInputTitleBitmap");
         this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameRemainText");
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameInputText");
         titleText = LanguageMgr.GetTranslation("chat.BugleInputFrameTitleString");
         this._remainStr = LanguageMgr.GetTranslation("chat.BugleInputFrameRemainString");
         this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
         addToContent(this._bg);
         addToContent(this._textBg);
         addToContent(this._textTitle);
         addToContent(this._remainTxt);
         addToContent(this._inputTxt);
         addEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
      }
      
      private function initEvents() : void
      {
         _submitButton.addEventListener(MouseEvent.CLICK,__onSubmitClick);
         this._inputTxt.addEventListener(Event.CHANGE,this.__upDateRemainTxt);
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __setFocus(param1:Event) : void
      {
         setTimeout(this._inputTxt.setFocus,100);
         this.initEvents();
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:RegExp = null;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               if(StringHelper.trim(this._inputTxt.text).length <= 0)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("chat.BugleInputNull"));
                  return;
               }
               _loc2_ = FilterWordManager.filterWrod(this._inputTxt.text);
               _loc3_ = /\r/gm;
               _loc2_ = _loc2_.replace(_loc3_,"");
               SocketManager.Instance.out.sendBBugle(_loc2_,this.templateID);
               this._inputTxt.text = "";
               this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
               if(parent)
               {
                  parent.removeChild(this);
               }
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._inputTxt.text = "";
               this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
               if(parent)
               {
                  parent.removeChild(this);
               }
         }
      }
      
      private function __upDateRemainTxt(param1:Event) : void
      {
         this._remainTxt.text = this._remainStr + String(this._inputTxt.maxChars - this._inputTxt.text.length);
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         _submitButton.removeEventListener(MouseEvent.CLICK,__onSubmitClick);
         this._inputTxt.removeEventListener(Event.CHANGE,this.__upDateRemainTxt);
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._textBg)
         {
            ObjectUtils.disposeObject(this._textBg);
         }
         this._textBg = null;
         if(this._textTitle)
         {
            ObjectUtils.disposeObject(this._textTitle);
         }
         this._textTitle = null;
         if(this._remainTxt)
         {
            ObjectUtils.disposeObject(this._remainTxt);
         }
         this._remainTxt = null;
         if(this._inputTxt)
         {
            ObjectUtils.disposeObject(this._inputTxt);
         }
         this._inputTxt = null;
         super.dispose();
      }
   }
}
