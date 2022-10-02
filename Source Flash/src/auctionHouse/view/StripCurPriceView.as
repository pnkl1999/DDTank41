package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StripCurPriceView extends Sprite implements Disposeable
   {
       
      
      private var _info:AuctionGoodsInfo;
      
      private var maxPrice_txt:FilterFrameText;
      
      private var mouthPrice_txt:FilterFrameText;
      
      private var yourPrice_bit:Bitmap;
      
      private var mouth_bit:Bitmap;
      
      private var goldMoney_mc:ScaleFrameImage;
      
      private var goldMoneyMouth_mc:ScaleFrameImage;
      
      private var goldMoney_mc_y:int;
      
      private var maxPrice_txt_y:int;
      
      private var yourPrice_bit_y:int;
      
      public function StripCurPriceView()
      {
         super();
         mouseEnabled = false;
         this.initView();
      }
      
      private function initView() : void
      {
         this.maxPrice_txt = ComponentFactory.Instance.creat("auctionHouse.StripMoneyTextI");
         addChild(this.maxPrice_txt);
         this.mouthPrice_txt = ComponentFactory.Instance.creat("auctionHouse.StripMoneyTextII");
         addChild(this.mouthPrice_txt);
         this.yourPrice_bit = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.yourPrice_bit");
         addChild(this.yourPrice_bit);
         this.mouth_bit = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.mouth_bit");
         addChild(this.mouth_bit);
         this.goldMoney_mc = ComponentFactory.Instance.creat("auctionHouse.StripMoneyIconI");
         addChild(this.goldMoney_mc);
         this.goldMoneyMouth_mc = ComponentFactory.Instance.creat("auctionHouse.StripMoneyIconII");
         addChild(this.goldMoneyMouth_mc);
         this.goldMoney_mc_y = this.goldMoney_mc.y;
         this.maxPrice_txt_y = this.maxPrice_txt.y;
         this.yourPrice_bit_y = this.yourPrice_bit.y;
      }
      
	  internal function set info(param1:AuctionGoodsInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      private function update() : void
      {
         if(this._info.AuctioneerID != PlayerManager.Instance.Self.ID && this._info.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.yourPrice_bit.visible = true;
            this.maxPrice_txt.text = this._info.Price.toString();
         }
         else
         {
            this.yourPrice_bit.visible = false;
            this.maxPrice_txt.text = this._info.Price.toString();
         }
         this.mouthPrice_txt.text = this._info.Mouthful.toString();
         this.goldMoney_mc.setFrame(this._info.PayType + 1);
         this.goldMoneyMouth_mc.setFrame(this._info.PayType + 1);
         this.setMouse();
      }
      
      private function setMouse() : void
      {
         if(this._info.Mouthful == 0)
         {
            this.goldMoneyMouth_mc.visible = false;
            this.mouthPrice_txt.text = "";
            this.goldMoney_mc.y = 13;
            this.maxPrice_txt.y = 11;
            this.mouth_bit.visible = false;
            this.yourPrice_bit.y = 12;
         }
         else
         {
            this.goldMoney_mc.setFrame(this._info.PayType + 1);
            this.goldMoneyMouth_mc.visible = true;
            this.goldMoney_mc.visible = true;
            this.mouth_bit.visible = true;
            this.goldMoney_mc.y = this.goldMoney_mc_y;
            this.maxPrice_txt.y = this.maxPrice_txt_y;
            this.yourPrice_bit.y = this.yourPrice_bit_y;
         }
         this.maxPrice_txt.mouseEnabled = false;
         this.mouthPrice_txt.mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         if(this._info)
         {
            this._info = null;
         }
         if(this.maxPrice_txt)
         {
            ObjectUtils.disposeObject(this.maxPrice_txt);
         }
         this.maxPrice_txt = null;
         if(this.mouthPrice_txt)
         {
            ObjectUtils.disposeObject(this.mouthPrice_txt);
         }
         this.mouthPrice_txt = null;
         if(this.yourPrice_bit)
         {
            ObjectUtils.disposeObject(this.yourPrice_bit);
         }
         this.yourPrice_bit = null;
         if(this.mouth_bit)
         {
            ObjectUtils.disposeObject(this.mouth_bit);
         }
         this.mouth_bit = null;
         if(this.goldMoney_mc)
         {
            ObjectUtils.disposeObject(this.goldMoney_mc);
         }
         this.goldMoney_mc = null;
         if(this.goldMoneyMouth_mc)
         {
            ObjectUtils.disposeObject(this.goldMoneyMouth_mc);
         }
         this.goldMoneyMouth_mc = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
