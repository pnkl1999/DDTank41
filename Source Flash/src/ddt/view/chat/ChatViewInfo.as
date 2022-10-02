package ddt.view.chat
{
   public class ChatViewInfo
   {
       
      
      public var inputVisible:Boolean = true;
      
      public var inputFaceEnabled:Boolean = false;
      
      public var inputVisibleSwitchEnabled:Boolean = false;
      
      public var inputX:int;
      
      public var inputY:int;
      
      public var outputIsLock:Boolean = false;
      
      public var outputLockEnabled:Boolean = false;
      
      public var outputBackground:int;
      
      public var outputContentFieldStyle:String;
      
      public var outputChannel:int = -1;
      
      public var outputX:int;
      
      public var outputY:int;
      
      public function ChatViewInfo()
      {
         this.outputContentFieldStyle = ChatOutputField.NORMAL_STYLE;
         super();
      }
   }
}
