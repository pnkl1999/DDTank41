package hotSpring.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class HotSpringAlertFrame extends Frame
   {
       
      
      private var _scrollPanel:ScrollPanel;
      
      private var _bg:Bitmap;
      
      private var _okBtn:TextButton;
      
      public function HotSpringAlertFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.hall.ChooseHallView.hotWellAlert");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("hall.hotSpringAlertPanel");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("hall.hotSpringBtn");
         addToContent(this._scrollPanel);
         this._scrollPanel.setView(this._bg);
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._okBtn);
         escEnable = true;
      }
      
      private function initEvents() : void
      {
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function removeEvents() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         super.dispose();
      }
   }
}
