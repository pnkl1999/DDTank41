package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class LuckyLotteryHelpFrame extends LotteryPopupFrame
   {
       
      
      private var _helpImage:Bitmap;
      
      public function LuckyLotteryHelpFrame()
      {
         super();
         this.initFrame();
      }
      
      override protected function initFrame() : void
      {
         this._helpImage = ComponentFactory.Instance.creatBitmap("asset.luckyLottery.helpFrameAsset");
         addChild(this._helpImage);
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.luckyHelpFrame.btnOk");
         addChild(_btnOk);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      override public function dispose() : void
      {
         if(this._helpImage)
         {
            ObjectUtils.disposeObject(this._helpImage);
         }
         this._helpImage = null;
         super.dispose();
      }
   }
}
