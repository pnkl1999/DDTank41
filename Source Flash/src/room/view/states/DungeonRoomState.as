package room.view.states
{
   import ddt.manager.GameInSocketOut;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.roomView.DungeonRoomView;
   
   public class DungeonRoomState extends BaseRoomState
   {
       
      
      public function DungeonRoomState()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         _roomView = new DungeonRoomView(RoomManager.Instance.current);
         addChild(_roomView);
         super.enter(param1,param2);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         if(_info && _info.selfRoomPlayer.isHost)
         {
            if(RoomManager.Instance.current.isOpenBoss)
            {
               GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,true,_info.roomPass,_info.roomName,1,_info.hardLevel,0,false,_info.mapId);
            }
            else
            {
               GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,false,_info.roomPass,_info.roomName,1,0,0,false,0);
            }
         }
         super.leaving(param1);
      }
      
      override public function getType() : String
      {
         return StateType.DUNGEON_ROOM;
      }
      
      override public function getBackType() : String
      {
         return StateType.DUNGEON_LIST;
      }
   }
}
