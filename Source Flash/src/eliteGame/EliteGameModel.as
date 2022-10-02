package eliteGame
{
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameTopSixteenInfo;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class EliteGameModel extends EventDispatcher
   {
       
      
      public var selfRank:int;
      
      public var selfScore:int;
      
      private var _scoreRankInfo:EliteGameAllScoreRankInfo;
      
      public var topSixteen30_40:Vector.<EliteGameTopSixteenInfo>;
      
      public var paarungRound30_40:DictionaryData;
      
      public var topSixteen41_50:Vector.<EliteGameTopSixteenInfo>;
      
      public var paarungRound41_50:DictionaryData;
      
      public function EliteGameModel()
      {
         super();
      }
      
      public function get scoreRankInfo() : EliteGameAllScoreRankInfo
      {
         return this._scoreRankInfo;
      }
      
      public function set scoreRankInfo(param1:EliteGameAllScoreRankInfo) : void
      {
         this._scoreRankInfo = param1;
         dispatchEvent(new EliteGameEvent(EliteGameEvent.SCORERANK_DATAREADY));
      }
   }
}
