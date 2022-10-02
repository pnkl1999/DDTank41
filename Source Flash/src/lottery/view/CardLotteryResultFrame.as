package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import lottery.cell.BigCardCell;
   import lottery.data.LotteryCardResultVO;
   
   public class CardLotteryResultFrame extends LotteryPopupFrame
   {
       
      
      private var _lotteryResultList:Vector.<LotteryCardResultVO>;
      
      private var _frameAsset:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _cardContainerAll:SimpleTileList;
      
      private var _resutlContainer:HBox;
      
      private var _btnPrev:SimpleBitmapButton;
      
      private var _btnNext:SimpleBitmapButton;
      
      private var _currentPhase:int = 0;
      
      public function CardLotteryResultFrame(param1:Vector.<LotteryCardResultVO> = null)
      {
         this._lotteryResultList = param1;
         super();
         this.addEvent();
      }
      
      override protected function initFrame() : void
      {
         var _loc2_:BigCardCell = null;
         this._frameAsset = ComponentFactory.Instance.creatBitmap("asset.cardLottery.resultFrameAsset");
         addChild(this._frameAsset);
         this._resutlContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.resultFrame.resutlContainer");
         addChild(this._resutlContainer);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new BigCardCell();
            _loc2_.cardId = 25;
            _loc2_.tipDirctions = "0,1,2";
            this._resutlContainer.addChild(_loc2_);
            _loc1_++;
         }
         this._panel = ComponentFactory.Instance.creatComponentByStylename("lottery.resultFrame.previewPanel");
         this._cardContainerAll = new SimpleTileList(5);
         this._cardContainerAll.startPos = new Point(0,5);
         this._panel.setView(this._cardContainerAll);
         addChild(this._panel);
         this._btnPrev = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnPrev");
         addChild(this._btnPrev);
         this._btnNext = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnNext");
         addChild(this._btnNext);
         this._btnNext.enable = false;
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnOk");
         addChild(_btnOk);
         this.viewResult();
      }
      
      private function addEvent() : void
      {
         this._btnNext.addEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         this._btnPrev.addEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      private function removeEvent() : void
      {
         this._btnNext.removeEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         this._btnPrev.removeEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         _btnOk.removeEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      public function setCardId(param1:Array, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:BigCardCell = null;
         if(param1.length != 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               BigCardCell(this._resutlContainer.getChildAt(_loc4_)).cardId = param1[_loc4_];
               _loc4_++;
            }
         }
         else if(param1.length == 0)
         {
            _loc5_ = 0;
            while(_loc5_ < 5)
            {
               BigCardCell(this._resutlContainer.getChildAt(_loc5_)).cardId = 25;
               _loc5_++;
            }
         }
         while(this._cardContainerAll.numChildren > 0)
         {
            this._cardContainerAll.removeChildAt(0);
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc6_ = new BigCardCell();
            _loc6_.tipDirctions = "0,1,2";
            _loc6_.cardId = param2[_loc3_];
            _loc6_.selected = param1.indexOf(param2[_loc3_]) > -1;
            this._cardContainerAll.addChild(_loc6_);
            _loc3_++;
         }
      }
      
      private function __phaseBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._btnNext:
               --this._currentPhase;
               break;
            case this._btnPrev:
               ++this._currentPhase;
         }
         this.viewResult();
      }
      
      private function viewResult() : void
      {
         if(this._currentPhase >= this._lotteryResultList.length)
         {
            this._currentPhase = 0;
         }
         if(this._currentPhase < 0)
         {
            this._currentPhase = this._lotteryResultList.length - 1;
         }
         this._btnNext.enable = this._currentPhase > 0;
         this._btnPrev.enable = this._currentPhase < this._lotteryResultList.length - 1;
         this.setCardId(this._lotteryResultList[this._currentPhase].resultIds,this._lotteryResultList[this._currentPhase].selfChooseIds);
      }
      
      override public function dispose() : void
      {
         if(this._frameAsset)
         {
            ObjectUtils.disposeObject(this._frameAsset);
         }
         this._frameAsset = null;
         if(this._panel)
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(this._cardContainerAll)
         {
            ObjectUtils.disposeObject(this._cardContainerAll);
         }
         this._cardContainerAll = null;
         if(this._resutlContainer)
         {
            ObjectUtils.disposeObject(this._resutlContainer);
         }
         this._resutlContainer = null;
         super.dispose();
      }
   }
}
