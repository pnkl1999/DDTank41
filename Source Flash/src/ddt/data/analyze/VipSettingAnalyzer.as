package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import vip.data.VipSetting;
   
   public class VipSettingAnalyzer extends DataAnalyzer
   {
       
      
      public var VipSettings:Dictionary;
      
      public function VipSettingAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:VipSetting = null;
         var _loc6_:int = 0;
         var _loc2_:XML = new XML(param1);
         this.VipSettings = new Dictionary();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new VipSetting();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].@VIPLevel;
               this.VipSettings[_loc6_] = _loc5_;
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
