package eliteGame.info
{
   public class EliteGameAllScoreRankInfo
   {
       
      
      public var lassUpdateTime:String;
      
      public var rank30_40:Vector.<EliteGameScroeRankInfo>;
      
      public var rank41_50:Vector.<EliteGameScroeRankInfo>;
      
      public function EliteGameAllScoreRankInfo()
      {
         super();
         this.rank30_40 = new Vector.<EliteGameScroeRankInfo>();
         this.rank41_50 = new Vector.<EliteGameScroeRankInfo>();
      }
   }
}
