package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.LikeFriendInfo;
   
   public class LikeFriendAnalyzer extends DataAnalyzer
   {
       
      
      public var likeFriendList:Array;
      
      public function LikeFriendAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:LikeFriendInfo = null;
         this.likeFriendList = new Array();
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         if(_loc2_.@value == "true")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new LikeFriendInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.likeFriendList.push(_loc5_);
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
