package church.view.weddingRoom.frame
{
   import church.view.menu.MenuView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class WeddingRoomGuestListItemView extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _txtItemInfo:FilterFrameText;
      
      private var _ltemBgAc:Bitmap;
      
      private var _sexIcon:SexIcon;
      
      private var _isSelected:Boolean;
      
      private var _vipName:GradientText;
      
      public function WeddingRoomGuestListItemView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this._ltemBgAc = ComponentFactory.Instance.creatBitmap("asset.church.room.guestListItemBgAcAsset");
         addChild(this._ltemBgAc);
         this._txtItemInfo = ComponentFactory.Instance.creat("church.room.listGuestListItemInfoAsset");
         this._txtItemInfo.mouseEnabled = false;
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListItemLevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListItemSexIcon");
         this._sexIcon.size = 0.8;
         addChild(this._sexIcon);
      }
      
      private function setEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      private function itemClick(param1:MouseEvent) : void
      {
         if(this._playerInfo.ID == ChurchManager.instance.currentRoom.brideID || this._playerInfo.ID == ChurchManager.instance.currentRoom.groomID)
         {
            return;
         }
         MenuView.show(this._playerInfo);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._isSelected = param2;
         this._ltemBgAc.visible = this._isSelected;
      }
      
      public function getCellValue() : *
      {
         return this._playerInfo;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._playerInfo = param1;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         this._txtItemInfo.text = this._playerInfo.NickName;
         if(this._playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(109,this._playerInfo.typeVIP);
            this._vipName.x = this._txtItemInfo.x;
            this._vipName.y = this._txtItemInfo.y;
            this._vipName.text = this._txtItemInfo.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._txtItemInfo);
         }
         else
         {
            addChild(this._txtItemInfo);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._sexIcon.setSex(this._playerInfo.Sex);
         this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer,true,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function removeView() : void
      {
         if(this._levelIcon)
         {
            if(this._levelIcon.parent)
            {
               this._levelIcon.parent.removeChild(this._levelIcon);
            }
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(this._txtItemInfo)
         {
            if(this._txtItemInfo.parent)
            {
               this._txtItemInfo.parent.removeChild(this._txtItemInfo);
            }
            this._txtItemInfo.dispose();
         }
         this._txtItemInfo = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._sexIcon)
         {
            if(this._sexIcon.parent)
            {
               this._sexIcon.parent.removeChild(this._sexIcon);
            }
            this._sexIcon.dispose();
         }
         this._sexIcon = null;
         if(this._ltemBgAc)
         {
            if(this._ltemBgAc.parent)
            {
               this._ltemBgAc.parent.removeChild(this._ltemBgAc);
            }
            this._ltemBgAc.bitmapData.dispose();
            this._ltemBgAc.bitmapData = null;
         }
         this._ltemBgAc = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
