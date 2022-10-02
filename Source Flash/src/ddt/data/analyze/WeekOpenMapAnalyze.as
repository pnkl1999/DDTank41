package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.map.OpenMapInfo;
   
   public class WeekOpenMapAnalyze extends DataAnalyzer
   {
      
      public static const PATH:String = "MapServerList.xml";
       
      
      public var list:Vector.<OpenMapInfo>;
      
      public function WeekOpenMapAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:OpenMapInfo = null;
         var _loc2_:XML = new XML(param1);
         var _loc3_:String = _loc2_.@value;
         if(_loc3_ == "true")
         {
            this.list = new Vector.<OpenMapInfo>();
            _loc4_ = _loc2_..Item;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length())
            {
               _loc6_ = new OpenMapInfo();
               _loc6_.maps = _loc4_[_loc5_].@OpenMap.split(",");
               _loc6_.serverID = _loc4_[_loc5_].@ServerID;
               this.list.push(_loc6_);
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
   }
}
