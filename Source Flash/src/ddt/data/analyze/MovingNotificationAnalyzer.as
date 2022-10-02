package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class MovingNotificationAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function MovingNotificationAnalyzer(param1:Function)
      {
         this.list = [];
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this.list = String(param1).split("\r\n");
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_] = this.list[_loc2_].replace("\\r","\r");
            this.list[_loc2_] = this.list[_loc2_].replace("\\n","\n");
            _loc2_++;
         }
         onAnalyzeComplete();
      }
   }
}
