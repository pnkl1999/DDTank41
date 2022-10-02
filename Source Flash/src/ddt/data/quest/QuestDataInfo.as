package ddt.data.quest
{
   public class QuestDataInfo
   {
       
      
      public var repeatLeft:int;
      
      public var hadChecked:Boolean;
      
      public var quality:int;
      
      private var _questID:int;
      
      private var _progress:Array;
      
      public var CompleteDate:Date;
      
      private var _isAchieved:Boolean;
      
      private var _isNew:Boolean;
      
      private var _informed:Boolean;
      
      private var _isExist:Boolean;
      
      public function QuestDataInfo(param1:int)
      {
         super();
         this._questID = param1;
         this.hadChecked = false;
         this._isNew = false;
         this._informed = false;
      }
      
      public function set isExist(param1:Boolean) : void
      {
         this._isExist = param1;
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function get id() : int
      {
         return this._questID;
      }
      
      public function set isNew(param1:Boolean) : void
      {
         this._isNew = param1;
      }
      
      public function get isNew() : Boolean
      {
         return this._isNew;
      }
      
      public function set informed(param1:Boolean) : void
      {
         this._informed = param1;
      }
      
      public function get needInformed() : Boolean
      {
         if(!this._informed && this._isNew)
         {
            return true;
         }
         return false;
      }
      
      public function get isAchieved() : Boolean
      {
         return this._isAchieved;
      }
      
      public function set isAchieved(param1:Boolean) : void
      {
         this._isAchieved = param1;
      }
      
      public function setProgress(param1:int, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         if(!this._progress)
         {
            this._progress = new Array();
         }
         this._progress[0] = param1;
         this._progress[1] = param2;
         this._progress[2] = param3;
         this._progress[3] = param4;
      }
      
      public function get progress() : Array
      {
         return this._progress;
      }
      
      public function get isCompleted() : Boolean
      {
         if(!this._progress)
         {
            return false;
         }
         if(this._progress[0] <= 0 && this._progress[1] <= 0 && this._progress[2] <= 0 && this._progress[3] <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function get ConditionCount() : int
      {
         if(this._progress[0])
         {
            return this._progress[0];
         }
         return 0;
      }
      
      public function set ConditionCount(param1:int) : void
      {
      }
   }
}
