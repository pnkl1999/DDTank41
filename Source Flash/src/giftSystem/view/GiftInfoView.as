package giftSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import giftSystem.view.giftAndRecord.GiftAndRecord;
   
   public class GiftInfoView extends Sprite implements Disposeable
   {
       
      
      private var _banner:GiftBannerView;
      
      private var _giftAndRecord:GiftAndRecord;
      
      private var _info:PlayerInfo;
      
      public function GiftInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._banner = ComponentFactory.Instance.creatCustomObject("giftBannerView");
         this._giftAndRecord = ComponentFactory.Instance.creatCustomObject("giftAndRecord");
         addChild(this._banner);
         addChild(this._giftAndRecord);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         this._banner.info = this._info;
         this._giftAndRecord.info = this._info;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._banner)
         {
            this._banner.dispose();
         }
         this._banner = null;
         if(this._giftAndRecord)
         {
            this._giftAndRecord.dispose();
         }
         this._giftAndRecord = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
