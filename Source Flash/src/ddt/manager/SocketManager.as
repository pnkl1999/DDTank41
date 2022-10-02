package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   
   import chickActivation.ChickActivationType;
   
   import ddt.data.socket.AcademyPackageType;
   import ddt.data.socket.ChurchPackageType;
   import ddt.data.socket.ConsortiaPackageType;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.EliteGamePackageType;
   import ddt.data.socket.FarmPackageType;
   import ddt.data.socket.FightSpiritPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.HotSpringPackageType;
   import ddt.data.socket.IMPackageType;
   import ddt.data.socket.ePackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.view.CheckCodeFrame;
   
   import labyrinth.data.LabyrinthPackageType;
   
   import littleGame.LittleGamePacketQueue;
   import littleGame.data.LittleGamePackageInType;
   import littleGame.events.LittleGameSocketEvent;
   
   import newChickenBox.model.NewChickenBoxPackageType;
   
   import petsBag.controller.PetBagController;
   
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageIn;
   import road7th.comm.SocketEvent;
   
   import worldboss.model.WorldBossPackageType;
   
   public class SocketManager extends EventDispatcher
   {
      
      public static const PACKAGE_CONTENT_START_INDEX:int = 20;
      
      private static var _instance:SocketManager;
       
      
      private var _socket:ByteSocket;
      
      private var _out:GameSocketOut;
      
      private var _isLogin:Boolean;
      
      public function SocketManager()
      {
         super();
         this._socket = new ByteSocket();
         this._socket.addEventListener(Event.CONNECT,this.__socketConnected);
         this._socket.addEventListener(Event.CLOSE,this.__socketClose);
         this._socket.addEventListener(SocketEvent.DATA,this.__socketData);
         this._socket.addEventListener(ErrorEvent.ERROR,this.__socketError);
         this._out = new GameSocketOut(this._socket);
      }
      
      public static function get Instance() : SocketManager
      {
         if(_instance == null)
         {
            _instance = new SocketManager();
         }
         return _instance;
      }
      
      public function set isLogin(param1:Boolean) : void
      {
         this._isLogin = param1;
      }
      
      public function get isLogin() : Boolean
      {
         return this._isLogin;
      }
      
      public function get socket() : ByteSocket
      {
         return this._socket;
      }
      
      public function get out() : GameSocketOut
      {
         return this._out;
      }
      
      public function connect(param1:String, param2:Number) : void
      {
         this._socket.connect(param1,param2);
      }
      
      private function __socketConnected(param1:Event) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONNECT_SUCCESS));
         this.out.sendLogin(PlayerManager.Instance.Account);
      }
      
      private function __socketClose(param1:Event) : void
      {
         LeavePageManager.forcedToLoginPath(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
         this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
      }
      
      private function __socketError(param1:ErrorEvent) : void
      {
         this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.false"));
         CheckCodeFrame.Instance.close();
      }
      
      private function __systemAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
         _loc2_.dispose();
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      public function testWishBead() : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP));
      }
      
      private function __socketData(param1:SocketEvent) : void
      {
         var pkg:PackageIn = null;
         var type:int = 0;
         var msg:String = null;
         var systemAlert:BaseAlerFrame = null;
         var event:SocketEvent = param1;
         try
         {
            pkg = event.data;
            switch(pkg.code)
            {
               case ePackageType.RSAKEY:
                  break;
               case ePackageType.SYS_MESSAGE:
                  type = pkg.readInt();
                  msg = pkg.readUTF();
                  if(msg == "" || msg == null)
                  {
                     return;
                  }
                  if(msg.substr(0,5) == "撮合成功!")
                  {
                     StateManager.getInGame_Step_2 = true;
                  }
                  switch(type)
                  {
                     case 0:
                        MessageTipManager.getInstance().show(msg,0,true);
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 1:
                        MessageTipManager.getInstance().show(msg,0,true);
                        ChatManager.Instance.sysChatRed(msg);
                        break;
                     case 2:
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 3:
                        ChatManager.Instance.sysChatRed(msg);
                        break;
                     case 4:
                        systemAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                        systemAlert.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
                        break;
                     case 5:
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 6:
                        ChatManager.Instance.sysChatLinkYellow(msg);
                        break;
                     case 7:
                        PetBagController.instance().pushMsg(msg);
						break;
					 default:
						 break;
                  }
                  break;
               case ePackageType.DAILY_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_AWARD,pkg));
                  break;
               case ePackageType.LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN,pkg));
                  break;
               case ePackageType.KIT_USER:
                  this.kitUser(pkg.readUTF());
                  break;
               case ePackageType.PING:
                  this.out.sendPint();
                  break;
               case ePackageType.EDITION_ERROR:
                  this.cleanLocalFile(pkg.readUTF());
                  break;
               case ePackageType.WISHBEADEQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP,pkg));
                  break;
               case ePackageType.BAG_LOCKED:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAG_LOCKED,pkg));
                  break;
               case ePackageType.SCENE_ADD_USER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_ADD_USER,pkg));
                  break;
               case ePackageType.SCENE_REMOVE_USER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_REMOVE_USER,pkg));
                  break;
               case ePackageType.GAME_ROOM:
                  this.createGameRoomEvent(pkg);
                  break;
               case ePackageType.GAME_CMD:
                  this.createGameEvent(pkg);
                  break;
               case ePackageType.SCENE_CHANNEL_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHANNEL_CHANGE,pkg));
                  break;
               case ePackageType.LEAGUE_START_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE,pkg));
                  break;
               case ePackageType.SCENE_CHAT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHAT,pkg));
                  break;
               case ePackageType.SCENE_FACE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_FACE,pkg));
                  break;
               case ePackageType.DELETE_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_GOODS,pkg));
                  break;
               case ePackageType.BUY_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_GOODS,pkg));
                  break;
               case ePackageType.CHANGE_PLACE_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_GOODS_PLACE,pkg));
                  break;
               case ePackageType.CHAIN_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAIN_EQUIP,pkg));
                  break;
               case ePackageType.UNCHAIN_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UNCHAIN_EQUIP,pkg));
                  break;
               case ePackageType.SEND_MAIL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_EMAIL,pkg));
                  break;
               case ePackageType.DELETE_MAIL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_MAIL,pkg));
                  break;
               case ePackageType.GET_MAIL_ATTACHMENT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,pkg));
                  break;
               case ePackageType.MAIL_CANCEL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_CANCEL,pkg));
                  break;
               case ePackageType.SEll_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELL_GOODS,pkg));
                  break;
               case ePackageType.UPDATE_COUPONS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_COUPONS,pkg));
                  break;
               case ePackageType.ITEM_STORE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STORE,pkg));
                  break;
               case ePackageType.UPDATE_PRIVATE_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,pkg));
                  break;
               case ePackageType.UPDATE_PLAYER_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,pkg));
                  break;
               case ePackageType.GRID_PROP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_PROP,pkg));
                  break;
               case ePackageType.EQUIP_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EQUIP_CHANGE,pkg));
                  break;
               case ePackageType.GRID_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_GOODS,pkg));
                  break;
               case ePackageType.NETWORK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NETWORK,pkg));
                  break;
               case ePackageType.GAME_TAKE_TEMP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_TEMP,pkg));
                  break;
               case ePackageType.SCENE_USERS_LIST:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_USERS_LIST,pkg));
                  break;
               case ePackageType.GAME_INVITE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_INVITE,pkg));
                  break;
               case ePackageType.S_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.S_BUGLE,pkg));
                  break;
               case ePackageType.B_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.B_BUGLE,pkg));
                  break;
               case ePackageType.C_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.C_BUGLE,pkg));
                  break;
               case ePackageType.DEFY_AFFICHE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEFY_AFFICHE,pkg));
                  break;
               case ePackageType.CHAT_PERSONAL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_PERSONAL,pkg));
                  break;
               case ePackageType.ITEM_COMPOSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_COMPOSE,pkg));
                  break;
               case ePackageType.ITEM_STRENGTHEN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STRENGTH,pkg));
                  break;
               case ePackageType.ITEM_TRANSFER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_TRANSFER,pkg));
                  break;
               case ePackageType.ITEM_FUSION_PREVIEW:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,pkg));
                  break;
               case ePackageType.ITEM_REFINERY_PREVIEW:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,pkg));
                  break;
               case ePackageType.ITEM_REFINERY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY,pkg));
                  break;
               case ePackageType.ITEM_INLAY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EMBED,pkg));
                  break;
               case ePackageType.OPEN_FIVE_SIX_HOLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,pkg));
                  break;
               case ePackageType.ITEM_FUSION:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION,pkg));
                  break;
               case ePackageType.QUEST_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_UPDATE,pkg));
                  break;
               case ePackageType.QUSET_OBTAIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_OBTAIN,pkg));
                  break;
               case ePackageType.QUEST_CHECK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_CHECK,pkg));
                  break;
               case ePackageType.QUEST_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_FINISH,pkg));
                  break;
               case ePackageType.ITEM_OBTAIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OBTAIN,pkg));
                  break;
               case ePackageType.ITEM_CONTINUE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_CONTINUE,pkg));
                  break;
               case ePackageType.SYS_DATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_DATE,pkg));
                  break;
               case ePackageType.ITEM_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EQUIP,pkg));
                  break;
               case ePackageType.MATE_ONLINE_TIME:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MATE_ONLINE_TIME,pkg));
                  break;
               case ePackageType.SYS_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_NOTICE,pkg));
                  break;
               case ePackageType.MAIL_RESPONSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_RESPONSE,pkg));
                  break;
               case ePackageType.AUCTION_REFRESH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_REFRESH,pkg));
                  break;
               case ePackageType.CHECK_CODE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHECK_CODE,pkg));
                  break;
               case ePackageType.IM_CMD:
                  this.createIMEvent(pkg);
                  break;
               case ePackageType.ELITEGAME:
                  this.createEliteGameEvent(pkg);
                  break;
               case ePackageType.CONSORTIA_CMD:
                  this.createConsortiaEvent(pkg);
                  break;
               case ePackageType.CONSORTIA_RESPONSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RESPONSE,pkg));
                  break;
               case ePackageType.CONSORTIA_MAIL_MESSAGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,pkg));
                  break;
               case ePackageType.ITEM_ADVANCE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_ADVANCE,pkg));
                  break;
               case ePackageType.CID_CHECK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CID_CHECK,pkg));
                  break;
               case ePackageType.ENTHRALL_LIGHT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTHRALL_LIGHT,pkg));
                  break;
               case ePackageType.BUFF_OBTAIN:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
                  }
                  else
                  {
                     QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
                  }
                  break;
               case ePackageType.BUFF_ADD:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
                  }
                  else
                  {
                     QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
                  }
                  break;
               case ePackageType.BUFF_UPDATE:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
                  }
                  else
                  {
                     QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
                  }
                  break;
               case ePackageType.USE_COLOR_CARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_CARD,pkg));
                  break;
               case ePackageType.AUCTION_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_UPDATE,pkg));
                  break;
               case ePackageType.GOODS_PRESENT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_PRESENT,pkg));
                  break;
               case ePackageType.GOODS_COUNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_COUNT,pkg));
                  break;
               case ePackageType.UPDATE_SHOP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,pkg));
                  break;
               case ePackageType.MARRYINFO_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_GET,pkg));
                  break;
               case ePackageType.MARRY_STATUS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_STATUS,pkg));
                  break;
               case ePackageType.MARRY_ROOM_CREATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_CREATE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,pkg));
                  break;
               case ePackageType.MARRY_SCENE_LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_LOGIN,pkg));
                  break;
               case ePackageType.PLAYER_ENTER_MARRY_ROOM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,pkg));
                  break;
               case ePackageType.PLAYER_EXIT_MARRY_ROOM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,pkg));
                  break;
               case ePackageType.MARRY_APPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY,pkg));
                  break;
               case ePackageType.MARRY_APPLY_REPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY_REPLY,pkg));
                  break;
               case ePackageType.DIVORCE_APPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIVORCE_APPLY,pkg));
                  break;
               case ePackageType.MARRY_ROOM_STATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_STATE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_DISPOSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,pkg));
                  break;
               case ePackageType.MARRYPROP_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYPROP_GET,pkg));
                  break;
               case ePackageType.MARRY_CMD:
                  this.createChurchEvent(pkg);
                  break;
               case ePackageType.AMARRYINFO_REFRESH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AMARRYINFO_REFRESH,pkg));
                  break;
               case ePackageType.MARRYINFO_ADD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_ADD,pkg));
                  break;
               case ePackageType.LINKREQUEST_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LINKGOODSINFO_GET,pkg));
                  break;
               case CrazyTankPackageType.INSUFFICIENT_MONEY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INSUFFICIENT_MONEY,pkg));
                  break;
               case ePackageType.GET_ITEM_MESS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_ITEM_MESS,pkg));
                  break;
               case ePackageType.USER_ANSWER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_ANSWER,pkg));
                  break;
               case ePackageType.MARRY_SCENE_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_CHANGE,pkg));
                  break;
               case ePackageType.HOTSPRING_CMD:
                  this.createHotSpringEvent(pkg);
                  break;
               case ePackageType.HOTSPRING_ROOM_CREATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ENTER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ADD_OR_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_REMOVE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_LIST_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_ADD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,pkg));
                  break;
               case ePackageType.GET_TIME_BOX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_INIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_INIT,pkg));
                  break;
               case ePackageType.ACHIEVEMENTDATA_INIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,pkg));
                  break;
               case ePackageType.USER_RANK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RANK,pkg));
                  break;
               case ePackageType.FIGHT_NPC:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_NPC,pkg));
                  break;
               case ePackageType.LOTTERY_ALTERNATE_LIST:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,pkg));
                  break;
               case ePackageType.LOTTERY_GET_ITEM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_GET_ITEM,pkg));
                  break;
               case ePackageType.CADDY_GET_AWARDS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_AWARDS,pkg));
                  break;
               case ePackageType.CADDY_GET_BADLUCK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_BADLUCK,pkg));
                  break;
               case ePackageType.LOOKUP_EFFORT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOOKUP_EFFORT,pkg));
                  break;
               case ePackageType.LOTTERY_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OFFERPACK_COMPLETE,pkg));
                  break;
               case ePackageType.QQTIPS_GET_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QQTIPS_GET_INFO,pkg));
                  break;
               case ePackageType.EDICTUM_GET_SERVION:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EDICTUM_GET_VERSION,pkg));
                  break;
               case ePackageType.FEEDBACK_REPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FEEDBACK_REPLY,pkg));
                  break;
               case ePackageType.ANSWERBOX_QUESTIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ANSWERBOX_QUESTIN,pkg));
                  break;
               case ePackageType.VIP_RENEWAL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_IS_OPENED,pkg));
                  break;
               case ePackageType.VIP_LEVELUP_AWARDS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_LEVELUP,pkg));
                  break;
               case ePackageType.USE_CHANGE_COLOR_SHELL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_SHELL,pkg));
                  break;
               case AcademyPackageType.ACADEMY_FATHER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER,pkg));
                  break;
               case ePackageType.ITEM_OPENUP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OPENUP,pkg));
                  break;
               case ePackageType.GET_DYNAMIC:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_DYNAMIC,pkg));
                  break;
               case ePackageType.USER_GET_GIFTS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_GET_GIFTS,pkg));
                  break;
               case ePackageType.USER_SEND_GIFTS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_SEND_GIFTS,pkg));
                  break;
               case ePackageType.USER_UPDATE_GIFT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_UPDATE_GIFT,pkg));
                  break;
               case ePackageType.WEEKLY_CLICK_CNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,pkg));
                  break;
               case ePackageType.USER_RELOAD_GIFT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RELOAD_GIFT,pkg));
                  break;
               case ePackageType.ACTIVE_PULLDOWN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_PULLDOWN,pkg));
                  break;
               case ePackageType.CARDS_DATA:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_DATA,pkg));
                  break;
               case ePackageType.CARD_RESET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARD_RESET,pkg));
                  break;
               case ePackageType.LOAD_RESOURCE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,pkg));
                  break;
               case ePackageType.CHAT_FILTERING_FRIENDS_SHARE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,pkg));
                  break;
               case ePackageType.LOTTERY_OPEN_BOX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_OPNE,pkg));
                  break;
               case ePackageType.DAILYRECORD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILYRECORD,pkg));
                  break;
               case ePackageType.TEXP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TEXP,pkg));
                  break;
               case ePackageType.LITTLEGAME_COMMAND:
                  this.createLittleGameEvent(pkg);
                  break;
               case ePackageType.LITTLEGAME_ACTIVED:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LITTLEGAME_ACTIVED,pkg));
                  break;
               case ePackageType.USER_LUCKYNUM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_LUCKYNUM,pkg));
                  break;
               case ePackageType.LEFT_GUN_ROULETTE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE,pkg));
                  break;
               case ePackageType.LEFT_GUN_ROULETTE_START:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,pkg));
                  break;
               case ePackageType.LOTTERY_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKY_LOTTERY,pkg));
                  break;
               case ePackageType.CAN_CARD_LOTTERY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,pkg));
                  break;
               case ePackageType.FIRSTRECHARGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIRSTRECHARGE_MESSAGE,pkg));
                  break;
               case ePackageType.NOVICEACTIVITY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NOVICEACTIVITY_MESSAGE,pkg));
                  break;
               case ePackageType.INVITE_FRIEND:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITEFRIEND,pkg));
                  break;
               case ePackageType.PET:
                  this.handlePetPkg(pkg);
                  break;
               case ePackageType.FARM:
                  this.handFarmPkg(pkg);
                  break;
			   case ePackageType.WORLDBOSS_CMD:
				   this.createWorldBossEvent(pkg);
				   break;
               case ePackageType.NEWCHICKENBOX_SYS:
                  this.createNewChickenBoxEvent(pkg);
                  break;
               case ePackageType.USE_CHANGE_SEX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_SEX,pkg));
                  break;
               case ePackageType.OPTION_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPTION_CHANGE,pkg));
                  break;
               case ePackageType.LABYRINTH:
                  this.labyrinthPkg(pkg);
                  break;
               case ePackageType.ACCUMULATIVELOGIN_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACCUMULATIVELOGIN_AWARD,pkg));
				  break;
			   case ePackageType.BAOLTFUNCTION:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAOLTFUNCTION,pkg));
				   break;
			   case ePackageType.ACTIVITY_SYSTEM:
				   this.activitySystem(pkg);
				   break;
			   case ePackageType.ACTIVITY_PACKAGE:
				   this.activityPackageHandler(pkg);
				   break;
			   case ePackageType.LATENT_ENERGY:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LATENT_ENERGY,pkg));
				   break;
			   case ePackageType.FIGHT_SPIRIT:
				   this.fightSpirit(pkg);
				   break;			   
			   case ePackageType.AVATAR_COLLECTION:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AVATAR_COLLECTION,pkg));
				   break;
			   case ePackageType.HONOR_UP_COUNT:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HONOR_UP_COUNT,pkg));
				   break;
			   case ePackageType.TOTEM:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TOTEM,pkg));
				   break;
			   case ePackageType.NECKLACE_STRENGTH:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NECKLACE_STRENGTH,pkg));
				   break;
			   case ePackageType.STORE_FINE_SUIT:
				   dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.STORE_FINE_SUITS,pkg));
				   break;
			   default:
				   break;
            }
            return;
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendErrorMsg(err.message + "\r\n" + err.getStackTrace());
            return;
         }
      }
	  
	  private function activitySystem(param1:PackageIn) : void
	  {
		  var _loc2_:int = param1.readByte();
		  if(_loc2_ >= 7 && _loc2_ <= 13)
		  {
			  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_SYSTEM,param1,_loc2_));
		  }
		  else if(_loc2_ >= 37 && _loc2_ <= 45)
		  {
			  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_BEGIN,param1,_loc2_));
		  }
		  else if(_loc2_ >= 64 && _loc2_ <= 66)
		  {
			  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,param1,_loc2_));
		  }
	  }
	  
	  private function createWorldBossEvent(param1:PackageIn) : void
	  {
		  var _loc2_:int = param1.readByte();
		  var _loc3_:CrazyTankSocketEvent = null;
		  switch(_loc2_)
		  {
			  case WorldBossPackageType.OPEN:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_INIT,param1);
				  break;
			  case WorldBossPackageType.OVER:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_OVER,param1);
				  break;
			  case WorldBossPackageType.CANENTER:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ENTER,param1);
				  break;
			  case WorldBossPackageType.ENTER:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOM,param1);
				  break;
			  case WorldBossPackageType.MOVE:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_MOVE,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_EXIT:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_EXIT,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_PLAYERSTAUTSUPDATE:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_FIGHTOVER:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_ROOM_CLOSE:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_RANKING:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING,param1);
				  break;
			  case WorldBossPackageType.WORLDBOSS_BUYBUFF:
				  _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF,param1);
		  }
		  if(_loc3_)
		  {
			  dispatchEvent(_loc3_);
		  }
	  }
      
      private function labyrinthPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case LabyrinthPackageType.REQUEST_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.REQUEST_UPDATE_EVENT,param1));
               break;
            case LabyrinthPackageType.PUSH_CLEAN_OUT_INFO:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.PUSH_CLEAN_OUT_INFO_EVENT,param1));
               break;
            case LabyrinthPackageType.CLEAN_OUT:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.CLEAN_OUT_EVENT,param1));
               break;
            case LabyrinthPackageType.TRY_AGAIN:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.TRY_AGAIN_EVENT,param1));
         }
      }
      
      private function handFarmPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case FarmPackageType.PAY_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FIELD,param1));
               break;
            case FarmPackageType.GAIN_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAIN_FIELD,param1));
               break;
            case FarmPackageType.FRUSH_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRUSH_FIELD,param1));
               break;
            case FarmPackageType.ENTER_FARM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_FARM,param1));
               break;
            case FarmPackageType.GROW_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEEDING,param1));
               break;
            case FarmPackageType.COMPOSE_FOOD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.COMPOSE_FOOD,param1));
               break;
            case FarmPackageType.ACCELERATE_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DO_MATURE,param1));
               break;
            case FarmPackageType.HELPER_SWITCH_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_SWITCH,param1));
               break;
            case FarmPackageType.KILLCROP_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KILL_CROP,param1));
               break;
            case FarmPackageType.HELPER_PAY_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_PAY,param1));
               break;
            case FarmPackageType.EXIT_FARM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_FARM,param1));
               break;
            case FarmPackageType.FARM_LAND_INFO:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_LAND_INFO,param1));
         }
      }
      
      private function createNewChickenBoxEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case NewChickenBoxPackageType.CHICKENBOXOPEN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN,param1);
               break;
            case NewChickenBoxPackageType.CHICKENBOXCLOSE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,param1);
               break;
            case NewChickenBoxPackageType.GETITEMLIST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,param1);
               break;
            case NewChickenBoxPackageType.CANCLICKCARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CANCLICKCARDENABLE,param1);
               break;
            case NewChickenBoxPackageType.TACKOVERCARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,param1);
               break;
            case NewChickenBoxPackageType.EAGLEEYE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,param1);
               break;
            case NewChickenBoxPackageType.OVERSHOWITEMS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.OVERSHOWITEMS,param1);
               break;
            case NewChickenBoxPackageType.ACTIVITY_OPEN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_OPEN,param1);
               break;
            case NewChickenBoxPackageType.ACTIVITY_END:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_END,param1);
               break;
            case NewChickenBoxPackageType.ALL_GOODS_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,param1);
               break;
            case NewChickenBoxPackageType.REWARD_RECORD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_RECORD,param1);
               break;
            case NewChickenBoxPackageType.GOODS_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,param1);
               break;
            case NewChickenBoxPackageType.PLAY_REWARD_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,param1);
               break;
            case NewChickenBoxPackageType.AWARD_RANK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,param1);
         }
         if(_loc3_)
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function handlePetPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         switch(_loc2_)
         {
            case CrazyTankPackageType.UPDATE_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,param1));
               break;
            case CrazyTankPackageType.DEL_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEL_PET_EQUIP,param1));
               break;
            case CrazyTankPackageType.REFRESH_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REFRESH_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,param1));
               break;
            case CrazyTankPackageType.PET_RISINGSTAR:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_RISINGSTAR,param1));
               break;
            case CrazyTankPackageType.PET_EVOLUTION:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_EVOLUTION,param1));
               break;
            case CrazyTankPackageType.PET_FORMINFO:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_FORMINFO,param1));
               break;
            case CrazyTankPackageType.PET_FOLLOW:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_FOLLOW,param1));
               break;
            case CrazyTankPackageType.PET_WAKE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_WAKE,param1));
               break;
            case CrazyTankPackageType.EAT_PETS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_EAT,param1));
               break;
            case FarmPackageType.BUY_PET_EXP_ITEM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,param1));
			   break;
			default:
				break;
         }
      }
      
      private function kitUser(param1:String) : void
      {
         this._socket.close();
         if(param1.indexOf(LanguageMgr.GetTranslation("tank.manager.SocketManager.copyRight")) != -1)
         {
            LoaderSavingManager.clearFiles("*.png");
         }
         LeavePageManager.forcedToLoginPath(param1);
      }
      
      private function errorAlert(param1:String) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),param1,"","",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
         _loc2_.moveEnable = false;
      }
      
      private function __onAlertClose(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
         if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
         {
            if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
            {
               if(PlayerManager.Instance.Self.IsFirst <= 1)
               {
                  ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"3");
               }
               else
               {
                  ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"1");
               }
            }
         }
         LeavePageManager.leaveToLoginPath();
         ObjectUtils.disposeObject(param1.currentTarget);
      }
	  //Code ga hanh
	  private function activityPackageHandler(param1:PackageIn) : void
	  {
		  var _loc2_:int = param1.readInt();
		  /*if(_loc2_ == GrowthPackageType.GROWTHPACKAGE)
		  {
			  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GROWTHPACKAGE,param1));
		  }
		  else*/ if(_loc2_ == ChickActivationType.CHICKACTIVATION)
		  {
			  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHICKACTIVATION_SYSTEM,param1));
		  }
	  }
	  //GemStone
	  private function fightSpirit(param1:PackageIn) : void
	  {
		  var _loc2_:int = param1.readByte();
		  var _loc3_:CrazyTankSocketEvent = null;
		  switch(_loc2_)
		  {
			  case FightSpiritPackageType.PLAYER_FIGHT_SPIRIT_UP:
				  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,param1));
				  break;
			  case FightSpiritPackageType.FIGHT_SPIRIT_INIT:
				  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,param1));
		  }
	  }
	  //
      
      private function cleanLocalFile(param1:String) : void
      {
         this._socket.close();
         LoaderSavingManager.clearFiles("*.png");
         this.errorAlert(param1);
      }
      
      private function createEliteGameEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         switch(_loc2_)
         {
            case EliteGamePackageType.ELITE_MATCH_TYPE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_TYPE,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_RANK_START:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_START,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_PLAYER_RANK:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_PLAYER_RANK,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_RANK_DETAIL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_DETAIL,param1));
         }
      }
      
      private function createIMEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         switch(_loc2_)
         {
            case IMPackageType.FRIEND_ADD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_ADD,param1));
               break;
            case IMPackageType.FRIEND_REMOVE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_REMOVE,param1));
               break;
            case IMPackageType.FRIEND_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_UPDATE,param1));
               break;
            case IMPackageType.FRIEND_STATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_STATE,param1));
               break;
            case IMPackageType.FRIEND_RESPONSE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_RESPONSE,param1));
               break;
            case IMPackageType.ONS_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONS_EQUIP,param1));
               break;
            case IMPackageType.SAME_CITY_FRIEND:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SAME_CITY_FRIEND,param1));
               break;
            case IMPackageType.ADD_CUSTOM_FRIENDS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS,param1));
               break;
            case IMPackageType.ONE_ON_ONE_TALK:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONE_ON_ONE_TALK,param1));
         }
      }
      
      private function createChurchEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case ChurchPackageType.MOVE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.MOVE,param1);
               break;
            case ChurchPackageType.HYMENEAL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL,param1);
               break;
            case ChurchPackageType.CONTINUATION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINUATION,param1);
               break;
            case ChurchPackageType.INVITE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE,param1);
               break;
            case ChurchPackageType.USEFIRECRACKERS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USEFIRECRACKERS,param1);
               break;
            case ChurchPackageType.HYMENEAL_STOP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL_STOP,param1);
               break;
            case ChurchPackageType.GUNSALUTE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUNSALUTE,param1);
               break;
            case ChurchPackageType.MARRYROOMSENDGIFT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYROOMSENDGIFT,param1);
         }
         if(_loc3_)
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function createLittleGameEvent(pkg:PackageIn) : void
      {
         var event:LittleGameSocketEvent = null;
         var command:int = pkg.readByte();
         switch(command)
         {
            case LittleGamePackageInType.WORLD_LIST:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.WORLD_LIST,pkg);
               break;
            case LittleGamePackageInType.START_LOAD:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.START_LOAD,pkg);
               dispatchEvent(event);
               return;
            case LittleGamePackageInType.ADD_SPRITE:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_SPRITE,pkg);
               break;
            case LittleGamePackageInType.REMOVE_SPRITE:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.REMOVE_SPRITE,pkg);
               break;
            case LittleGamePackageInType.GAME_START:
               LittleGamePacketQueue.Instance.reset();
               LittleGamePacketQueue.Instance.setLifeTime(pkg.extend2);
               LittleGamePacketQueue.Instance.startup();
               event = new LittleGameSocketEvent(LittleGameSocketEvent.GAME_START,pkg);
               break;
            case LittleGamePackageInType.MOVE:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.MOVE,pkg);
               break;
            case LittleGamePackageInType.UPDATE_POS:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATE_POS,pkg);
               break;
            case LittleGamePackageInType.ADD_OBJECT:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_OBJECT,pkg);
               break;
            case LittleGamePackageInType.UPDATELIVINGSPROPERTY:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATELIVINGSPROPERTY,pkg);
               break;
            case LittleGamePackageInType.DoAction:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.DOACTION,pkg);
               break;
            case LittleGamePackageInType.DoMovie:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.DOMOVIE,pkg);
               break;
            case LittleGamePackageInType.GETSCORE:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.GETSCORE,pkg);
               break;
            case LittleGamePackageInType.INVOKE_OBJECT:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.INVOKE_OBJECT,pkg);
               break;
            case LittleGamePackageInType.SETCLOCK:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.SETCLOCK,pkg);
               break;
            case LittleGamePackageInType.PONG:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.PONG,pkg);
               break;
            case LittleGamePackageInType.NET_DELAY:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.NET_DELAY,pkg);
               break;
            case LittleGamePackageInType.KICK_PLAYE:
               event = new LittleGameSocketEvent(LittleGameSocketEvent.KICK_PLAYE,pkg);
         }
         if(event)
         {
            LittleGamePacketQueue.Instance.addQueue(event);
         }
      }
      
      private function createHotSpringEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case HotSpringPackageType.TARGET_POINT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE,param1));
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_INVITE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_TIME_UPDATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,param1);
               break;
            case HotSpringPackageType.CONTINU_BY_MONEY_SUCCESS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINU_BY_MONEY_SUCCESS,param1));
               break;
            case HotSpringPackageType.CONTINU_BY_MONEY:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_END,param1));
         }
         if(_loc3_)
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function createConsortiaEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         switch(_loc2_)
         {
            case ConsortiaPackageType.CONSORTIA_TRYIN:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CREATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CREATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DISBAND:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DISBAND,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_RENEGADE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RENEGADE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TRYIN_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TRYIN_DEL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_RICHES_OFFER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_APPLY_STATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DUTY_DELETE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_DELETE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DUTY_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_INVITE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_INVITE_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_REMARK_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CHAT:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAT,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_LEVEL_UP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TASK_RELEASE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,param1));
               break;
            case ConsortiaPackageType.POLL_CANDIDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POLL_CANDIDATE,param1));
               break;
            case ConsortiaPackageType.SKILL_SOCKET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SKILL_SOCKET,param1));
               break;
            case ConsortiaPackageType.CONSORTION_MAIL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_MAIL,param1));
               break;
            case ConsortiaPackageType.BUY_BADGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_BADGE,param1));
         }
      }
      
      private function createGameRoomEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         switch(_loc2_)
         {
            case GameRoomPackageType.GAME_ROOM_CREATE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_LOGIN:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_LOGIN,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_SETUP_CHANGE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_KICK:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_KICK,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_ADDPLAYER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_ENTER,param1));
               break;
            case GameRoomPackageType.GAME_TEAM:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TEAM,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_UPDATE_PLACE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_CANCEL:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_AWIT_CANCEL,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_STYLE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GMAE_STYLE_RECV,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_WAIT:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_RECV,param1));
               break;
            case GameRoomPackageType.ROOM_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ROOMLIST_PASS,param1));
               break;
            case GameRoomPackageType.GAME_PLAYER_STATE_CHANGE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,param1));
               break;
            case GameRoomPackageType.ROOMLIST_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_REMOVEPLAYER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_EXIT,param1));
               break;
            case GameRoomPackageType.LAST_MISSION_FOR_WARRIORSARENA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,param1));
               break;
            case GameRoomPackageType.PASSED_WARRIORSARENA_10:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PASSED_WARRIORSARENA_10,param1));
               break;
            case GameRoomPackageType.No_WARRIORSARENA_TICKET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.No_WARRIORSARENA_TICKET,param1));
         }
      }
      
      private function createGameEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case CrazyTankPackageType.GEM_GLOW:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW,param1);
               break;
            case CrazyTankPackageType.SEND_PICTURE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF,param1);
               break;
            case CrazyTankPackageType.GAME_MISSION_START:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_START,param1);
               break;
            case CrazyTankPackageType.GAME_MISSION_PREPARE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE,param1);
               break;
            case CrazyTankPackageType.UPDATE_BOARD_STATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE,param1);
               break;
            case CrazyTankPackageType.ADD_MAP_THING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING,param1);
               break;
            case CrazyTankPackageType.BARRIER_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO,param1);
               break;
            case CrazyTankPackageType.GAME_CREATE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE,param1));
               break;
            case CrazyTankPackageType.START_GAME:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START,param1));
               break;
            case CrazyTankPackageType.WANNA_LEADER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER,param1);
               break;
            case CrazyTankPackageType.GAME_LOAD:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD,param1));
               break;
            case CrazyTankPackageType.GAME_MISSION_INFO:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO,param1));
               break;
            case CrazyTankPackageType.GAME_OVER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER,param1));
               break;
            case CrazyTankPackageType.MISSION_OVE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE,param1));
               break;
            case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,param1));
               break;
            case CrazyTankPackageType.DIRECTION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED,param1);
               break;
            case CrazyTankPackageType.GUN_ROTATION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE,param1);
               break;
            case CrazyTankPackageType.FIRE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT,param1);
               break;
            case CrazyTankPackageType.SYNC_LIFETIME:
               QueueManager.setLifeTime(param1.readInt());
               break;
            case CrazyTankPackageType.MOVESTART:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE,param1);
               break;
            case CrazyTankPackageType.MOVESTOP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE,param1);
               break;
            case CrazyTankPackageType.TURN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE,param1);
               break;
            case CrazyTankPackageType.HEALTH:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD,param1);
               break;
            case CrazyTankPackageType.FROST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST,param1);
               break;
            case CrazyTankPackageType.NONOLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE,param1);
               break;
            case CrazyTankPackageType.CHANGE_STATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE,param1);
               break;
            case CrazyTankPackageType.PLAYER_PROPERTY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROPERTY,param1);
               break;
            case CrazyTankPackageType.INVINCIBLY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY,param1);
               break;
            case CrazyTankPackageType.VANE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE,param1);
               break;
            case CrazyTankPackageType.HIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE,param1);
               break;
            case CrazyTankPackageType.CARRY:
               break;
            case CrazyTankPackageType.BECKON:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON,param1);
               break;
            case CrazyTankPackageType.FIGHTPROP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP,param1);
               break;
            case CrazyTankPackageType.STUNT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT,param1);
               break;
            case CrazyTankPackageType.PROP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP,param1);
               break;
            case CrazyTankPackageType.DANDER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER,param1);
               break;
            case CrazyTankPackageType.REDUCE_DANDER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.REDUCE_DANDER,param1);
               break;
            case CrazyTankPackageType.LOAD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD,param1);
               break;
            case CrazyTankPackageType.ADDATTACK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK,param1);
               break;
            case CrazyTankPackageType.ADDBALL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL,param1);
               break;
            case CrazyTankPackageType.SHOOTSTRAIGHT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT,param1);
               break;
            case CrazyTankPackageType.SUICIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE,param1);
               break;
            case CrazyTankPackageType.FIRE_TAG:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,param1);
               break;
            case CrazyTankPackageType.CHANGE_BALL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL,param1);
               break;
            case CrazyTankPackageType.PICK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX,param1);
               break;
            case CrazyTankPackageType.BLAST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE,param1);
               break;
            case CrazyTankPackageType.BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT,param1);
               break;
            case CrazyTankPackageType.DISAPPEAR:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR,param1);
               break;
            case CrazyTankPackageType.TAKE_CARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT,param1);
               break;
            case CrazyTankPackageType.ADD_LIVING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING,param1);
               break;
            case CrazyTankPackageType.PLAY_MOVIE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE,param1);
               break;
            case CrazyTankPackageType.PLAY_SOUND:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND,param1);
               break;
            case CrazyTankPackageType.LOAD_RESOURCE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,param1);
               break;
            case CrazyTankPackageType.ADD_MAP_THINGS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS,param1);
               break;
            case CrazyTankPackageType.LIVING_BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT,param1);
               break;
            case CrazyTankPackageType.LIVING_FALLING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING,param1);
               break;
            case CrazyTankPackageType.LIVING_JUMP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP,param1);
               break;
            case CrazyTankPackageType.LIVING_MOVETO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO,param1);
               break;
            case CrazyTankPackageType.LIVING_SAY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY,param1);
               break;
            case CrazyTankPackageType.LIVING_RANGEATTACKING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING,param1);
               break;
            case CrazyTankPackageType.SHOW_CARDS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS,param1);
               break;
            case CrazyTankPackageType.FOCUS_ON_OBJECT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT,param1);
               break;
            case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,param1);
               break;
            case CrazyTankPackageType.PLAY_INFO_IN_GAME:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,param1);
               QueueManager.setLifeTime(param1.extend2);
               break;
            case CrazyTankPackageType.GAME_ROOM_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO,param1);
               break;
            case CrazyTankPackageType.ADD_TIP_LAYER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER,param1);
               break;
            case CrazyTankPackageType.PLAY_ASIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE,param1);
               break;
            case CrazyTankPackageType.FORBID_DRAG:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG,param1);
               break;
            case CrazyTankPackageType.TOP_LAYER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER,param1);
               break;
            case CrazyTankPackageType.CONTROL_BGM:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM,param1);
               break;
            case CrazyTankPackageType.USE_DEPUTY_WEAPON:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,param1);
               break;
            case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,param1);
               break;
            case CrazyTankPackageType.POPUP_QUESTION_FRAME:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,param1);
               break;
            case CrazyTankPackageType.PASS_STORY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,param1);
               break;
            case CrazyTankPackageType.LIVING_BOLTMOVE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE,param1));
               break;
            case CrazyTankPackageType.CHANGE_TARGET:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET,param1);
               break;
            case CrazyTankPackageType.LIVING_SHOW_BLOOD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,param1);
               break;
            case CrazyTankPackageType.TEMP_STYLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_STYLE,param1);
               break;
            case CrazyTankPackageType.ACTION_MAPPING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTION_MAPPING,param1);
               break;
            case CrazyTankPackageType.FIGHT_ACHIEVEMENT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,param1);
               break;
            case CrazyTankPackageType.APPLYSKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.APPLYSKILL,param1);
               break;
            case CrazyTankPackageType.REMOVESKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.REMOVESKILL,param1);
               break;
            case CrazyTankPackageType.MAXFORCE_CHANGED:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGEMAXFORCE,param1);
               break;
            case CrazyTankPackageType.WIND_PIC:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WINDPIC,param1);
               break;
            case CrazyTankPackageType.SYSMESSAGE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAMESYSMESSAGE,param1);
               break;
            case CrazyTankPackageType.LIVING_CHAGEANGLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_CHAGEANGLE,param1);
               break;
            case CrazyTankPackageType.PET_SKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_PET_SKILL,param1);
               break;
            case CrazyTankPackageType.PET_BUFF:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BUFF,param1);
               break;
            case CrazyTankPackageType.PET_BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BEAT,param1);
               break;
            case CrazyTankPackageType.PET_SKILL_CD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_SKILL_CD,param1);
               break;
            case CrazyTankPackageType.ROUND_ONE_END:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ROUND_ONE_END,param1);
               break;
            case CrazyTankPackageType.SKIPNEXT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SKIPNEXT,param1);
         }
         if(_loc3_)
         {
            QueueManager.addQueue(_loc3_);
         }
      }
   }
}
