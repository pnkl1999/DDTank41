package ddt.manager
{
   import ddt.data.Experience;
   import ddt.data.HotSpringRoomInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hotSpring.event.HotSpringRoomEvent;
   import road7th.comm.PackageIn;
   
   public class HotSpringManager extends EventDispatcher
   {
      
      private static var _instance:HotSpringManager;
       
      
      private var _roomCurrently:HotSpringRoomInfo;
      
      private var _playerEffectiveTime:int;
      
      private var _playerEnterRoomTime:Date;
      
      public var messageTip:String;
      
      private var _isRemoveLoading:Boolean = true;
      
      public function HotSpringManager()
      {
         super();
      }
      
      public static function get instance() : HotSpringManager
      {
         if(!_instance)
         {
            _instance = new HotSpringManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,this.roomEnterSucceed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,this.roomPlayerRemove);
      }
      
      public function roomPlayerRemove(param1:CrazyTankSocketEvent = null) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         this.roomCurrently = null;
         if(PlayerManager.Instance.Self.Grade < Experience.MAX_LEVEL)
         {
            if(_loc3_ && _loc3_ != "" && _loc3_.length > 0)
            {
               ChatManager.Instance.sysChatYellow(_loc3_);
               MessageTipManager.getInstance().show(_loc3_);
            }
         }
         if(this.messageTip && this.messageTip != "" && this.messageTip.length > 0)
         {
            ChatManager.Instance.sysChatYellow(this.messageTip);
            MessageTipManager.getInstance().show(this.messageTip);
         }
         dispatchEvent(new HotSpringRoomEvent(HotSpringRoomEvent.ROOM_PLAYER_REMOVE,PlayerManager.Instance.Self.ID));
      }
      
      public function get roomCurrently() : HotSpringRoomInfo
      {
         return this._roomCurrently;
      }
      
      public function set roomCurrently(param1:HotSpringRoomInfo) : void
      {
         if(param1 && (!this._roomCurrently || this._roomCurrently.roomID != param1.roomID))
         {
            this._roomCurrently = param1;
            this.roomEnter();
            return;
         }
         this._roomCurrently = param1;
      }
      
      private function roomEnterSucceed(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:HotSpringRoomInfo = new HotSpringRoomInfo();
         _loc3_.roomID = _loc2_.readInt();
         _loc3_.roomNumber = _loc2_.readInt();
         _loc3_.roomName = _loc2_.readUTF();
         _loc3_.roomPassword = _loc2_.readUTF();
         _loc3_.effectiveTime = _loc2_.readInt();
         _loc3_.curCount = _loc2_.readInt();
         _loc3_.playerID = _loc2_.readInt();
         _loc3_.playerName = _loc2_.readUTF();
         _loc3_.startTime = _loc2_.readDate();
         _loc3_.roomIntroduction = _loc2_.readUTF();
         _loc3_.roomType = _loc2_.readInt();
         _loc3_.maxCount = _loc2_.readInt();
         this._playerEnterRoomTime = _loc2_.readDate();
         this._playerEffectiveTime = _loc2_.readInt();
         this.roomCurrently = _loc3_;
      }
      
      private function roomEnter() : void
      {
         if(StateManager.getState(StateType.HOT_SPRING_ROOM) == null)
         {
            this._isRemoveLoading = false;
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsClose);
         }
         StateManager.setState(StateType.HOT_SPRING_ROOM);
      }
      
      private function __loadingIsClose(param1:Event) : void
      {
         this._isRemoveLoading = true;
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         SocketManager.Instance.out.sendHotSpringRoomPlayerRemove();
      }
      
      public function removeLoadingEvent() : void
      {
         if(!this._isRemoveLoading)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         }
      }
      
      public function get playerEffectiveTime() : int
      {
         return this._playerEffectiveTime;
      }
      
      public function set playerEffectiveTime(param1:int) : void
      {
         this._playerEffectiveTime = param1;
      }
      
      public function get playerEnterRoomTime() : Date
      {
         return this._playerEnterRoomTime;
      }
      
      public function set playerEnterRoomTime(param1:Date) : void
      {
         this._playerEnterRoomTime = param1;
      }
   }
}
