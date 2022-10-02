package ddt.data.quest
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.ConsortiaEventInfo;
   
   public class ConsortiaEventListAnayler extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function ConsortiaEventListAnayler(param1:Function = null)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ConsortiaEventInfo = null;
         this.list = new Array();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortiaEventInfo();
               _loc5_.ID = _loc3_[_loc4_].@ID;
               _loc5_.ConsortiaID = _loc3_[_loc4_].@ConsortiaID;
               _loc5_.Date = _loc3_[_loc4_].@Date;
               _loc5_.Type = _loc3_[_loc4_].@Type;
               _loc5_.NickName = _loc3_[_loc4_].@NickName;
               _loc5_.EventValue = _loc3_[_loc4_].@EventValue;
               _loc5_.ManagerName = _loc3_[_loc4_].@ManagerName;
               this.list.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
