package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class StrengthenDataAnalyzer extends DataAnalyzer
   {
       
      
      public var _strengthData:Vector.<Dictionary>;
      
      private var _xml:XML;
      
      public function StrengthenDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this._xml = new XML(param1);
         this.initData();
         var _loc2_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = _loc2_[_loc3_].@TemplateID;
               _loc5_ = _loc2_[_loc3_].@StrengthenLevel;
               _loc6_ = _loc2_[_loc3_].@Data;
               this._strengthData[_loc5_][_loc4_] = _loc6_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function initData() : void
      {
         var _loc2_:Dictionary = null;
         this._strengthData = new Vector.<Dictionary>();
         var _loc1_:int = 0;
         while(_loc1_ <= 12)
         {
            _loc2_ = new Dictionary();
            this._strengthData.push(_loc2_);
            _loc1_++;
         }
      }
   }
}
