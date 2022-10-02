package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ConsortionBankFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _titleBmp:Bitmap;
      
      private var _bankbagView:ConsortionBankBagView;
      
      public function ConsortionBankFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.consortiabank.ConsortiaBankView.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.bank.bg");
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.consortion.bankFrame.title");
         this._bankbagView = ComponentFactory.Instance.creatCustomObject("consortionBankBagView");
         addToContent(this._bg);
         addToContent(this._titleBmp);
         addToContent(this._bankbagView);
         this._bankbagView.isNeedCard(false);
         this._bankbagView.info = PlayerManager.Instance.Self;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._bankbagView)
         {
            this._bankbagView.dispose();
         }
         this._bankbagView = null;
         super.dispose();
         this._bg = null;
         this._titleBmp = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
