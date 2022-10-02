package trainer.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import trainer.controller.NewHandGuideManager;
   
   public class WelcomeView extends BaseAlerFrame
   {
       
      
      private var _bmpTxt:Bitmap;
      
      private var _bmpNpc:Bitmap;
      
      private var _txtName:FilterFrameText;
      
      public function WelcomeView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpTxt = null;
         this._bmpNpc = null;
         this._txtName = null;
         super.dispose();
      }
      
      private function initView() : void
      {
         info = new AlertInfo();
         _info.showCancel = false;
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.welcome.posBtn");
         this._bmpNpc = ComponentFactory.Instance.creat("asset.trainer.welcome.girl");
         addToContent(this._bmpNpc);
         this._bmpTxt = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.txt");
         addToContent(this._bmpTxt);
         this._txtName = ComponentFactory.Instance.creat("trainer.welcome.name");
         this._txtName.text = PlayerManager.Instance.Self.NickName;
         addToContent(this._txtName);
         ChatManager.Instance.releaseFocus();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            SoundManager.instance.play("008");
            NewHandGuideManager.Instance.mapID = 111;
            SocketManager.Instance.out.createUserGuide();
         }
      }
      
      public function show() : void
      {
         var _loc1_:Point = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.posWelcome");
         x = _loc1_.x;
         y = _loc1_.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
