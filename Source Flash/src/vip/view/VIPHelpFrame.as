package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.view.experience.ExpTweenManager;
   import vip.VipController;
   
   public class VIPHelpFrame extends Frame
   {
       
      
      private var content:Bitmap;
      
      private var openVip:BaseButton;
      
      private var _openFun:Function;
      
      private var _contentScroll:ScrollPanel;
      
      private var _buttomBit:ScaleBitmapImage;
      
      public function VIPHelpFrame()
      {
         super();
         this.initFrame();
      }
      
      private function initFrame() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         titleText = LanguageMgr.GetTranslation("ddt.vip.helpFrame.title");
         this.content = ComponentFactory.Instance.creatBitmap("asset.vip.helpFrame.content");
         this._contentScroll = ComponentFactory.Instance.creatComponentByStylename("viphelpFrame.scroll");
         addToContent(this._contentScroll);
         this._contentScroll.setView(this.content);
         this._buttomBit = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.buttomBG");
         addToContent(this._buttomBit);
         this._buttomBit.y = 365;
         this.openVip = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
         addToContent(this.openVip);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("vipHelpFrame.openBtnPos");
         this.openVip.x = _loc1_.x;
         this.openVip.y = _loc1_.y;
         StageReferance.stage.focus = this;
         this.openVip.addEventListener(MouseEvent.CLICK,this.__open);
      }
      
      public function set openFun(param1:Function) : void
      {
         this._openFun = param1;
      }
      
      public function show() : void
      {
         if(ExpTweenManager.Instance.isPlaying)
         {
            return;
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __open(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
            return;
         }
         if(this._openFun != null)
         {
            this._openFun();
         }
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.openVip)
         {
            this.openVip.removeEventListener(MouseEvent.CLICK,this.__open);
         }
         if(this.content)
         {
            ObjectUtils.disposeObject(this.content);
         }
         this.content = null;
         if(this.openVip)
         {
            ObjectUtils.disposeObject(this.openVip);
         }
         this.openVip = null;
         this._openFun = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         VipController.instance.helpframeNull();
      }
   }
}
