package ddt.data.quest
{
   import ddt.manager.TaskManager;
   
   public class QuestCategory
   {
       
      
      private var _completedQuestArray:Array;
      
      private var _newQuestArray:Array;
      
      private var _questArray:Array;
      
      public function QuestCategory()
      {
         super();
         this._completedQuestArray = new Array();
         this._newQuestArray = new Array();
         this._questArray = new Array();
      }
      
      public function addNew(param1:QuestInfo) : void
      {
         this._newQuestArray.push(param1);
      }
      
      public function addCompleted(param1:QuestInfo) : void
      {
         this._completedQuestArray.push(param1);
      }
      
      public function addQuest(param1:QuestInfo) : void
      {
         this._questArray.push(param1);
      }
      
      public function get list() : Array
      {
         return this._completedQuestArray.concat(this._newQuestArray.concat(this._questArray));
      }
      
      public function get haveNew() : Boolean
      {
         var _loc1_:QuestInfo = null;
         for each(_loc1_ in this._newQuestArray)
         {
            if(_loc1_.data && _loc1_.data.isNew)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get haveRecommend() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.list.length)
         {
            if(this.list[_loc1_].StarLev == 1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get haveClickedNew() : Boolean
      {
         var _loc1_:QuestInfo = null;
         for each(_loc1_ in this._newQuestArray)
         {
            if(_loc1_ == TaskManager.currentNewQuest)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get haveCompleted() : Boolean
      {
         return this._completedQuestArray.length > 0;
      }
   }
}
