package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.BadgeInfo;
   import flash.utils.Dictionary;
   
   public class BadgeInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function BadgeInfoAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:BadgeInfo = null;
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         var _loc4_:int = _loc3_.length();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new BadgeInfo();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
            this.list[_loc6_.BadgeID] = _loc6_;
            _loc5_++;
         }
         onAnalyzeComplete();
      }
   }
}
