package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.quest.QuestInfo;
   import flash.utils.Dictionary;
   
   public class QuestListAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _list:Dictionary;
      
      public function QuestListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get list() : Dictionary
      {
         return this._list;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:QuestInfo = null;
         this._xml = new XML(param1);
         var _loc2_:XMLList = this._xml..Item;
         this._list = new Dictionary();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = QuestInfo.createFromXML(_loc4_);
            this._list[_loc5_.Id] = _loc5_;
            _loc3_++;
         }
         onAnalyzeComplete();
      }
   }
}
