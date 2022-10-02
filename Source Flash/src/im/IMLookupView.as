package im
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.CMFriendInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.PlayerTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class IMLookupView extends Sprite implements Disposeable
   {
       
      
      public const MAX_ITEM_NUM:int = 8;
      
      public const ITEM_MAX_HEIGHT:int = 33;
      
      public const ITEM_MIN_HEIGHT:int = 28;
      
      private var _bg:Bitmap;
      
      private var _cleanUpBtn:SimpleBitmapButton;
      
      private var _inputText:TextInput;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _currentList:Array;
      
      private var _itemArray:Array;
      
      private var _listType:int;
      
      private var _currentItemInfo:*;
      
      private var _currentItem:IMLookupItem;
      
      private var _list:VBox;
      
      private var _NAN:Bitmap;
      
      public function IMLookupView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.IM.lookUp_bg");
         addChild(this._bg);
         this._cleanUpBtn = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.cleanUpBtn");
         this._cleanUpBtn.visible = false;
         addChild(this._cleanUpBtn);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.textinput");
         addChild(this._inputText);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.lookUpBG");
         this._bg2.visible = false;
         addChild(this._bg2);
         this._list = ComponentFactory.Instance.creat("IM.IMLookup.lookupList");
         addChild(this._list);
         this._NAN = ComponentFactory.Instance.creatBitmap("asset.IM.NAN");
         this._NAN.visible = false;
         addChild(this._NAN);
      }
      
      private function initEvent() : void
      {
         this._inputText.addEventListener(Event.CHANGE,this.__textInput);
         this._inputText.addEventListener(MouseEvent.CLICK,this.__inputClick);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__stopEvent);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         if(PlayerManager.Instance.blackList)
         {
            PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         if(PlayerManager.Instance.recentContacts)
         {
            PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         this._cleanUpBtn.addEventListener(MouseEvent.CLICK,this.__cleanUpClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function __inputClick(param1:MouseEvent) : void
      {
         this.strTest();
      }
      
      private function __stageClick(param1:MouseEvent) : void
      {
         if(DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._inputText) || param1.target is ScaleFrameImage || param1.target is PlayerTip || param1.target is SimpleBitmapButton)
         {
            return;
         }
         this.hide();
      }
      
      private function hide() : void
      {
         this._bg2.visible = false;
         this._NAN.visible = false;
         this._cleanUpBtn.visible = false;
         this._list.visible = false;
      }
      
      private function __stopEvent(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function __cleanUpClick(param1:MouseEvent) : void
      {
         this._inputText.text = "";
         this.strTest();
         SoundManager.instance.play("008");
      }
      
      private function __updateList(param1:Event) : void
      {
         if(this._list && this._list.visible)
         {
            this.strTest();
         }
      }
      
      private function __textInput(param1:Event) : void
      {
         this.strTest();
      }
      
      private function strTest() : void
      {
         this.disposeItems();
         this.updateList();
         if(this._listType == IMView.FRIEND_LIST)
         {
            this.friendStrTest();
         }
         else if(this._listType == IMView.CMFRIEND_LIST)
         {
            this.CMFriendStrTest();
         }
         this.setFlexBg();
      }
      
      private function friendStrTest() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:IMLookupItem = null;
         var _loc5_:IMLookupItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._currentList.length)
         {
            if(this._itemArray.length >= this.MAX_ITEM_NUM)
            {
               this.setFlexBg();
               return;
            }
            _loc2_ = "";
            _loc3_ = "";
            if(this._currentList[_loc1_] is PlayerInfo)
            {
               _loc2_ = (this._currentList[_loc1_] as PlayerInfo).NickName;
               _loc3_ = this._inputText.text;
            }
            else if(this._currentList[_loc1_] is ConsortiaPlayerInfo)
            {
               _loc2_ = (this._currentList[_loc1_] as ConsortiaPlayerInfo).NickName;
               _loc3_ = this._inputText.text;
            }
            if(_loc3_ == "")
            {
               this.setFlexBg();
               return;
            }
            if(!_loc2_)
            {
               this.setFlexBg();
               return;
            }
            if(_loc2_.indexOf(this._inputText.text) != -1)
            {
               if(this._currentList[_loc1_] is PlayerInfo)
               {
                  _loc4_ = new IMLookupItem(this._currentList[_loc1_] as PlayerInfo);
                  _loc4_.addEventListener(MouseEvent.CLICK,this.__clickHandler);
                  this._list.addChild(_loc4_);
                  this._itemArray.push(_loc4_);
               }
               else if(this._currentList[_loc1_] is ConsortiaPlayerInfo)
               {
                  if(this.testAlikeName((this._currentList[_loc1_] as ConsortiaPlayerInfo).NickName))
                  {
                     _loc5_ = new IMLookupItem(this._currentList[_loc1_] as ConsortiaPlayerInfo);
                     _loc5_.addEventListener(MouseEvent.CLICK,this.__clickHandler);
                     this._list.addChild(_loc5_);
                     this._itemArray.push(_loc5_);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         ChatManager.Instance.privateChatTo((param1.currentTarget as IMLookupItem).info.NickName,(param1.currentTarget as IMLookupItem).info.ID);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         this._currentItemInfo = (param1.currentTarget as IMLookupItem).info;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function CMFriendStrTest() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:IMLookupItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._currentList.length)
         {
            if(this._itemArray.length >= this.MAX_ITEM_NUM)
            {
               this.setFlexBg();
               return;
            }
            _loc2_ = (this._currentList[_loc1_] as CMFriendInfo).NickName;
            if(_loc2_ == "")
            {
               _loc2_ = (this._currentList[_loc1_] as CMFriendInfo).OtherName;
            }
            _loc3_ = this._inputText.text;
            if(_loc3_ == "")
            {
               this.setFlexBg();
               return;
            }
            if(_loc2_.indexOf(this._inputText.text) != -1)
            {
               _loc4_ = new IMLookupItem(this._currentList[_loc1_] as CMFriendInfo);
               _loc4_.addEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._list.addChild(_loc4_);
               this._itemArray.push(_loc4_);
            }
            _loc1_++;
         }
      }
      
      private function setFlexBg() : void
      {
         if(this._inputText.text == "")
         {
            this._bg2.visible = false;
            this._NAN.visible = false;
            this._cleanUpBtn.visible = false;
         }
         else if(this._inputText.text != "" && this._itemArray.length == 0)
         {
            this._bg2.visible = true;
            this._bg2.height = this.ITEM_MAX_HEIGHT;
            this._NAN.visible = true;
            this._cleanUpBtn.visible = true;
            this._list.visible = true;
         }
         else
         {
            this._NAN.visible = false;
            this._cleanUpBtn.visible = true;
            this._bg2.visible = true;
            this._list.visible = true;
            if(this._itemArray)
            {
               this._bg2.height = this._itemArray.length * this.ITEM_MIN_HEIGHT == 0 ? Number(Number(this.ITEM_MAX_HEIGHT)) : Number(Number(this._itemArray.length * this.ITEM_MIN_HEIGHT));
            }
         }
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         if(this._itemArray)
         {
            _loc1_ = 0;
            while(_loc1_ < this._itemArray.length)
            {
               (this._itemArray[_loc1_] as IMLookupItem).removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               (this._itemArray[_loc1_] as IMLookupItem).dispose();
               _loc1_++;
            }
         }
         this._list.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function updateList() : void
      {
         if(this._listType == 0)
         {
            this._currentList = [];
            this._currentList = PlayerManager.Instance.friendList.list;
            this._currentList = this._currentList.concat(ConsortionModelControl.Instance.model.memberList.list);
            if(PlayerManager.Instance.blackList && PlayerManager.Instance.blackList.list)
            {
               this._currentList = this._currentList.concat(PlayerManager.Instance.blackList.list);
            }
            if(PlayerManager.Instance.recentContacts && PlayerManager.Instance.recentContacts.list)
            {
               this._currentList = this._currentList.concat(IMController.Instance.getRecentContactsStranger());
            }
         }
         else if(this._listType == 2)
         {
            this._currentList = [];
            if(!PlayerManager.Instance.CMFriendList)
            {
               return;
            }
            this._currentList = PlayerManager.Instance.CMFriendList.list;
         }
      }
      
      private function testAlikeName(param1:String) : Boolean
      {
         var _loc2_:Array = [];
         _loc2_ = PlayerManager.Instance.friendList.list;
         _loc2_ = _loc2_.concat(PlayerManager.Instance.blackList.list);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc2_[_loc3_] as FriendListPlayer).NickName == param1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function set listType(param1:int) : void
      {
         this._listType = param1;
         this.updateList();
      }
      
      public function get currentItemInfo() : *
      {
         return this._currentItemInfo;
      }
      
      public function dispose() : void
      {
         this._inputText.removeEventListener(Event.CHANGE,this.__textInput);
         this._inputText.removeEventListener(MouseEvent.CLICK,this.__inputClick);
         this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__stopEvent);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__updateList);
         if(PlayerManager.Instance.blackList)
         {
            PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         if(PlayerManager.Instance.recentContacts)
         {
            PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE,this.__updateList);
         }
         this._cleanUpBtn.removeEventListener(MouseEvent.CLICK,this.__cleanUpClick);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
         this.disposeItems();
         if(this._bg2)
         {
            this._bg2.dispose();
            this._bg2 = null;
         }
         if(this._bg && this._bg.bitmapData)
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(this._cleanUpBtn)
         {
            this._cleanUpBtn.dispose();
            this._cleanUpBtn = null;
         }
         if(this._inputText)
         {
            this._inputText.dispose();
            this._inputText = null;
         }
         if(this._currentItem)
         {
            this._currentItem.dispose();
            this._currentItem = null;
         }
         if(this._list)
         {
            this._list.dispose();
            this._list = null;
         }
         if(this._NAN && this._NAN.bitmapData)
         {
            this._NAN.bitmapData.dispose();
            this._NAN = null;
         }
      }
   }
}
