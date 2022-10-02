package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class LuckyLotteryFailureFrame extends LotteryPopupFrame
   {
       
      
      private var _frameImage:Bitmap;
      
      public function LuckyLotteryFailureFrame()
      {
         super();
      }
      
      override protected function initFrame() : void
      {
         this._frameImage = ComponentFactory.Instance.creatBitmap("asset.luckyLottery.failureFrameAsset");
         addChild(this._frameImage);
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.luckyFailureFrame.btnOk");
         addChild(_btnOk);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      override public function dispose() : void
      {
         if(this._frameImage)
         {
            ObjectUtils.disposeObject(this._frameImage);
         }
         this._frameImage = null;
         super.dispose();
      }
   }
}
