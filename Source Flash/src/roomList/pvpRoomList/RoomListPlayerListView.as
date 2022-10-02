package roomList.pvpRoomList
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.buff.BuffControl;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class RoomListPlayerListView extends Sprite implements Disposeable
   {
       
      
      private var _selfInfo:SelfInfo;
      
      private var _playerListBG:ScaleFrameImage;
      
      private var _player:ICharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _nickNameText:FilterFrameText;
      
      private var _consortiaNameText:FilterFrameText;
      
      private var _reputeText:FilterFrameText;
      
      private var _gesteText:FilterFrameText;
      
      private var _playerList:ListPanel;
      
      private var _data:DictionaryData;
      
      private var _currentItem:RoomListPlayerItem;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _buff:BuffControl;
      
      private var _academyIcon:AcademyIcon;
      
      private var _vipName:GradientText;
      
      public function RoomListPlayerListView(param1:DictionaryData)
      {
         this._data = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      public function set type(param1:int) : void
      {
         this._playerListBG.setFrame(param1);
      }
      
      private function init() : void
      {
         this._selfInfo = PlayerManager.Instance.Self;
         this._playerListBG = ComponentFactory.Instance.creat("roomList.pvpRoomList.playerListBG");
         this._playerListBG.setFrame(1);
         addChild(this._playerListBG);
         this._nickNameText = ComponentFactory.Instance.creat("roomList.pvpRoomList.nickNameText");
         addChild(this._nickNameText);
         this._vipName = PlayerManager.Instance.Self.getVipNameTxt(104);
         this._vipName.textSize = 16;
         this._vipName.x = this._nickNameText.x;
         this._vipName.y = this._nickNameText.y - 2;
         addChild(this._vipName);
         this._consortiaNameText = ComponentFactory.Instance.creat("roomList.pvpRoomList.consortiaNameText");
         addChild(this._consortiaNameText);
         this._reputeText = ComponentFactory.Instance.creat("roomList.pvpRoomList.reputeText");
         addChild(this._reputeText);
         this._gesteText = ComponentFactory.Instance.creat("roomList.pvpRoomList.gesteText");
         addChild(this._gesteText);
         this._nickNameText.text = this._selfInfo.NickName;
         if(this._selfInfo.IsVIP)
         {
            this._vipName.text = this._nickNameText.text;
            this._vipName.visible = true;
            this._nickNameText.visible = false;
         }
         else
         {
            this._vipName.visible = false;
            this._nickNameText.visible = true;
         }
         this._reputeText.text = String(this._selfInfo.Repute);
         this._gesteText.text = String(this._selfInfo.Offer);
         if(this._selfInfo.ConsortiaName == "")
         {
            this._consortiaNameText.text = "";
         }
         else
         {
            this._consortiaNameText.text = String("<" + this._selfInfo.ConsortiaName + ">");
         }
         if(this._consortiaNameText.text.substr(this._consortiaNameText.text.length - 1) == ".")
         {
            this._consortiaNameText.text += ">";
         }
         this._player = CharactoryFactory.createCharacter(this._selfInfo);
         this._player.show();
         this._player.setShowLight(true);
         var _loc1_:Point = ComponentFactory.Instance.creat("roomList.playerPos");
         this._player.x = _loc1_.x;
         this._player.y = _loc1_.y;
         addChild(this._player as DisplayObject);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("roomList.levelIcon");
         this._levelIcon.setInfo(this._selfInfo.Grade,this._selfInfo.Repute,this._selfInfo.WinCount,this._selfInfo.TotalCount,this._selfInfo.FightPower,this._selfInfo.Offer,true,false);
         addChild(this._levelIcon);
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("roomList.VipIcon");
         this._vipIcon.setInfo(this._selfInfo);
         addChild(this._vipIcon);
         if(!this._selfInfo.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(this._selfInfo.SpouseID > 0 && !this._marriedIcon)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("roomList.MarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":this._selfInfo.SpouseName,
               "gender":this._selfInfo.Sex
            };
            addChild(this._marriedIcon);
         }
         this._academyIcon = ComponentFactory.Instance.creatCustomObject("roomList.roomListPlayerItem.AcademyIcon");
         this._academyIcon.tipData = this._selfInfo;
         addChild(this._academyIcon);
         this.updateIconPos();
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("roomList.pvpRoomList.playerlistII");
         addChild(this._playerList);
         this._playerList.list.updateListView();
         this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._buff = ComponentFactory.Instance.creatCustomObject("asset.roomList.buff");
         addChild(this._buff);
      }
      
      private function updateIconPos() : void
      {
         if(this._vipIcon)
         {
            if(this._marriedIcon)
            {
               this._marriedIcon.y = this._vipIcon.y + 37;
               this._academyIcon.y = this._marriedIcon.y + this._marriedIcon.height + 5;
            }
            else
            {
               this._academyIcon.y = this._vipIcon.y + this._vipIcon.height + 5;
            }
         }
         else if(!this._vipIcon)
         {
            if(this._marriedIcon)
            {
               this._marriedIcon.y = this._levelIcon.y + 37;
               this._academyIcon.y = this._marriedIcon.y + this._marriedIcon.height + 5;
            }
            else
            {
               this._academyIcon.y = this._levelIcon.y + this._levelIcon.height + 5;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
      }
      
      private function __updatePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this._playerList.list.updateListView();
         this.upSelfItem();
      }
      
      private function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this.upSelfItem();
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
         this.upSelfItem();
      }
      
      private function upSelfItem() : void
      {
         var _loc1_:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
         var _loc2_:int = this._playerList.vectorListModel.indexOf(_loc1_);
         if(_loc2_ == -1 || _loc2_ == 0)
         {
            return;
         }
         this._playerList.vectorListModel.removeAt(_loc2_);
         this._playerList.vectorListModel.append(_loc1_,0);
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = param1.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
         if(this._currentItem != param1.cell as RoomListPlayerItem)
         {
            this._currentItem.setListCellStatus(this._playerList.list,false,param1.index);
            this._currentItem = param1.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         var _loc4_:PlayerInfo = null;
         var _loc3_:Array = this._playerList.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         _loc2_ = 0;
         var _loc5_:int = _loc3_.length - 1;
         while(_loc5_ >= 0)
         {
            _loc4_ = _loc3_[_loc5_] as PlayerInfo;
            if(!(param1.IsVIP && !_loc4_.IsVIP))
            {
               if(!param1.IsVIP && _loc4_.IsVIP)
               {
                  return _loc5_ + 1;
               }
               if(param1.IsVIP == _loc4_.IsVIP)
               {
                  if(param1.Grade <= _loc4_.Grade)
                  {
                     return _loc5_ + 1;
                  }
                  _loc2_ = _loc5_ - 1;
               }
            }
            _loc5_--;
         }
         return _loc2_ < 0 ? int(int(0)) : int(int(_loc2_));
      }
      
      public function dispose() : void
      {
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         this._playerListBG.dispose();
         this._playerListBG = null;
         this._player.dispose();
         this._player = null;
         this._levelIcon.dispose();
         this._levelIcon = null;
         if(this._vipIcon.filters)
         {
            this._vipIcon.filters = null;
         }
         this._vipIcon.dispose();
         this._vipIcon = null;
         this._nickNameText.dispose();
         this._nickNameText = null;
         this._consortiaNameText.dispose();
         this._consortiaNameText = null;
         this._reputeText.dispose();
         this._reputeText = null;
         this._gesteText.dispose();
         this._gesteText = null;
         this._playerList.vectorListModel.clear();
         this._playerList.dispose();
         this._playerList = null;
         if(this._marriedIcon && this._marriedIcon.parent)
         {
            this._marriedIcon.parent.removeChild(this._marriedIcon);
            this._marriedIcon.dispose();
            this._marriedIcon = null;
         }
         if(this._academyIcon)
         {
            this._academyIcon.dispose();
            this._academyIcon = null;
         }
         this._data = null;
         if(this._currentItem)
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         this._buff.dispose();
         this._buff = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
