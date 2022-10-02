package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import road7th.data.DictionaryData;
   
   public class RecentContactsAnalyze extends DataAnalyzer
   {
       
      
      public var recentContacts:DictionaryData;
      
      public function RecentContactsAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:FriendListPlayer = null;
         var _loc6_:PlayerState = null;
         var _loc2_:XML = new XML(param1);
         this.recentContacts = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = new PlayerState(int(_loc2_.Item[_loc4_].@State));
               _loc5_.playerState = _loc6_;
               this.recentContacts.add(_loc5_.ID,_loc5_);
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
