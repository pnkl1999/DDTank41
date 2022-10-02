package trainer.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class GhostTipFrame extends Frame
   {
       
      
      private var content:Bitmap;
      
      private var _titleStr:String;
      
      private var _okStr:String;
      
      private var _okBtn:TextButton;
      
      public function GhostTipFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.content = ComponentFactory.Instance.creat("asset.trainer.ghostTip");
         this._titleStr = LanguageMgr.GetTranslation("tank.view.common.DeadTipDialog.title");
         titleText = this._titleStr;
         this._okStr = LanguageMgr.GetTranslation("tank.view.common.DeadTipDialog.btn");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._okBtn.text = this._okStr;
         this._okBtn.x = this.content.width / 2 - this._okBtn.width / 2;
         this._okBtn.y = 185 - this._okBtn.height;
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__onClickOK);
         addToContent(this.content);
         addToContent(this._okBtn);
         addEventListener(FrameEvent.RESPONSE,this._frameEventHandler);
      }
      
      private function __onClickOK(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._frameEventHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__onClickOK);
         this._okBtn.dispose();
         super.dispose();
      }
      
      private function _frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
   }
}
