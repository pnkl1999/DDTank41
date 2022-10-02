package giftSystem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.NameInputDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   import giftSystem.element.ChooseNum;
   import giftSystem.element.GiftCartItem;
   
   public class ClearingInterface extends Frame
   {
       
      
      private var _BG:Scale9CornerImage;
      
      private var _BG2:Scale9CornerImage;
      
      private var _BG3:Bitmap;
      
      private var _giftTitle:Bitmap;
      
      private var _chooseFriendBtn:BaseButton;
      
      private var _nameInput:NameInputDropListTarget;
      
      private var _dropList:DropList;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _statistics:Bitmap;
      
      private var _buyMoneyBtn:BaseButton;
      
      private var _presentBtn:BaseButton;
      
      private var _totalMoney:FilterFrameText;
      
      private var _poorMoney:FilterFrameText;
      
      private var _giftNum:FilterFrameText;
      
      private var _giftCartItem:GiftCartItem;
      
      private var _moneyIsEnough:ScaleFrameImage;
      
      private var _info:ShopItemInfo;
      
      public function ClearingInterface()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this.titleText = LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.title");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.background");
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.background2");
         this._BG3 = ComponentFactory.Instance.creatBitmap("asset.clearingInterface.btnBG");
         this._giftTitle = ComponentFactory.Instance.creatBitmap("asset.clearingInterface.giftTitle");
         this._chooseFriendBtn = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.chooseFriend");
         this._nameInput = ComponentFactory.Instance.creatCustomObject("ClearingInterface.nameInput");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         this._statistics = ComponentFactory.Instance.creatBitmap("asset.clearingInterface.clearing");
         this._moneyIsEnough = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.isEnoughImage");
         this._buyMoneyBtn = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.buyMoney");
         this._presentBtn = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.present");
         this._totalMoney = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.totalMoney");
         this._poorMoney = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.poorMoney");
         this._giftNum = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface.giftNum");
         this._giftCartItem = ComponentFactory.Instance.creatCustomObject("giftCartItem");
         this._poorMoney.text = String(PlayerManager.Instance.Self.Money);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         addToContent(this._BG);
         addToContent(this._BG2);
         addToContent(this._BG3);
         addToContent(this._giftTitle);
         addToContent(this._chooseFriendBtn);
         addToContent(this._nameInput);
         addToContent(this._statistics);
         addToContent(this._moneyIsEnough);
         addToContent(this._buyMoneyBtn);
         addToContent(this._presentBtn);
         addToContent(this._totalMoney);
         addToContent(this._poorMoney);
         addToContent(this._giftNum);
         addToContent(this._giftCartItem);
         this._moneyIsEnough.setFrame(1);
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this.setName(param1);
         this._friendList.setVisible = false;
      }
      
      public function setName(param1:String) : void
      {
         this._nameInput.text = param1;
      }
      
      public function set info(param1:ShopItemInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         this._giftCartItem.info = this._info;
         this.__numberChange(null);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._chooseFriendBtn.addEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._buyMoneyBtn.addEventListener(MouseEvent.CLICK,this.__buyMoney);
         this._presentBtn.addEventListener(MouseEvent.CLICK,this.__present);
         this._giftCartItem.addEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__moneyChange);
         GiftController.Instance.addEventListener(GiftEvent.SEND_GIFT_RETURN,this.__sendRetrunHandler);
      }
      
      protected function __sendRetrunHandler(param1:GiftEvent) : void
      {
         if(param1.str == "true")
         {
            this.dispose();
         }
         else
         {
            this._presentBtn.enable = true;
         }
      }
      
      private function __numberChange(param1:Event) : void
      {
         var _loc2_:int = this._info.getItemPrice(1).moneyValue * this._giftCartItem.number;
         var _loc3_:int = PlayerManager.Instance.Self.Money - _loc2_;
         this._totalMoney.text = _loc2_.toString();
         if(_loc3_ < 0)
         {
            this._moneyIsEnough.setFrame(2);
         }
         else
         {
            this._moneyIsEnough.setFrame(1);
         }
         this._giftNum.text = this._giftCartItem.number.toString();
      }
      
      private function __present(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(parseInt(this._poorMoney.text) < 0)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            return;
         }
         if(this._nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.inputName"));
            return;
         }
         if(this._giftCartItem.number <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.noEnoughMoney"));
            return;
         }
         if(this._nameInput.text == PlayerManager.Instance.Self.NickName)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.canNotYourSelf"));
            return;
         }
         if(this._info.Label == 6 && this._giftCartItem.number != 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.ClearingInterface.limit"));
            return;
         }
         SocketManager.Instance.out.sendBuyGift(this._nameInput.text,this._info.GoodsID,this._giftCartItem.number,1);
      }
      
      private function __buyMoney(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      private function __showFramePanel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._chooseFriendBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x - 95;
         this._friendList.y = _loc2_.y + this._chooseFriendBtn.height;
         this._friendList.setVisible = true;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._chooseFriendBtn.removeEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._buyMoneyBtn.removeEventListener(MouseEvent.CLICK,this.__buyMoney);
         this._presentBtn.removeEventListener(MouseEvent.CLICK,this.__present);
         this._giftCartItem.removeEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__moneyChange);
         GiftController.Instance.removeEventListener(GiftEvent.SEND_GIFT_RETURN,this.__sendRetrunHandler);
      }
      
      override public function dispose() : void
      {
         if(this._dropList)
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(this._friendList)
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         super.dispose();
         this.removeEvent();
         GiftController.Instance.rebackName = "";
         this._BG = null;
         this._BG2 = null;
         this._BG3 = null;
         this._giftTitle = null;
         this._chooseFriendBtn = null;
         this._nameInput = null;
         this._dropList = null;
         this._statistics = null;
         this._buyMoneyBtn = null;
         this._presentBtn = null;
         this._totalMoney = null;
         this._poorMoney = null;
         this._giftNum = null;
         this._giftCartItem = null;
         this._moneyIsEnough = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __hideDropList(param1:Event) : void
      {
         if(param1.target is FilterFrameText)
         {
            return;
         }
         if(this._dropList && this._dropList.parent)
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      protected function __onReceiverChange(param1:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._nameInput.text);
      }
      
      private function filterRepeatInArray(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ == 0)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_].NickName == param1[_loc3_].NickName)
               {
                  break;
               }
               if(_loc4_ == _loc2_.length - 1)
               {
                  _loc2_.push(param1[_loc3_]);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function filterSearch(param1:Array, param2:String) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].NickName.indexOf(param2) != -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function __moneyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"])
         {
            this.__numberChange(null);
         }
      }
      
      protected function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(_loc2_);
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
   }
}
