package lanternriddles.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class LanternDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _data:Object;
      
      public function LanternDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:LanternInfo = null;
         var _loc6_:int = 0;
         var _loc2_:XML = new XML(param1);
         this._data = {};
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new LanternInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].@QuestionID;
               if(!this._data[_loc6_])
               {
                  this._data[_loc6_] = _loc5_;
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
