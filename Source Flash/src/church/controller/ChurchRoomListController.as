package church.controller
{
   import church.model.ChurchRoomListModel;
   import church.view.ChurchMainView;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ChurchRoomListController extends BaseStateView
   {
      
      public static const UNMARRY:String = "unmarry";
       
      
      private var _model:ChurchRoomListModel;
      
      private var _view:ChurchMainView;
      
      private var _mapSrcLoaded:Boolean = false;
      
      private var _mapServerReady:Boolean = false;
      
      public function ChurchRoomListController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         this.addEvent();
         MainToolBar.Instance.show();
         SoundManager.instance.playMusic("062");
      }
      
      private function init() : void
      {
         this._model = new ChurchRoomListModel();
         this._view = new ChurchMainView(this,this._model);
         this._view.show();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      private function __addRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:SelfInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(!_loc3_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.addRoom"));
            return;
         }
         var _loc4_:ChurchRoomInfo = new ChurchRoomInfo();
         _loc4_.id = _loc2_.readInt();
         _loc4_.isStarted = _loc2_.readBoolean();
         _loc4_.roomName = _loc2_.readUTF();
         _loc4_.isLocked = _loc2_.readBoolean();
         _loc4_.mapID = _loc2_.readInt();
         _loc4_.valideTimes = _loc2_.readInt();
         _loc4_.currentNum = _loc2_.readInt();
         _loc4_.createID = _loc2_.readInt();
         _loc4_.createName = _loc2_.readUTF();
         _loc4_.groomID = _loc2_.readInt();
         _loc4_.groomName = _loc2_.readUTF();
         _loc4_.brideID = _loc2_.readInt();
         _loc4_.brideName = _loc2_.readUTF();
         _loc4_.creactTime = _loc2_.readDate();
         var _loc5_:int = _loc2_.readByte();
         if(_loc5_ == 1)
         {
            _loc4_.status = ChurchRoomInfo.WEDDING_NONE;
         }
         else
         {
            _loc4_.status = ChurchRoomInfo.WEDDING_ING;
         }
         if(PathManager.solveExternalInterfaceEnabel())
         {
            _loc6_ = PlayerManager.Instance.Self;
            ExternalInterfaceManager.sendToAgent(8,_loc6_.ID,_loc6_.NickName,ServerManager.Instance.zoneName,-1,"",_loc6_.SpouseName);
         }
         _loc4_.discription = _loc2_.readUTF();
         this._model.addRoom(_loc4_);
      }
      
      private function __removeRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         this._model.removeRoom(_loc2_);
      }
      
      private function __updateRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:ChurchRoomInfo = null;
         var _loc5_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = new ChurchRoomInfo();
            _loc4_.id = _loc2_.readInt();
            _loc4_.isStarted = _loc2_.readBoolean();
            _loc4_.roomName = _loc2_.readUTF();
            _loc4_.isLocked = _loc2_.readBoolean();
            _loc4_.mapID = _loc2_.readInt();
            _loc4_.valideTimes = _loc2_.readInt();
            _loc4_.currentNum = _loc2_.readInt();
            _loc4_.createID = _loc2_.readInt();
            _loc4_.createName = _loc2_.readUTF();
            _loc4_.groomID = _loc2_.readInt();
            _loc4_.groomName = _loc2_.readUTF();
            _loc4_.brideID = _loc2_.readInt();
            _loc4_.brideName = _loc2_.readUTF();
            _loc4_.creactTime = _loc2_.readDate();
            _loc5_ = _loc2_.readByte();
            if(_loc5_ == 1)
            {
               _loc4_.status = ChurchRoomInfo.WEDDING_NONE;
            }
            else
            {
               _loc4_.status = ChurchRoomInfo.WEDDING_ING;
            }
            _loc4_.discription = _loc2_.readUTF();
            this._model.updateRoom(_loc4_);
         }
      }
      
      public function createRoom(param1:ChurchRoomInfo) : void
      {
         if(ChurchManager.instance.selfRoom)
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
         }
         SocketManager.Instance.out.sendCreateRoom(param1.roomName,!!Boolean(param1.password) ? param1.password : "",param1.mapID,param1.valideTimes,param1.canInvite,param1.discription);
      }
      
      public function unmarry(param1:Boolean = false) : void
      {
         if(ChurchManager.instance._selfRoom)
         {
            if(ChurchManager.instance._selfRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
               SocketManager.Instance.out.sendUnmarry(true);
               SocketManager.Instance.out.sendUnmarry(param1);
               if(this._model && ChurchManager.instance._selfRoom)
               {
                  this._model.removeRoom(ChurchManager.instance._selfRoom.id);
               }
               dispatchEvent(new Event(UNMARRY));
               return;
            }
         }
         SocketManager.Instance.out.sendUnmarry(param1);
         if(this._model && ChurchManager.instance._selfRoom)
         {
            this._model.removeRoom(ChurchManager.instance._selfRoom.id);
         }
         dispatchEvent(new Event(UNMARRY));
      }
      
      public function changeViewState(param1:String) : void
      {
         this._view.changeState(param1);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         SocketManager.Instance.out.sendExitMarryRoom();
         MainToolBar.Instance.backFunction = null;
         MainToolBar.Instance.hide();
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.CHURCH_ROOM_LIST;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._model)
         {
            this._model.dispose();
         }
         this._model = null;
         if(this._view)
         {
            if(this._view.parent)
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.dispose();
         }
         this._view = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
