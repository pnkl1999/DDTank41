package lottery.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lottery.cell.ChoosedCardCell;
   import lottery.data.LotteryModel;
   import lottery.events.LotteryEvent;
   
   public class CardChooseRightView extends Sprite implements Disposeable
   {
      
      private static const SELECTED_LIMIT:int = 5;
       
      
      private var _selectedContainer:SimpleTileList;
      
      private var _btnReset:BaseButton;
      
      private var _btnSure:BaseButton;
      
      private var _selectedCount:int;
      
      private var _enable:Boolean;
      
      public function CardChooseRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function get selectedCount() : int
      {
         return this._selectedCount;
      }
      
      private function initView() : void
      {
         var _loc1_:ChoosedCardCell = null;
         this._selectedContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.selectedContainer",[3]);
         addChild(this._selectedContainer);
         while(this._selectedContainer.numChildren < SELECTED_LIMIT)
         {
            _loc1_ = new ChoosedCardCell();
            _loc1_.addEventListener(MouseEvent.CLICK,this.__choosedClick);
            this._selectedContainer.addChild(_loc1_);
         }
         this._btnReset = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.btnReset");
         addChild(this._btnReset);
         this._btnSure = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.btnSure");
         addChild(this._btnSure);
         this._btnSure.enable = false;
         this._btnReset.enable = false;
         this._enable = true;
      }
      
      private function addEvent() : void
      {
         this._btnReset.addEventListener(MouseEvent.CLICK,this.__resetClick);
         this._btnSure.addEventListener(MouseEvent.CLICK,this.__sureClick);
      }
      
      private function removeEvent() : void
      {
         this._btnReset.removeEventListener(MouseEvent.CLICK,this.__resetClick);
         this._btnSure.removeEventListener(MouseEvent.CLICK,this.__sureClick);
         var _loc1_:int = 0;
         while(_loc1_ < this._selectedContainer.numChildren)
         {
            this._selectedContainer.getChildAt(_loc1_).removeEventListener(MouseEvent.CLICK,this.__choosedClick);
            _loc1_++;
         }
      }
      
      public function get isSelectFull() : Boolean
      {
         return this._selectedCount >= SELECTED_LIMIT;
      }
      
      private function __resetClick(param1:MouseEvent) : void
      {
         var _loc3_:ChoosedCardCell = null;
         if(!this._enable)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ < SELECTED_LIMIT)
         {
            _loc3_ = this._selectedContainer.getChildAt(_loc2_) as ChoosedCardCell;
            _loc3_.hide();
            _loc2_++;
         }
         this._selectedCount = 0;
         this._btnSure.enable = false;
         this._btnReset.enable = false;
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_CANCEL_ALL));
      }
      
      private function __sureClick(param1:MouseEvent) : void
      {
         if(!this._enable)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._selectedCount < SELECTED_LIMIT)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Money >= LotteryModel.cardLotteryMoney)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.cardLottery();
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      public function setLastEmptyCardId(param1:int) : void
      {
         ++this._selectedCount;
         ChoosedCardCell(this.getEmptyCardCell()).show(param1);
         this._btnSure.enable = this._selectedCount >= SELECTED_LIMIT ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._btnReset.enable = true;
      }
      
      public function getEmptyCardCell() : DisplayObject
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._selectedContainer.numChildren)
         {
            if(ChoosedCardCell(this._selectedContainer.getChildAt(_loc1_)).isEmptyCard)
            {
               return this._selectedContainer.getChildAt(_loc1_);
            }
            _loc1_++;
         }
         return this._selectedContainer.getChildAt(this._selectedCount - 1);
      }
      
      private function cardLottery() : void
      {
         var _loc3_:ChoosedCardCell = null;
         if(this._selectedCount < SELECTED_LIMIT)
         {
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < SELECTED_LIMIT)
         {
            _loc3_ = this._selectedContainer.getChildAt(_loc2_) as ChoosedCardCell;
            if(_loc3_.cardId < 1)
            {
               return;
            }
            _loc1_.push(_loc3_.cardId);
            _loc2_++;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.wagerSuccess"));
         SocketManager.Instance.out.sendCardLotteryIds(_loc1_);
         StateManager.setState(StateType.LOTTERY_HALL);
      }
      
      private function __choosedClick(param1:MouseEvent) : void
      {
         if(!this._enable)
         {
            return;
         }
         if(ChoosedCardCell(param1.currentTarget).isEmptyCard)
         {
            return;
         }
         SoundManager.instance.play("008");
         --this._selectedCount;
         ChoosedCardCell(param1.currentTarget).hide();
         this._btnSure.enable = false;
         this._btnReset.enable = this._selectedCount > 0;
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_CANCEL,ChoosedCardCell(param1.currentTarget).cardId));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._selectedContainer)
         {
            ObjectUtils.disposeAllChildren(this._selectedContainer);
         }
         this._selectedContainer = null;
         if(this._btnReset)
         {
            ObjectUtils.disposeObject(this._btnReset);
         }
         this._btnReset = null;
         if(this._btnSure)
         {
            ObjectUtils.disposeObject(this._btnSure);
         }
         this._btnSure = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
