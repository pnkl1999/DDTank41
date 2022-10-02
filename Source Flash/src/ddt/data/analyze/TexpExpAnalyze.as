package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import texpSystem.data.TexpExp;
   
   public class TexpExpAnalyze extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function TexpExpAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:TexpExp = null;
         var _loc6_:int = 0;
         this.list = new Dictionary();
         var _loc2_:XML = new XML(param1);
         message = _loc2_.@message;
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new TexpExp();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].@Grage;
               this.list[_loc6_] = _loc5_;
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}
