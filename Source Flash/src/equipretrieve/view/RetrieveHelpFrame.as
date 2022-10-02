package equipretrieve.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class RetrieveHelpFrame extends BaseAlerFrame
   {
       
      
      private var _BG:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      public function RetrieveHelpFrame()
      {
         super();
         this.setView();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.equipretrieve.helpTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("close"),true,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         info.escEnable = true;
         this._BG = Bitmap(ComponentFactory.Instance.creatBitmap("equipretrieve.helpInfoBg"));
         addToContent(this._BG);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
