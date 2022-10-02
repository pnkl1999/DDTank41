package labyrinth.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class LabyrinthModel extends EventDispatcher
   {
       
      
      private var _myProgress:int;
      
      private var _myRanking:int;
      
      private var _completeChallenge:Boolean;
      
      private var _isDoubleAward:Boolean = true;
      
      private var _rankingList:Array;
      
      private var _currentFloor:int;
      
      private var _accumulateExp:int;
      
      private var _cleanOutInfos:DictionaryData;
      
      private var _remainTime:int;
      
      private var _currentRemainTime:int;
      
      private var _cleanOutAllTime:int;
      
      private var _cleanOutGold:int;
      
      private var _tryAgainComplete:Boolean;
      
      private var _isInGame:Boolean;
      
      private var _isCleanOut:Boolean;
      
      private var _serverMultiplyingPower:Boolean;
      
      public function LabyrinthModel(param1:IEventDispatcher = null)
      {
         this._cleanOutInfos = new DictionaryData();
         super(param1);
      }
      
      public function get myRanking() : int
      {
         return this._myRanking;
      }
      
      public function set myRanking(param1:int) : void
      {
         this._myRanking = param1;
      }
      
      public function get myProgress() : int
      {
         return this._myProgress;
      }
      
      public function set myProgress(param1:int) : void
      {
         this._myProgress = param1;
      }
      
      public function get completeChallenge() : Boolean
      {
         return this._completeChallenge;
      }
      
      public function set completeChallenge(param1:Boolean) : void
      {
         this._completeChallenge = param1;
      }
      
      public function get isDoubleAward() : Boolean
      {
         return this._isDoubleAward;
      }
      
      public function set isDoubleAward(param1:Boolean) : void
      {
         this._isDoubleAward = param1;
      }
      
      public function get rankingList() : Array
      {
         return this._rankingList;
      }
      
      public function set rankingList(param1:Array) : void
      {
         this._rankingList = param1;
      }
      
      public function get currentFloor() : int
      {
         return this._currentFloor;
      }
      
      public function set currentFloor(param1:int) : void
      {
         this._currentFloor = param1;
      }
      
      public function get accumulateExp() : int
      {
         return this._accumulateExp;
      }
      
      public function set accumulateExp(param1:int) : void
      {
         this._accumulateExp = param1;
      }
      
      public function get cleanOutInfos() : DictionaryData
      {
         return this._cleanOutInfos;
      }
      
      public function set cleanOutInfos(param1:DictionaryData) : void
      {
         this._cleanOutInfos = param1;
      }
      
      public function get remainTime() : int
      {
         return this._remainTime;
      }
      
      public function set remainTime(param1:int) : void
      {
         this._remainTime = param1;
      }
      
      public function get cleanOutAllTime() : int
      {
         return this._cleanOutAllTime;
      }
      
      public function set cleanOutAllTime(param1:int) : void
      {
         this._cleanOutAllTime = param1;
      }
      
      public function get cleanOutGold() : int
      {
         return this._cleanOutGold;
      }
      
      public function set cleanOutGold(param1:int) : void
      {
         this._cleanOutGold = param1;
      }
      
      public function get currentRemainTime() : int
      {
         return this._currentRemainTime;
      }
      
      public function set currentRemainTime(param1:int) : void
      {
         this._currentRemainTime = param1;
      }
      
      public function get tryAgainComplete() : Boolean
      {
         return this._tryAgainComplete;
      }
      
      public function set tryAgainComplete(param1:Boolean) : void
      {
         this._tryAgainComplete = param1;
      }
      
      public function get isInGame() : Boolean
      {
         return this._isInGame;
      }
      
      public function set isInGame(param1:Boolean) : void
      {
         this._isInGame = param1;
      }
      
      public function get isCleanOut() : Boolean
      {
         return this._isCleanOut;
      }
      
      public function set isCleanOut(param1:Boolean) : void
      {
         this._isCleanOut = param1;
      }
      
      public function get serverMultiplyingPower() : Boolean
      {
         return this._serverMultiplyingPower;
      }
      
      public function set serverMultiplyingPower(param1:Boolean) : void
      {
         this._serverMultiplyingPower = param1;
      }
   }
}
