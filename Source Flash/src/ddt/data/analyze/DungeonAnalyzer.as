package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   
   public class DungeonAnalyzer extends DataAnalyzer
   {
      
      private static const PATH:String = "LoadPVEItems.xml";
       
      
      public var list:Vector.<DungeonInfo>;
      
      public function DungeonAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:DungeonInfo = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.list = new Vector.<DungeonInfo>();
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new DungeonInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               if(_loc5_.Name != "")
               {
                  this.list.push(_loc5_);
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
