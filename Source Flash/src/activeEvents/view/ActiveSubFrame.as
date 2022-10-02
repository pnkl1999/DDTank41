package activeEvents.view
{
   import activeEvents.ActiveController;
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ActiveSubFrame extends Frame
   {
       
      
      private var _closeBtn:TextButton;
      
      private var _panel:ScrollPanel;
      
      private var _control:ActiveController;
      
      private var _content:ActiveSubContent;
      
      private var _bg:Bitmap;
      
      public function ActiveSubFrame()
      {
         super();
         this._init();
         this.addEvent();
      }
      
      public function set control(param1:ActiveController) : void
      {
         this._control = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         this._control.activeSubFrame = null;
         this._control = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      public function receiveItem(param1:ActiveEventsInfo) : void
      {
         this._content.info = param1;
      }
      
      private function _init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.mainBg");
         this._bg.width = 355;
         addToContent(this._bg);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeCloseBtnII");
         this._closeBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._closeBtn);
         this._content = new ActiveSubContent();
         addToContent(this._content);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._frameEventHd);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this._closeBtnHd);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._frameEventHd);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this._closeBtnHd);
      }
      
      private function _frameEventHd(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      private function _closeBtnHd(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._control.closeSubFrame();
      }
   }
}
