package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.EquipType;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.box.GradeBoxInfo;
   import ddt.data.box.TimeBoxInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.states.StateType;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.BossBoxView;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.bossbox.TimeBoxEvent;
   import ddt.view.bossbox.TimeCountDown;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class BossBoxManager extends EventDispatcher
   {
      
      public static const GradeBox:int = 1;
      
      public static const FightLibAwardBox:int = 3;
      
      public static const SignAward:int = 4;
      
      private static var _instance:BossBoxManager;
      
      public static const LOADUSERBOXINFO_COMPLETE:String = "loadUserBoxInfo_complete";
      
      public static var DataLoaded:Boolean = false;
       
      
      private var _time:TimeCountDown;
      
      private var _delayBox:int = 1;
      
      private var _startDelayTime:Boolean = true;
      
      private var _isShowGradeBox:Boolean;
      
      private var _isBoxShowedNow:Boolean = false;
      
      private var _boxShowArray:Array;
      
      private var _delaySumTime:int = 0;
      
      private var _isTimeBoxOver:Boolean = false;
      
      private var _boxButtonShowType:int = 1;
      
      private var _currentGrade:int;
      
      private var _selectedBoxID:String = null;
      
      public var timeBoxList:DictionaryData;
      
      public var gradeBoxList:DictionaryData;
      
      public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
      
      public var boxTemplateID:Dictionary;
      
      public var inventoryItemList:DictionaryData;
      
      public var boxTempIDList:DictionaryData;
      
      public var beadTempInfoList:DictionaryData;
      
      public var exploitTemplateIDs:Dictionary;
      
      public var _receieGrade:int;
      
      public var _needGetBoxTime:int;
      
      public function BossBoxManager()
      {
         super();
         this.setup();
      }
      
      public static function get instance() : BossBoxManager
      {
         if(_instance == null)
         {
            _instance = new BossBoxManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._time = new TimeCountDown(1000);
         this._boxShowArray = new Array();
         this.initExploitTemplateIDs();
      }
      
      private function initExploitTemplateIDs() : void
      {
         this.exploitTemplateIDs = new Dictionary();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_I] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_II] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_III] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_IV] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_V] = new Vector.<BoxGoodsTempInfo>();
      }
      
      private function initEvent() : void
      {
         this._time.addEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
         this._time.addEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_TIME_BOX,this._getTimeBox);
      }
      
      public function setup() : void
      {
         this.init();
         this.initEvent();
      }
      
      public function setupBoxInfo(param1:UserBoxInfoAnalyzer) : void
      {
         this.timeBoxList = param1.timeBoxList;
         this.gradeBoxList = param1.gradeBoxList;
         this.boxTemplateID = param1.boxTemplateID;
         DataLoaded = true;
         dispatchEvent(new Event(BossBoxManager.LOADUSERBOXINFO_COMPLETE));
      }
      
      public function setupBoxTempInfo(param1:BoxTempInfoAnalyzer) : void
      {
         this.inventoryItemList = param1.inventoryItemList;
         this.boxTempIDList = param1.caddyTempIDList;
         this.beadTempInfoList = param1.beadTempInfoList;
         this.caddyBoxGoodsInfo = param1.caddyBoxGoodsInfo;
      }
      
      public function startDelayTime() : void
      {
         this.resetTime();
      }
      
      private function resetTime() : void
      {
         if(this.timeBoxList == null)
         {
            return;
         }
         if(this.timeBoxList[this._delayBox] && this.startDelayTimeB && this.timeBoxList[this._delayBox].Level >= this.currentGrade)
         {
            this._time.setTimeOnMinute(this.timeBoxList[this._delayBox].Condition);
            this.delaySumTime = this.timeBoxList[this._delayBox].Condition * 60;
            this.boxButtonShowType = SmallBoxButton.showTypeCountDown;
         }
      }
      
      public function startGradeChangeEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._updateGradeII);
      }
      
      private function _updateGradeII(param1:PlayerPropertyEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade > this.currentGrade)
         {
            if(this.timeBoxList[1] && PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
            {
               this.boxButtonShowType = SmallBoxButton.showTypeHide;
            }
         }
      }
      
      private function _checkeGradeForBox(param1:int, param2:int) : Boolean
      {
         this.currentGrade = PlayerManager.Instance.Self.Grade;
         return this._findGetedBoxGrade(param1,param2);
      }
      
      public function showSignAward(param1:int, param2:Array) : void
      {
         this._showBox(SignAward,param1,param2);
      }
      
      public function showFightLibAwardBox(param1:int, param2:int, param3:Array) : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this.isShowGradeBox = false;
            this._showBox(FightLibAwardBox,1,param3,param1,param2);
         }
         else
         {
            this.isShowGradeBox = true;
         }
      }
      
      public function showBoxOfGrade() : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this.isShowGradeBox = false;
            this.showGradeBox();
         }
         else
         {
            this.isShowGradeBox = true;
         }
      }
      
      private function removeEvent() : void
      {
         this._time.removeEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
         this._time.removeEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_TIME_BOX,this._getTimeBox);
      }
      
      private function _getTimeBox(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         if(_loc3_)
         {
            this._isBoxShowedNow = false;
            this._selectedBoxID = null;
            this._findBoxIdByTime_II(_loc4_);
            this.resetTime();
            this._showOtherBox();
         }
      }
      
      private function _findBoxIdByTime_II(param1:int) : void
      {
         var _loc2_:TimeBoxInfo = null;
         var _loc3_:TimeBoxInfo = null;
         for each(_loc3_ in this.timeBoxList)
         {
            if(_loc3_.Condition > param1)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = _loc3_;
               }
               if(_loc3_.Condition < _loc2_.Condition)
               {
                  _loc2_ = _loc3_;
               }
            }
         }
         if(_loc2_)
         {
            this._delayBox = _loc2_.ID;
            this.startDelayTimeB = true;
         }
         else
         {
            this.startDelayTimeB = false;
            this._isTimeBoxOver = true;
            this.boxButtonShowType = SmallBoxButton.showTypeHide;
         }
      }
      
      private function _findGetedBoxByTime(param1:int) : void
      {
         var _loc2_:TimeBoxInfo = null;
         for each(_loc2_ in this.timeBoxList)
         {
            if(param1 == _loc2_.Condition)
            {
               this._delayBox = _loc2_.ID;
               if(this.timeBoxList[this._delayBox])
               {
                  this.startDelayTimeB = true;
               }
               else
               {
                  this.startDelayTimeB = false;
               }
               return;
            }
         }
      }
      
      private function _findGetedBoxGrade(param1:int, param2:int) : Boolean
      {
         var _loc4_:GradeBoxInfo = null;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.gradeBoxList)
         {
            if(PlayerManager.Instance.Self.Sex)
            {
               if(_loc4_.Level > param1 && _loc4_.Level <= param2 && _loc4_.Condition)
               {
                  if(this._boxShowArray.indexOf(_loc4_.ID + ",grade") == -1)
                  {
                     this._boxShowArray.push(_loc4_.ID + ",grade");
                  }
                  _loc3_ = true;
               }
            }
            else if(_loc4_.Level > param1 && _loc4_.Level <= param2 && !_loc4_.Condition)
            {
               if(this._boxShowArray.indexOf(_loc4_.ID + ",grade") == -1)
               {
                  this._boxShowArray.push(_loc4_.ID + ",grade");
               }
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function _showOtherBox() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._boxShowArray.length)
         {
            if(String(this._boxShowArray[_loc1_]).indexOf("grade") > 0)
            {
               this.showGradeBox();
               return;
            }
            _loc1_++;
         }
      }
      
      private function _timeOver(param1:Event) : void
      {
         if(this.timeBoxList[this._delayBox])
         {
            this._boxShowArray.push(this._delayBox + ",time");
            this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
            SocketManager.Instance.out.sendGetTimeBox(0,this.timeBoxList[this._delayBox].Condition);
         }
      }
      
      private function _timeOne(param1:Event) : void
      {
         --this.delaySumTime;
      }
      
      private function _getShowBoxID(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._boxShowArray.length)
         {
            if(String(this._boxShowArray[_loc2_]).indexOf(param1) > 0)
            {
               _loc3_ = String(this._boxShowArray[_loc2_]).split(",")[0];
               this._selectedBoxID = this._boxShowArray.splice(_loc2_,1);
               return _loc3_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function showTimeBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AwardsView = null;
         if(!this._isBoxShowedNow)
         {
            _loc1_ = this._getShowBoxID("time");
            if(_loc1_ != 0)
            {
               this._showBox(0,_loc1_,this.inventoryItemList[this.timeBoxList[_loc1_].TemplateID]);
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
               _loc2_.boxType = 0;
               _loc2_.goodsList = this.inventoryItemList[this.timeBoxList[this._delayBox].TemplateID];
               _loc2_.setCheck();
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
         }
      }
      
      public function showGradeBox() : void
      {
      }
      
      public function _showBox(param1:int, param2:int, param3:Array, param4:int = -1, param5:int = -1) : void
      {
         this._isBoxShowedNow = true;
         LayerManager.Instance.addToLayer(new BossBoxView(param1,param2,param3,param4,param5),LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      public function showOtherGradeBox() : void
      {
         this._isBoxShowedNow = false;
         this._showOtherBox();
      }
      
      public function isShowBoxButton() : Boolean
      {
         if(this.timeBoxList == null || PlayerManager.Instance.Self.Grade < 8)
         {
            return false;
         }
         if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level || this._isTimeBoxOver)
         {
            return false;
         }
         return true;
      }
      
      public function deleteBoxButton() : void
      {
         this.stopShowTimeBox(this._delayBox);
      }
      
      public function stopShowTimeBox(param1:int) : void
      {
         if(this._isBoxShowedNow && this._selectedBoxID != null)
         {
            this._boxShowArray.push(this._selectedBoxID);
         }
         this._isBoxShowedNow = false;
      }
      
      public function set receieGrade(param1:int) : void
      {
         this._receieGrade = param1;
         if(this._findGetedBoxGrade(this._receieGrade,PlayerManager.Instance.Self.Grade))
         {
            this.isShowGradeBox = true;
         }
      }
      
      public function set needGetBoxTime(param1:int) : void
      {
         this._needGetBoxTime = param1;
         if(this._needGetBoxTime > 0)
         {
            this._findGetedBoxByTime(this._needGetBoxTime);
            if(this.startDelayTimeB)
            {
               this.startDelayTimeB = false;
               if(this._boxShowArray.indexOf(this._delayBox + ",time") == -1)
               {
                  this._boxShowArray.push(this._delayBox + ",time");
               }
               this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
            }
         }
      }
      
      public function set receiebox(param1:int) : void
      {
         this._findBoxIdByTime_II(param1);
      }
      
      public function set isShowGradeBox(param1:Boolean) : void
      {
         this._isShowGradeBox = param1;
      }
      
      public function get isShowGradeBox() : Boolean
      {
         return this._isShowGradeBox;
      }
      
      public function set currentGrade(param1:int) : void
      {
         var _loc2_:TimeBoxInfo = null;
         this._currentGrade = param1;
         for each(_loc2_ in this.timeBoxList)
         {
            if(this._currentGrade > _loc2_.Level)
            {
               this.startDelayTimeB = false;
               this._isTimeBoxOver = true;
               this.boxButtonShowType = SmallBoxButton.showTypeHide;
               break;
            }
         }
      }
      
      public function get currentGrade() : int
      {
         return this._currentGrade;
      }
      
      public function set boxButtonShowType(param1:int) : void
      {
         this._boxButtonShowType = param1;
         var _loc2_:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE);
         _loc2_.boxButtonShowType = this._boxButtonShowType;
         dispatchEvent(_loc2_);
      }
      
      public function get boxButtonShowType() : int
      {
         return this._boxButtonShowType;
      }
      
      public function set delaySumTime(param1:int) : void
      {
         this._delaySumTime = param1;
         var _loc2_:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATETIMECOUNT);
         _loc2_.delaySumTime = this._delaySumTime;
         dispatchEvent(_loc2_);
      }
      
      public function get delaySumTime() : int
      {
         return this._delaySumTime;
      }
      
      public function set startDelayTimeB(param1:Boolean) : void
      {
         this._startDelayTime = param1;
      }
      
      public function get startDelayTimeB() : Boolean
      {
         return this._startDelayTime;
      }
   }
}
