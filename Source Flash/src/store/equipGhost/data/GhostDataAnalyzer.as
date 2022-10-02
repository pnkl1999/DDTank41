package store.equipGhost.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public final class GhostDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _dataList:Vector.<GhostData>;
      
      public function GhostDataAnalyzer(param1:Function)
      {
         this._dataList = new Vector.<GhostData>();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc3_ = _loc5_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               (_loc2_ = new GhostData()).parseXML(_loc3_[_loc4_]);
               this._dataList.push(_loc2_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      public function get data() : Vector.<GhostData>
      {
         return this._dataList;
      }
   }
}
