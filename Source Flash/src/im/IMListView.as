package im
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Timer;
   import im.info.CustomInfo;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class IMListView extends Sprite implements Disposeable
   {
       
      
      private var _listPanel:ListPanel;
      
      private var _playerArray:Array;
      
      private var _titleList:Vector.<FriendListPlayer>;
      
      private var _currentItemInfo:FriendListPlayer;
      
      private var _currentTitleInfo:FriendListPlayer;
      
      private var _pos:int;
      
      private var _timer:Timer;
      
      private var _responseR:Sprite;
      
      private var _currentItem:IMListItemView;
      
      public function IMListView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.initTitle();
         this._timer = new Timer(200);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("IM.IMlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._listPanel);
         this._listPanel.list.updateListView();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._currentTitleInfo = this._titleList[1];
         this._responseR = new Sprite();
         this._responseR.graphics.beginFill(16777215,0);
         this._responseR.graphics.drawRect(0,0,this._listPanel.width,this._listPanel.height);
         this._responseR.graphics.endFill();
         addChild(this._responseR);
         this._responseR.mouseChildren = false;
         this._responseR.mouseEnabled = false;
         this.updateList();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__removeRecentContact);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,this.__addItem);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.ADD,this.__addBlackItem);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN,this.__listItemDownHandler);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP,this.__listItemUpHandler);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT,this.__listItemOutHandler);
         this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_TOP,this.__topRangeHandler);
         this._responseR.addEventListener(DragManager.DRAG_IN_RANGE_BUTTOM,this.__buttomRangeHandler);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         IMController.Instance.addEventListener(IMEvent.ADD_NEW_GROUP,this.__addNewGroup);
         IMController.Instance.addEventListener(IMEvent.UPDATE_GROUP,this.__updaetGroup);
         IMController.Instance.addEventListener(IMEvent.DELETE_GROUP,this.__deleteGroup);
      }
      
      protected function __deleteGroup(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._titleList.length)
         {
            if(this._titleList[_loc2_].titleType == IMController.Instance.deleteCustomID)
            {
               this._titleList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this._currentTitleInfo.titleIsSelected = false;
         this.updateTitle();
         this.updateList();
      }
      
      protected function __updaetGroup(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._titleList.length)
         {
            if(this._titleList[_loc2_].titleType == IMController.Instance.customInfo.ID)
            {
               this._titleList[_loc2_].titleText = IMController.Instance.customInfo.Name;
               break;
            }
            _loc2_++;
         }
         this._currentTitleInfo.titleIsSelected = false;
         this.updateTitle();
         this.updateList();
      }
      
      protected function __addNewGroup(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:FriendListPlayer = new FriendListPlayer();
         _loc2_.type = 0;
         _loc2_.titleType = IMController.Instance.customInfo.ID;
         _loc2_.titleIsSelected = false;
         _loc2_.titleText = IMController.Instance.customInfo.Name;
         if(this._titleList.length == 4)
         {
            this._titleList.splice(2,0,_loc2_);
            PlayerManager.Instance.customList.splice(1,0,IMController.Instance.customInfo);
         }
         else
         {
            _loc3_ = 2;
            while(_loc3_ < this._titleList.length - 2)
            {
               if(IMController.Instance.customInfo.ID < this._titleList[_loc3_].titleType)
               {
                  this._titleList.splice(_loc3_,0,_loc2_);
                  PlayerManager.Instance.customList.splice(_loc3_ - 1,0,IMController.Instance.customInfo);
                  break;
               }
               if(_loc3_ == this._titleList.length - 3)
               {
                  this._titleList.splice(_loc3_ + 1,0,_loc2_);
                  PlayerManager.Instance.customList.splice(_loc3_,0,IMController.Instance.customInfo);
                  break;
               }
               _loc3_++;
            }
         }
         this.updateTitle();
         this.updateList();
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.recentContacts.removeEventListener(DictionaryEvent.REMOVE,this.__removeRecentContact);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.ADD,this.__addItem);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.UPDATE,this.__updateItem);
         PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.ADD,this.__addBlackItem);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_DOWN,this.__listItemDownHandler);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_MOUSE_UP,this.__listItemUpHandler);
         this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_ROLL_OUT,this.__listItemOutHandler);
         this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_TOP,this.__topRangeHandler);
         this._responseR.removeEventListener(DragManager.DRAG_IN_RANGE_BUTTOM,this.__buttomRangeHandler);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         IMController.Instance.removeEventListener(IMEvent.ADD_NEW_GROUP,this.__addNewGroup);
         IMController.Instance.removeEventListener(IMEvent.UPDATE_GROUP,this.__updaetGroup);
         IMController.Instance.removeEventListener(IMEvent.DELETE_GROUP,this.__deleteGroup);
      }
      
      protected function __addToStage(param1:Event) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         _loc2_ = this._listPanel.localToGlobal(new Point(0,0));
         this._responseR.x = _loc2_.x;
         this._responseR.y = _loc2_.y;
      }
      
      protected function __listItemOutHandler(param1:ListItemEvent) : void
      {
         this._timer.stop();
      }
      
      protected function __listItemUpHandler(param1:ListItemEvent) : void
      {
         this._timer.stop();
      }
      
      protected function __listItemDownHandler(param1:ListItemEvent) : void
      {
         this._currentItem = param1.cell as IMListItemView;
         var _loc2_:FriendListPlayer = this._currentItem.getCellValue() as FriendListPlayer;
         if(_loc2_.type == 1 && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      protected function __topRangeHandler(param1:Event) : void
      {
         this._listPanel.setViewPosition(-1);
      }
      
      protected function __buttomRangeHandler(param1:Event) : void
      {
         this._listPanel.setViewPosition(1);
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:Point = null;
         this._timer.stop();
         _loc2_ = this._listPanel.localToGlobal(new Point(0,0));
         this._responseR.x = _loc2_.x;
         this._responseR.y = _loc2_.y;
         DragManager.startDrag(this._currentItem,this._currentItem.getCellValue(),this.createImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,false,true,true,this._responseR,this._currentItem.height + 10);
         this.showTitle();
      }
      
      private function createImg() : DisplayObject
      {
         var _loc1_:Bitmap = new Bitmap(new BitmapData(this._currentItem.width - 6,this._currentItem.height - 6,false,0),"auto",true);
         var _loc2_:Matrix = new Matrix(1,0,0,1,-2,-2);
         _loc1_.bitmapData.draw(this._currentItem,_loc2_);
         return _loc1_;
      }
      
      private function initTitle() : void
      {
         var _loc5_:FriendListPlayer = null;
         this._titleList = new Vector.<FriendListPlayer>();
         var _loc1_:Vector.<CustomInfo> = PlayerManager.Instance.customList;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc5_ = new FriendListPlayer();
            _loc5_.type = 0;
            _loc5_.titleType = _loc1_[_loc2_].ID;
            _loc5_.titleIsSelected = false;
            if(_loc2_ == _loc1_.length - 1)
            {
               _loc5_.titleNumText = "[" + "0/" + String(PlayerManager.Instance.blackList.length) + "]";
            }
            else
            {
               _loc5_.titleNumText = "[" + String(PlayerManager.Instance.getOnlineFriendForCustom(_loc1_[_loc2_].ID).length) + "/" + String(PlayerManager.Instance.getFriendForCustom(_loc1_[_loc2_].ID).length) + "]";
            }
            _loc5_.titleText = _loc1_[_loc2_].Name;
            this._titleList.push(_loc5_);
            _loc2_++;
         }
         var _loc3_:FriendListPlayer = new FriendListPlayer();
         _loc3_.type = 0;
         _loc3_.titleType = 2;
         _loc3_.titleIsSelected = false;
         _loc3_.titleNumText = "[" + String(PlayerManager.Instance.onlineRecentContactList.length) + "/" + String(PlayerManager.Instance.recentContacts.length) + "]";
         _loc3_.titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.recentContact");
         this._titleList.unshift(_loc3_);
         var _loc4_:FriendListPlayer = new FriendListPlayer();
         _loc4_.type = 0;
         _loc4_.titleType = 3;
         _loc4_.titleText = LanguageMgr.GetTranslation("tank.game.IM.custom");
         this._titleList.push(_loc4_);
         this._titleList[1].titleIsSelected = true;
      }
      
      private function __addBlackItem(param1:DictionaryEvent) : void
      {
         if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected == true && this._listPanel && this._listPanel.vectorListModel)
         {
            this._listPanel.vectorListModel.append(param1.data,this.getInsertIndex(param1.data as FriendListPlayer));
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
         else
         {
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function __updateItem(param1:DictionaryEvent) : void
      {
         this.updateTitle();
         this.updateList();
      }
      
      private function __addItem(param1:DictionaryEvent) : void
      {
         if((this._currentTitleInfo.titleType == 0 || this._currentTitleInfo.titleType >= 10) && this._currentTitleInfo.titleIsSelected == true && this._listPanel && this._listPanel.vectorListModel)
         {
            this._listPanel.vectorListModel.append(param1.data,this.getInsertIndex(param1.data as FriendListPlayer));
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
         else
         {
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function __removeItem(param1:DictionaryEvent) : void
      {
         if(this._listPanel && this._listPanel.vectorListModel)
         {
            this._listPanel.vectorListModel.remove(param1.data);
            this.updateTitle();
            this._listPanel.list.updateListView();
         }
      }
      
      private function getInsertIndex(param1:FriendListPlayer) : int
      {
         var _loc2_:int = 0;
         var _loc4_:FriendListPlayer = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:Array = this._listPanel.vectorListModel.elements;
         var _loc6_:int = 0;
         while(_loc6_ < this._titleList.length)
         {
            if(this._titleList[_loc6_].titleIsSelected)
            {
               _loc2_ = _loc6_ + 1;
            }
            _loc6_++;
         }
         if(_loc3_.length == this._titleList.length)
         {
            return _loc2_;
         }
         if(this._currentTitleInfo.titleType != 1 && this._currentTitleInfo.titleIsSelected)
         {
            _loc5_ = 0;
            if(param1.playerState.StateID != 0)
            {
               _loc5_ = PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + _loc2_ - 1;
               if(_loc5_ != 0)
               {
                  _loc7_ = _loc2_;
                  while(_loc7_ < _loc5_)
                  {
                     _loc4_ = _loc3_[_loc7_] as FriendListPlayer;
                     if(param1.IsVIP && _loc4_.IsVIP && param1.Grade < _loc4_.Grade)
                     {
                        _loc2_++;
                     }
                     if(!param1.IsVIP && _loc4_.IsVIP)
                     {
                        _loc2_++;
                     }
                     if(!param1.IsVIP && !_loc4_.IsVIP && param1.Grade < _loc4_.Grade)
                     {
                        _loc2_++;
                     }
                     _loc7_++;
                  }
               }
               return _loc2_;
            }
            _loc2_ = PlayerManager.Instance.getOnlineFriendForCustom(this._currentTitleInfo.titleType).length + _loc2_;
            _loc5_ = PlayerManager.Instance.getOfflineFriendForCustom(this._currentTitleInfo.titleType).length + _loc2_ - 1;
            if(_loc5_ != 0)
            {
               _loc8_ = _loc2_;
               while(_loc8_ < _loc5_)
               {
                  _loc4_ = _loc3_[_loc8_] as FriendListPlayer;
                  if(param1.Grade > _loc4_.Grade)
                  {
                     break;
                  }
                  _loc2_++;
                  _loc8_++;
               }
            }
            return _loc2_;
         }
         _loc5_ = PlayerManager.Instance.blackList.length + _loc2_ - 1;
         if(_loc5_ != 0)
         {
            _loc9_ = _loc2_;
            while(_loc9_ < _loc5_)
            {
               _loc4_ = _loc3_[_loc9_] as FriendListPlayer;
               if(param1.Grade > _loc4_.Grade)
               {
                  break;
               }
               _loc2_++;
               _loc9_++;
            }
         }
         return _loc2_;
      }
      
      private function __removeRecentContact(param1:DictionaryEvent) : void
      {
         this.updateTitle();
         this.updateList();
      }
      
      private function updateTitle() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(PlayerManager.Instance.friendList)
         {
            _loc1_ = 1;
            while(_loc1_ < this._titleList.length - 2)
            {
               _loc2_ = PlayerManager.Instance.getOnlineFriendForCustom(this._titleList[_loc1_].titleType).length;
               _loc3_ = PlayerManager.Instance.getFriendForCustom(this._titleList[_loc1_].titleType).length;
               this._titleList[_loc1_].titleNumText = "[" + String(_loc2_) + "/" + String(_loc3_) + "]";
               _loc1_++;
            }
         }
         if(PlayerManager.Instance.blackList)
         {
            this._titleList[this._titleList.length - 2].titleNumText = "[" + "0/" + String(PlayerManager.Instance.blackList.length) + "]";
         }
         if(PlayerManager.Instance.recentContacts)
         {
            this._titleList[0].titleNumText = "[" + String(PlayerManager.Instance.onlineRecentContactList.length) + "/" + String(PlayerManager.Instance.recentContacts.length) + "]";
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         var _loc2_:int = 0;
         if((param1.cellValue as FriendListPlayer).type == 1)
         {
            if(!this._currentItemInfo)
            {
               this._currentItemInfo = param1.cellValue as FriendListPlayer;
               this._currentItemInfo.titleIsSelected = true;
            }
            if(this._currentItemInfo != param1.cellValue as FriendListPlayer)
            {
               this._currentItemInfo.titleIsSelected = false;
               this._currentItemInfo = param1.cellValue as FriendListPlayer;
               this._currentItemInfo.titleIsSelected = true;
            }
         }
         else
         {
            if(!this._currentTitleInfo)
            {
               this._currentTitleInfo = param1.cellValue as FriendListPlayer;
               this._currentTitleInfo.titleIsSelected = true;
            }
            if(this._currentTitleInfo != param1.cellValue as FriendListPlayer)
            {
               this._currentTitleInfo.titleIsSelected = false;
               this._currentTitleInfo = param1.cellValue as FriendListPlayer;
               this._currentTitleInfo.titleIsSelected = true;
            }
            else
            {
               this._currentTitleInfo.titleIsSelected = !this._currentTitleInfo.titleIsSelected;
            }
            _loc2_ = 0;
            while(_loc2_ < this._titleList.length)
            {
               if(this._titleList[_loc2_] != this._currentTitleInfo)
               {
                  this._titleList[_loc2_].titleIsSelected = false;
               }
               _loc2_++;
            }
            this.updateList();
            SoundManager.instance.play("008");
         }
         this._listPanel.list.updateListView();
      }
      
      private function updateList() : void
      {
         this._pos = this._listPanel.list.viewPosition.y;
         IMController.Instance.titleType = this._currentTitleInfo.titleType;
         if(this._currentTitleInfo.titleType != 1 && this._currentTitleInfo.titleType != 2 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateFriendList(this._currentTitleInfo.titleType);
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateBlackList();
         }
         else if(this._currentTitleInfo.titleType == 2 && this._currentTitleInfo.titleIsSelected)
         {
            this.updateRecentContactList();
         }
         else if(!this._currentTitleInfo.titleIsSelected)
         {
            this.showTitle();
         }
         this.updateTitle();
         this._listPanel.list.updateListView();
         var _loc1_:IntPoint = new IntPoint(0,this._pos);
         this._listPanel.list.viewPosition = _loc1_;
      }
      
      private function showTitle() : void
      {
         this._playerArray = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._titleList.length)
         {
            this._playerArray.push(this._titleList[_loc1_]);
            this._titleList[_loc1_].titleIsSelected = false;
            _loc1_++;
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateFriendList(param1:int = 0) : void
      {
         var _loc9_:FriendListPlayer = null;
         this._playerArray = [];
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._titleList.length)
         {
            this._playerArray.push(this._titleList[_loc3_]);
            if(param1 == this._titleList[_loc3_].titleType)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         var _loc4_:Array = PlayerManager.Instance.getOnlineFriendForCustom(param1);
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc7_] as FriendListPlayer;
            if(_loc9_.IsVIP)
            {
               _loc5_.push(_loc9_);
            }
            else
            {
               _loc6_.push(_loc9_);
            }
            _loc7_++;
         }
         _loc5_ = this.sort(_loc5_);
         _loc6_ = this.sort(_loc6_);
         _loc4_ = _loc5_.concat(_loc6_);
         _loc4_ = IMController.Instance.sortAcademyPlayer(_loc4_);
         this._playerArray = this._playerArray.concat(_loc4_);
         _loc4_ = PlayerManager.Instance.getOfflineFriendForCustom(param1);
         _loc4_ = this.sort(_loc4_);
         _loc4_ = IMController.Instance.sortAcademyPlayer(_loc4_);
         this._playerArray = this._playerArray.concat(_loc4_);
         var _loc8_:int = _loc2_ + 1;
         while(_loc8_ < this._titleList.length)
         {
            this._playerArray.push(this._titleList[_loc8_]);
            _loc8_++;
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateBlackList() : void
      {
         this._playerArray = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._titleList.length - 1)
         {
            this._playerArray.push(this._titleList[_loc1_]);
            _loc1_++;
         }
         var _loc2_:Array = PlayerManager.Instance.blackList.list;
         this._playerArray = this._playerArray.concat(_loc2_);
         this._playerArray.push(this._titleList[this._titleList.length - 1]);
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function updateRecentContactList() : void
      {
         var _loc3_:FriendListPlayer = null;
         var _loc6_:int = 0;
         var _loc7_:PlayerState = null;
         this._playerArray = [];
         this._playerArray.unshift(this._titleList[0]);
         var _loc1_:Array = [];
         var _loc2_:DictionaryData = PlayerManager.Instance.recentContacts;
         var _loc4_:Array = IMController.Instance.recentContactsList;
         if(_loc4_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_] != 0)
               {
                  _loc3_ = _loc2_[_loc4_[_loc6_]];
                  if(_loc3_ && _loc1_.indexOf(_loc3_) == -1)
                  {
                     if(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID))
                     {
                        _loc7_ = new PlayerState(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                        _loc3_.playerState = _loc7_;
                     }
                     _loc1_.push(_loc3_);
                  }
               }
               _loc6_++;
            }
         }
         this._playerArray = this._playerArray.concat(_loc1_);
         var _loc5_:int = 1;
         while(_loc5_ < this._titleList.length)
         {
            this._playerArray.push(this._titleList[_loc5_]);
            _loc5_++;
         }
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._playerArray);
         this._listPanel.list.updateListView();
      }
      
      private function sort(param1:Array) : Array
      {
         return param1.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._listPanel && this._listPanel.parent)
         {
            this._listPanel.parent.removeChild(this._listPanel);
            this._listPanel.dispose();
            this._listPanel = null;
         }
         if(this._currentItemInfo)
         {
            this._currentItemInfo.titleIsSelected = false;
         }
      }
   }
}
