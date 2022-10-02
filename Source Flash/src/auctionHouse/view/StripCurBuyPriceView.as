package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class StripCurBuyPriceView extends Sprite implements Disposeable
   {
       
      
      private var curPricel_txt:FilterFrameText;
      
      private var mouthful_txt:FilterFrameText;
      
      private var state_mc:ScaleFrameImage;
      
      private var goldMoneyTop_mc:ScaleFrameImage;
      
      private var goldMoneyChao_mc:ScaleFrameImage;
      
      private var _info:AuctionGoodsInfo;
      
      public function StripCurBuyPriceView()
      {
         super();
      }
      
      public function setup(param1:int) : void
      {
         this.initView();
         this.state_mc.setFrame(param1);
      }
      
      private function initView() : void
      {
         this.curPricel_txt = ComponentFactory.Instance.creat("auctionHouse.StripCurPricelTextII");
         addChild(this.curPricel_txt);
         this.mouthful_txt = ComponentFactory.Instance.creat("auctionHouse.StripmouthfulTextII");
         addChild(this.mouthful_txt);
         this.state_mc = ComponentFactory.Instance.creat("auctionHouse.BuyPriceState");
         addChild(this.state_mc);
         this.goldMoneyTop_mc = ComponentFactory.Instance.creat("auctionHouse.StripMoneyIconIII");
         addChild(this.goldMoneyTop_mc);
         this.goldMoneyChao_mc = ComponentFactory.Instance.creat("auctionHouse.StripMoneyIconV");
         addChild(this.goldMoneyChao_mc);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
	  internal function set info(param1:AuctionGoodsInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      private function update() : void
      {
         this.curPricel_txt.text = this._info.Price.toString();
         this.setMouth();
         if(this._info.PayType == 0)
         {
            this.goldMoneyChao_mc.setFrame(1);
         }
         else
         {
            this.goldMoneyChao_mc.setFrame(2);
         }
         mouseEnabled = false;
         if(this._info.BuyerID != PlayerManager.Instance.Self.ID)
         {
            this.state_mc.setFrame(2);
         }
         else
         {
            this.state_mc.setFrame(1);
         }
      }
      
      private function setMouth() : void
      {
         if(this._info.Mouthful == 0)
         {
            this.goldMoneyTop_mc.visible = false;
            this.mouthful_txt.text = "";
         }
         else
         {
            this.goldMoneyTop_mc.setFrame(this._info.PayType + 1);
            this.goldMoneyTop_mc.visible = true;
            this.mouthful_txt.text = this._info.Mouthful.toString();
         }
         this.goldMoneyTop_mc.mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         if(this.mouthful_txt)
         {
            ObjectUtils.disposeObject(this.mouthful_txt);
         }
         this.mouthful_txt = null;
         if(this.curPricel_txt)
         {
            ObjectUtils.disposeObject(this.curPricel_txt);
         }
         this.curPricel_txt = null;
         if(this.goldMoneyTop_mc)
         {
            ObjectUtils.disposeObject(this.goldMoneyTop_mc);
         }
         this.goldMoneyTop_mc = null;
         if(this.goldMoneyChao_mc)
         {
            ObjectUtils.disposeObject(this.goldMoneyChao_mc);
         }
         this.goldMoneyChao_mc = null;
         if(this.state_mc)
         {
            ObjectUtils.disposeObject(this.state_mc);
         }
         this.state_mc = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
