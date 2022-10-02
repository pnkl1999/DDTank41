package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   
   public class BadgeShopFrame extends Frame
   {
       
      
      private var _panel:BadgeShopPanel;
      
      public function BadgeShopFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("consortion.buyBadgeFrameTitle");
         escEnable = true;
      }
      
      override protected function init() : void
      {
         super.init();
         this._panel = new BadgeShopPanel();
         PositionUtils.setPos(this._panel,"consortiaBadgePanel.pos");
         addToContent(this._panel);
      }
      
      override protected function onResponse(param1:int) : void
      {
         switch(param1)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               SoundManager.instance.playButtonSound();
               this.dispose();
         }
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this._panel.dispose();
         this._panel = null;
         super.dispose();
      }
   }
}
