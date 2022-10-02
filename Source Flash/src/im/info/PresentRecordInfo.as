package im.info
{
   import ddt.manager.PlayerManager;
   import road7th.utils.DateUtils;
   
   public class PresentRecordInfo
   {
      
      public static const SHOW:int = 0;
      
      public static const HIDE:int = 1;
      
      public static const UNREAD:int = 2;
       
      
      public var id:int;
      
      public var exist:int = 2;
      
      public var messages:Vector.<String>;
      
      public var recordMessage:Vector.<Object>;
      
      public function PresentRecordInfo()
      {
         super();
         this.messages = new Vector.<String>();
         this.recordMessage = new Vector.<Object>();
      }
      
      public function addMessage(param1:String, param2:Date, param3:String) : void
      {
         var _loc4_:String = DateUtils.dateFormat(param2);
         var _loc5_:String = "";
         if(param1 == PlayerManager.Instance.Self.NickName)
         {
            _loc5_ += "<FONT COLOR=\'#06f710\'>" + param1 + "   " + _loc4_.split(" ")[1] + "</FONT>\n";
         }
         else
         {
            _loc5_ += "<FONT COLOR=\'#ffff01\'>" + param1 + "   " + _loc4_.split(" ")[1] + "</FONT>\n";
         }
         _loc5_ += param3;
         this.messages.push(_loc5_);
         var _loc6_:String = "";
         if(param1 == PlayerManager.Instance.Self.NickName)
         {
            _loc6_ += "<FONT COLOR=\'#06f710\'>" + param1 + "   " + _loc4_ + "</FONT>\n";
         }
         else
         {
            _loc6_ += "<FONT COLOR=\'#ffff01\'>" + param1 + "   " + _loc4_ + "</FONT>\n";
         }
         _loc6_ += param3;
         this.recordMessage.push(_loc6_);
      }
      
      public function get lastMessage() : String
      {
         return this.messages[this.messages.length - 1];
      }
      
      public function get lastRecordMessage() : Object
      {
         return this.recordMessage[this.recordMessage.length - 1];
      }
   }
}
