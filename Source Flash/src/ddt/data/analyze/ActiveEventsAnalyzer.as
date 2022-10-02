package ddt.data.analyze
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   
   public class ActiveEventsAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      private var _xml:XML;
      
      public function ActiveEventsAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ActiveEventsInfo = null;
         this._xml = new XML(param1);
         this._list = new Array();
         var _loc2_:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ActiveEventsInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               if(_loc4_.ActiveType == ActiveEventsInfo.GOODS_EXCHANGE)
               {
                  _loc4_.analyzeGoodsExchangeInfo();
               }
               /*if(_loc4_.ActiveID == 1)
               {
                  PathManager.solveinpleLights(_loc4_.limitValue);
               }*/
               this._list.push(_loc4_);
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
      
      public function get list() : Array
      {
         return this._list.slice(0);
      }
   }
}
