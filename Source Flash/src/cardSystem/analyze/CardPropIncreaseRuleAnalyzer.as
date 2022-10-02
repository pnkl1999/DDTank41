package cardSystem.analyze
{
   import cardSystem.data.CardPropIncreaseInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class CardPropIncreaseRuleAnalyzer extends DataAnalyzer
   {
       
      
      private var _levelIncre:DictionaryData;
      
      public var propIncreaseDic:DictionaryData;
      
      public function CardPropIncreaseRuleAnalyzer(param1:Function)
      {
         super(param1);
         this.propIncreaseDic = new DictionaryData();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:CardPropIncreaseInfo = null;
         var _loc6_:String = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new CardPropIncreaseInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].@Id;
               if(this.propIncreaseDic[_loc6_] == null)
               {
                  this.propIncreaseDic[_loc6_] = new DictionaryData();
                  this.propIncreaseDic[_loc6_].add(_loc5_.Level,_loc5_);
               }
               else
               {
                  this.propIncreaseDic[_loc6_].add(_loc5_.Level,_loc5_);
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
   }
}
