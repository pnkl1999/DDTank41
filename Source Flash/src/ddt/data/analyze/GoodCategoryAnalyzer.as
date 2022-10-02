package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   
   public class GoodCategoryAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<CateCoryInfo>;
      
      private var _xml:XML;
      
      public function GoodCategoryAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:CateCoryInfo = null;
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this.list = new Vector.<CateCoryInfo>();
            _loc2_ = this._xml..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new CateCoryInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
   }
}
