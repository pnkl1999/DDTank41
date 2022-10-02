package quest
{
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   
   public class QuestBubbleMode
   {
       
      
      private var _questInfoCompleteArr:Array;
      
      private var _questInfoArr:Array;
      
      private var _questInfoTxtArr:Array;
      
      private var _isShowIn:Boolean;
      
      public function QuestBubbleMode()
      {
         super();
      }
      
      public function get questsInfo() : Array
      {
         var _loc1_:Array = [];
         this._questInfoCompleteArr = [];
         this._questInfoArr = [];
         _loc1_ = TaskManager.getAvailableQuests().list;
         return this._reseachComplete(_loc1_);
      }
      
      private function _addInfoToArr(param1:QuestInfo) : void
      {
         if(param1.canViewWithProgress && this._questInfoArr.length < 5 && (!this._isShowIn || this._isShowIn && param1.isCompleted))
         {
            this._questInfoArr.push(param1);
         }
      }
      
      private function _reseachComplete(param1:Array) : Array
      {
         this._reseachInfoForId(param1);
         return this._setTxtInArr();
      }
      
      private function _setTxtInArr() : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Array = new Array();
         for(var _loc2_:int = 0; _loc2_ < this._questInfoArr.length; _loc2_++)
         {
            if(QuestInfo(this._questInfoArr[_loc2_]).Type == 3)
            {
               if(QuestInfo(this._questInfoArr[_loc2_]).id >= 2000 && QuestInfo(this._questInfoArr[_loc2_]).id <= 2018)
               {
                  continue;
               }
            }
            _loc3_ = 0;
            _loc4_ = QuestInfo(this._questInfoArr[_loc2_]).progress[0];
            _loc5_ = QuestInfo(this._questInfoArr[_loc2_])._conditions[0].target;
            _loc6_ = 1;
            while(QuestInfo(this._questInfoArr[_loc2_])._conditions[_loc6_])
            {
               _loc8_ = QuestInfo(this._questInfoArr[_loc2_]).progress[_loc6_];
               _loc9_ = QuestInfo(this._questInfoArr[_loc2_])._conditions[_loc6_].target;
               if(_loc8_ != 0)
               {
                  if(_loc8_ / _loc9_ < _loc4_ / _loc5_ || _loc4_ == 0)
                  {
                     _loc4_ = _loc8_;
                     _loc5_ = _loc9_;
                     _loc3_ = _loc6_;
                  }
               }
               _loc6_++;
            }
            _loc7_ = new Object();
            switch(QuestInfo(this._questInfoArr[_loc2_]).Type)
            {
               case 0:
                  _loc7_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
                  break;
               case 1:
                  _loc7_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
                  break;
               case 2:
                  _loc7_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
                  break;
               case 3:
                  _loc7_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
                  break;
               case 4:
                  _loc7_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
				  break;
            }
            if(QuestInfo(this._questInfoArr[_loc2_]).isCompleted)
            {
               _loc7_.txtI = "<font COLOR=\'#8be961\'>" + _loc7_.txtI + "</font>";
               _loc7_.txtII = "<font COLOR=\'#8be961\'>" + this._analysisStrIII(QuestInfo(this._questInfoArr[_loc2_])) + "</font>";
               _loc7_.txtIII = "<font COLOR=\'#8be961\'>" + this._analysisStrIV(QuestInfo(this._questInfoArr[_loc2_])) + "</font>";
            }
            else
            {
               _loc7_.txtII = this._analysisStrII(QuestInfo(this._questInfoArr[_loc2_])._conditions[_loc3_].description);
               _loc7_.txtIII = QuestInfo(this._questInfoArr[_loc2_]).conditionStatus[_loc3_];
            }
            _loc1_.push(_loc7_);
         }
         return _loc1_;
      }
      
      private function _analysisStrII(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1.length <= 6)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = param1.substr(0,6);
            _loc2_ += "...";
         }
         return _loc2_;
      }
      
      private function _analysisStrIII(param1:QuestInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1._conditions.length)
         {
            if(param1.progress[_loc3_] <= 0)
            {
               return param1._conditions[_loc3_].description;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function _analysisStrIV(param1:QuestInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1._conditions.length)
         {
            if(param1.progress[_loc3_] <= 0)
            {
               return param1.conditionStatus[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function _reseachInfoForId(param1:Array) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:IndexObj = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = QuestInfo(param1[_loc3_]).questProgressNum;
            _loc6_ = new IndexObj(_loc3_,_loc5_);
            _loc2_.push(_loc6_);
            _loc3_++;
         }
         _loc2_.sortOn("progressNum",Array.NUMERIC);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._questInfoCompleteArr.push(QuestInfo(param1[_loc2_[_loc3_].id]));
            _loc3_++;
         }
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this._questInfoCompleteArr.length)
         {
            if(this._questInfoCompleteArr[_loc3_].questProgressNum != this._questInfoCompleteArr[_loc4_].questProgressNum)
            {
               this._checkInfoArr(4,_loc4_,_loc3_);
               this._checkInfoArr(3,_loc4_,_loc3_);
               this._checkInfoArr(2,_loc4_,_loc3_);
               this._checkInfoArr(0,_loc4_,_loc3_);
               this._checkInfoArr(1,_loc4_,_loc3_);
               _loc4_ = _loc3_;
            }
            _loc3_++;
         }
         this._checkInfoArr(4,_loc4_,this._questInfoCompleteArr.length);
         this._checkInfoArr(3,_loc4_,this._questInfoCompleteArr.length);
         this._checkInfoArr(2,_loc4_,this._questInfoCompleteArr.length);
         this._checkInfoArr(0,_loc4_,this._questInfoCompleteArr.length);
         this._checkInfoArr(1,_loc4_,this._questInfoCompleteArr.length);
      }
      
      private function _checkInfoArr(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = param2;
         while(_loc4_ < param3)
         {
            if(QuestInfo(this._questInfoCompleteArr[_loc4_]).Type == param1)
            {
               this._addInfoToArr(this._questInfoCompleteArr[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      public function getQuestInfoById(param1:int) : QuestInfo
      {
         return this._questInfoArr[param1];
      }
   }
}

class IndexObj
{
    
   
   public var id:int;
   
   public var progressNum:Number;
   
   function IndexObj(param1:int, param2:Number)
   {
      super();
      this.id = param1;
      this.progressNum = param2;
   }
}
