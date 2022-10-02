package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GoodsAdditionAnalyer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _additionArr:Array;
      
      public function GoodsAdditionAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         this._additionArr = new Array();
         this._xml = new XML(param1);
         var _loc2_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new Object();
               _loc4_.ItemCatalog = int(_loc2_[_loc3_].@ItemCatalog);
               _loc4_.SubCatalog = int(_loc2_[_loc3_].@SubCatalog);
               _loc4_.StrengthenLevel = int(_loc2_[_loc3_].@StrengthenLevel);
               _loc4_.FailtureTimes = int(_loc2_[_loc3_].@FailtureTimes);
               _loc4_.PropertyPlus = int(_loc2_[_loc3_].@PropertyPlus);
               _loc4_.SuccessRatePlus = int(_loc2_[_loc3_].@SuccessRatePlus);
               this._additionArr.push(_loc4_);
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
      
      public function get additionArr() : Array
      {
         return this._additionArr;
      }
   }
}
