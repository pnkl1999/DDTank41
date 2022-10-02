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
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VIPRechargeAlertFrame extends Frame
   {
       
      
      private var _content:DisplayObject;
      
      private var _renewalVipBtn:BaseButton;
      
      private var _contentScroll:ScrollPanel;
      
      private var _buttomBit:ScaleBitmapImage;
      
      private var _head:VipFrameHead;
      
      private var _dueDataWord:Bitmap;
      
      private var _dueData:FilterFrameText;
      
      public function VIPRechargeAlertFrame()
      {
         super();
         this.initFrame();
      }
      
      public function set content(param1:DisplayObject) : void
      {
         this._content = param1;
         this._contentScroll.setView(this._content);
      }
      
      private function initFrame() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this._dueDataWord = ComponentFactory.Instance.creatBitmap("asset.vip.dueDate2");
         this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate2");
         addToContent(this._dueDataWord);
         addToContent(this._dueData);
         this._buttomBit = ComponentFactory.Instance.creatComponentByStylename("VIPRechargeAlert.buttomBG");
         addToContent(this._buttomBit);
         this._buttomBit.y = 365;
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         addToContent(this._renewalVipBtn);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("VIPRechargeAlert.renewalVipBtnPos");
         this._renewalVipBtn.x = _loc1_.x;
         this._renewalVipBtn.y = _loc1_.y;
         this._contentScroll = ComponentFactory.Instance.creatComponentByStylename("vipRechargeAlertFrame.scroll");
         addToContent(this._contentScroll);
         this._contentScroll.vScrollProxy = ScrollPanel.AUTO;
         this._contentScroll.hScrollProxy = ScrollPanel.OFF;
         this._head = new VipFrameHead(true);
         this._head.y = 20;
         addToContent(this._head);
         titleText = LanguageMgr.GetTranslation("ddt.vip.helpFrame.title");
         StageReferance.stage.focus = this;
         this._renewalVipBtn.addEventListener(MouseEvent.CLICK,this.__OK);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this.updata();
      }
      
      private function updata() : void
      {
         var _loc1_:Date = PlayerManager.Instance.Self.VIPExpireDay as Date;
         this._dueData.text = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-" + _loc1_.date;
      }
      
      private function __OK(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._head)
         {
            this._head.dispose();
            this._head = null;
         }
         if(this._dueDataWord)
         {
            ObjectUtils.disposeObject(this._dueDataWord);
            this._dueDataWord = null;
         }
         if(this._dueData)
         {
            ObjectUtils.disposeObject(this._dueData);
            this._dueData = null;
         }
         if(this._renewalVipBtn)
         {
            this._renewalVipBtn.removeEventListener(MouseEvent.CLICK,this.__OK);
         }
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(this._renewalVipBtn)
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
