package trainer.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import trainer.data.Step;
   
   public class VaneTipView extends BaseAlerFrame
   {
       
      
      private var _vane:Bitmap;
      
      public function VaneTipView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         _info.moveEnable = false;
         _info.showCancel = false;
         this._vane = ComponentFactory.Instance.creatBitmap("asset.trainer.vane");
         addToContent(this._vane);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.syncWeakStep(Step.VANE_TIP);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ObjectUtils.disposeAllChildren(this);
         this._vane = null;
         super.dispose();
      }
   }
}
