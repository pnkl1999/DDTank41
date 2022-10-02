package eliteGame.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameScroeRankInfo;
   
   public class EliteGameScoreRankAnalyer extends DataAnalyzer
   {
       
      
      public var scoreRankInfo:EliteGameAllScoreRankInfo;
      
      public function EliteGameScoreRankAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:XMLList = null;
         var _loc6_:Vector.<EliteGameScroeRankInfo> = null;
         var _loc7_:int = 0;
         var _loc8_:EliteGameScroeRankInfo = null;
         this.scoreRankInfo = new EliteGameAllScoreRankInfo();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.scoreRankInfo.lassUpdateTime = _loc2_.@lastUpdateTime;
            _loc3_ = _loc2_.ItemSet;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = _loc3_[_loc4_].Item;
               _loc6_ = new Vector.<EliteGameScroeRankInfo>();
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length())
               {
                  _loc8_ = new EliteGameScroeRankInfo();
                  _loc8_.nickName = _loc5_[_loc7_].@PlayerName;
                  _loc8_.rank = _loc5_[_loc7_].@PlayerRank;
                  _loc8_.scroe = _loc5_[_loc7_].@PlayerScore;
                  _loc6_.push(_loc8_);
                  _loc7_++;
               }
               _loc6_.sort(this.compare);
               if(_loc3_[_loc4_].@value == "1")
               {
                  this.scoreRankInfo.rank30_40 = _loc6_;
               }
               else
               {
                  this.scoreRankInfo.rank41_50 = _loc6_;
               }
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
      
      private function compare(param1:EliteGameScroeRankInfo, param2:EliteGameScroeRankInfo) : Number
      {
         return param1.rank > param2.rank ? Number(Number(1)) : (param1.rank == param2.rank ? Number(Number(0)) : Number(Number(-1)));
      }
   }
}
