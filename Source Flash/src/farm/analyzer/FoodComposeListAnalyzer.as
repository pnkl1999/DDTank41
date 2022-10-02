package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.utils.Dictionary;
   
   public class FoodComposeListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      private var _listDetail:Vector.<FoodComposeListTemplateInfo>;
      
      public function FoodComposeListAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:FoodComposeListTemplateInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = new FoodComposeListTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc5_);
            if(_loc4_ != _loc6_.FoodID)
            {
               _loc4_ = _loc6_.FoodID;
               this._listDetail = new Vector.<FoodComposeListTemplateInfo>();
               this._listDetail.push(_loc6_);
            }
            else if(_loc4_ == _loc6_.FoodID)
            {
               this._listDetail.push(_loc6_);
            }
            this.list[_loc4_] = this._listDetail;
         }
         onAnalyzeComplete();
      }
   }
}
