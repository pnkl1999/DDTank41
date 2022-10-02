package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   
   public class AuctionBuyView extends Sprite implements Disposeable
   {
       
      
      private var _bidMoney:BidMoneyView;
      
      private var _right:AuctionBuyRightView;
      
      private var _bid_btn:BaseButton;
      
      private var _mouthful_btn:BaseButton;
      
      private var _bid_btnR:BaseButton;
      
      private var _mouthfulAndbid:ScaleBitmapImage;
      
      private var _mouthful_btnR:BaseButton;
      
      private var _btClickLock:Boolean;
      
      public function AuctionBuyView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         addChild(this._bid_btn);
         this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         addChild(this._mouthful_btn);
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this._bidMoney.cannotBid();
         this._bid_btnR = ComponentFactory.Instance.creat("auctionHouse.Bid_btnR");
         this._mouthful_btnR = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btnR");
         this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionBuyRightView");
         addChild(this._right);
         this.initialiseBtn();
         this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
         this._mouthfulAndbid.addChild(this._bid_btnR);
         this._mouthfulAndbid.addChild(this._mouthful_btnR);
         addChild(this._mouthfulAndbid);
         this._mouthfulAndbid.visible = false;
         this._bid_btn.enable = false;
         this._bid_btnR.enable = false;
      }
      
      private function addEvent() : void
      {
         this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this._bid_btnR.addEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
      }
      
      private function __nextPage(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
      }
      
      private function __prePage(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
      }
      
      private function removeEvent() : void
      {
         this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectRightStrip);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btn.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this._bid_btnR.removeEventListener(MouseEvent.CLICK,this.__bid);
         this._mouthful_btnR.removeEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT,this._mouthfulAndbidOver);
      }
      
      private function getBidPrice() : int
      {
         var _loc2_:int = 0;
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc1_.BuyerName == "")
         {
            _loc2_ = _loc1_.Price;
         }
         else
         {
            _loc2_ = _loc1_.Price + _loc1_.Rise;
         }
         return _loc2_;
      }
      
	  internal function hide() : void
      {
      }
      
      private function initialiseBtn() : void
      {
         this._mouthful_btn.enable = false;
         this._bid_btn.enable = false;
         this._mouthful_btnR.enable = false;
         this._bid_btnR.enable = false;
         this._bidMoney.cannotBid();
      }
      
	  internal function addAuction(param1:AuctionGoodsInfo) : void
      {
         this._right.addAuction(param1);
      }
      
	  internal function removeAuction() : void
      {
         this._bidMoney.cannotBid();
      }
      
	  internal function updateAuction(param1:AuctionGoodsInfo) : void
      {
         this._right.updateAuction(param1);
         this.__selectRightStrip(null);
      }
      
	  internal function clearList() : void
      {
         this._right.clearList();
      }
      
      private function _mouthfulAndbidOver(param1:MouseEvent) : void
      {
         this._mouthfulAndbid.visible = false;
      }
      
      private function __selectRightStrip(param1:AuctionHouseEvent) : void
      {
         this._mouthfulAndbid.x = this.globalToLocal(new Point(mouseX,mouseY)).x - 10;
         this._mouthfulAndbid.y = this.globalToLocal(new Point(mouseX,mouseY)).y - 10;
         if(this._mouthfulAndbid.x > stage.stageWidth - this._mouthfulAndbid.width)
         {
            this._mouthfulAndbid.x = this._mouthfulAndbid.x - this._mouthfulAndbid.width + 20;
         }
         this.setChildIndex(this._mouthfulAndbid,this.numChildren - 1);
         if(param1)
         {
            this._mouthfulAndbid.visible = true;
         }
         var _loc2_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc2_)
         {
            if(_loc2_.AuctioneerID == PlayerManager.Instance.Self.ID)
            {
               this.initialiseBtn();
               return;
            }
            this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc2_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            this._bid_btnR.enable = this._bid_btn.enable = _loc2_.BuyerID == PlayerManager.Instance.Self.ID ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            if(_loc2_.BuyerID != PlayerManager.Instance.Self.ID)
            {
               this._bidMoney.canMoneyBid(_loc2_.Price + _loc2_.Rise);
            }
            else
            {
               this._bidMoney.cannotBid();
            }
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
         var alert:BaseAlerFrame = null;
         var event:MouseEvent = param1;
         _bidKeyUp = function(param1:Event):void
         {
            SoundManager.instance.play("008");
            __bidII();
            alert1.removeEventListener(FrameEvent.RESPONSE,_responseII);
            _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
            ObjectUtils.disposeObject(alert1);
            _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         };
         _responseII = function(param1:FrameEvent):void
         {
            SoundManager.instance.play("008");
            _checkResponse(param1.responseCode,__bidII,__cannel);
            var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
            _loc2_.removeEventListener(FrameEvent.RESPONSE,_responseII);
            _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
            ObjectUtils.disposeObject(param1.target);
            _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         };
         SoundManager.instance.play("047");
         this._btClickLock = true;
         this._mouthfulAndbid.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this.__selectRightStrip(null);
            return;
         }
         if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         this._bid_btn.enable = false;
         this._bid_btnR.enable = false;
         alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
         LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         alert1.addToContent(this._bidMoney);
         this._bidMoney.money.setFocus();
         alert1.moveEnable = false;
         alert1.addEventListener(FrameEvent.RESPONSE,_responseII);
         this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP,_bidKeyUp);
      }
      
      private function __bidII() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getBidPrice() > this._bidMoney.getData())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.price") + String(this._bidMoney.getData()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.less") + String(this.getBidPrice()));
               return;
            }
            _loc1_ = this._right.getSelectInfo();
            if(_loc1_)
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,this._bidMoney.getData());
            }
            return;
         }
      }
      
      private function __mouthFull(param1:MouseEvent) : void
      {
         var _loc4_:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._mouthfulAndbid.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._mouthful_btn.enable = this._mouthful_btnR.enable = false;
         this._bid_btn.enable = this._bid_btnR.enable = false;
         this._btClickLock = true;
         var _loc2_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc2_.Mouthful > PlayerManager.Instance.Self.Money)
         {
            _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkResponse(param1.responseCode,LeavePageManager.leaveToFillPath,this._cancelFun);
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseI);
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkResponse(param1.responseCode,this.__callMouthFull,this.__cannel);
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function __callMouthFull() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         var _loc2_:int = 0;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            _loc1_ = this._right.getSelectInfo();
            if(_loc1_)
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,_loc1_.Mouthful);
               IMController.Instance.saveRecentContactsID(_loc1_.AuctioneerID);
               if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
               {
                  SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
               }
               _loc2_ = 0;
               while(_loc2_ < SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].length)
               {
                  if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID][_loc2_] == _loc1_.AuctionID)
                  {
                     SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].splice(_loc2_,1);
                  }
                  _loc2_++;
               }
               SharedManager.Instance.save();
               this._bidMoney.cannotBid();
               this._right.clearSelectStrip();
            }
            return;
         }
      }
      
      private function __cannel() : void
      {
         var _loc1_:AuctionGoodsInfo = this._right.getSelectInfo();
         if(_loc1_)
         {
            this._mouthful_btnR.enable = this._mouthful_btn.enable = _loc1_.Mouthful == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            this._bid_btnR.enable = this._bid_btn.enable = _loc1_.BuyerID == PlayerManager.Instance.Self.ID ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         }
         else
         {
            this._mouthful_btnR.enable = this._mouthful_btn.enable = false;
            this._bid_btnR.enable = this._bid_btn.enable = false;
         }
      }
      
      private function _cancelFun() : void
      {
      }
      
      private function __addToStage(param1:Event) : void
      {
         this.initialiseBtn();
         this._bidMoney.cannotBid();
      }
      
      private function _checkResponse(param1:int, param2:Function = null, param3:Function = null, param4:Function = null) : void
      {
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
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._right)
         {
            ObjectUtils.disposeObject(this._right);
         }
         this._right = null;
         if(this._mouthful_btn)
         {
            ObjectUtils.disposeObject(this._mouthful_btn);
         }
         this._mouthful_btn = null;
         if(this._bid_btn)
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(this._bidMoney)
         {
            ObjectUtils.disposeObject(this._bidMoney);
         }
         this._bidMoney = null;
         if(parent)
         {
            parent.removeChild(this);
         }
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
      }
   }
}
