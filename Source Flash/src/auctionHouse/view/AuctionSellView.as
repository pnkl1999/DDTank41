package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="nextPage",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="prePage",type="auctionHouse.event.AuctionHouseEvent")]
   public class AuctionSellView extends Sprite implements Disposeable
   {
       
      
      private var _right:AuctionRightView;
      
      private var _left:AuctionSellLeftView;
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _cancelBid_btn:BaseButton;
      
      private var _btClickLock:Boolean;
      
      public function AuctionSellView(param1:AuctionHouseController, param2:AuctionHouseModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
         this._right.setup(AuctionState.SELL);
         addChild(this._right);
         this._left = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionSellLeftView");
         addChildAt(this._left,0);
         this._cancelBid_btn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.CancelBid_btn");
         addChild(this._cancelBid_btn);
      }
      
      private function addEvent() : void
      {
         this._cancelBid_btn.addEventListener(MouseEvent.CLICK,this.__cancel);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeStage);
         this._right.prePage_btn.addEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.addEventListener(MouseEvent.CLICK,this.__next);
         this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function removeEvent() : void
      {
         this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._cancelBid_btn.removeEventListener(MouseEvent.CLICK,this.__cancel);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeStage);
         this._right.prePage_btn.removeEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK,this.__next);
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
      }
      
      private function __addToStage(param1:Event) : void
      {
         this._cancelBid_btn.enable = false;
         this._left.addStage();
      }
      
	  internal function clearLeft() : void
      {
         this._left.clear();
      }
      
	  internal function clearList() : void
      {
         this._right.clearList();
      }
      
	  internal function hideReady() : void
      {
         this._left.hideReady();
         this._right.hideReady();
      }
      
	  internal function addAuction(param1:AuctionGoodsInfo) : void
      {
         this._right.addAuction(param1);
      }
      
	  internal function setPage(param1:int, param2:int) : void
      {
         this._right.setPage(param1,param2);
      }
      
	  internal function updateList(param1:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(param1);
      }
      
      private function __cancel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("043");
         this._btClickLock = true;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._cancelBid_btn.enable = false;
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.cancel"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.__cancelOk();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.__cannelNo();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function __cancelOk() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this._right.getSelectInfo())
            {
               if(this._right.getSelectInfo().BuyerName != "")
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Price"));
                  return;
               }
               SocketManager.Instance.out.auctionCancelSell(this._right.getSelectInfo().AuctionID);
               this._controller.model.sellTotal -= 1;
               this._right.clearSelectStrip();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
            }
            SoundManager.instance.play("008");
            this._cancelBid_btn.enable = false;
            return;
         }
      }
      
      private function __cannelNo() : void
      {
         SoundManager.instance.play("008");
         this._cancelBid_btn.enable = true;
      }
      
      private function __removeStage(param1:Event) : void
      {
         this._left.clear();
      }
      
      private function __next(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._cancelBid_btn.enable = false;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
      }
      
      private function __pre(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._cancelBid_btn.enable = false;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
      }
      
      private function sortChange(param1:AuctionHouseEvent) : void
      {
         this._cancelBid_btn.enable = false;
         this._model.sellCurrent = 1;
         this._controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1,this._right.sortCondition,this._right.sortBy.toString());
      }
      
	  internal function searchByCurCondition(param1:int, param2:int = -1) : void
      {
         this._controller.searchAuctionList(param1,"",-1,-1,param2,-1,this._right.sortCondition,this._right.sortBy.toString());
      }
      
      private function __selectStrip(param1:AuctionHouseEvent) : void
      {
         if(this._right.getSelectInfo())
         {
            if(this._right.getSelectInfo().BuyerName != "")
            {
               this._cancelBid_btn.enable = false;
            }
            else
            {
               this._cancelBid_btn.enable = true;
            }
         }
      }
      
      public function get this_left() : AuctionSellLeftView
      {
         return this._left;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._right)
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(this._left)
         {
            ObjectUtils.disposeObject(this._left);
         }
         this._left = null;
         if(this._cancelBid_btn)
         {
            ObjectUtils.disposeObject(this._cancelBid_btn);
         }
         this._cancelBid_btn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
