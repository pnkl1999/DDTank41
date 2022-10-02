package accumulativeLogin
{
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class AccumulativeLoginAnalyer extends DataAnalyzer
   {
       
      
      private var _accumulativeloginDataDic:Dictionary;
      
      public function AccumulativeLoginAnalyer(param1:Function)
      {
         super(param1);
         this._accumulativeloginDataDic = new Dictionary();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:AccumulativeLoginRewardData = null;
         var _loc7_:AccumulativeLoginRewardData = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc7_ = new AccumulativeLoginRewardData();
               ObjectUtils.copyPorpertiesByXML(_loc7_,_loc3_[_loc5_]);
               _loc4_.push(_loc7_);
               _loc5_++;
            }
            for each(_loc6_ in _loc4_)
            {
               if(!this._accumulativeloginDataDic[_loc6_.Count])
               {
                  this._accumulativeloginDataDic[_loc6_.Count] = new Array();
               }
               this._accumulativeloginDataDic[_loc6_.Count].push(_loc6_);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get accumulativeloginDataDic() : Dictionary
      {
         return this._accumulativeloginDataDic;
      }
   }
}
