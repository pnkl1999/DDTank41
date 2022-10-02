package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class CardLotteryNoResultFrame extends LotteryPopupFrame
   {
       
      
      private var _bgAsset:Bitmap;
      
      public function CardLotteryNoResultFrame()
      {
         super();
      }
      
      override protected function initFrame() : void
      {
         this._bgAsset = ComponentFactory.Instance.creatBitmap("asset.cardLottery.noResultBgAsset");
         addChild(this._bgAsset);
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.cardNoResultFrame.btnOk");
         addChild(_btnOk);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      override public function dispose() : void
      {
         if(this._bgAsset)
         {
            ObjectUtils.disposeObject(this._bgAsset);
         }
         this._bgAsset = null;
         super.dispose();
      }
   }
}
