package ddt.view.chat
{
   import ddt.utils.Helpers;
   
   public class ChatData
   {
      
      public static const B_BUGGLE_TYPE_NORMAL:uint = 0;
      
      public static const BUGLE_ANIMATION:String = "bugleAnimation";
       
      
      public var channel:uint;
      
      public var htmlMessage:String = "";
      
      public var msg:String = "";
      
      private var _receiver:String = "";
      
      public var receiverID:int;
      
      public var sender:String = "";
      
      public var isAutoReply:Boolean = false;
      
      public var senderID:int;
      
      public var zoneID:int = -1;
      
      public var zoneName:String = "";
      
      public var type:int = -1;
      
      public var bigBuggleType:uint = 0;
      
      public var link:Array;
      
      public function ChatData()
      {
         super();
      }
      
      public function set receiver(param1:String) : void
      {
         this._receiver = param1;
      }
      
      public function get receiver() : String
      {
         return this._receiver;
      }
      
      public function clone() : ChatData
      {
         var _loc1_:ChatData = new ChatData();
         Helpers.copyProperty(this,_loc1_,["channel","htmlMessage","msg","receiver","receiverID","sender","senderID","zoneID","type"]);
         _loc1_.link = new Array().concat(this.link);
         return _loc1_;
      }
   }
}
