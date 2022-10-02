package lottery.data
{
   public class LotteryModel
   {
      
      private static var _cardLotteryMoney:Number = 200;
       
      
      private var _cardLimit:int;
      
      private var _currentCardTimes:int;
      
      private var _luckyLimit:int;
      
      private var _currentLukcyTimes:int;
      
      public function LotteryModel()
      {
         super();
      }
      
      public static function get cardLotteryMoney() : Number
      {
         return _cardLotteryMoney;
      }
      
      public static function set cardLotteryMoney(param1:Number) : void
      {
         _cardLotteryMoney = param1;
      }
   }
}
