package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.view.FriendDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class GiveOthersOpenedView extends GiveYourselfOpenView implements Disposeable
   {
       
      
      private var _repeatNameImg:Bitmap;
      
      private var _friendName:FriendDropListTarget;
      
      private var _dropList:DropList;
      
      private var _repeatName:TextInput;
      
      private var _friendListBtn:BaseButton;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _list:VBox;
      
      private var _itemArray:Array;
      
      private var _listBG:Scale9CornerImage;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      public function GiveOthersOpenedView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         _nameImg.visible = true;
         this._repeatNameImg = ComponentFactory.Instance.creatBitmap("asset.vip.repeatName");
         addChild(this._repeatNameImg);
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("asset.vip.friendNameBG");
         addChild(this._inputBG);
         this._friendName = ComponentFactory.Instance.creat("GiveOthersOpenedView.friendName");
         addChild(this._friendName);
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._friendName;
         this._dropList.x = this._inputBG.x;
         this._dropList.y = this._inputBG.y + this._inputBG.height;
         this._repeatName = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.repeatName");
         addChild(this._repeatName);
         this._friendListBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.friendList");
         addChild(this._friendListBtn);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.searchListBG");
         addChild(this._listBG);
         this._listBG.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.searchList");
         addChild(this._list);
         this._itemArray = new Array();
         this.fixPos();
         _isSelf = false;
         showOpenOrRenewal();
         this.addEvent();
      }
      
      private function fixPos() : void
      {
         _nameImg.y = 48;
         _VIPDaysImg.y = 107;
         _oneBtn.y = 100;
         _twoBtn.y = 100;
         _threeBtn.y = 100;
         _forthBtn.y = 100;
         _otherBtn.y = 132;
         _otherInput.y = 137;
         _monthNum.y = 143;
         _showPayMoneyBG.y = 167;
         _ownedMoneyImg.y = 206;
         _moneyIconImg.y = 208;
         _money.y = 207;
         _offerImage.y = 88;
         _rewardBtn.visible = false;
      }
      
      private function addEvent() : void
      {
         this._friendName.addEventListener(TextEvent.TEXT_INPUT,this.__textInputHandler);
         this._friendName.addEventListener(Event.CHANGE,this.__textChange);
         this._repeatName.addEventListener(TextEvent.TEXT_INPUT,this.__repeattextInputHandler);
         this._friendListBtn.addEventListener(MouseEvent.CLICK,this.__friendListView);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__listAction);
         this._friendName.addEventListener(FocusEvent.FOCUS_IN,this.__textChange);
         this._dropList.addEventListener(DropList.SELECTED,this.__seletected);
      }
      
      private function removeEvent() : void
      {
         this._friendName.removeEventListener(TextEvent.TEXT_INPUT,this.__textInputHandler);
         this._friendName.removeEventListener(Event.CHANGE,this.__textChange);
         this._repeatName.removeEventListener(TextEvent.TEXT_INPUT,this.__repeattextInputHandler);
         this._friendListBtn.removeEventListener(MouseEvent.CLICK,this.__friendListView);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__listAction);
         this._friendName.removeEventListener(FocusEvent.FOCUS_IN,this.__textChange);
         this._dropList.removeEventListener(DropList.SELECTED,this.__seletected);
      }
      
      private function __seletected(param1:Event) : void
      {
         this._repeatName.text = this._friendName.text;
      }
      
      private function __listAction(param1:MouseEvent) : void
      {
         if(param1.target is FriendDropListTarget)
         {
            return;
         }
         if(this._dropList && this._dropList.parent)
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function __textChange(param1:Event) : void
      {
         if(this._friendName.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._friendName.text);
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
      
      private function __textInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._friendName,14);
      }
      
      private function __repeattextInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._repeatName.textField,14);
      }
      
      override protected function __openVip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
            return;
         }
         if(this._friendName.text == "" || this._repeatName.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.finish"));
            return;
         }
         if(this._friendName.text != this._repeatName.text)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkName"));
            return;
         }
         if(FilterWordManager.isGotForbiddenWords(this._friendName.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.loginstate.inputInvalidate"));
            return;
         }
         if(_otherBtn.selected && _otherInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkOtherInput"));
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforOther",this._friendName.text,time,payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(this._moneyConfirm.parent)
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               sendVip();
               this._friendName.text = "";
               this._repeatName.text = "";
               _otherInput.text = "";
               upPayMoneyText();
         }
         this._confirmFrame.dispose();
         if(this._confirmFrame.parent)
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      override protected function send() : void
      {
         VipController.instance.sendOpenVip(this._friendName.text,days);
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this._friendName.text = param1;
         this._repeatName.text = param1;
         this._friendList.setVisible = false;
      }
      
      private function __friendListView(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         SoundManager.instance.play("008");
         _loc2_ = this._friendListBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x + this._friendListBtn.width;
         this._friendList.y = _loc2_.y;
         this._friendList.setVisible = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._dropList)
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(this._repeatNameImg)
         {
            ObjectUtils.disposeObject(this._repeatNameImg);
         }
         this._repeatNameImg = null;
         if(this._friendName)
         {
            ObjectUtils.disposeObject(this._friendName);
         }
         this._friendName = null;
         if(this._repeatName)
         {
            ObjectUtils.disposeObject(this._repeatName);
         }
         this._repeatName = null;
         if(this._friendListBtn)
         {
            ObjectUtils.disposeObject(this._friendListBtn);
         }
         this._friendListBtn = null;
         if(this._friendList)
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         if(this._confirmFrame)
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(this._moneyConfirm)
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(this._inputBG)
         {
            ObjectUtils.disposeObject(this._inputBG);
         }
         this._inputBG = null;
         if(this._listBG)
         {
            ObjectUtils.disposeObject(this._listBG);
         }
         this._listBG = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
