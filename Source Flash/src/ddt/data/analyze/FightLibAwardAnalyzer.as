package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.fightLib.FightLibAwardInfo;
   import ddt.data.fightLib.FightLibInfo;
   
   public class FightLibAwardAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function FightLibAwardAnalyzer(param1:Function)
      {
         this.list = [];
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:XMLList = XML(param1).Item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new Object();
            _loc5_.id = int(_loc4_.@ID);
            _loc5_.diff = int(_loc4_.@Easy);
            _loc5_.itemID = int(_loc4_.@AwardItem);
            _loc5_.count = int(_loc4_.@Count);
            _loc2_.push(_loc5_);
         }
         this.sortItems(_loc2_);
         onAnalyzeComplete();
      }
      
      private function sortItems(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            this.pushInListByIDAndDiff({
               "id":_loc2_.itemID,
               "count":_loc2_.count
            },_loc2_.id,_loc2_.diff);
         }
      }
      
      private function pushInListByIDAndDiff(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:FightLibAwardInfo = this.findAwardInfoByID(param2);
         switch(param3)
         {
            case FightLibInfo.EASY:
               _loc4_.easyAward.push(param1);
               break;
            case FightLibInfo.NORMAL:
               _loc4_.normalAward.push(param1);
               break;
            case FightLibInfo.DIFFICULT:
               _loc4_.difficultAward.push(param1);
         }
      }
      
      private function findAwardInfoByID(param1:int) : FightLibAwardInfo
      {
         var _loc2_:FightLibAwardInfo = null;
         var _loc3_:int = this.list.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.list[_loc4_].id == param1)
            {
               _loc2_ = this.list[_loc4_];
               return _loc2_;
            }
            _loc4_++;
         }
         if(_loc2_ == null)
         {
            _loc2_ = new FightLibAwardInfo();
            _loc2_.id = param1;
            this.list.push(_loc2_);
         }
         return _loc2_;
      }
   }
}
