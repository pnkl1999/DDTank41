package invite
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import im.IMController;
   import invite.data.InvitePlayerInfo;
   import invite.view.NavButton;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class InviteFrame extends Frame
   {
      
      public static const Brotherhood:int = 3;
      
      public static const Friend:int = 1;
      
      public static const Hall:int = 2;
      
      public static const RECENT:int = 4;
       
      
      private var _visible:Boolean = true;
      
      private var _resState:String;
      
      private var _listBack:DisplayObject;
      
      private var _refreshButton:TextButton;
      
      private var _cancelButton:TextButton;
      
      private var _hallButton:NavButton;
      
      private var _frientButton:NavButton;
      
      private var _brotherhoodButton:NavButton;
      
      private var _recentContactBtn:NavButton;
      
      private var _list:ListPanel;
      
      private var _listType:int = 0;
      
      private var _changeComplete:Boolean = false;
      
      private var _refleshCount:int = 0;
      
      private var _invitePlayerInfos:Array;
      
      public var roomType:int;
      
      public function InviteFrame()
      {
         super();
         this.configUi();
         this.addEvent();
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            this.refleshList(Brotherhood);
         }
         else
         {
            this.refleshList(Friend);
         }
      }
      
      private function configUi() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._listBack = ComponentFactory.Instance.creatComponentByStylename("invite.list.BackgroundList");
         addToContent(this._listBack);
         this._refreshButton = ComponentFactory.Instance.creatComponentByStylename("invite.RefreshButton");
         this._refreshButton.text = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
         addToContent(this._refreshButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("invite.CancelButton");
         this._cancelButton.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         addToContent(this._cancelButton);
         this._hallButton = ComponentFactory.Instance.creatComponentByStylename("invite.HallButton");
         addToContent(this._hallButton);
         this._frientButton = ComponentFactory.Instance.creatComponentByStylename("invite.FrientButton");
         addToContent(this._frientButton);
         this._brotherhoodButton = ComponentFactory.Instance.creatComponentByStylename("invite.BrotherhoodButton");
         addToContent(this._brotherhoodButton);
         this._recentContactBtn = ComponentFactory.Instance.creatComponentByStylename("invite.recentButton");
         addToContent(this._recentContactBtn);
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("invite.NoConsortiaHallPos");
            this._hallButton.x = _loc1_.x;
            this._hallButton.y = _loc1_.y;
            _loc1_ = ComponentFactory.Instance.creatCustomObject("invite.NoConsortiaFrientPos");
            this._frientButton.x = _loc1_.x;
            this._frientButton.y = _loc1_.y;
            _loc1_ = ComponentFactory.Instance.creatCustomObject("invite.NoConsortiaBrotherhoodPos");
            this._brotherhoodButton.x = _loc1_.x;
            this._brotherhoodButton.y = _loc1_.y;
         }
         this._list = ComponentFactory.Instance.creatComponentByStylename("invite.List");
         addToContent(this._list);
         IMController.Instance.loadRecentContacts();
      }
      
      private function addEvent() : void
      {
         this._brotherhoodButton.addEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._frientButton.addEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._hallButton.addEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._recentContactBtn.addEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._refreshButton.addEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCloseClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.__onCloseClick(null);
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__onRefreshClick(null);
         }
      }
      
      private function removeEvent() : void
      {
         this._brotherhoodButton.removeEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._frientButton.removeEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._hallButton.removeEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._recentContactBtn.removeEventListener(MouseEvent.CLICK,this.__onNavClick);
         this._refreshButton.removeEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.__onCloseClick(null);
         }
         else if(param1.keyCode == Keyboard.ENTER)
         {
            this.__onRefreshClick(null);
         }
      }
      
      private function __onRefreshClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._changeComplete)
         {
            if(this._listType == Hall)
            {
               this.refleshList(this._listType,++this._refleshCount);
            }
            else
            {
               this.refleshList(this._listType);
            }
         }
      }
      
      private function __onGetList(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:PlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new PlayerInfo();
            _loc6_.ID = _loc2_.readInt();
            _loc6_.NickName = _loc2_.readUTF();
            _loc6_.typeVIP = _loc2_.readByte();
            _loc6_.VIPLevel = _loc2_.readInt();
            _loc6_.Sex = _loc2_.readBoolean();
            _loc6_.Grade = _loc2_.readInt();
            _loc6_.ConsortiaID = _loc2_.readInt();
            _loc6_.ConsortiaName = _loc2_.readUTF();
            _loc6_.Offer = _loc2_.readInt();
            _loc6_.WinCount = _loc2_.readInt();
            _loc6_.TotalCount = _loc2_.readInt();
            _loc6_.EscapeCount = _loc2_.readInt();
            _loc6_.Repute = _loc2_.readInt();
            _loc6_.FightPower = _loc2_.readInt();
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         this.updateList(Hall,_loc3_);
      }
      
      private function __onNavClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:NavButton = param1.currentTarget as NavButton;
         if(!_loc2_.selected && this._changeComplete)
         {
            if(_loc2_ == this._brotherhoodButton)
            {
               this._changeComplete = false;
               if(PlayerManager.Instance.Self.ConsortiaID != 0)
               {
                  this.refleshList(Brotherhood);
               }
               else
               {
                  this._changeComplete = true;
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.consortiaRateI"));
               }
            }
            else if(_loc2_ == this._hallButton)
            {
               this._changeComplete = false;
               this.refleshList(Hall);
            }
            else if(_loc2_ == this._frientButton)
            {
               this._changeComplete = false;
               this.refleshList(Friend);
            }
            else if(_loc2_ == this._recentContactBtn)
            {
               this._changeComplete = false;
               this.refleshList(RECENT);
            }
         }
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function updateList(param1:int, param2:Array) : void
      {
         var _loc3_:InvitePlayerInfo = null;
         var _loc5_:BasePlayer = null;
         var _loc6_:Array = null;
         this._changeComplete = true;
         this.clearList();
         this.setListType(param1);
         this._invitePlayerInfos = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_] as BasePlayer;
            if(_loc5_.ID != PlayerManager.Instance.Self.ID)
            {
               _loc3_ = new InvitePlayerInfo();
               _loc3_.NickName = _loc5_.NickName;
               _loc3_.typeVIP = _loc5_.typeVIP;
               _loc3_.Sex = _loc5_.Sex;
               _loc3_.Grade = _loc5_.Grade;
               _loc3_.Repute = _loc5_.Repute;
               _loc3_.WinCount = _loc5_.WinCount;
               _loc3_.TotalCount = _loc5_.TotalCount;
               _loc3_.FightPower = _loc5_.FightPower;
               _loc3_.ID = _loc5_.ID;
               _loc3_.Offer = _loc5_.Offer;
               this._list.vectorListModel.insertElementAt(_loc3_,this.getInsertIndex(_loc5_));
               this._invitePlayerInfos.push(_loc3_);
            }
            _loc4_++;
         }
         if(param1 == Friend)
         {
            _loc6_ = this._invitePlayerInfos;
            _loc6_ = IMController.Instance.sortAcademyPlayer(_loc6_);
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(_loc6_);
         }
         this._list.list.updateListView();
         if(this._list.vectorListModel.elements.length > 0)
         {
            this._list.vScrollProxy = ScrollPanel.ON;
         }
         else
         {
            this._list.vScrollProxy = ScrollPanel.OFF;
         }
      }
      
      private function clearList() : void
      {
         this._list.vectorListModel.clear();
      }
      
      private function setFrame(param1:DisplayObject, param2:int) : void
      {
         DisplayUtils.setFrame(param1,param2);
      }
      
      private function getInsertIndex(param1:BasePlayer) : int
      {
         var _loc5_:PlayerInfo = null;
         var _loc3_:Array = this._list.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         var _loc4_:int = _loc3_.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc3_[_loc4_] as PlayerInfo;
            if(!(param1.IsVIP && !_loc5_.IsVIP))
            {
               if(!param1.IsVIP && _loc5_.IsVIP)
               {
                  return _loc4_ + 1;
               }
            }
            _loc4_--;
         }
         return 0;
      }
      
      public function setListType(param1:int) : void
      {
         if(this._listType == param1)
         {
            return;
         }
         this._listType = param1;
         if(this._listType == Brotherhood)
         {
            this._brotherhoodButton.selected = true;
            this._frientButton.selected = false;
            this._hallButton.selected = false;
            this._recentContactBtn.selected = false;
         }
         else if(this._listType == Friend)
         {
            this._brotherhoodButton.selected = false;
            this._frientButton.selected = true;
            this._hallButton.selected = false;
            this._recentContactBtn.selected = false;
         }
         else if(this._listType == Hall)
         {
            this._brotherhoodButton.selected = false;
            this._frientButton.selected = false;
            this._hallButton.selected = true;
            this._recentContactBtn.selected = false;
            this._refleshCount = 0;
         }
         else if(this._listType == RECENT)
         {
            this._brotherhoodButton.selected = false;
            this._frientButton.selected = false;
            this._hallButton.selected = false;
            this._recentContactBtn.selected = true;
         }
      }
      
      private function getInviteState() : Boolean
      {
         return true;
      }
      
      private function __onResError(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
      }
      
      private function __onResComplete(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         if(param1.module == UIModuleTypes.INVITE && this._visible)
         {
            this._resState = "complete";
            this.configUi();
            this.addEvent();
            if(PlayerManager.Instance.Self.ConsortiaID != 0)
            {
               this.refleshList(Brotherhood);
            }
            else
            {
               this.refleshList(Friend);
            }
         }
      }
      
      private function refleshList(param1:int, param2:int = 0) : void
      {
         if(param1 == Hall)
         {
            GameInSocketOut.sendGetScenePlayer(param2);
         }
         else if(param1 == Friend)
         {
            this.updateList(Friend,PlayerManager.Instance.onlineFriendList);
         }
         else if(param1 == Brotherhood)
         {
            this.updateList(Brotherhood,ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
         }
         else if(param1 == RECENT)
         {
            this.updateList(RECENT,this.rerecentContactList);
         }
      }
      
      private function get rerecentContactList() : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc5_:int = 0;
         var _loc6_:PlayerState = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.recentContacts;
         var _loc2_:Array = IMController.Instance.recentContactsList;
         var _loc4_:Array = [];
         if(_loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_] != 0)
               {
                  _loc3_ = _loc1_[_loc2_[_loc5_]];
                  if(_loc3_ && _loc4_.indexOf(_loc3_) == -1)
                  {
                     if(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID))
                     {
                        _loc6_ = new PlayerState(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                        _loc3_.playerState = _loc6_;
                     }
                     if(_loc3_.playerState.StateID != PlayerState.OFFLINE)
                     {
                        _loc4_.push(_loc3_);
                     }
                  }
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      override public function dispose() : void
      {
         this._visible = false;
         if(this._resState == "loading")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         }
         else
         {
            this.removeEvent();
            if(this._list)
            {
               ObjectUtils.disposeObject(this._list);
               this._list = null;
            }
            if(this._brotherhoodButton)
            {
               ObjectUtils.disposeObject(this._brotherhoodButton);
               this._brotherhoodButton = null;
            }
            if(this._frientButton)
            {
               ObjectUtils.disposeObject(this._frientButton);
               this._frientButton = null;
            }
            if(this._hallButton)
            {
               ObjectUtils.disposeObject(this._hallButton);
               this._hallButton = null;
            }
            if(this._cancelButton)
            {
               ObjectUtils.disposeObject(this._cancelButton);
               this._cancelButton = null;
            }
            if(this._refreshButton)
            {
               ObjectUtils.disposeObject(this._refreshButton);
               this._refreshButton = null;
            }
            if(this._listBack)
            {
               ObjectUtils.disposeObject(this._listBack);
               this._listBack = null;
            }
            if(this._recentContactBtn)
            {
               ObjectUtils.disposeObject(this._recentContactBtn);
               this._recentContactBtn = null;
            }
         }
         super.dispose();
      }
   }
}
