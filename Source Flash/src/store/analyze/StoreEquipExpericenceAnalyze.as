package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class StoreEquipExpericenceAnalyze extends DataAnalyzer
   {
       
      
      public var expericence:Array;
      
      public var necklaceStrengthExpList:DictionaryData;
      
      public var necklaceStrengthPlusList:DictionaryData;
      
      public function StoreEquipExpericenceAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:XML = new XML(param1);
         this.expericence = [];
         this.necklaceStrengthExpList = new DictionaryData();
         this.necklaceStrengthPlusList = new DictionaryData();
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               this.expericence[_loc3_] = int(_loc2_[_loc3_].@Exp);
               _loc4_ = int(_loc2_[_loc3_].@NecklaceStrengthExp);
               _loc5_ = int(_loc2_[_loc3_].@NecklaceStrengthPlus);
               this.necklaceStrengthExpList.add(_loc3_,_loc4_);
               this.necklaceStrengthPlusList.add(_loc3_,_loc5_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
