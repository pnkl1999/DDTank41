package league.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class LeagueStartNoticeView extends BaseAlerFrame
   {
       
      
      private var _bmpNpc:Bitmap;
      
      private var _bmpTxt:Bitmap;
      
      public function LeagueStartNoticeView()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      private function initView() : void
      {
         info = new AlertInfo();
         _info.showCancel = false;
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.league.posBtn");
         this._bmpNpc = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.girl2");
         PositionUtils.setPos(this._bmpNpc,"league.LeagueStartNoticeView.girlPos");
         addToContent(this._bmpNpc);
         this._bmpTxt = ComponentFactory.Instance.creatBitmap("asset.league.leagueNotice");
         addToContent(this._bmpTxt);
         ChatManager.Instance.releaseFocus();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._bmpTxt = null;
         this._bmpNpc = null;
      }
      
      public function show() : void
      {
         var _loc1_:Point = null;
         if(PlayerManager.Instance.Self._hasPopupLeagueNotice)
         {
            return;
         }
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.posLeagueStart");
         x = _loc1_.x;
         y = _loc1_.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         PlayerManager.Instance.Self._hasPopupLeagueNotice = true;
      }
   }
}
