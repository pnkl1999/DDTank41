package ddt.view.academyCommon.myAcademy.myAcademyItem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import email.manager.MailManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   import im.IMEvent;
   
   public class MyAcademyMasterItem extends Sprite implements Disposeable
   {
       
      
      protected var _nameTxt:FilterFrameText;
      
      protected var _stateTxt:FilterFrameText;
      
      protected var _removeBtn:BaseButton;
      
      protected var _itemBG:ScaleFrameImage;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _sexIcon:SexIcon;
      
      protected var _info:PlayerInfo;
      
      protected var _isSelect:Boolean;
      
      protected var _addFriend:BaseButton;
      
      protected var _emailBtn:BaseButton;
      
      protected var _removeGold:int;
      
      public function MyAcademyMasterItem()
      {
         super();
         this.init();
         this.initEvent();
         this.initComponent();
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         this.updateComponent();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      protected function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.itemBG");
         this._itemBG.setFrame(1);
         addChild(this._itemBG);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.nameTxt");
         addChild(this._nameTxt);
         this._stateTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.stateTxt");
         addChild(this._stateTxt);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.MyAcademyMasterItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = new SexIcon();
         PositionUtils.setPos(this._sexIcon,"academyCommon.myAcademy.MyAcademyMasterItem.sexIcon");
         addChild(this._sexIcon);
         this._removeBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.removeBtn");
         addChild(this._removeBtn);
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.addFriendBtn");
         this._addFriend.visible = false;
         addChild(this._addFriend);
         this._emailBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterItem.emailBtn");
         addChild(this._emailBtn);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._itemBG.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         this._removeBtn.addEventListener(MouseEvent.CLICK,this.__removeClick);
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriendClick);
         this._emailBtn.addEventListener(MouseEvent.CLICK,this.__emailBtnClick);
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this.__addFriend);
      }
      
      private function __addFriend(param1:IMEvent) : void
      {
         if(this._info && (param1.data as PlayerInfo).ID == this._info.ID)
         {
            this._addFriend.enable = false;
         }
      }
      
      private function __emailBtnClick(param1:MouseEvent) : void
      {
         MailManager.Instance.showWriting(this._info.NickName);
      }
      
      private function __addFriendClick(param1:MouseEvent) : void
      {
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      protected function __removeClick(param1:MouseEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc4_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         if(!this.getTimerOvertop())
         {
            _loc2_.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.remove",this._info.NickName);
            _loc3_ = AlertManager.Instance.alert("academySimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else
         {
            _loc2_.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.removeII",this._info.NickName);
            _loc4_ = AlertManager.Instance.alert("academySimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_.addEventListener(FrameEvent.RESPONSE,this.__alerFrameEvent);
         }
      }
      
      protected function __alerFrameEvent(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (param1.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      protected function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (param1.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Gold >= 10000)
               {
                  this.submit();
                  break;
               }
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
               break;
         }
      }
      
      protected function __quickBuyResponse(param1:FrameEvent) : void
      {
         var _loc3_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         _loc2_.dispose();
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc3_.itemID = EquipType.GOLD_BOX;
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyFireMaster(this._info.ID);
      }
      
      private function __onMouseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerTipManager.show(this._info,this._itemBG.localToGlobal(new Point(0,0)).y);
      }
      
      protected function initComponent() : void
      {
         this._removeGold = 10000;
      }
      
      protected function updateComponent() : void
      {
         this._nameTxt.text = this._info.NickName;
         if(this._info.playerState.StateID != PlayerState.OFFLINE)
         {
            this._stateTxt.text = LanguageMgr.GetTranslation("tank.view.im.IMFriendList.online");
         }
         else
         {
            this._stateTxt.text = this._info.getLastDate().toString() + LanguageMgr.GetTranslation("hours");
         }
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
         this._sexIcon.setSex(this._info.Sex);
         if(IMController.Instance.isFriend(this._info.NickName))
         {
            this._addFriend.enable = false;
         }
         else
         {
            this._addFriend.enable = true;
         }
      }
      
      protected function getTimerOvertop() : Boolean
      {
         if(this._info.playerState.StateID != PlayerState.OFFLINE)
         {
            return false;
         }
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Date = this._info.lastDate;
         var _loc3_:Number = (_loc1_.valueOf() - _loc2_.valueOf()) / 3600000;
         return _loc3_ > 72 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            this._itemBG.setFrame(1);
         }
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            this._itemBG.setFrame(2);
         }
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         if(this._isSelect)
         {
            this._itemBG.setFrame(3);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
      }
      
      public function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         if(this._itemBG)
         {
            this._itemBG.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         }
         if(this._removeBtn)
         {
            this._removeBtn.removeEventListener(MouseEvent.CLICK,this.__removeClick);
         }
         if(this._addFriend)
         {
            this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriendClick);
         }
         if(this._emailBtn)
         {
            this._emailBtn.removeEventListener(MouseEvent.CLICK,this.__emailBtnClick);
         }
         PlayerManager.Instance.removeEventListener(IMEvent.ADDNEW_FRIEND,this.__addFriend);
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
         }
         if(this._stateTxt)
         {
            ObjectUtils.disposeObject(this._stateTxt);
            this._stateTxt = null;
         }
         if(this._removeBtn)
         {
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
         }
         if(this._itemBG)
         {
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
         }
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._sexIcon)
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(this._addFriend)
         {
            ObjectUtils.disposeObject(this._addFriend);
            this._addFriend = null;
         }
         if(this._emailBtn)
         {
            ObjectUtils.disposeObject(this._emailBtn);
            this._emailBtn = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
