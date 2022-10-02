package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.StringUtils;
   import flash.utils.Dictionary;
   
   public class LanguageAnalyzer extends DataAnalyzer
   {
       
      
      public var languages:Dictionary;
      
      public function LanguageAnalyzer(param1:Function)
      {
         this.languages = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:Array = String(param1).split("\r\n");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.indexOf("#") != 0)
            {
               _loc4_ = _loc4_.replace("\\r","\r");
               _loc4_ = _loc4_.replace("\\n","\n");
               _loc5_ = _loc4_.indexOf(":");
               if(_loc5_ != -1)
               {
                  _loc6_ = _loc4_.substring(0,_loc5_);
                  _loc7_ = _loc4_.substr(_loc5_ + 1);
                  _loc7_ = _loc7_.split("##")[0];
                  this.languages[_loc6_] = StringUtils.trimRight(_loc7_);
                  onAnalyzeComplete();
               }
            }
            _loc3_++;
         }
      }
   }
}
