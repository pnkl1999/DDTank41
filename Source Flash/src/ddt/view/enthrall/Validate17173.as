package ddt.view.enthrall
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.manager.EnthrallManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Validate17173 extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _okBtn:TextButton;
      
      public function Validate17173()
      {
         super();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("asset.core.view.enthrall.Alert");
         addToContent(this._bg);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._okBtn.y = this._bg.y + this._bg.height + 20;
         this._okBtn.x = 165;
         this._okBtn.text = LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkBtn");
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__check);
         addToContent(this._okBtn);
         titleText = LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkTitle");
      }
      
      private function __check(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setFlashCall");
         }
         if(EnthrallManager.getInstance().interfaceID == 1)
         {
            navigateToURL(new URLRequest("http://mygame.17173.com/ddt/fcm/"),"_blank");
         }
         else if(EnthrallManager.getInstance().interfaceID == 2)
         {
            navigateToURL(new URLRequest("http://fcm.duowan.com"),"_blank");
         }
         else if(EnthrallManager.getInstance().interfaceID == 3)
         {
            navigateToURL(new URLRequest("http://www.kaixin001.com/interface/realid.php?newpage=1"),"_blank");
         }
         else if(EnthrallManager.getInstance().interfaceID == 4)
         {
            navigateToURL(new URLRequest("http://youxi.baidu.com/i/my_info.xhtml?gid=108"),"_blank");
         }
         else if(EnthrallManager.getInstance().interfaceID == 5)
         {
            navigateToURL(new URLRequest("http://account.changyou.com/quickRegister/QuickRegDetail.jsp"),"_blank");
         }
         this.dispose();
      }
      
      private function clear() : void
      {
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
         }
      }
      
      public function hide() : void
      {
         this.clear();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         this.hide();
         this.removeEvent();
         this._okBtn.dispose();
         this._bg = null;
         super.dispose();
      }
   }
}
