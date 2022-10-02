package cardSystem.analyze
{
   import cardSystem.data.SetsInfo;
   import com.pickgliss.loader.DataAnalyzer;
   
   public class SetsSortRuleAnalyzer extends DataAnalyzer
   {
       
      
      public var setsVector:Vector.<SetsInfo>;
      
      public function SetsSortRuleAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:SetsInfo = null;
         var _loc6_:int = 0;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         this.setsVector = new Vector.<SetsInfo>();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new SetsInfo();
               _loc5_.ID = _loc3_[_loc4_].@ID;
               _loc5_.name = _loc3_[_loc4_].@Name;
               _loc5_.storyDescript = _loc3_[_loc4_].@Description;
               _loc6_ = parseInt(_loc3_[_loc4_].@SuitID) - 1;
               _loc7_ = _loc3_[_loc4_]..Card;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length())
               {
                  if(_loc7_[_loc8_].@ID != "0")
                  {
                     _loc5_.cardIdVec.push(parseInt(_loc7_[_loc8_].@ID));
                  }
                  _loc8_++;
               }
               this.setsVector.push(_loc5_);
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
