package ddt.view.chat
{
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      
      public static const ADD_CHAT:String = "addChat";
      
      public static const CAN_SHOW_BUGGLE:String = "canShowBuggle";
      
      public static const CUSTOM_SET_PRIVATE_CHAT_TO:String = "customSetPrivateChatTo";
      
      public static const INPUT_CHANNEL_CHANNGED:String = "inputChannelChanged";
      
      public static const INPUT_TEXT_CHANGED:String = "inputTextChanged";
      
      public static const NICKNAME_CLICK_TO_OUTSIDE:String = "nicknameClickToOutside";
      
      public static const SCROLL_CHANG:String = "scrollChanged";
      
      public static const SHOW_FACE:String = "addFace";
      
      public static const DELETE:String = "delete";
      
      public static const SEND_CONSORTIA:String = "sendConsortia";
      
      public static const SET_FACECONTIANER_LOCTION:String = "setFacecontainerLoction";
       
      
      public var data:Object;
      
      public function ChatEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
      
      override public function clone() : Event
      {
         return new ChatEvent(type,this.data);
      }
   }
}
