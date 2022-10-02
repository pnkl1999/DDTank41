package lottery.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.utils.StringHelper;
   
   public class LotteryResultAnalyzer extends DataAnalyzer
   {
       
      
      public var lotteryResultList:Vector.<LotteryCardResultVO>;
      
      public function LotteryResultAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:LotteryCardResultVO = null;
         var _loc6_:XMLList = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         this.lotteryResultList = new Vector.<LotteryCardResultVO>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_.WealthDivine;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new LotteryCardResultVO();
               _loc5_.resultIds = this.analyzeNumber(String(_loc3_[_loc4_].@num));
               if(_loc2_.page[_loc4_])
               {
                  _loc6_ = _loc2_.page[_loc4_].PlayerDivineNum;
                  _loc7_ = new Array();
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.length())
                  {
                     _loc7_ = _loc7_.concat(this.analyzeNumber(String(_loc6_[_loc8_].@num)));
                     _loc8_++;
                  }
                  _loc5_.selfChooseIds = _loc7_;
                  this.lotteryResultList.push(_loc5_);
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
      
      private function analyzeNumber(param1:String) : Array
      {
         if(StringHelper.isNullOrEmpty(param1))
         {
            return [];
         }
         var _loc2_:Array = param1.split(",");
         if(_loc2_.indexOf(0) > -1 || _loc2_.indexOf("0") > -1)
         {
            return [];
         }
         return _loc2_;
      }
   }
}
