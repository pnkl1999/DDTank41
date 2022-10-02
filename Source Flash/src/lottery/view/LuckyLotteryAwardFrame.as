package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import lottery.cell.LotteryBuffCell;
   
   public class LuckyLotteryAwardFrame extends LotteryPopupFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _awardCell:LotteryBuffCell;
      
      public function LuckyLotteryAwardFrame()
      {
         super();
      }
      
      override protected function initFrame() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.luckyLottery.awardFrameAsset");
         addChild(this._bg);
         this._awardCell = ComponentFactory.Instance.creatCustomObject("lottery.winnerAwardsCell");
         addChild(this._awardCell);
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.LuckyAwardFrame.btnOk");
         addChild(_btnOk);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      public function setInfo(param1:int, param2:int) : void
      {
         this._awardCell.info = ItemManager.Instance.getTemplateById(param1);
         this._awardCell.timeLimit = param2;
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._awardCell)
         {
            ObjectUtils.disposeObject(this._awardCell);
         }
         this._awardCell = null;
         super.dispose();
      }
   }
}
