package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.CMFriendInfo;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class LoadCMFriendList extends DataAnalyzer
   {
       
      
      public function LoadCMFriendList(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:int = 0;
         var _loc6_:CMFriendInfo = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc2_:DictionaryData = new DictionaryData();
         var _loc3_:XML = new XML(param1);
         var _loc4_:XMLList = _loc3_..Item;
         if(_loc3_.@value == "true")
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length())
            {
               _loc6_ = new CMFriendInfo();
               _loc6_.NickName = _loc4_[_loc5_].@NickName;
               _loc6_.UserName = _loc4_[_loc5_].@UserName;
               _loc6_.UserId = _loc4_[_loc5_].@UserId;
               _loc6_.Photo = _loc4_[_loc5_].@Photo;
               _loc6_.PersonWeb = _loc4_[_loc5_].@PersonWeb;
               _loc6_.OtherName = _loc4_[_loc5_].@OtherName;
               _loc6_.level = _loc4_[_loc5_].@Level;
               _loc7_ = _loc4_[_loc5_].@Sex;
               if(_loc7_ == 0)
               {
                  _loc6_.sex = false;
               }
               else
               {
                  _loc6_.sex = true;
               }
               _loc8_ = _loc4_[_loc5_].@IsExist;
               if(_loc8_ == "true")
               {
                  _loc6_.IsExist = true;
               }
               else
               {
                  _loc6_.IsExist = false;
               }
               if(!(_loc6_.IsExist && PlayerManager.Instance.friendList[_loc6_.UserId]))
               {
                  _loc2_.add(_loc6_.UserName,_loc6_);
               }
               _loc5_++;
            }
            PlayerManager.Instance.CMFriendList = _loc2_;
            onAnalyzeComplete();
         }
         else
         {
            message = _loc3_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
