package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   
   public class AuctionBuyStripView extends BaseStripView
   {
       
      
      private var _curPrice:StripCurBuyPriceView;
      
      private var _lefTip:StripTip;
      
      public function AuctionBuyStripView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         back_mc.width = 924;
         stripSelect_bit.width = 924;
         leftBG.width = 867;
         _name.x = 61;
         _count.x = 302;
         _leftTime.x = 380;
         this._lefTip = ComponentFactory.Instance.creat("auctionHouse.view.StripLeftTime");
         this._lefTip.x = _leftTime.x;
         _leftTime.y = 0;
         _leftTime.x = 0;
         this._lefTip.setView(_leftTime);
         addChild(this._lefTip);
         this._curPrice = ComponentFactory.Instance.creat("auctionHouse.view.StripCurBuyPriceView");
         this._curPrice.setup(1);
         addChild(this._curPrice);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         _leftTime.mouseEnabled = true;
      }
      
      override internal function clearSelectStrip() : void
      {
         super.clearSelectStrip();
         this.removeChild(this._curPrice);
      }
      
      override protected function updateInfo() : void
      {
         super.updateInfo();
         this._curPrice.info = _info;
         this._lefTip.width = _leftTime.textWidth;
         this._lefTip.height = _leftTime.textHeight;
         this._lefTip.tipData = _info.getSithTimeDescription();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._curPrice)
         {
            ObjectUtils.disposeObject(this._curPrice);
         }
         this._curPrice = null;
         if(this._lefTip)
         {
            ObjectUtils.disposeObject(this._lefTip);
         }
         this._lefTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
