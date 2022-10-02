package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import im.IMController;
   import im.info.CustomInfo;
   import road7th.data.DictionaryData;
   
   public class FriendListAnalyzer extends DataAnalyzer
   {
       
      
      public var customList:Vector.<CustomInfo>;
      
      public var friendlist:DictionaryData;
      
      public var blackList:DictionaryData;
      
      public function FriendListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         var _loc8_:CustomInfo = null;
         var _loc9_:CustomInfo = null;
         var _loc10_:FriendListPlayer = null;
         var _loc11_:PlayerState = null;
         var _loc12_:Array = null;
         var _loc2_:XML = new XML(param1);
         this.friendlist = new DictionaryData();
         this.blackList = new DictionaryData();
         this.customList = new Vector.<CustomInfo>();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..customList;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               if(_loc3_[_loc4_].@Name != "")
               {
                  _loc8_ = new CustomInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc8_,_loc3_[_loc4_]);
                  this.customList.push(_loc8_);
               }
               _loc4_++;
            }
            _loc5_ = 0;
            while(_loc5_ < this.customList.length)
            {
               if(this.customList[_loc5_].ID == 1)
               {
                  _loc9_ = this.customList[_loc5_];
                  this.customList.splice(_loc5_,1);
                  this.customList.push(_loc9_);
               }
               _loc5_++;
            }
            _loc6_ = _loc2_..Item;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length())
            {
               _loc10_ = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(_loc10_,_loc6_[_loc7_]);
               if(_loc10_.Birthday != "Null")
               {
                  _loc12_ = _loc10_.Birthday.split(/-/g);
                  _loc10_.BirthdayDate = new Date();
                  _loc10_.BirthdayDate.fullYearUTC = Number(_loc12_[0]);
                  _loc10_.BirthdayDate.monthUTC = Number(_loc12_[1]) - 1;
                  _loc10_.BirthdayDate.dateUTC = Number(_loc12_[2]);
               }
               _loc11_ = new PlayerState(int(_loc2_.Item[_loc7_].@State));
               _loc10_.playerState = _loc11_;
               _loc10_.apprenticeshipState = _loc2_.Item[_loc7_].@ApprenticeshipState;
               if(_loc10_.Relation != 1)
               {
                  this.friendlist.add(_loc10_.ID,_loc10_);
               }
               else
               {
                  this.blackList.add(_loc10_.ID,_loc10_);
               }
               _loc7_++;
            }
            if(PlayerManager.Instance.Self.IsFirst == 1 && PathManager.CommunityExist())
            {
               IMController.Instance.createConsortiaLoader();
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
