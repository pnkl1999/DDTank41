package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class VipLevelUpAwardsView extends Frame
   {
       
      
      private var viewBG:Bitmap;
      
      private var _frameLabel:Bitmap;
      
      private var _button:BaseButton;
      
      private var list:AwardsGoodsList;
      
      public function VipLevelUpAwardsView()
      {
         super();
         this.initUI();
         this.initEvent();
      }
      
      private function initUI() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this.viewBG = ComponentFactory.Instance.creatBitmap("asset.vip.goodsBG2");
         addToContent(this.viewBG);
         this._frameLabel = ComponentFactory.Instance.creatBitmap("asset.vip.vipLevelUpTile");
         addToContent(this._frameLabel);
         this._button = ComponentFactory.Instance.creat("vip.BoxGetButtonIII");
         addToContent(this._button);
      }
      
      public function set vipLevelUpGoodsList(param1:Array) : void
      {
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.showForVipLevelUpAward(param1);
         addChild(this.list);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.viewBG)
         {
            ObjectUtils.disposeObject(this.viewBG);
         }
         this.viewBG = null;
         if(this._frameLabel)
         {
            ObjectUtils.disposeObject(this._frameLabel);
         }
         this._frameLabel = null;
         if(this._button)
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(this.list)
         {
            ObjectUtils.disposeObject(this.list);
         }
         this.list = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
