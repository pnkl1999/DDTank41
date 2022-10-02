package church.view.weddingRoom
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomController;
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.view.churchFire.ChurchFireView;
   import church.view.invite.ChurchInviteController;
   import church.view.weddingRoom.frame.WeddingRoomConfigView;
   import church.view.weddingRoom.frame.WeddingRoomContinuationView;
   import church.view.weddingRoom.frame.WeddingRoomGiftFrameForGuest;
   import church.view.weddingRoom.frame.WeddingRoomGuestListView;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.PathManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   
   public class WeddingRoomToolView extends Sprite implements Disposeable
   {
       
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _churchRoomControler:ChurchRoomController;
      
      private var _toolBg:Bitmap;
      
      private var _toolSwitchBg:BaseButton;
      
      private var _toolSwitch:Bitmap;
      
      private var _switchEnable:Boolean = true;
      
      private var _toolBtnRoomAdmin:BaseButton;
      
      private var _toolBtnInviteGuest:BaseButton;
      
      private var _toolBtnGift:BaseButton;
      
      private var _toolBtnFire:BaseButton;
      
      private var _toolBtnFill:BaseButton;
      
      private var _toolBtnExit:BaseButton;
      
      private var _toolBtnBack:BaseButton;
      
      private var _alertExit:BaseAlerFrame;
      
      private var _alertStartWedding:BaseAlerFrame;
      
      private var _fireLoader:BaseLoader;
      
      private var _churchFireView:ChurchFireView;
      
      private var _toolAdminBg:Bitmap;
      
      private var _startWeddingTip:Bitmap;
      
      private var _startWeddingTip2:Bitmap;
      
      private var _toolBtnStartWedding:BaseButton;
      
      private var _toolBtnAdminInviteGuest:BaseButton;
      
      private var _toolBtnGuestList:BaseButton;
      
      private var _toolBtnContinuation:BaseButton;
      
      private var _toolBtnModify:BaseButton;
      
      private var _adminToolVisible:Boolean = true;
      
      private var _sendGifeToolVisible:Boolean = false;
      
      private var _weddingRoomGiftFrameViewForGuest:WeddingRoomGiftFrameForGuest;
      
      private var _weddingRoomConfigView:WeddingRoomConfigView;
      
      private var _weddingRoomContinuationView:WeddingRoomContinuationView;
      
      private var _weddingRoomGuestListView:WeddingRoomGuestListView;
      
      private var _churchInviteController:ChurchInviteController;
      
      private var _startTipTween:TweenLite;
      
      private var _switchTween:TweenLite;
      
      private var _sendGiftToolBg:Bitmap;
      
      private var _toolSendGiftBtn:BaseButton;
      
      public var _toolSendCashBtn:BaseButton;
      
      public var _toolSendCashBtnForGuest:BaseButton;
      
      private var _isplayerStartTipMovieState:int = 0;
      
      public function WeddingRoomToolView()
      {
         super();
         this.initialize();
      }
      
      public function get controller() : ChurchRoomController
      {
         return this._controller;
      }
      
      public function set controller(param1:ChurchRoomController) : void
      {
         this._controller = param1;
      }
      
      public function set churchRoomModel(param1:ChurchRoomModel) : void
      {
         this._model = param1;
      }
      
      public function set churchRoomControler(param1:ChurchRoomController) : void
      {
         this._churchRoomControler = param1;
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this.loadFire();
         this._toolBg = ComponentFactory.Instance.creat("asset.church.room.toolBgAsset");
         addChild(this._toolBg);
         this._toolSwitchBg = ComponentFactory.Instance.creat("church.room.toolSwitchBgAsset");
         addChild(this._toolSwitchBg);
         this._toolSwitch = ComponentFactory.Instance.creat("asset.church.room.toolSwitchAsset");
         addChild(this._toolSwitch);
         this._toolBtnGift = ComponentFactory.Instance.creat("church.room.toolBtnGiftBtnAsset");
         addChild(this._toolBtnGift);
         this._toolBtnFire = ComponentFactory.Instance.creat("church.room.toolBtnFireBtnAsset");
         addChild(this._toolBtnFire);
         this._toolBtnFill = ComponentFactory.Instance.creat("church.room.toolBtnFillBtnAsset");
         addChild(this._toolBtnFill);
         this._toolBtnExit = ComponentFactory.Instance.creat("church.room.toolBtnExitBtnAsset");
         addChild(this._toolBtnExit);
         this._toolBtnBack = ComponentFactory.Instance.creat("church.room.toolBtnBackBtnAsset");
         this._toolBtnBack.visible = false;
         addChild(this._toolBtnBack);
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            this.showAdminToolView();
         }
         else
         {
            this._toolBtnInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnInviteGuestBtnAsset");
            addChild(this._toolBtnInviteGuest);
            if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               if(this._toolBtnInviteGuest)
               {
                  this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
               }
            }
         }
         this.showGiftToolView();
         this.GiftToolVisible = this._sendGifeToolVisible;
      }
      
      private function setEvent() : void
      {
         this._toolSwitchBg.addEventListener(MouseEvent.CLICK,this.toolSwitch);
         this._toolBtnGift.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFire.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFill.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnExit.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnBack.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendGiftBtn.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtn.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtnForGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            this._toolBtnGuestList.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnContinuation.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnModify.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnRoomAdmin.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnAdminInviteGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnStartWedding.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         else
         {
            this._toolBtnInviteGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__weddingStatusChange);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
      }
      
      public function resetView() : void
      {
         if(ChurchManager.instance.currentScene)
         {
            if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               this._toolBtnStartWedding.enable = false;
               this._startWeddingTip.visible = false;
               this._startWeddingTip2.visible = false;
               if(this._startWeddingTip)
               {
                  this._startWeddingTip.visible = false;
               }
               if(this._startWeddingTip2)
               {
                  this._startWeddingTip2.visible = false;
               }
            }
            this._toolBtnBack.visible = true;
            this._toolBtnExit.visible = false;
         }
         else
         {
            if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               this._toolBtnStartWedding.enable = true;
               this._startWeddingTip.visible = true;
               this._startWeddingTip2.visible = true;
               if(this._adminToolVisible)
               {
                  if(this._startWeddingTip)
                  {
                     this._startWeddingTip.visible = true;
                  }
                  if(this._startWeddingTip2)
                  {
                     this._startWeddingTip2.visible = true;
                  }
               }
               else
               {
                  if(this._startWeddingTip)
                  {
                     this._startWeddingTip.visible = false;
                  }
                  if(this._startWeddingTip2)
                  {
                     this._startWeddingTip2.visible = false;
                  }
               }
            }
            this._toolBtnBack.visible = false;
            this._toolBtnExit.visible = true;
         }
      }
      
      private function __weddingStatusChange(param1:WeddingRoomEvent) : void
      {
         if(ChurchManager.instance.currentScene)
         {
            return;
         }
         if(this._startWeddingTip)
         {
            if(this._startWeddingTip.parent)
            {
               this._startWeddingTip.parent.removeChild(this._startWeddingTip);
            }
         }
         if(this._startWeddingTip2)
         {
            if(this._startWeddingTip2.parent)
            {
               this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
            }
         }
         this._startTipTween = null;
         var _loc2_:String = ChurchManager.instance.currentRoom.status;
         if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            if(this._toolBtnInviteGuest)
            {
               this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
            }
         }
         if(_loc2_ == ChurchRoomInfo.WEDDING_ING)
         {
            if(this._toolBtnStartWedding)
            {
               this._toolBtnStartWedding.enable = false;
            }
            if(this._toolBtnAdminInviteGuest)
            {
               this._toolBtnAdminInviteGuest.enable = false;
            }
            if(this._toolBtnInviteGuest)
            {
               this._toolBtnInviteGuest.enable = false;
            }
            if(this._toolBtnFire)
            {
               this._toolBtnFire.enable = false;
            }
            if(this._churchFireView && this._churchFireView.parent)
            {
               this._churchFireView.parent.removeChild(this._churchFireView);
            }
         }
         else
         {
            if(this._toolBtnStartWedding)
            {
               this._toolBtnStartWedding.enable = true;
            }
            if(this._toolBtnAdminInviteGuest)
            {
               this._toolBtnAdminInviteGuest.enable = true;
            }
            if(this._toolBtnInviteGuest)
            {
               this._toolBtnInviteGuest.enable = true;
            }
            if(this._toolBtnFire)
            {
               this._toolBtnFire.enable = true;
            }
            if(this._toolBtnExit)
            {
               this._toolBtnExit.enable = true;
            }
            if(this._toolBtnBack)
            {
               this._toolBtnBack.enable = true;
            }
         }
      }
      
      private function __updateBtn(param1:WeddingRoomEvent) : void
      {
         if(this._churchInviteController)
         {
            this._churchInviteController.hide();
         }
         if(ChurchManager.instance.currentScene)
         {
            this._toolBtnBack.visible = false;
            this._toolBtnExit.visible = true;
         }
         else
         {
            this._toolBtnBack.visible = true;
            this._toolBtnExit.visible = false;
         }
      }
      
      private function showAdminToolView() : void
      {
         this._toolAdminBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
         addChild(this._toolAdminBg);
         this._toolBtnStartWedding = ComponentFactory.Instance.creat("church.room.toolBtnStartWeddingBtnAsset");
         addChild(this._toolBtnStartWedding);
         this._toolBtnRoomAdmin = ComponentFactory.Instance.creat("church.room.toolBtnRoomAdminBtnAsset");
         addChild(this._toolBtnRoomAdmin);
         this._toolBtnGuestList = ComponentFactory.Instance.creat("church.room.toolBtnGuestListBtnAsset");
         addChild(this._toolBtnGuestList);
         this._toolBtnContinuation = ComponentFactory.Instance.creat("church.room.toolBtnContinuationBtnAsset");
         addChild(this._toolBtnContinuation);
         this._toolBtnAdminInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnAdminInviteGuestBtnAsset");
         addChild(this._toolBtnAdminInviteGuest);
         if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            if(this._toolBtnInviteGuest)
            {
               this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
            }
         }
         this._toolBtnModify = ComponentFactory.Instance.creat("church.room.toolBtnModifyBtnAsset");
         addChild(this._toolBtnModify);
         if(PlayerManager.Instance.Self.ID != ChurchManager.instance.currentRoom.createID)
         {
            this._toolBtnModify.enable = false;
         }
         if(!this._startWeddingTip)
         {
            this._startWeddingTip = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTipAsset");
         }
         addChild(this._startWeddingTip);
         if(!this._startWeddingTip2)
         {
            this._startWeddingTip2 = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTip2Asset");
         }
         addChild(this._startWeddingTip2);
         this.playerStartTipMovie();
      }
      
      private function set adminToolVisible(param1:Boolean) : void
      {
         if(this._toolAdminBg)
         {
            this._toolAdminBg.visible = param1;
         }
         if(this._toolBtnStartWedding)
         {
            this._toolBtnStartWedding.visible = param1;
         }
         if(this._toolBtnGuestList)
         {
            this._toolBtnGuestList.visible = param1;
         }
         if(this._toolBtnContinuation)
         {
            this._toolBtnContinuation.visible = param1;
         }
         if(this._toolBtnAdminInviteGuest)
         {
            this._toolBtnAdminInviteGuest.visible = param1;
         }
         if(this._toolBtnModify)
         {
            this._toolBtnModify.visible = param1;
         }
         if(this._startWeddingTip)
         {
            this._startWeddingTip.visible = param1;
         }
         if(this._startWeddingTip2)
         {
            this._startWeddingTip2.visible = param1;
         }
         if(ChurchManager.instance.currentScene == true)
         {
            if(this._startWeddingTip)
            {
               this._startWeddingTip.visible = false;
            }
            if(this._startWeddingTip2)
            {
               this._startWeddingTip2.visible = false;
            }
         }
      }
      
      private function showGiftToolView() : void
      {
         this._sendGiftToolBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
         this._sendGiftToolBg.width = 120;
         this._sendGiftToolBg.x = 60;
         addChild(this._sendGiftToolBg);
         this._toolSendGiftBtn = ComponentFactory.Instance.creat("church.room.toolBtnSendGiftAsset");
         addChild(this._toolSendGiftBtn);
         this._toolSendCashBtn = ComponentFactory.Instance.creat("asset.church.room.adminToGuest");
         this._toolSendCashBtn.enable = false;
         addChild(this._toolSendCashBtn);
         this._toolSendCashBtn.visible = false;
         this._toolSendCashBtnForGuest = ComponentFactory.Instance.creat("church.room.toolBtnSendCashAsset");
         this.addChild(this._toolSendCashBtnForGuest);
         this._toolSendCashBtnForGuest.visible = false;
      }
      
      private function set GiftToolVisible(param1:Boolean) : void
      {
         if(this._toolSendGiftBtn)
         {
            this._toolSendGiftBtn.visible = param1;
         }
         if(this._sendGiftToolBg)
         {
            this._sendGiftToolBg.visible = param1;
         }
         if(!param1)
         {
            this._toolSendCashBtnForGuest.visible = false;
            this._toolSendCashBtn.visible = false;
         }
         else if(this.isGuest())
         {
            this._toolSendCashBtnForGuest.visible = true;
            this._toolSendCashBtn.visible = false;
         }
         else
         {
            this._toolSendCashBtnForGuest.visible = false;
            this._toolSendCashBtn.visible = true;
         }
      }
      
      private function playerStartTipMovie() : void
      {
         if(this._isplayerStartTipMovieState == 1)
         {
            this._isplayerStartTipMovieState = 0;
            this._startTipTween = TweenLite.to(this._startWeddingTip2,0.3,{
               "y":this._startWeddingTip2.y - 10,
               "ease":Sine.easeInOut,
               "onComplete":this.playerStartTipMovie
            });
         }
         else
         {
            this._isplayerStartTipMovieState = 1;
            this._startTipTween = TweenLite.to(this._startWeddingTip2,0.3,{
               "y":this._startWeddingTip2.y + 10,
               "ease":Sine.easeInOut,
               "onComplete":this.playerStartTipMovie
            });
         }
      }
      
      private function isGuest() : Boolean
      {
         var _loc1_:Array = [ChurchManager.instance.currentRoom.groomName,ChurchManager.instance.currentRoom.brideName];
         var _loc2_:int = _loc1_.indexOf(PlayerManager.Instance.Self.NickName);
         return _loc2_ >= 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      private function onToolMenuClick(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this._toolBtnGift:
               SoundManager.instance.play("008");
               this.GiftToolVisible = !this._sendGifeToolVisible;
               this._sendGifeToolVisible = !this._sendGifeToolVisible;
               this._adminToolVisible = this.adminToolVisible = false;
               break;
            case this._toolBtnFire:
               if(this._toolBtnFire.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               this.openFireList();
               break;
            case this._toolBtnFill:
               LeavePageManager.leaveToFillPath();
               break;
            case this._toolBtnBack:
               if(this._toolBtnBack.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               this.exitRoom();
               break;
            case this._toolBtnExit:
               if(this._toolBtnExit.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               if(!this._alertExit)
               {
                  this._alertExit = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.leaveRoom"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._alertExit.addEventListener(FrameEvent.RESPONSE,this.exitResponse);
               }
               break;
            case this._toolBtnRoomAdmin:
               SoundManager.instance.play("008");
               this._sendGifeToolVisible = this.GiftToolVisible = false;
               this.adminToolVisible = !this._adminToolVisible;
               this._adminToolVisible = !this._adminToolVisible;
               break;
            case this._toolBtnModify:
               SoundManager.instance.play("008");
               this.openRoomConfig();
               break;
            case this._toolBtnContinuation:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  SoundManager.instance.play("008");
                  return;
               }
               SoundManager.instance.play("008");
               this.openRoomContinuation();
               break;
            case this._toolBtnGuestList:
               SoundManager.instance.play("008");
               this.openGuestList();
               break;
            case this._toolBtnInviteGuest:
            case this._toolBtnAdminInviteGuest:
               SoundManager.instance.play("008");
               this.openInviteGuest();
               break;
            case this._toolBtnStartWedding:
               SoundManager.instance.play("008");
               this.openStartWedding();
               break;
            case this._toolSendGiftBtn:
               SoundManager.instance.play("008");
               GiftController.Instance.inChurch = true;
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
               break;
            case this._toolSendCashBtn:
               SoundManager.instance.play("008");
               SocketManager.Instance.out.requestRefund();
               this.giftViewForGuest();
               break;
            case this._toolSendCashBtnForGuest:
               SoundManager.instance.play("008");
               this.giftView();
         }
      }
      
      public function giftViewForGuest() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
      }
      
      public function giftView() : void
      {
         var _loc1_:ChatData = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < 100)
         {
            _loc1_ = new ChatData();
            _loc1_.channel = ChatInputView.SYS_NOTICE;
            _loc1_.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.Money");
            ChatManager.Instance.chat(_loc1_);
            return;
         }
         if(this._weddingRoomGiftFrameViewForGuest)
         {
            if(this._weddingRoomGiftFrameViewForGuest.parent)
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameViewForGuest.dispose();
            this._weddingRoomGiftFrameViewForGuest = null;
         }
         else
         {
            this._weddingRoomGiftFrameViewForGuest = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameViewForGuest");
            this._weddingRoomGiftFrameViewForGuest.addEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameViewForGuest.controller = this._controller;
            this._weddingRoomGiftFrameViewForGuest.show();
         }
      }
      
      private function exitResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.exitRoom();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._alertExit)
               {
                  if(this._alertExit.parent)
                  {
                     this._alertExit.parent.removeChild(this._alertExit);
                  }
                  this._alertExit.dispose();
               }
               this._alertExit = null;
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function exitRoom() : void
      {
         if(ChurchManager.instance.currentScene && ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)
         {
            ChurchManager.instance.currentScene = false;
         }
         else
         {
            StateManager.setState(StateType.CHURCH_ROOM_LIST);
         }
      }
      
      private function toolSwitch(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._switchEnable)
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":stage.stageWidth - this.width + (this.width - 34),
               "ease":Sine.easeInOut
            });
            this._switchEnable = false;
         }
         else
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":stage.stageWidth - this.width,
               "ease":Sine.easeInOut
            });
            this._switchEnable = true;
         }
      }
      
      public function loadFire() : void
      {
         this._fireLoader = LoaderManager.Instance.creatLoader("Catharine.swf",BaseLoader.MODULE_LOADER);
		 //this._fireLoader = LoaderManager.Instance.creatLoader(PathManager.solveCatharineSwf,BaseLoader.MODULE_LOADER);
         LoaderManager.Instance.startLoad(this._fireLoader);
      }
      
      private function get isFireLoaded() : Boolean
      {
         var fireClass:Class = null;
         try
         {
            fireClass = ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.FireItemAccect02") as Class;
            if(fireClass)
            {
               return true;
            }
            return false;
         }
         catch(e:Error)
         {
            return false;
         }
         return false;
      }
      
      private function openFireList() : void
      {
         this.closeRoomGuestList();
         this.closeInviteGuest();
         if(!this.isFireLoaded)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.churchScene.SceneUI.switchVisibleFireList"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
            return;
         }
         if(!this._churchFireView)
         {
            this._churchFireView = ComponentFactory.Instance.creatCustomObject("church.churchFire.ChurchFireView",[this._controller,this._model]);
         }
         if(this._churchFireView.parent)
         {
            this._churchFireView.parent.removeChild(this._churchFireView);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._churchFireView,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      private function openRoomConfig() : void
      {
         if(this._weddingRoomConfigView)
         {
            if(this._weddingRoomConfigView.parent)
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
            this._weddingRoomConfigView.dispose();
            this._weddingRoomConfigView = null;
         }
         else
         {
            this._weddingRoomConfigView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomConfigView");
            this._weddingRoomConfigView.addEventListener(Event.CLOSE,this.closeRoomConfig);
            this._weddingRoomConfigView.controller = this._controller;
            this._weddingRoomConfigView.show();
         }
      }
      
      private function openRoomContinuation() : void
      {
         if(this._weddingRoomContinuationView)
         {
            if(this._weddingRoomContinuationView.parent)
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
            this._weddingRoomContinuationView.dispose();
            this._weddingRoomContinuationView = null;
         }
         else
         {
            this._weddingRoomContinuationView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomContinuationView");
            this._weddingRoomContinuationView.addEventListener(Event.CLOSE,this.closeRoomContinuation);
            this._weddingRoomContinuationView.controller = this._controller;
            this._weddingRoomContinuationView.show();
         }
      }
      
      private function openGuestList() : void
      {
         this.closeFireList();
         this.closeInviteGuest();
         if(this._weddingRoomGuestListView)
         {
            if(this._weddingRoomGuestListView.parent)
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
            this._weddingRoomGuestListView.dispose();
            this._weddingRoomGuestListView = null;
         }
         else
         {
            this._weddingRoomGuestListView = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListView",[this._controller,this._model]);
            this._weddingRoomGuestListView.addEventListener(Event.CLOSE,this.closeRoomGuestList);
            this._weddingRoomGuestListView.show();
         }
      }
      
      private function openInviteGuest() : void
      {
         this.closeFireList();
         this.closeRoomGuestList();
         if(this._churchInviteController == null)
         {
            this._churchInviteController = new ChurchInviteController();
         }
         if(this._churchInviteController.getView().parent)
         {
            this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
         }
         else
         {
            this._churchInviteController.refleshList(0);
            this._churchInviteController.showView();
         }
      }
      
      private function openStartWedding() : void
      {
         if(this._toolBtnStartWedding.enable == true)
         {
            SoundManager.instance.play("008");
         }
         this._alertStartWedding = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("are.you.sure.to.marry"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertStartWedding.addEventListener(FrameEvent.RESPONSE,this.startWeddingResponse);
      }
      
      private function startWeddingResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._controller.startWedding();
               this.closeStartWedding();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.closeStartWedding();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function closeStartWedding() : void
      {
         if(this._alertStartWedding)
         {
            if(this._alertStartWedding.parent)
            {
               this._alertStartWedding.parent.removeChild(this._alertStartWedding);
            }
            this._alertStartWedding.dispose();
         }
         this._alertStartWedding = null;
      }
      
      private function closeFireList() : void
      {
         if(this._churchFireView && this._churchFireView.parent)
         {
            this._churchFireView.parent.removeChild(this._churchFireView);
         }
      }
      
      private function closeRoomGift(param1:Event = null) : void
      {
         if(this._weddingRoomGiftFrameViewForGuest)
         {
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
            if(this._weddingRoomGiftFrameViewForGuest.parent)
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.dispose();
         }
         this._weddingRoomGiftFrameViewForGuest = null;
      }
      
      private function closeRoomConfig(param1:Event = null) : void
      {
         if(this._weddingRoomConfigView)
         {
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
            if(this._weddingRoomConfigView.parent)
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.dispose();
         }
         this._weddingRoomConfigView = null;
      }
      
      private function closeRoomContinuation(param1:Event = null) : void
      {
         if(this._weddingRoomContinuationView)
         {
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
            if(this._weddingRoomContinuationView.parent)
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.dispose();
         }
         this._weddingRoomContinuationView = null;
      }
      
      private function closeRoomGuestList(param1:Event = null) : void
      {
         if(this._weddingRoomGuestListView)
         {
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
            if(this._weddingRoomGuestListView.parent)
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.dispose();
         }
         this._weddingRoomGuestListView = null;
      }
      
      private function closeInviteGuest(param1:Event = null) : void
      {
         if(this._churchInviteController && this._churchInviteController.getView() && this._churchInviteController.getView().parent)
         {
            this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
         }
      }
      
      private function removeView() : void
      {
         if(this._toolBg)
         {
            if(this._toolBg.parent)
            {
               this._toolBg.parent.removeChild(this._toolBg);
            }
            this._toolBg.bitmapData.dispose();
            this._toolBg.bitmapData = null;
         }
         this._toolBg = null;
         if(this._startWeddingTip2)
         {
            if(this._startWeddingTip2.parent)
            {
               this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
            }
            this._startWeddingTip2.bitmapData.dispose();
            this._startWeddingTip2.bitmapData = null;
         }
         this._startWeddingTip2 = null;
         if(this._toolSwitchBg)
         {
            if(this._toolSwitchBg.parent)
            {
               this._toolSwitchBg.parent.removeChild(this._toolSwitchBg);
            }
            this._toolSwitchBg.dispose();
         }
         this._toolSwitchBg = null;
         if(this._toolSwitch)
         {
            if(this._toolSwitch.parent)
            {
               this._toolSwitch.parent.removeChild(this._toolSwitch);
            }
            this._toolSwitch.bitmapData.dispose();
            this._toolSwitch.bitmapData = null;
         }
         this._toolSwitch = null;
         if(this._toolAdminBg)
         {
            if(this._toolAdminBg.parent)
            {
               this._toolAdminBg.parent.removeChild(this._toolAdminBg);
            }
            this._toolAdminBg.bitmapData.dispose();
            this._toolAdminBg.bitmapData = null;
         }
         this._toolAdminBg = null;
         if(this._startWeddingTip)
         {
            if(this._startWeddingTip.parent)
            {
               this._startWeddingTip.parent.removeChild(this._startWeddingTip);
            }
            this._startWeddingTip.bitmapData.dispose();
            this._startWeddingTip.bitmapData = null;
         }
         this._startWeddingTip = null;
         if(this._toolBtnRoomAdmin)
         {
            if(this._toolBtnRoomAdmin.parent)
            {
               this._toolBtnRoomAdmin.parent.removeChild(this._toolBtnRoomAdmin);
            }
            this._toolBtnRoomAdmin.dispose();
         }
         this._toolBtnRoomAdmin = null;
         if(this._toolBtnGift)
         {
            if(this._toolBtnGift.parent)
            {
               this._toolBtnGift.parent.removeChild(this._toolBtnGift);
            }
            this._toolBtnGift.dispose();
         }
         this._toolBtnGift = null;
         if(this._toolBtnFire)
         {
            if(this._toolBtnFire.parent)
            {
               this._toolBtnFire.parent.removeChild(this._toolBtnFire);
            }
            this._toolBtnFire.dispose();
         }
         this._toolBtnFire = null;
         if(this._toolBtnFill)
         {
            if(this._toolBtnFill.parent)
            {
               this._toolBtnFill.parent.removeChild(this._toolBtnFill);
            }
            this._toolBtnFill.dispose();
         }
         this._toolBtnFill = null;
         if(this._toolBtnExit)
         {
            if(this._toolBtnExit.parent)
            {
               this._toolBtnExit.parent.removeChild(this._toolBtnExit);
            }
            this._toolBtnExit.dispose();
         }
         this._toolBtnExit = null;
         if(this._toolBtnBack)
         {
            if(this._toolBtnBack.parent)
            {
               this._toolBtnBack.parent.removeChild(this._toolBtnBack);
            }
            this._toolBtnBack.dispose();
         }
         this._toolBtnBack = null;
         if(this._toolBtnStartWedding)
         {
            if(this._toolBtnStartWedding.parent)
            {
               this._toolBtnStartWedding.parent.removeChild(this._toolBtnStartWedding);
            }
            this._toolBtnStartWedding.dispose();
         }
         this._toolBtnStartWedding = null;
         if(this._toolBtnAdminInviteGuest)
         {
            if(this._toolBtnAdminInviteGuest.parent)
            {
               this._toolBtnAdminInviteGuest.parent.removeChild(this._toolBtnAdminInviteGuest);
            }
            this._toolBtnAdminInviteGuest.dispose();
         }
         this._toolBtnAdminInviteGuest = null;
         if(this._toolBtnGuestList)
         {
            if(this._toolBtnGuestList.parent)
            {
               this._toolBtnGuestList.parent.removeChild(this._toolBtnGuestList);
            }
            this._toolBtnGuestList.dispose();
         }
         this._toolBtnGuestList = null;
         if(this._toolBtnContinuation)
         {
            if(this._toolBtnContinuation.parent)
            {
               this._toolBtnContinuation.parent.removeChild(this._toolBtnContinuation);
            }
            this._toolBtnContinuation.dispose();
         }
         this._toolBtnContinuation = null;
         if(this._toolBtnModify)
         {
            if(this._toolBtnModify.parent)
            {
               this._toolBtnModify.parent.removeChild(this._toolBtnModify);
            }
            this._toolBtnModify.dispose();
         }
         this._toolBtnModify = null;
         if(this._alertExit)
         {
            if(this._alertExit.parent)
            {
               this._alertExit.parent.removeChild(this._alertExit);
            }
            this._alertExit.dispose();
         }
         this._alertExit = null;
         this._fireLoader = null;
         if(this._churchFireView)
         {
            if(this._churchFireView.parent)
            {
               this._churchFireView.parent.removeChild(this._churchFireView);
            }
            this._churchFireView.dispose();
         }
         this._churchFireView = null;
         if(this._weddingRoomGiftFrameViewForGuest)
         {
            if(this._weddingRoomGiftFrameViewForGuest.parent)
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.dispose();
         }
         this._weddingRoomGiftFrameViewForGuest = null;
         if(this._weddingRoomConfigView)
         {
            if(this._weddingRoomConfigView.parent)
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.dispose();
         }
         this._weddingRoomConfigView = null;
         if(this._weddingRoomContinuationView)
         {
            if(this._weddingRoomContinuationView.parent)
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.dispose();
         }
         this._weddingRoomContinuationView = null;
         if(this._weddingRoomGuestListView)
         {
            if(this._weddingRoomGuestListView.parent)
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.dispose();
         }
         this._weddingRoomGuestListView = null;
         if(this._toolBtnInviteGuest)
         {
            if(this._toolBtnInviteGuest.parent)
            {
               this._toolBtnInviteGuest.parent.removeChild(this._toolBtnInviteGuest);
            }
            this._toolBtnInviteGuest.dispose();
         }
         this._toolBtnInviteGuest = null;
         if(this._alertStartWedding)
         {
            if(this._alertStartWedding.parent)
            {
               this._alertStartWedding.parent.removeChild(this._alertStartWedding);
            }
            this._alertStartWedding.dispose();
         }
         this._alertStartWedding = null;
         if(this._sendGiftToolBg)
         {
            if(this._sendGiftToolBg.parent)
            {
               this._sendGiftToolBg.parent.removeChild(this._sendGiftToolBg);
            }
            ObjectUtils.disposeObject(this._sendGiftToolBg);
         }
         this._sendGiftToolBg = null;
         if(this._toolSendGiftBtn)
         {
            if(this._toolSendGiftBtn.parent)
            {
               this._toolSendGiftBtn.parent.removeChild(this._toolSendGiftBtn);
            }
            ObjectUtils.disposeObject(this._toolSendGiftBtn);
         }
         this._toolSendGiftBtn = null;
         if(this._toolSendCashBtn)
         {
            if(this._toolSendCashBtn.parent)
            {
               this._toolSendCashBtn.parent.removeChild(this._toolSendCashBtn);
            }
            ObjectUtils.disposeObject(this._toolSendCashBtn);
         }
         this._toolSendCashBtn = null;
         if(this._toolSendCashBtnForGuest)
         {
            if(this._toolSendCashBtnForGuest.parent)
            {
               this._toolSendCashBtnForGuest.parent.removeChild(this._toolSendCashBtnForGuest);
            }
            ObjectUtils.disposeObject(this._toolSendCashBtnForGuest);
         }
         this._toolSendCashBtnForGuest = null;
         if(this._churchInviteController)
         {
            this._churchInviteController.dispose();
         }
         this._churchInviteController = null;
         if(this._switchTween)
         {
            this._switchTween.kill();
         }
         this._switchTween = null;
         if(this._startTipTween)
         {
            this._startTipTween.kill();
         }
         this._startTipTween = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__weddingStatusChange);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         this._toolSwitchBg.removeEventListener(MouseEvent.CLICK,this.toolSwitch);
         this._toolBtnGift.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFire.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFill.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnExit.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendGiftBtn.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtn.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtnForGuest.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         if(this._toolBtnRoomAdmin)
         {
            this._toolBtnRoomAdmin.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._toolBtnModify)
         {
            this._toolBtnModify.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._toolBtnContinuation)
         {
            this._toolBtnContinuation.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._toolBtnGuestList)
         {
            this._toolBtnGuestList.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._toolBtnStartWedding)
         {
            this._toolBtnStartWedding.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._toolBtnAdminInviteGuest)
         {
            this._toolBtnAdminInviteGuest.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(this._weddingRoomGiftFrameViewForGuest)
         {
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
         }
         if(this._weddingRoomConfigView)
         {
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
         }
         if(this._weddingRoomContinuationView)
         {
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
         }
         if(this._weddingRoomGuestListView)
         {
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
         }
         if(this._alertExit)
         {
            this._alertExit.removeEventListener(FrameEvent.RESPONSE,this.exitResponse);
         }
         if(this._alertStartWedding)
         {
            this._alertStartWedding.removeEventListener(FrameEvent.RESPONSE,this.startWeddingResponse);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
