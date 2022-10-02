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
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import im.IMController;
   
   public class AuctionBrowseView extends Sprite implements Disposeable
   {
       
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _list:BrowseLeftMenuView;
      
      private var _bidMoney:BidMoneyView;
      
      private var _bid_btn:BaseButton;
      
      private var _mouthful_btn:BaseButton;
      
      private var _bid_btnR:BaseButton;
      
      private var _mouthfulAndbid:ScaleBitmapImage;
      
      private var _mouthful_btnR:BaseButton;
      
      private var _btClickLock:Boolean;
      
      private var _isSearch:Boolean;
      
      private var _right:AuctionRightView;
      
      private var _isUpdating:Boolean;
      
      public function AuctionBrowseView(param1:AuctionHouseController, param2:AuctionHouseModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         addChild(this._bid_btn);
         this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         addChild(this._mouthful_btn);
         this._bid_btnR = ComponentFactory.Instance.creat("auctionHouse.Bid_btnR");
         this._mouthful_btnR = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btnR");
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this._list = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BrowseLeftMenuView");
         addChild(this._list);
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
         this._right.setup(AuctionState.BROWSE);
         addChild(this._right);
         this.initialiseBtn();
         this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
         this._mouthfulAndbid.addChild(this._bid_btnR);
         this._mouthfulAndbid.addChild(this._mouthful_btnR);
         addChild(this._mouthfulAndbid);
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
         this._mouthfulAndbid.visible = false;
      }
      
      private function initialiseBtn() : void
      {
         this._mouthful_btn.enable = false;
         this._bid_btn.enable = false;
         this._bidMoney.cannotBid();
      }
      
      private function addEvent() : void
      {
         this._right.prePage_btn.addEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.addEventListener(MouseEvent.CLICK,this.__next);
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._list.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectLeftStrip);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bid_btnR.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,this.__updateAuction);
      }
      
      private function removeEvent() : void
      {
         this._right.prePage_btn.removeEventListener(MouseEvent.CLICK,this.__pre);
         this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK,this.__next);
         this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,this.sortChange);
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._list.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectLeftStrip);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bid_btnR.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,this.__updateAuction);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
      }
      
	  internal function addAuction(param1:AuctionGoodsInfo) : void
      {
         if(AuctionHouseModel._dimBooble != true)
         {
            this._right.addAuction(param1);
         }
      }
      
	  internal function updateAuction(param1:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(param1);
         this.__selectRightStrip(null);
      }
      
	  internal function removeAuction() : void
      {
         this.__searchCondition(null);
      }
      
	  internal function hideReady() : void
      {
         this._right.hideReady();
      }
      
	  internal function clearList() : void
      {
         if(AuctionHouseModel._dimBooble == true)
         {
            this._list.setFocusName();
            return;
         }
         this._right.clearList();
         this.__selectRightStrip(null);
      }
      
	  internal function setCategory(param1:Vector.<CateCoryInfo>) : void
      {
         this._list.setCategory(param1);
      }
      
	  internal function setPage(param1:int, param2:int) : void
      {
         this._right.setPage(param1,param2);
      }
      
	  internal function setSelectType(param1:CateCoryInfo) : void
      {
         this.initialiseBtn();
         this._list.setSelectType(param1);
      }
      
	  internal function getLeftInfo() : CateCoryInfo
      {
         return this._list.getInfo();
      }
      
	  internal function setTextEmpty() : void
      {
         this._list.searchText = "";
      }
      
	  internal function getPayType() : int
      {
         return -1;
      }
      
	  internal function searchByCurCondition(param1:int, param2:int = -1) : void
      {
         if(param2 != -1)
         {
            this._controller.searchAuctionList(param1,"",this._list.getType(),-1,param2,-1,this._right.sortCondition,this._right.sortBy.toString());
            return;
         }
         if(this._isSearch)
         {
            this._controller.searchAuctionList(param1,this._list.searchText,this._list.getType(),this.getPayType(),param2,-1,this._right.sortCondition,this._right.sortBy.toString());
         }
         else
         {
            this._controller.searchAuctionList(param1,this._list.searchText,this._list.getType(),-1,param2,-1,this._right.sortCondition,this._right.sortBy.toString());
         }
         this._bidMoney.cannotBid();
      }
      
      private function getBidPrice() : int
      {
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc1_)
         {
            return _loc1_.BuyerName == "" ? int(int(_loc1_.Price)) : int(int(_loc1_.Price + _loc1_.Rise));
         }
         return 0;
      }
      
      private function getPrice() : int
      {
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         return !!Boolean(_loc1_) ? int(int(_loc1_.Price)) : int(int(0));
      }
      
      private function getMouthful() : int
      {
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         return !!Boolean(_loc1_) ? int(int(_loc1_.Mouthful)) : int(int(0));
      }
      
      private function __searchCondition(param1:MouseEvent) : void
      {
         this._isSearch = true;
         if(this._list.getInfo() == null)
         {
            this._controller.browseTypeChangeNull();
         }
         else
         {
            this._controller.browseTypeChange(this._list.getInfo());
         }
      }
      
      private function keyEnterHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__searchCondition(null);
         }
      }
      
      private function __next(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
      }
      
      private function __pre(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
      }
      
      private function __selectLeftStrip(param1:AuctionHouseEvent) : void
      {
         this._isSearch = false;
         this._controller.browseTypeChange(this._list.getInfo());
      }
      
      private function __selectRightStrip(param1:AuctionHouseEvent) : void
      {
         var _loc2_:AuctionGoodsInfo = null;
         SoundManager.instance.play("047");
         this._mouthfulAndbid.x = this.globalToLocal(new Point(mouseX,mouseY)).x - 10;
         this._mouthfulAndbid.y = this.globalToLocal(new Point(mouseX,mouseY)).y - 10;
         if(this._mouthfulAndbid.x > stage.stageWidth - this._mouthfulAndbid.width)
         {
            this._mouthfulAndbid.x = this._mouthfulAndbid.x - this._mouthfulAndbid.width + 20;
         }
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
         this.setChildIndex(this._mouthfulAndbid,this.numChildren - 1);
         if(this._isUpdating)
         {
            return;
         }
         _loc2_ = this._right.getSelectInfo();
         if(_loc2_ == null || _loc2_.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(_loc2_.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._mouthfulAndbid.visible = true;
            this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc2_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            return;
         }
         if(param1 && param1.currentTarget == this._right)
         {
            this._mouthfulAndbid.visible = true;
         }
         this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc2_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         if(_loc2_.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
         if(param1)
         {
            this._bid_btnR.enable = this._bid_btn.enable = true;
         }
      }
      
      private function init_FUL_BID_btnStatue() : void
      {
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
         if(this._isUpdating)
         {
            return;
         }
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc1_ == null || _loc1_.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(_loc1_.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc1_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            return;
         }
         this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc1_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         this._bid_btn.enable = true;
         if(_loc1_.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
      }
      
      private function __bid(param1:MouseEvent) : void
      {
         var alert1:AuctionInputFrame = null;
         var _bidKeyUp:Function = null;
         var _responseII:Function = null;
         alert1 = null;
         _bidKeyUp = null;
         _responseII = null;
         var event:MouseEvent = param1;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this._right.getSelectInfo().PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
         if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            _bidKeyUp = function(param1:Event):void
            {
               SoundManager.instance.play("008");
               __bidOk();
               alert1.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(alert1);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            _responseII = function(param1:FrameEvent):void
            {
               SoundManager.instance.play("008");
               _checkResponse(param1.responseCode,__bidOk,__cancel);
               var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
               _loc2_.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(param1.target);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            this.checkPlayerMoney();
            this._bid_btn.enable = false;
            this._mouthfulAndbid.visible = false;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthful_btnR.enable = false;
               this._bid_btn.enable = true;
               BaglockedManager.Instance.show();
               return;
            }
            alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
            LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            alert1.addToContent(this._bidMoney);
            this._bidMoney.money.setFocus();
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE,_responseII);
            this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP,_bidKeyUp);
         }
      }
      
      private function _checkResponse(param1:int, param2:Function = null, param3:Function = null, param4:Function = null) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               param2();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               param3();
         }
      }
      
      private function _cancelFun() : void
      {
      }
      
      private function __mouthFull(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         this._mouthfulAndbid.visible = false;
         if(this.getMouthful() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthful_btnR.enable = false;
               BaglockedManager.Instance.show();
               return;
            }
            this._mouthful_btn.enable = false;
            this._bid_btn.enable = false;
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _mouthfulAndbidOver(param1:MouseEvent) : void
      {
         this._mouthfulAndbid.visible = false;
         this._bid_btnR.enable = false;
         this._mouthful_btnR.enable = false;
      }
      
      private function _responseIV(param1:FrameEvent) : void
      {
         this._checkResponse(param1.responseCode,this.__mouthFullOk,this.__cancel);
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         ObjectUtils.disposeObject(param1.target);
         this._isUpdating = false;
      }
      
      private function __bidOk() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         this._isUpdating = true;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getBidPrice() > this._bidMoney.getData())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Auction") + String(this.getBidPrice()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               this._bid_btn.enable = true;
               return;
            }
            if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
               this._bid_btn.enable = true;
               LeavePageManager.showFillFrame();
               return;
            }
            if(this.getMouthful() != 0 && this._bidMoney.getData() >= this.getMouthful())
            {
               this._btClickLock = true;
               this._mouthful_btn.enable = false;
               this._bid_btn.enable = false;
               this.__mouthFullOk();
               return;
            }
            _loc1_ = this._right.getSelectInfo();
            if(_loc1_)
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,this._bidMoney.getData());
               IMController.Instance.saveRecentContactsID(_loc1_.AuctioneerID);
               _loc1_ = null;
            }
            return;
         }
      }
      
      private function __cancel() : void
      {
         this.init_FUL_BID_btnStatue();
      }
      
      private function checkPlayerMoney() : void
      {
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         this._bid_btn.enable = false;
         this._mouthful_btn.enable = false;
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.Mouthful != 0 && this.getMouthful() <= PlayerManager.Instance.Self.Money)
         {
            this._mouthful_btn.enable = true;
         }
      }
      
      private function __mouthFullOk() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
               this._bid_btn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Your") + String(this.getMouthful()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               return;
            }
            _loc1_ = this._right.getSelectInfo();
            if(_loc1_ && _loc1_.AuctionID && _loc1_.Mouthful)
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,_loc1_.Mouthful);
               IMController.Instance.saveRecentContactsID(_loc1_.AuctioneerID);
               this._right.clearSelectStrip();
               this._right.setSelectEmpty();
               this._bidMoney.cannotBid();
               this.searchByCurCondition(this._model.browseCurrent);
            }
            return;
         }
      }
      
      private function __updateAuction(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt();
            if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
            {
               SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
            }
            SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].push(_loc3_);
            SharedManager.Instance.save();
         }
         this._isUpdating = false;
      }
      
      private function __addToStage(param1:Event) : void
      {
         this.initialiseBtn();
         this._bidMoney.cannotBid();
         this._right.addStageInit();
      }
      
      private function sortChange(param1:AuctionHouseEvent) : void
      {
         this.__searchCondition(null);
      }
      
      public function get Right() : AuctionRightView
      {
         return this._right;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._bidMoney)
         {
            ObjectUtils.disposeObject(this._bidMoney);
         }
         this._bidMoney = null;
         if(this._bid_btn)
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(this._mouthful_btn)
         {
            ObjectUtils.disposeObject(this._mouthful_btn);
         }
         this._mouthful_btn = null;
         if(this._bid_btnR)
         {
            ObjectUtils.disposeObject(this._bid_btnR);
         }
         this._bid_btnR = null;
         if(this._mouthful_btnR)
         {
            ObjectUtils.disposeObject(this._mouthful_btnR);
         }
         this._mouthful_btnR = null;
         if(this._mouthfulAndbid)
         {
            ObjectUtils.disposeObject(this._mouthfulAndbid);
         }
         this._mouthfulAndbid = null;
         if(this._right)
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
