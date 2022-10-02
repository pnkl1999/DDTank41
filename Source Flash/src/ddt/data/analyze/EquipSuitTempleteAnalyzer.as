package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class EquipSuitTempleteAnalyzer extends DataAnalyzer
   {
       
      
      private var _dic:Dictionary;
      
      private var _data:Dictionary;
      
      public function EquipSuitTempleteAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:EquipSuitTemplateInfo = null;
         var _loc6_:Array = null;
         this._dic = new Dictionary();
         this._data = new Dictionary();
         var _loc7_:XML = new XML(param1);
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..item;
            _loc3_ = describeType(new SuitTemplateInfo());
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length())
            {
               _loc5_ = new EquipSuitTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc4_]);
               if(this._dic[_loc5_.ID])
               {
                  _loc6_ = this._dic[_loc5_.ID];
               }
               else
               {
                  _loc6_ = [];
                  this._dic[_loc5_.ID] = _loc6_;
               }
               _loc6_.push(_loc5_);
               this._data[_loc5_.PartName] = _loc5_;
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc7_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get dic() : Dictionary
      {
         return this._dic;
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
   }
}
