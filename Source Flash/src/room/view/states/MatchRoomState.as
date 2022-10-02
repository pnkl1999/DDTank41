package room.view.states
{
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import flash.events.Event;
   import room.RoomManager;
   import room.view.roomView.MatchRoomView;
   import trainer.data.Step;
   
   public class MatchRoomState extends BaseRoomState
   {
       
      
      public function MatchRoomState()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         _roomView = new MatchRoomView(RoomManager.Instance.current);
         addChild(_roomView);
         super.enter(param1,param2);
      }
      
      override protected function __startLoading(param1:Event) : void
      {
         super.__startLoading(param1);
         SocketManager.Instance.out.syncWeakStep(Step.CREATE_ROOM_TIP);
         SocketManager.Instance.out.syncWeakStep(Step.START_GAME_TIP);
      }
      
      override public function getType() : String
      {
         return StateType.MATCH_ROOM;
      }
      
      override public function getBackType() : String
      {
         return StateType.ROOM_LIST;
      }
   }
}
