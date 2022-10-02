package ddt.utils
{
   import ddt.view.chat.chat_system;
   import flash.utils.ByteArray;
   
   public class ChatHelper
   {
       
      
      public function ChatHelper()
      {
         super();
      }
      
      chat_system static function readGoodsLinks(param1:ByteArray, param2:Boolean = false, param3:int = 0) : Array
      {
         var _loc7_:Object = null;
         var _loc4_:Array = [];
         var _loc5_:uint = param1.readUnsignedByte();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new Object();
            _loc7_.index = param1.readInt();
            _loc7_.TemplateID = param1.readInt();
            _loc7_.ItemID = param1.readInt();
            if(param2)
            {
               _loc7_.key = param1.readUTF();
            }
            _loc7_.type = param3;
            _loc4_.push(_loc7_);
            _loc6_++;
         }
         return _loc4_;
      }
   }
}
