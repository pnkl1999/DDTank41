package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class MyAcademyPlayersAnalyze extends DataAnalyzer
   {
       
      
      public var myAcademyPlayers:DictionaryData;
      
      public function MyAcademyPlayersAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:FriendListPlayer = null;
         var _loc6_:PlayerState = null;
         var _loc7_:String = null;
         var _loc2_:XML = new XML(param1);
         this.myAcademyPlayers = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new FriendListPlayer();
               _loc5_.ID = _loc3_[_loc4_].@UserID;
               _loc6_ = new PlayerState(int(_loc3_[_loc4_].@State));
               _loc5_.playerState = _loc6_;
               _loc5_.apprenticeshipState = _loc3_[_loc4_].@ApprenticeshipState;
               _loc5_.IsMarried = _loc3_[_loc4_].@IsMarried;
               _loc7_ = _loc3_[_loc4_].@LastDate;
               _loc5_.lastDate = DateUtils.dealWithStringDate(_loc7_);
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.myAcademyPlayers.add(_loc5_.ID,_loc5_);
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
