package invite.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import vip.VipController;
   
   public class InviteListCell extends Sprite implements Disposeable, IListCell
   {
      
      private static const LevelLimit:int = 6;
      
      private static const RoomTypeLimit:int = 2;
       
      
      public var roomType:int;
      
      private var _data:Object;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _masterIcon:ScaleFrameImage;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _BG:Bitmap;
      
      private var _BGII:Bitmap;
      
      private var _isSelected:Boolean;
      
      private var _inviteButton:SimpleBitmapButton;
      
      private var _itembar:Bitmap;
      
      public function InviteListCell()
      {
         super();
         this.configUi();
         this.addEvent();
         mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._inviteButton)
         {
            ObjectUtils.disposeObject(this._inviteButton);
            this._inviteButton = null;
         }
         if(this._sexIcon)
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
            this._name = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._itembar)
         {
            ObjectUtils.disposeObject(this._itembar);
            this._itembar = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function configUi() : void
      {
         this._itembar = ComponentFactory.Instance.creatBitmap("invite.cell.itembar");
         addChild(this._itembar);
         this._name = ComponentFactory.Instance.creat("invite.cell.playerItemName");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("invite.cell.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("invite.cell.SexIcon");
         addChild(this._sexIcon);
         this._masterIcon = UICreatShortcut.creatAndAdd("invite.masterRelationIcon",this);
         this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("invite.cell.InviteButton");
         addChild(this._inviteButton);
      }
      
      private function addEvent() : void
      {
         this._inviteButton.addEventListener(MouseEvent.CLICK,this.__onInviteClick);
      }
      
      private function removeEvent() : void
      {
         this._inviteButton.removeEventListener(MouseEvent.CLICK,this.__onInviteClick);
      }
      
      private function __onInviteClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inviteButton.enable = false;
         this._inviteButton.filters = [ComponentFactory.Instance.model.getSet("invite.InviteFrame.DisenableGF")];
         this._data.invited = true;
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(_loc2_.type == RoomInfo.MATCH_ROOM)
         {
            if(this.inviteLvTip(LevelLimit))
            {
               return;
            }
         }
         else if(_loc2_.type == RoomInfo.CHALLENGE_ROOM)
         {
            if(this.inviteLvTip(12))
            {
               return;
            }
         }
         if((_loc2_.type == RoomInfo.DUNGEON_ROOM || _loc2_.type == RoomInfo.ACADEMY_DUNGEON_ROOM || _loc2_.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON) && this._data.Grade < GameManager.MinLevelDuplicate)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
            return;
         }
         if(this._data is ConsortiaPlayerInfo)
         {
            if(this.checkLevel(this._data.info.Grade))
            {
               GameInSocketOut.sendInviteGame(this._data.info.ID);
            }
         }
         else if(this.checkLevel(this._data.Grade))
         {
            GameInSocketOut.sendInviteGame(this._data.ID);
         }
      }
      
      private function inviteLvTip(param1:int) : Boolean
      {
         if(this._data is ConsortiaPlayerInfo)
         {
            if(this._data.info.Grade < param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot",param1));
               return true;
            }
         }
         else if(this._data.Grade < param1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot",param1));
            return true;
         }
         return false;
      }
      
      private function checkLevel(param1:int) : Boolean
      {
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(_loc2_.type > RoomTypeLimit)
         {
            if(param1 < GameManager.MinLevelDuplicate)
            {
               return false;
            }
         }
         else if(_loc2_.type == RoomTypeLimit)
         {
            if((_loc2_.levelLimits - 1) * 10 > param1)
            {
               return false;
            }
         }
         return true;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         this.update();
      }
      
      private function update() : void
      {
         if(!this._data.invited)
         {
            this._inviteButton.enable = true;
            this._inviteButton.filters = null;
         }
         this._name.text = this._data.NickName;
         if(this._data.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(121,this._data.typeVIP);
            this._vipName.x = this._name.x;
            this._vipName.y = this._name.y;
            this._vipName.text = this._name.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._name);
         }
         else
         {
            addChild(this._name);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._sexIcon.setSex(this._data.Sex);
         this._levelIcon.setInfo(this._data.Grade,this._data.Repute,this._data.WinCount,this._data.TotalCount,this._data.FightPower,this._data.Offer,true,false);
         this._masterIcon.visible = PlayerManager.Instance.Self.isMyApprent(this._data.ID) || PlayerManager.Instance.Self.isMyMaster(this._data.ID);
         this._sexIcon.visible = !this._masterIcon.visible;
         if(PlayerManager.Instance.Self.isMyMaster(this._data.ID))
         {
            if(this._data.Sex)
            {
               this._masterIcon.setFrame(1);
            }
            else
            {
               this._masterIcon.setFrame(2);
            }
         }
         else if(this._data.Sex)
         {
            this._masterIcon.setFrame(3);
         }
         else
         {
            this._masterIcon.setFrame(4);
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
