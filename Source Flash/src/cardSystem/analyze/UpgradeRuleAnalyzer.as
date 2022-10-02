package cardSystem.analyze
{
   import cardSystem.data.SetsUpgradeRuleInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class UpgradeRuleAnalyzer extends DataAnalyzer
   {
       
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public function UpgradeRuleAnalyzer(param1:Function)
      {
         super(param1);
         this.upgradeRuleVec = new Vector.<SetsUpgradeRuleInfo>();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SetsUpgradeRuleInfo = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = _loc3_.length();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = new SetsUpgradeRuleInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               this.upgradeRuleVec.push(_loc6_);
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
