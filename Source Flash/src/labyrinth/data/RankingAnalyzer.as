package labyrinth.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class RankingAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function RankingAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:RankingInfo = null;
         var _loc5_:int = 0;
         this.list = [];
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         if(_loc2_.@value == "true")
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc4_ = new RankingInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc3_[_loc5_]);
               this.list.push(_loc4_);
               _loc5_++;
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
