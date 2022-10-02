package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class CardLotteryHelpFrame extends LotteryPopupFrame
   {
       
      
      private var _helpImage:Bitmap;
      
      public function CardLotteryHelpFrame()
      {
         super();
      }
      
      override protected function initFrame() : void
      {
         this._helpImage = ComponentFactory.Instance.creatBitmap("asset.cardLottery.helpFrameAsset");
         addChild(this._helpImage);
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.cardHelpFrame.btnOk");
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
