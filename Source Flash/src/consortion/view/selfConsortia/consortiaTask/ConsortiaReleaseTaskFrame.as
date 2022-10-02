package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.view.selfConsortia.UpGradeLackRichesFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class ConsortiaReleaseTaskFrame extends BaseAlerFrame
   {
       
      
      private var _arr:Array;
      
      public function ConsortiaReleaseTaskFrame()
      {
         this._arr = [3,3,5,5,8,8,10,10,12,12];
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.submitLabel = LanguageMgr.GetTranslation("consortia.task.releaseTable");
         _loc1_.showCancel = false;
         info = _loc1_;
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.conortion.releaseContent");
         addToContent(_loc2_);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease)
            {
               ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease = false;
               ObjectUtils.disposeObject(this);
            }
            else
            {
               this.__okClick();
               ObjectUtils.disposeObject(this);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function __okClick() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.okTable"),LanguageMgr.GetTranslation("consortia.task.OKContent",ServerConfigManager.instance.MissionRiches[PlayerManager.Instance.Self.consortiaInfo.Level - 1]),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < ServerConfigManager.instance.MissionRiches[PlayerManager.Instance.Self.consortiaInfo.Level - 1])
            {
               this.__openRichesTip();
            }
            else
            {
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RELEASE_TASK);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
               ObjectUtils.disposeObject(this);
            }
         }
         ObjectUtils.disposeObject(param1.currentTarget as BaseAlerFrame);
      }
      
      private function __openRichesTip() : void
      {
         SoundManager.instance.play("047");
         var _loc1_:UpGradeLackRichesFrame = ComponentFactory.Instance.creatComponentByStylename("upGradeLackRichesFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
