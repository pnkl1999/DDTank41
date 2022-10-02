package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RoomListPlayerItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _name:FilterFrameText;
      
      private var _BG:Bitmap;
      
      private var _BGII:Bitmap;
      
      private var _isSelected:Boolean;
      
      private var _vipName:GradientText;
      
      public function RoomListPlayerItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.roomList.playerItemBG");
         this._BG.visible = false;
         this._BG.y = 2;
         addChild(this._BG);
         this._BGII = ComponentFactory.Instance.creat("asset.roomList.playerItemBG");
         this._BGII.alpha = 0;
         addChild(this._BGII);
         this._name = ComponentFactory.Instance.creat("roomList.pvpRoomList.playerItemName");
         this._name.isAutoFitLength = true;
         addChild(this._name);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("roomList.roomPlayerItem.SexIcon");
         addChild(this._sexIcon);
         this._vipName = PlayerManager.Instance.Self.getVipNameTxt(120);
         this._vipName.x = this._name.x;
         this._vipName.y = this._name.y;
         addChild(this._vipName);
         addEventListener(MouseEvent.CLICK,this.itemClick);
      }
      
      private function itemClick(param1:MouseEvent) : void
      {
         PlayerTipManager.show(this._info,localToGlobal(new Point(0,0)).y);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._isSelected = param2;
         if(this._BG)
         {
            this._BG.visible = this._isSelected;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         this._name.text = this._info.NickName;
         if(this._info.IsVIP)
         {
            this._vipName.text = this._name.text;
            this._vipName.visible = true;
            this._name.visible = false;
         }
         else
         {
            this._name.visible = true;
            this._vipName.visible = false;
         }
         this._sexIcon.setSex(this._info.Sex);
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.itemClick);
         if(this._vipName)
         {
            this._vipName.dispose();
         }
         this._vipName = null;
         this._name.dispose();
         this._levelIcon.dispose();
         this._sexIcon.dispose();
      }
   }
}
