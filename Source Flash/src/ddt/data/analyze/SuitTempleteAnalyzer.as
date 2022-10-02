package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class SuitTempleteAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Dictionary;
      
      public function SuitTempleteAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:SuitTemplateInfo = null;
         this._list = new Dictionary();
         var _loc6_:XML = new XML(param1);
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..item;
            _loc3_ = describeType(new SuitTemplateInfo());
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length())
            {
               _loc5_ = new SuitTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc4_]);
               this._list[_loc5_.SuitId] = _loc5_;
               _loc4_++;
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
      
      public function get list() : Dictionary
      {
         return this._list;
      }
   }
}
