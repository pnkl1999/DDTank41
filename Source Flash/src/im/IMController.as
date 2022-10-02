package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import consortion.ConsortionModelControl;
   import ddt.bagStore.BagStore;
   import ddt.data.CMFriendInfo;
   import ddt.data.InviteInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.LoadCMFriendList;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.GameManager;
   import im.chatFrame.PrivateChatFrame;
   import im.info.CustomInfo;
   import im.info.PresentRecordInfo;
   import im.messagebox.MessageBox;
   import invite.ResponseInviteFrame;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.utils.StringHelper;
   import trainer.data.Step;
   import luckStar.manager.LuckStarManager;
   
   public class IMController extends EventDispatcher
   {
      
      public static const HAS_NEW_MESSAGE:String = "hasNewMessage";
      
      public static const NO_MESSAGE:String = "nomessage";
      
      public static const ALERT_MESSAGE:String = "alertMessage";
      
      public static const MAX_MESSAGE_IN_BOX:int = 10;
      
      private static var _instance:IMController;
       
      
      private var _existChat:Vector.<PresentRecordInfo>;
      
      private var _imview:IMView;
      
      private var _currentPlayer:PlayerInfo;
      
      private var _panels:Dictionary;
      
      private var _name:String;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _isShow:Boolean;
      
      private var _recentContactsList:Array;
      
      private var _isLoadRecentContacts:Boolean;
      
      private var _titleType:int;
      
      private var _loader:DisplayLoader;
      
      private var _icon:Bitmap;
      
      public var isLoadComplete:Boolean = false;
      
      public var privateChatFocus:Boolean;
      
      public var changeID:int;
      
      public var cancelflashState:Boolean;
      
      public var customInfo:CustomInfo;
      
      public var deleteCustomID:int;
      
      private var _privateFrame:PrivateChatFrame;
      
      private var _lastId:int;
      
      private var _changeInfo:PlayerInfo;
      
      private var _messageBox:MessageBox;
      
      private var _timer:Timer;
      
      private var _groupFrame:FriendGroupFrame;
      
      private var _tempLock:Boolean;
      
      private var _id:int;
      
      private var _groupId:int;
      
      private var _groupName:String;
      
      private var _isAddCMFriend:Boolean = true;
      
      private var _deleteRecentContact:int;
      
      private var _likeFriendList:Array;
      
      public function IMController()
      {
         super();
         this._existChat = new Vector.<PresentRecordInfo>();
      }
      
      public static function get Instance() : IMController
      {
         if(_instance == null)
         {
            _instance = new IMController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this.__addNewFriend);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_INVITE,this.__receiveInvite);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_RESPONSE,this.__friendResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONE_ON_ONE_TALK,this.__privateTalkHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS,this.__addCustomHandler);
         if(PathManager.CommunityExist())
         {
            this.loadIcon();
         }
      }
      
      protected function __addCustomHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:String = _loc2_.readUTF();
         switch(_loc3_)
         {
            case 1:
               if(_loc4_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.success",_loc6_));
                  this.customInfo = new CustomInfo();
                  this.customInfo.ID = _loc5_;
                  this.customInfo.Name = _loc6_;
                  dispatchEvent(new IMEvent(IMEvent.ADD_NEW_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.fail",_loc6_));
               }
               break;
            case 2:
               if(_loc4_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.success",_loc6_));
                  PlayerManager.Instance.deleteCustomGroup(_loc5_);
                  _loc7_ = 0;
                  while(_loc7_ < PlayerManager.Instance.customList.length)
                  {
                     if(PlayerManager.Instance.customList[_loc7_].ID == _loc5_)
                     {
                        PlayerManager.Instance.customList.splice(_loc7_,1);
                        break;
                     }
                     _loc7_++;
                  }
                  this.deleteCustomID = _loc5_;
                  dispatchEvent(new IMEvent(IMEvent.DELETE_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.fail",_loc6_));
               }
               break;
            case 3:
               if(_loc4_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.success"));
                  this.customInfo = new CustomInfo();
                  this.customInfo.ID = _loc5_;
                  this.customInfo.Name = _loc6_;
                  _loc8_ = 0;
                  while(_loc8_ < PlayerManager.Instance.customList.length)
                  {
                     if(PlayerManager.Instance.customList[_loc8_].ID == _loc5_)
                     {
                        PlayerManager.Instance.customList[_loc8_].Name = _loc6_;
                        break;
                     }
                     _loc8_++;
                  }
                  dispatchEvent(new IMEvent(IMEvent.UPDATE_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.fail"));
               }
         }
      }
      
      public function checkHasNew(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._existChat.length)
         {
            if(param1 == this._existChat[_loc2_].id && this._existChat[_loc2_].exist == PresentRecordInfo.UNREAD)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function __privateTalkHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:PresentRecordInfo = null;
         var _loc10_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:Date = _loc2_.readDate();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:Boolean = _loc2_.readBoolean();
         var _loc9_:int = 0;
         while(_loc9_ < this._existChat.length)
         {
            if(this._existChat[_loc9_].id == _loc3_)
            {
               _loc8_ = this._existChat[_loc9_];
               _loc8_.addMessage(_loc4_,_loc5_,_loc6_);
               if(_loc4_ != PlayerManager.Instance.Self.NickName)
               {
                  this._existChat.splice(_loc9_,1);
                  this._existChat.unshift(_loc8_);
               }
               break;
            }
            _loc9_++;
         }
         if(_loc8_ == null)
         {
            _loc8_ = new PresentRecordInfo();
            _loc8_.id = _loc3_;
            _loc8_.addMessage(_loc4_,_loc5_,_loc6_);
            this._existChat.unshift(_loc8_);
         }
         this.saveInShared(_loc8_);
         this.getMessage();
         this.saveRecentContactsID(_loc8_.id);
         if(this._privateFrame != null && this._privateFrame.parent && this._privateFrame.playerInfo.ID == _loc3_)
         {
            _loc10_ = 0;
            while(_loc10_ < this._existChat.length)
            {
               if(this._existChat[_loc10_].id == _loc3_)
               {
                  this._privateFrame.addMessage(this._existChat[_loc10_].lastMessage);
                  this._existChat[_loc10_].exist = PresentRecordInfo.SHOW;
                  break;
               }
               _loc10_++;
            }
         }
         else
         {
            this.setExist(_loc3_,PresentRecordInfo.UNREAD);
            this.changeID = _loc3_;
            this.cancelflashState = false;
            dispatchEvent(new Event(HAS_NEW_MESSAGE));
         }
         if(PlayerManager.Instance.Self.playerState.AutoReply != "" && _loc4_ != PlayerManager.Instance.Self.NickName && !_loc7_)
         {
            SocketManager.Instance.out.sendOneOnOneTalk(_loc3_,FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply),true);
         }
      }
      
      private function setExist(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._existChat.length)
         {
            if(this._existChat[_loc3_].id == param1)
            {
               this._existChat[_loc3_].exist = param2;
               break;
            }
            _loc3_++;
         }
      }
      
      public function alertPrivateFrame(param1:int = 0) : void
      {
         var messages:Vector.<String> = null;
         var tempInfo:PresentRecordInfo = null;
         var id:int = param1;
         if(this._privateFrame == null)
         {
            this._privateFrame = ComponentFactory.Instance.creatComponentByStylename("privateChatFrame");
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_OPEN))
         {
            return;
         }
         if(id == 0 && (this._existChat.length == 0 || this._existChat.length == 1 && this._privateFrame.parent))
         {
            return;
         }
         if(id != 0 && this._lastId == id)
         {
            return;
         }
         if(this._privateFrame.parent)
         {
            this.setExist(this._lastId,PresentRecordInfo.HIDE);
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         if(id != 0)
         {
            this._changeInfo = PlayerManager.Instance.findPlayer(id);
            this._lastId = id;
         }
         else
         {
            this._changeInfo = PlayerManager.Instance.findPlayer(this._existChat[0].id);
            this._lastId = this._existChat[0].id;
         }
         try
         {
            this._privateFrame.playerInfo = this._changeInfo;
         }
         catch(e:Error)
         {
            SocketManager.Instance.out.sendItemEquip(_changeInfo.ID,false);
            _changeInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         }
         var i:int = 0;
         while(i < this._existChat.length)
         {
            if(this._existChat[i].id == this._lastId)
            {
               this._existChat[i].exist = PresentRecordInfo.SHOW;
               messages = this._existChat[i].messages;
               this._privateFrame.addAllMessage(messages);
               tempInfo = this._existChat[i];
               this.changeID = this._existChat[i].id;
               dispatchEvent(new Event(ALERT_MESSAGE));
               this._existChat.splice(i,1);
               this._existChat.push(tempInfo);
               break;
            }
            i++;
         }
         if(!this.hasUnreadMessage())
         {
            dispatchEvent(new Event(NO_MESSAGE));
         }
         this.getMessage();
         this.saveRecentContactsID(id);
         LayerManager.Instance.addToLayer(this._privateFrame,LayerManager.GAME_TOP_LAYER,true);
      }
      
      public function cancelFlash() : void
      {
         this.cancelflashState = true;
         dispatchEvent(new Event(NO_MESSAGE));
      }
      
      public function hasUnreadMessage() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._existChat.length)
         {
            if(this._existChat[_loc1_].exist == PresentRecordInfo.UNREAD)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function __IDChange(param1:PlayerPropertyEvent) : void
      {
         this._changeInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__IDChange);
         this._privateFrame.playerInfo = this._changeInfo;
      }
      
      public function hidePrivateFrame(param1:int) : void
      {
         StageReferance.stage.focus = StageReferance.stage;
         var _loc2_:int = 0;
         while(_loc2_ < this._existChat.length)
         {
            if(param1 == this._existChat[_loc2_].id)
            {
               break;
            }
            if(_loc2_ == this._existChat.length - 1)
            {
               this.createPresentRecordInfo(param1);
            }
            _loc2_++;
         }
         if(this._existChat.length == 0)
         {
            this.createPresentRecordInfo(param1);
         }
         this._lastId = 0;
         if(this._privateFrame.parent)
         {
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         this.setExist(param1,PresentRecordInfo.HIDE);
      }
      
      private function createPresentRecordInfo(param1:int) : void
      {
         var _loc2_:PresentRecordInfo = null;
         _loc2_ = new PresentRecordInfo();
         _loc2_.id = param1;
         _loc2_.exist = PresentRecordInfo.HIDE;
         this._existChat.push(_loc2_);
      }
      
      public function disposePrivateFrame(param1:int) : void
      {
         StageReferance.stage.focus = StageReferance.stage;
         this._lastId = 0;
         if(this._privateFrame.parent)
         {
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         this.removePrivateMessage(param1);
      }
      
      public function removePrivateMessage(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._existChat.length)
         {
            if(this._existChat[_loc2_].id == param1)
            {
               this.changeID = param1;
               dispatchEvent(new Event(ALERT_MESSAGE));
               this._existChat.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(!this.hasUnreadMessage())
         {
            dispatchEvent(new Event(NO_MESSAGE));
         }
      }
      
      private function saveInShared(param1:PresentRecordInfo) : void
      {
         var _loc2_:Vector.<Object> = null;
         if(SharedManager.Instance.privateChatRecord[param1.id] == null)
         {
            SharedManager.Instance.privateChatRecord[param1.id] = param1.recordMessage;
         }
         else
         {
            _loc2_ = SharedManager.Instance.privateChatRecord[param1.id];
            if(_loc2_ != param1.recordMessage)
            {
               _loc2_.push(param1.lastRecordMessage);
            }
            SharedManager.Instance.privateChatRecord[param1.id] = _loc2_;
         }
         SharedManager.Instance.save();
      }
      
      public function showMessageBox(param1:DisplayObject) : void
      {
         var _loc2_:Point = null;
         if(this._messageBox == null)
         {
            this._messageBox = new MessageBox();
            this._timer = new Timer(200);
            this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
         if(this.getMessage().length > 0)
         {
            LayerManager.Instance.addToLayer(this._messageBox,LayerManager.GAME_TOP_LAYER);
            _loc2_ = param1.localToGlobal(new Point(0,0));
            this._messageBox.y = _loc2_.y - this._messageBox.height;
            this._messageBox.x = _loc2_.x - this._messageBox.width / 2 + param1.width / 2;
            if(this._messageBox.x + this._messageBox.width > StageReferance.stageWidth)
            {
               this._messageBox.x = StageReferance.stageWidth - this._messageBox.width - 10;
            }
         }
         this._timer.stop();
      }
      
      public function getMessage() : Vector.<PresentRecordInfo>
      {
         var _loc2_:int = 0;
         var _loc1_:Vector.<PresentRecordInfo> = new Vector.<PresentRecordInfo>();
         if(this._messageBox)
         {
            _loc2_ = 0;
            while(_loc2_ < this._existChat.length)
            {
               if(this._existChat[_loc2_].exist != PresentRecordInfo.SHOW)
               {
                  _loc1_.push(this._existChat[_loc2_]);
               }
               if(_loc1_.length == MAX_MESSAGE_IN_BOX)
               {
                  break;
               }
               _loc2_++;
            }
            this._messageBox.message = _loc1_;
         }
         return _loc1_;
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         if(!this._messageBox.overState)
         {
            this._messageBox.parent.removeChild(this._messageBox);
            this._timer.stop();
         }
      }
      
      public function hideMessageBox() : void
      {
         if(this._messageBox && this._messageBox.parent && this._timer)
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function setupRecentContactsList() : void
      {
         if(!this._recentContactsList)
         {
            this._recentContactsList = [];
         }
         this._recentContactsList = SharedManager.Instance.recentContactsID[PlayerManager.Instance.Self.ID];
         this._isLoadRecentContacts = true;
      }
      
      public function switchVisible() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.IM);
      }
      
      public function get icon() : Bitmap
      {
         return this._loader.content as Bitmap;
      }
      
      private function loadIcon() : void
      {
         this._loader = LoaderManager.Instance.creatAndStartLoad(PathManager.CommunityIcon(),BaseLoader.BITMAP_LOADER) as BitmapLoader;
      }
      
      private function __friendResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:String = null;
         var _loc2_:int = param1.pkg.clientId;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:String = param1.pkg.readUTF();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         if(_loc5_)
         {
            _loc6_ = LanguageMgr.GetTranslation("tank.view.im.IMController.sameCityfriend");
            _loc6_ = _loc6_.replace(/r/g,"[" + _loc4_ + "]");
         }
         else
         {
            _loc6_ = "[" + _loc4_ + "]" + LanguageMgr.GetTranslation("tank.view.im.IMController.friend");
         }
         ChatManager.Instance.sysChatYellow(_loc6_);
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      private function __addNewFriend(param1:IMEvent) : void
      {
         this._currentPlayer = param1.data as PlayerInfo;
      }
      
      private function privateChat() : void
      {
         if(this._currentPlayer != null)
         {
            ChatManager.Instance.privateChatTo(this._currentPlayer.NickName,this._currentPlayer.ID);
         }
      }
      
      public function set isShow(param1:Boolean) : void
      {
         this._isShow = param1;
      }
      
      private function hide() : void
      {
         this._imview.dispose();
         this._imview = null;
      }
      
      private function show() : void
      {
         this._imview = null;
         if(this._imview == null)
         {
            this._imview = ComponentFactory.Instance.creat("IMFrame");
            this._imview.addEventListener(FrameEvent.RESPONSE,this.__imviewEvent);
         }
         LayerManager.Instance.addToLayer(this._imview,LayerManager.GAME_DYNAMIC_LAYER,false);
      }
      
      private function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         if(param1.module == UIModuleTypes.IM)
         {
            if(this._isLoadRecentContacts)
            {
               PlayerManager.Instance.addEventListener(PlayerManager.RECENT_CONTAST_COMPLETE,this.__recentContactsComplete);
               this.loadRecentContacts();
            }
            else
            {
               if(!this.isLoadComplete)
               {
                  return;
               }
               if(this._isShow)
               {
                  this.hide();
               }
               else
               {
                  this.show();
                  this._isShow = true;
                  this._isLoadRecentContacts = false;
               }
            }
         }
      }
      
      private function __recentContactsComplete(param1:Event) : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.RECENT_CONTAST_COMPLETE,this.__recentContactsComplete);
         if(!this.isLoadComplete)
         {
            return;
         }
         if(this._isShow)
         {
            this.hide();
         }
         else
         {
            this.show();
            this._isShow = true;
            this._isLoadRecentContacts = false;
         }
      }
      
      private function __receiveInvite(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:InviteInfo = null;
         if(this.getInviteState() && InviteManager.Instance.enabled)
         {
            if(PlayerManager.Instance.Self.Grade < 4)
            {
               return;
            }
            if(!SharedManager.Instance.showInvateWindow)
            {
               return;
            }
            _loc2_ = param1.pkg;
            _loc3_ = new InviteInfo();
            _loc3_.playerid = _loc2_.readInt();
            _loc3_.roomid = _loc2_.readInt();
            _loc3_.mapid = _loc2_.readInt();
            _loc3_.secondType = _loc2_.readByte();
            _loc3_.gameMode = _loc2_.readByte();
            _loc3_.hardLevel = _loc2_.readByte();
            _loc3_.levelLimits = _loc2_.readByte();
            _loc3_.nickname = _loc2_.readUTF();
            _loc3_.IsVip = _loc2_.readBoolean();
            _loc3_.VIPLevel = _loc2_.readInt();
            _loc3_.RN = _loc2_.readUTF();
            _loc3_.password = _loc2_.readUTF();
            _loc3_.barrierNum = _loc2_.readInt();
            _loc3_.isOpenBoss = _loc2_.readBoolean();
            if(_loc3_.gameMode > 2 && PlayerManager.Instance.Self.Grade < GameManager.MinLevelDuplicate)
            {
               return;
            }
			if(LuckStarManager.Instance.openState)
			{
				return;
			}
            this.startReceiveInvite(_loc3_);
         }
      }
      
      private function startReceiveInvite(param1:InviteInfo) : void
      {
         SoundManager.instance.play("018");
         var _loc2_:InteractiveObject = StageReferance.stage.focus;
         var _loc3_:ResponseInviteFrame = ResponseInviteFrame.newInvite(param1);
         _loc3_.show();
         if(_loc2_ is TextField)
         {
            if(TextField(_loc2_).type == TextFieldType.INPUT)
            {
               StageReferance.stage.focus = _loc2_;
            }
         }
      }
      
      private function getInviteState() : Boolean
      {
         if(!SharedManager.Instance.showInvateWindow)
         {
            return false;
         }
         if(BagStore.instance.storeOpenAble)
         {
            return false;
         }
         switch(StateManager.currentStateType)
         {
            case StateType.MAIN:
            case StateType.ROOM_LIST:
            case StateType.DUNGEON_LIST:
               return true;
            default:
               return false;
         }
      }
      
      public function set titleType(param1:int) : void
      {
         this._titleType = param1;
      }
      
      public function get titleType() : int
      {
         return this._titleType;
      }
      
      public function addFriend(param1:String) : void
      {
         if(this.isMaxFriend())
         {
            return;
         }
         this._name = param1;
         if(!this.checkFriendExist(this._name))
         {
            this.alertGroupFrame(this._name);
         }
      }
      
      public function isMaxFriend() : Boolean
      {
         var _loc1_:int = 0;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc1_ = PlayerManager.Instance.Self.VIPLevel + 2;
         }
         if(PlayerManager.Instance.friendList.length >= 200 + _loc1_ * 50)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend",200 + _loc1_ * 50),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__close);
            return true;
         }
         return false;
      }
      
      private function alertGroupFrame(param1:String) : void
      {
         if(this._groupFrame == null)
         {
            this._groupFrame = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame");
            this._groupFrame.nickName = param1;
         }
         LayerManager.Instance.addToLayer(this._groupFrame,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._tempLock = ChatManager.Instance.lock;
         StageReferance.stage.focus = this._groupFrame;
      }
      
      public function clearGroupFrame() : void
      {
         this._groupFrame = null;
      }
      
      private function __close(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._baseAlerFrame)
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__close);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      public function addBlackList(param1:String) : void
      {
         if(PlayerManager.Instance.blackList.length >= 100)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addBlackList"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__closeII);
            return;
         }
         this._name = param1;
         if(!this.checkBlackListExit(param1))
         {
            if(this._baseAlerFrame)
            {
               this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
               this._baseAlerFrame.dispose();
               this._baseAlerFrame = null;
            }
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.issure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
            this._tempLock = ChatManager.Instance.lock;
         }
      }
      
      private function __closeII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._baseAlerFrame)
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__closeII);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = this._tempLock;
         }
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               this.__addBlack();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      private function __frameEventII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = this._tempLock;
         }
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               this.alertGroupFrame(this._name);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      private function __addBlack() : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendAddFriend(this._name,1);
         this._name = "";
      }
      
      private function __addFriend() : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendAddFriend(this._name,0);
         this._name = "";
      }
      
      public function deleteFriend(param1:int, param2:Boolean = false) : void
      {
         this._id = param1;
         this.disposeAlert();
         if(!param2)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.deleteFriend"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
         }
         else
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMBlackItem.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
         }
      }
      
      public function deleteGroup(param1:int, param2:String) : void
      {
         this._groupId = param1;
         this._groupName = param2;
         this.disposeAlert();
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMGourp.sure",param2),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__deleteGroupEvent);
      }
      
      private function __deleteGroupEvent(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.disposeAlert();
               SocketManager.Instance.out.sendCustomFriends(2,this._groupId,this._groupName);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.disposeAlert();
         }
      }
      
      private function __frameEventIII(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.disposeAlert();
               SocketManager.Instance.out.sendDelFriend(this._id);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
               this._id = -1;
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.disposeAlert();
         }
      }
      
      private function disposeAlert() : void
      {
         if(this._baseAlerFrame)
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      private function checkBlackListExit(param1:String) : Boolean
      {
         var _loc3_:PlayerInfo = null;
         if(param1 == PlayerManager.Instance.Self.NickName)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannot"));
            return true;
         }
         var _loc2_:DictionaryData = PlayerManager.Instance.blackList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.NickName == param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.thisplayer"));
               return true;
            }
         }
         return false;
      }
      
      private function checkFriendExist(param1:String) : Boolean
      {
         var _loc3_:PlayerInfo = null;
         var _loc4_:DictionaryData = null;
         var _loc5_:PlayerInfo = null;
         if(!param1)
         {
            return true;
         }
         if(param1.toLowerCase() == PlayerManager.Instance.Self.NickName.toLowerCase())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannotAddSelfFriend"));
            return true;
         }
         var _loc2_:DictionaryData = PlayerManager.Instance.friendList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.NickName == param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.chongfu"));
               return true;
            }
         }
         _loc4_ = PlayerManager.Instance.blackList;
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.NickName == param1)
            {
               this._name = param1;
               this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.thisone"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventII);
               return true;
            }
         }
         return false;
      }
      
      public function isFriend(param1:String) : Boolean
      {
         var _loc3_:PlayerInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.friendList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.NickName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBlackList(param1:String) : Boolean
      {
         var _loc3_:PlayerInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.blackList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.NickName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __imviewEvent(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.hide();
         }
      }
      
      public function createConsortiaLoader() : void
      {
         var _loc1_:URLVariables = null;
         var _loc2_:BaseLoader = null;
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityFriendList()))
         {
            _loc1_ = RequestVairableCreater.creatWidthKey(true);
            _loc1_["uid"] = PlayerManager.Instance.Account.Account;
            _loc2_ = LoaderManager.Instance.creatLoader(PathManager.CommunityFriendList(),BaseLoader.REQUEST_LOADER,_loc1_);
            _loc2_.analyzer = new LoadCMFriendList(this.setupCMFriendList);
            _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            LoaderManager.Instance.startLoad(_loc2_);
         }
      }
      
      private function setupCMFriendList(param1:LoadCMFriendList) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         if(PlayerManager.Instance.Self.IsFirst == 1 && this._isAddCMFriend)
         {
            this.cmFriendAddToFriend();
         }
      }
      
      private function cmFriendAddToFriend() : void
      {
         var _loc3_:CMFriendInfo = null;
         this._isAddCMFriend = false;
         var _loc1_:DictionaryData = PlayerManager.Instance.CMFriendList;
         var _loc2_:DictionaryData = PlayerManager.Instance.friendList;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.IsExist && !_loc2_[_loc3_.UserId])
            {
               SocketManager.Instance.out.sendAddFriend(_loc3_.NickName,0,true);
               _loc1_.remove(_loc3_.UserName);
            }
         }
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      public function loadRecentContacts() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["recentContacts"] = this.getFullRecentContactsID();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("IMRecentContactsList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc2_.analyzer = new RecentContactsAnalyze(PlayerManager.Instance.setupRecentContacts);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
         this._isLoadRecentContacts = false;
      }
      
      public function get recentContactsList() : Array
      {
         return this._recentContactsList;
      }
      
      public function getFullRecentContactsID() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         for each(_loc2_ in this._recentContactsList)
         {
            if(_loc2_ != 0)
            {
               _loc1_ += String(_loc2_) + ",";
            }
         }
         _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
         if(_loc1_ == "")
         {
            _loc1_ = "0";
         }
         return _loc1_;
      }
      
      public function saveRecentContactsID(param1:int = 0) : void
      {
         if(!this._recentContactsList)
         {
            this._recentContactsList = [];
         }
         if(param1 == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._recentContactsList.length < 20)
         {
            if(this.testIdentical(param1) != -1)
            {
               this._recentContactsList.splice(this.testIdentical(param1),1);
            }
            this._recentContactsList.unshift(param1);
         }
         else
         {
            if(this.testIdentical(param1) != -1)
            {
               this._recentContactsList.splice(this.testIdentical(param1),1);
            }
            else
            {
               this._recentContactsList.splice(-1,1);
            }
            this._recentContactsList.unshift(param1);
         }
         SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
         SharedManager.Instance.save();
         this._isLoadRecentContacts = true;
      }
      
      public function deleteRecentContacts(param1:int = 0) : void
      {
         if(!this._recentContactsList)
         {
            return;
         }
         this._deleteRecentContact = param1;
         if(this._baseAlerFrame)
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("im.IMController.deleteRecentContactsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
      }
      
      private function __deleteRecentContact(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               if(this.testIdentical(this._deleteRecentContact) != -1)
               {
                  this._recentContactsList.splice(this.testIdentical(this._deleteRecentContact),1);
                  if(this._deleteRecentContact != 0)
                  {
                     PlayerManager.Instance.deleteRecentContact(this._deleteRecentContact);
                  }
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
               SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
               SharedManager.Instance.save();
               this._isLoadRecentContacts = true;
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               if(this._baseAlerFrame)
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      public function testIdentical(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this._recentContactsList)
         {
            _loc2_ = 0;
            while(_loc2_ < this._recentContactsList.length)
            {
               if(this._recentContactsList[_loc2_] == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
         }
         return -1;
      }
      
      public function getRecentContactsStranger() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in PlayerManager.Instance.recentContacts)
         {
            if(this.testAlikeName(_loc2_.NickName))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function testAlikeName(param1:String) : Boolean
      {
         var _loc2_:Array = [];
         _loc2_ = PlayerManager.Instance.friendList.list;
         _loc2_ = _loc2_.concat(PlayerManager.Instance.blackList.list);
         _loc2_ = _loc2_.concat(ConsortionModelControl.Instance.model.memberList.list);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] is FriendListPlayer && (_loc2_[_loc3_] as FriendListPlayer).NickName == param1)
            {
               return false;
            }
            if(_loc2_[_loc3_] is ConsortiaPlayerInfo && (_loc2_[_loc3_] as ConsortiaPlayerInfo).NickName == param1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function sortAcademyPlayer(param1:Array) : Array
      {
         var _loc5_:PlayerInfo = null;
         var _loc6_:PlayerInfo = null;
         var _loc2_:Array = [];
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         if(_loc3_.getMasterOrApprentices().length <= 0)
         {
            return param1;
         }
         var _loc4_:DictionaryData = _loc3_.getMasterOrApprentices();
         if(_loc3_.getMasterOrApprentices().length > 0)
         {
            for each(_loc5_ in param1)
            {
               if(_loc4_[_loc5_.ID] && _loc5_.ID != _loc3_.ID)
               {
                  if(_loc5_.ID == _loc3_.masterID)
                  {
                     _loc2_.unshift(_loc5_);
                  }
                  else
                  {
                     _loc2_.push(_loc5_);
                  }
               }
            }
            for each(_loc6_ in _loc2_)
            {
               param1.splice(param1.indexOf(_loc6_),1);
            }
         }
         return _loc2_.concat(param1);
      }
      
      public function set likeFriendList(param1:Array) : void
      {
         this._likeFriendList = param1;
      }
      
      public function get likeFriendList() : Array
      {
         return this._likeFriendList;
      }
   }
}
