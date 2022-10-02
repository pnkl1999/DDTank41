package exitPrompt
{
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   import email.manager.MailManager;
   
   public class ExitPromptModel
   {
       
      
      private var _list0Arr:Array;
      
      private var _list1Arr:Array;
      
      private var _list2Num:int;
      
      public function ExitPromptModel()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this._list0Arr = new Array();
         this._list1Arr = new Array();
         if(TaskManager.getAvailableQuests(2).list && TaskManager.getAvailableQuests(3).list)
         {
            this._list0Arr = this._returnList0Arr(TaskManager.getAvailableQuests(2).list);
            this._list1Arr = this._returnList1Arr(TaskManager.getAvailableQuests(3).list);
         }
         if(MailManager.Instance.Model && MailManager.Instance.Model.noReadMails)
         {
            this._list2Num = MailManager.Instance.Model.noReadMails.length;
         }
      }
      
      private function _returnList0Arr(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = new Array();
            _loc2_[_loc3_][0] = QuestInfo(param1[_loc3_]).Title;
            if(QuestInfo(param1[_loc3_]).RepeatMax > 50)
            {
               _loc2_[_loc3_][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
            }
            else if(QuestInfo(param1[_loc3_]).RepeatMax == 1)
            {
               _loc2_[_loc3_][1] = "0" + "/" + String(QuestInfo(param1[_loc3_]).RepeatMax);
            }
            else
            {
               _loc2_[_loc3_][1] = String(QuestInfo(param1[_loc3_]).RepeatMax - QuestInfo(param1[_loc3_]).data.repeatLeft) + "/" + String(QuestInfo(param1[_loc3_]).RepeatMax);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function _returnList1Arr(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = new Array();
            _loc2_[_loc3_][0] = QuestInfo(param1[_loc3_]).Title;
            if(QuestInfo(param1[_loc3_]).RepeatMax > 50)
            {
               _loc2_[_loc3_][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
            }
            else if(QuestInfo(param1[_loc3_]).RepeatMax == 1)
            {
               _loc2_[_loc3_][1] = "0" + "/" + String(QuestInfo(param1[_loc3_]).RepeatMax);
            }
            else
            {
               _loc2_[_loc3_][1] = String(QuestInfo(param1[_loc3_]).RepeatMax - QuestInfo(param1[_loc3_]).data.repeatLeft) + "/" + String(QuestInfo(param1[_loc3_]).RepeatMax);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get list0Arr() : Array
      {
         return this._list0Arr;
      }
      
      public function get list1Arr() : Array
      {
         return this._list1Arr;
      }
      
      public function get list2Num() : int
      {
         return this._list2Num;
      }
   }
}
