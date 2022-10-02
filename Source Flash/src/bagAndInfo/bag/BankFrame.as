package bagAndInfo.bag
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class BankFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bankbagView:BankBagView;
      
      public function BankFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.BagAndInfo.BankBag.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.bank.bg");
         this._bankbagView = ComponentFactory.Instance.creatCustomObject("bag.bankBagView");
         addToContent(this._bg);
         addToContent(this._bankbagView);
         this._bankbagView.isNeedCard(false);
         this._bankbagView.info = PlayerManager.Instance.Self;
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
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
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
