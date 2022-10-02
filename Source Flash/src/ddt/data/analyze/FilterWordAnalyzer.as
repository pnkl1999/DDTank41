package ddt.data.analyze
{
   import com.hurlant.util.Base64;
   import com.pickgliss.loader.DataAnalyzer;
   
   public class FilterWordAnalyzer extends DataAnalyzer
   {
       
      
      public var words:Array;
      
      public var serverWords:Array;
      
      public var unableChar:String;
      
      public function FilterWordAnalyzer(param1:Function)
      {
         this.words = [];
         this.serverWords = [];
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:String = Base64.decode(String(param1));
         var _loc3_:Array = _loc2_.toLocaleLowerCase().split("\n");
         if(_loc3_)
         {
            if(_loc3_[0])
            {
               this.unableChar = _loc3_[0];
            }
            if(_loc3_[1])
            {
               this.words = _loc3_[1].split("|");
            }
            if(_loc3_[2])
            {
               this.serverWords = _loc3_[2].split("|");
            }
         }
         onAnalyzeComplete();
      }
   }
}
