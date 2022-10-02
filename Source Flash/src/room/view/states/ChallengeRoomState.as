package room.view.states
{
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import room.RoomManager;
   import room.view.roomView.ChallengeRoomView;
   
   public class ChallengeRoomState extends BaseRoomState
   {
       
      
      public function ChallengeRoomState()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         _roomView = new ChallengeRoomView(RoomManager.Instance.current);
         addChild(_roomView);
         ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
         if(RoomManager.Instance.haveTempInventPlayer())
         {
            GameInSocketOut.sendInviteGame(RoomManager.Instance.tempInventPlayerID);
            RoomManager.Instance.tempInventPlayerID = -1;
         }
         super.enter(param1,param2);
      }
      
      override public function getType() : String
      {
         return StateType.CHALLENGE_ROOM;
      }
      
      override public function getBackType() : String
      {
         return StateType.ROOM_LIST;
      }
   }
}
