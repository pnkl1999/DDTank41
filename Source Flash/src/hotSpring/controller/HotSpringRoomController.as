package hotSpring.controller
{
   import ddt.data.HotSpringRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.HotSpringManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hotSpring.model.HotSpringRoomModel;
   import hotSpring.view.HotSpringRoomView;
   import hotSpring.vo.PlayerVO;
   import road7th.comm.PackageIn;
   
   public class HotSpringRoomController extends BaseStateView
   {
       
      
      private var _model:HotSpringRoomModel;
      
      private var _view:HotSpringRoomView;
      
      private var _isActive:Boolean = true;
      
      private var _messageTip:String;
      
      public function HotSpringRoomController()
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
         HotSpringManager.instance.removeLoadingEvent();
         this._model = HotSpringRoomModel.Instance;
         if(this._view)
         {
            this._view.hide();
            this._view.dispose();
         }
         this._view = null;
         this._view = new HotSpringRoomView(this,this._model);
         this._view.show();
         graphics.beginFill(0);
         graphics.drawRect(0,0,1000,600);
         graphics.endFill();
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,this.roomAddOrUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,this.roomPlayerAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,this.roomPlayerRemoveNotice);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,this.roomPlayerTargetPoint);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINU_BY_MONEY_SUCCESS,this.updateTime);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,this.roomAddOrUpdate);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,this.roomPlayerAdd);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,this.roomPlayerRemoveNotice);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,this.roomPlayerTargetPoint);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINU_BY_MONEY_SUCCESS,this.updateTime);
         removeEventListener(Event.ACTIVATE,this.__activeChange);
         removeEventListener(Event.DEACTIVATE,this.__activeChange);
         removeEventListener(MouseEvent.CLICK,this.__activeChange);
      }
      
      private function updateTime(event:CrazyTankSocketEvent) : void
      {
         this._view.updataRoomTime();
      }
      
      public function hotAddtime() : void
      {
         SocketManager.Instance.out.sendHotAddTime();
      }
      
      private function __activeChange(param1:Event) : void
      {
         if(param1.type == Event.DEACTIVATE)
         {
            this._isActive = false;
         }
         else
         {
            this._isActive = true;
         }
      }
      
      private function roomAddOrUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:HotSpringRoomInfo = new HotSpringRoomInfo();
         _loc3_.roomNumber = _loc2_.readInt();
         _loc3_.roomID = _loc2_.readInt();
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
         _loc3_.roomIsPassword = _loc3_.roomPassword != "" && _loc3_.roomPassword.length > 0;
         if(HotSpringManager.instance.roomCurrently && _loc3_.roomID == HotSpringManager.instance.roomCurrently.roomID)
         {
            HotSpringManager.instance.roomCurrently = _loc3_;
         }
      }
      
      private function roomPlayerAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:PlayerVO = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == PlayerManager.Instance.Self.ID)
         {
            _loc4_ = this._model.selfVO;
         }
         else
         {
            _loc4_ = new PlayerVO();
         }
         var _loc5_:PlayerInfo = PlayerManager.Instance.findPlayer(_loc3_);
         _loc5_.beginChanges();
         _loc5_.Grade = _loc2_.readInt();
         _loc5_.Hide = _loc2_.readInt();
         _loc5_.Repute = _loc2_.readInt();
         _loc5_.NickName = _loc2_.readUTF();
         _loc5_.typeVIP = _loc2_.readByte();
         _loc5_.VIPLevel = _loc2_.readInt();
         _loc5_.Sex = _loc2_.readBoolean();
         _loc5_.Style = _loc2_.readUTF();
         _loc5_.Colors = _loc2_.readUTF();
         _loc5_.Skin = _loc2_.readUTF();
         var _loc6_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         _loc5_.FightPower = _loc2_.readInt();
         _loc5_.WinCount = _loc2_.readInt();
         _loc5_.TotalCount = _loc2_.readInt();
         _loc4_.playerDirection = _loc2_.readInt();
         _loc5_.commitChanges();
         _loc4_.playerInfo = _loc5_;
         _loc4_.playerPos = _loc6_;
         if(_loc3_ == PlayerManager.Instance.Self.ID)
         {
            this._model.selfVO = _loc4_;
         }
         this._model.roomPlayerAddOrUpdate(_loc4_);
      }
      
      public function roomPlayerRemoveSend(param1:String = "") : void
      {
         HotSpringManager.instance.messageTip = param1;
         SocketManager.Instance.out.sendHotSpringRoomPlayerRemove();
      }
      
      private function roomPlayerRemoveNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._model.roomPlayerRemove(_loc3_);
      }
      
      public function roomPlayerTargetPointSend(param1:PlayerVO) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomPlayerTargetPoint(param1);
      }
      
      private function roomPlayerTargetPoint(param1:CrazyTankSocketEvent) : void
      {
         var _loc11_:Point = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:Array = _loc3_.split(",");
         var _loc8_:Array = [];
         var _loc9_:uint = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc11_ = new Point(_loc7_[_loc9_],_loc7_[_loc9_ + 1]);
            _loc8_.push(_loc11_);
            _loc9_ += 2;
         }
         var _loc10_:PlayerVO = this._model.roomPlayerList[_loc4_] as PlayerVO;
         if(!_loc10_)
         {
            return;
         }
         if(this._isActive)
         {
            _loc10_.currentWalkStartPoint = new Point(_loc5_,_loc6_);
            _loc10_.walkPath = _loc8_;
            this._model.roomPlayerAddOrUpdate(_loc10_);
         }
         else
         {
            _loc10_.playerPos = _loc8_.pop();
         }
      }
      
      public function roomRenewalFee(param1:HotSpringRoomInfo) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomRenewalFee(param1.roomID);
      }
      
      public function roomEdit(param1:HotSpringRoomInfo) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomEdit(param1);
      }
      
      public function roomPlayerContinue(param1:Boolean) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomPlayerContinue(param1);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.roomPlayerRemoveSend();
         this.dispose();
         super.leaving(param1);
      }
      
      override public function getBackType() : String
      {
         return StateType.HOT_SPRING_ROOM_LIST;
      }
      
      override public function getType() : String
      {
         return StateType.HOT_SPRING_ROOM;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._view)
         {
            this._view.hide();
            this._view.dispose();
         }
         this._view = null;
         if(this._model)
         {
            this._model.dispose();
         }
         this._model = null;
      }
   }
}
