package socialContact.friendBirthday
{
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import road7th.data.DictionaryData;
   
   public class FriendBirthdayManager
   {
      
      private static var _instance:FriendBirthdayManager;
       
      
      private const INTERVAL:int = 86400;
      
      private var _friendName:String;
      
      public function FriendBirthdayManager()
      {
         super();
      }
      
      public static function get Instance() : FriendBirthdayManager
      {
         if(_instance == null)
         {
            _instance = new FriendBirthdayManager();
         }
         return _instance;
      }
      
      public function findFriendBirthday() : void
      {
         var _loc3_:* = null;
         var _loc4_:FriendListPlayer = null;
         var _loc1_:Vector.<FriendListPlayer> = new Vector.<FriendListPlayer>();
         var _loc2_:DictionaryData = PlayerManager.Instance.friendList;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_] as FriendListPlayer;
            if(_loc4_.BirthdayDate && this._countBrithday(_loc4_.BirthdayDate) && this._countNameInShare(_loc4_.NickName))
            {
               _loc1_.push(_loc4_);
               SharedManager.Instance.friendBrithdayName = SharedManager.Instance.friendBrithdayName + "," + _loc4_.NickName;
               SharedManager.Instance.save();
            }
         }
         if(_loc1_.length > 0)
         {
            this._sendMySelfEmail(_loc1_);
         }
      }
      
      private function _countBrithday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date();
         var _loc3_:Boolean = false;
         if(_loc2_.monthUTC == param1.monthUTC && param1.dateUTC - _loc2_.dateUTC <= 1 && param1.dateUTC - _loc2_.dateUTC > -1)
         {
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function _sendMySelfEmail(param1:Vector.<FriendListPlayer>) : void
      {
         SocketManager.Instance.out.sendWithBrithday(param1);
      }
      
      public function set friendName(param1:String) : void
      {
         this._friendName = param1;
      }
      
      public function get friendName() : String
      {
         return this._friendName;
      }
      
      private function _countNameInShare(param1:String) : Boolean
      {
         var _loc2_:Array = SharedManager.Instance.friendBrithdayName.split(/,/);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
   }
}
