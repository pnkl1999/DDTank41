package consortion.view.selfConsortia
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class MemberItem extends Sprite implements Disposeable, IListCell
   {
      
      public static const MAX_OFFLINE_HOURS:int = 720;
       
      
      private var _itemBG:ScaleFrameImage;
      
      private var _light:Bitmap;
      
      private var _name:FilterFrameText;
      
      private var _nameForVip:GradientText;
      
      private var _job:FilterFrameText;
      
      private var _offer:FilterFrameText;
      
      private var _fightPower:FilterFrameText;
      
      private var _offLine:FilterFrameText;
      
      private var _levelIcon:LevelIcon;
      
      private var _playerInfo:ConsortiaPlayerInfo;
      
      private var _isSelected:Boolean;
      
      public function MemberItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         buttonMode = true;
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("memberItem.BG");
         this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.name");
         this._job = ComponentFactory.Instance.creatComponentByStylename("memberItem.job");
         this._offer = ComponentFactory.Instance.creatComponentByStylename("memberItem.offer");
         this._fightPower = ComponentFactory.Instance.creatComponentByStylename("memberItem.fightPower");
         this._offLine = ComponentFactory.Instance.creatComponentByStylename("memberItem.offline");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         this._light = ComponentFactory.Instance.creatBitmap("asset.memberItem.light");
         addChild(this._itemBG);
         addChild(this._job);
         addChild(this._levelIcon);
         addChild(this._offer);
         addChild(this._fightPower);
         addChild(this._offLine);
         addChild(this._light);
         this._light.visible = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onItmeClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onItmeClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyHanlder);
      }
      
      private function __onItmeClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerTipManager.show(this._playerInfo,StageReferance.stage.mouseY);
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         this._light.visible = this._isSelected;
      }
      
      public function isSelelct(param1:Boolean) : void
      {
         this._light.visible = this._isSelected = param1;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         if(this._playerInfo == null || this._playerInfo.ID != PlayerManager.Instance.Self.ID)
         {
            if(param3 % 2 != 0)
            {
               this._itemBG.setFrame(2);
            }
            else
            {
               this._itemBG.setFrame(1);
            }
         }
         if(this._playerInfo)
         {
            this.isSelelct(param2);
         }
      }
      
      public function getCellValue() : *
      {
         return this._playerInfo;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._playerInfo = param1;
         if(this._playerInfo == null)
         {
            this.isSelelct(false);
            mouseEnabled = false;
            mouseChildren = false;
            this.setVisible(false);
         }
         else
         {
            mouseEnabled = true;
            mouseChildren = true;
            this.setVisible(true);
            this.setName();
            if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               this._itemBG.setFrame(3);
               PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyHanlder);
               this._offer.text = String(PlayerManager.Instance.Self.UseOffer);
            }
            else
            {
               PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyHanlder);
               this._offer.text = String(this._playerInfo.UseOffer);
            }
            this._job.text = this._playerInfo.DutyName;
            this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer);
            this._fightPower.text = String(this._playerInfo.FightPower);
            if(this._playerInfo.playerState.StateID != PlayerState.OFFLINE)
            {
               this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.offlineTxt");
            }
            else if(this._playerInfo.playerState.StateID == PlayerState.OFFLINE)
            {
               if(this._playerInfo.OffLineHour == -1)
               {
                  this._offLine.text = this._playerInfo.minute + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute");
               }
               else if(this._playerInfo.OffLineHour >= 1 && this._playerInfo.OffLineHour < 24)
               {
                  this._offLine.text = this._playerInfo.OffLineHour + LanguageMgr.GetTranslation("hours");
               }
               else if(this._playerInfo.OffLineHour >= 24 && this._playerInfo.OffLineHour < 720)
               {
                  this._offLine.text = this._playerInfo.day + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day");
               }
               else if(this._playerInfo.OffLineHour >= 720 && this._playerInfo.OffLineHour < 999)
               {
                  this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.month");
               }
               else
               {
                  this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.long");
               }
            }
         }
      }
      
      private function __selfPropertyHanlder(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["RichesOffer"] || param1.changedProperties["UseOffer"])
         {
            this._offer.text = String(PlayerManager.Instance.Self.UseOffer);
         }
         if(param1.changedProperties["isVip"])
         {
            this.setName();
         }
      }
      
      private function setVisible(param1:Boolean) : void
      {
         if(this._nameForVip)
         {
            this._nameForVip.visible = param1;
         }
         this._name.visible = param1;
         this._job.visible = param1;
         this._levelIcon.visible = param1;
         this._offer.visible = param1;
         this._fightPower.visible = param1;
         this._offLine.visible = param1;
      }
      
      private function setName() : void
      {
         var _loc1_:BasePlayer = null;
         _loc1_ = null;
         var _loc2_:TextFormat = null;
         if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            _loc1_ = PlayerManager.Instance.Self;
         }
         else
         {
            _loc1_ = this._playerInfo;
         }
         if(_loc1_.IsVIP)
         {
            ObjectUtils.disposeObject(this._nameForVip);
            this._nameForVip = VipController.instance.getVipNameTxt(149,_loc1_.typeVIP);
            _loc2_ = new TextFormat();
            _loc2_.align = "center";
            _loc2_.bold = true;
            this._nameForVip.textField.defaultTextFormat = _loc2_;
            this._nameForVip.textSize = 18;
            this._nameForVip.x = this._name.x;
            this._nameForVip.y = this._name.y;
            this._nameForVip.text = _loc1_.NickName;
            addChild(this._nameForVip);
            DisplayUtils.removeDisplay(this._name);
         }
         else
         {
            this._name.text = _loc1_.NickName;
            addChild(this._name);
            DisplayUtils.removeDisplay(this._nameForVip);
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._itemBG = null;
         this._light = null;
         this._name = null;
         this._nameForVip = null;
         this._job = null;
         this._offer = null;
         this._fightPower = null;
         this._offLine = null;
         this._levelIcon = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
