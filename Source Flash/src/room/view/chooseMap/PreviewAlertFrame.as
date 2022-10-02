package room.view.chooseMap
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class PreviewAlertFrame extends Frame
   {
       
      
      private var _scrollPanel:ScrollPanel;
      
      private var _bg:Bitmap;
      
      private var _okBtn:TextButton;
      
      public function PreviewAlertFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("room.PreviewScrollPanel");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.fifthPreviewAsset");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("room.PreviewBtn");
         titleText = LanguageMgr.GetTranslation("tank.room.DungeonSneak");
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
         this.dispose();
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(param1);
      }
      
      private function removeEvents() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      override public function dispose() : void
      {
         SoundManager.instance.play("008");
         this.removeEvents();
         super.dispose();
      }
   }
}
