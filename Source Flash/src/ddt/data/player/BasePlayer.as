package ddt.data.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Experience;
   import ddt.events.PlayerPropertyEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   [Event(name="propertychange",type="ddt.events.PlayerPropertyEvent")]
   [Event(name="gold_change",type="tank.data.player.PlayerPropertyEvent")]
   public class BasePlayer extends EventDispatcher
   {
      
      public static const BADGE_ID:String = "badgeid";
      
      public static const JUNIOR_VIP:int = 1;
      
      public static const SENIOR_VIP:int = 2;
       
      
      public var PetsID:int;
      
      private var _zoneID:int;
      
      public var ID:Number;
      
      public var LoginName:String;
      
      protected var _nick:String;
      
      public var Sex:Boolean;
      
      public var WinCount:int;
      
      public var EscapeCount:int;
      
      private var _totalCount:int = 0;
      
      private var _repute:int;
      
      private var _grade:int;
      
      private var _IsUpGrade:Boolean;
      
      public var isUpGradeInGame:Boolean = false;
      
      private var _fightPower:int;
      
      private var _matchInfo:MatchInfo;
      
      private var _leagueFirst:Boolean;
      
      private var _lasetWeekScore:Number;
      
      public var _score:Number = 0;
      
      private var _gP:int;
      
      private var _offer:int;
      
      private var _state:PlayerState;
      
      private var _typeVIP:int = 0;
      
      public var VIPLevel:int = 1;
      
      public var VIPExp:int;
      
      private var _honor:String = "";
      
      private var _achievementPoint:int;
      
      private var _isMarried:Boolean;
      
      public var SpouseID:int;
      
      private var _spouseName:String;
      
      public var ConsortiaID:int = 0;
      
      public var ConsortiaName:String;
      
      public var DutyLevel:int;
      
      private var _dutyName:String;
      
      private var _right:int;
      
      private var _RichesRob:int;
      
      private var _RichesOffer:int;
      
      private var _UseOffer:int;
      
      private var _badgeID:int = 0;
      
      private var _apprenticeshipState:int;
      
      public var LastLoginDate:Date;
      
      private var _hpTexpExp:int = -1;
      
      private var _attTexpExp:int = -1;
      
      private var _defTexpExp:int = -1;
      
      private var _spdTexpExp:int = -1;
      
      private var _lukTexpExp:int = -1;
      
      private var _texpCount:int;
      
      private var _texpTaskCount:int;
      
      private var _texpTaskDate:Date;
      
      protected var _changeCount:int = 0;
      
      protected var _changedPropeties:Dictionary;
      
      protected var _lastValue:Dictionary;
      
      public var honorId:int;
      
      public function BasePlayer()
      {
         this._changedPropeties = new Dictionary();
         this._lastValue = new Dictionary();
         super();
      }
      
      public function set ZoneID(param1:int) : void
      {
         this._zoneID = param1;
      }
      
      public function get ZoneID() : int
      {
         return this._zoneID;
      }
      
      public function set NickName(param1:String) : void
      {
         this._nick = param1;
      }
      
      public function get NickName() : String
      {
         return this._nick;
      }
      
      public function get SexByInt() : int
      {
         if(this.Sex)
         {
            return 1;
         }
         return 2;
      }
      
      public function set SexByInt(param1:int) : void
      {
      }
      
      public function get TotalCount() : int
      {
         return this._totalCount;
      }
      
      public function set TotalCount(param1:int) : void
      {
         if(this._totalCount == param1 || param1 <= 0)
         {
            return;
         }
         if(this._totalCount == param1 - 1 || this._totalCount == param1 - 2)
         {
            this.onPropertiesChanged("TotalCount");
         }
         this._totalCount = param1;
      }
      
      public function get Repute() : int
      {
         return this._repute;
      }
      
      public function set Repute(param1:int) : void
      {
         this._repute = param1;
         this.onPropertiesChanged("Repute");
      }
      
      public function get Grade() : int
      {
         return this._grade;
      }
      
      public function set Grade(param1:int) : void
      {
         if(this._grade == param1 || param1 <= 0)
         {
            return;
         }
         if(this._grade != 0 && this._grade < param1)
         {
            this.IsUpGrade = true;
         }
         this._grade = param1;
         this.onPropertiesChanged("Grade");
      }
      
      public function get IsUpGrade() : Boolean
      {
         return this._IsUpGrade;
      }
      
      public function set IsUpGrade(param1:Boolean) : void
      {
         this._IsUpGrade = param1;
      }
      
      public function get FightPower() : int
      {
         return this._fightPower;
      }
      
      public function get matchInfo() : MatchInfo
      {
         if(this._matchInfo == null)
         {
            this._matchInfo = new MatchInfo();
         }
         return this._matchInfo;
      }
      
      public function set matchInfo(param1:MatchInfo) : void
      {
         if(this._matchInfo == param1)
         {
            return;
         }
         ObjectUtils.copyProperties(this.matchInfo,param1);
         this.onPropertiesChanged("matchInfo");
      }
      
      public function get DailyLeagueFirst() : Boolean
      {
         return this._leagueFirst;
      }
      
      public function set DailyLeagueFirst(param1:Boolean) : void
      {
         if(this._leagueFirst == param1)
         {
            return;
         }
         this._leagueFirst = param1;
         this.onPropertiesChanged("DailyLeagueFirst");
      }
      
      public function get DailyLeagueLastScore() : Number
      {
         return this._lasetWeekScore;
      }
      
      public function set DailyLeagueLastScore(param1:Number) : void
      {
         if(this._lasetWeekScore == param1)
         {
            return;
         }
         this._lasetWeekScore = param1;
         this.onPropertiesChanged("DailyLeagueLastScore");
      }
      
      public function set FightPower(param1:int) : void
      {
         if(this._fightPower == param1)
         {
            return;
         }
         this._fightPower = param1;
         this.onPropertiesChanged("FightPower");
      }
      
      public function get Score() : Number
      {
         return this._score;
      }
      
      public function set Score(param1:Number) : void
      {
         if(this._score == param1)
         {
            return;
         }
         this._score = param1;
         this.onPropertiesChanged("Score");
      }
      
      public function get GP() : int
      {
         return this._gP;
      }
      
      public function set GP(param1:int) : void
      {
         this._gP = param1;
         this.Grade = Experience.getGrade(this._gP);
         this.onPropertiesChanged("GP");
      }
      
      public function get Offer() : int
      {
         return this._offer;
      }
      
      public function set Offer(param1:int) : void
      {
         if(this._offer == param1)
         {
            return;
         }
         this._offer = param1;
         this.onPropertiesChanged("Offer");
      }
      
      public function get playerState() : PlayerState
      {
         if(this._state == null)
         {
            this._state = new PlayerState(PlayerState.ONLINE);
         }
         return this._state;
      }
      
      public function set playerState(param1:PlayerState) : void
      {
         if(this._state == null || this._state.StateID == PlayerState.ONLINE || this._state.StateID != param1.StateID && this._state.Priority <= param1.Priority)
         {
            this._state = param1;
            this.onPropertiesChanged("State");
         }
      }
      
      public function get IsVIP() : Boolean
      {
         return this._typeVIP >= 1;
      }
      
      public function set IsVIP(param1:Boolean) : void
      {
         this._typeVIP = int(param1);
      }
      
      public function set typeVIP(param1:int) : void
      {
         this._typeVIP = param1;
         this.onPropertiesChanged("isVip");
      }
      
      public function get typeVIP() : int
      {
         return this._typeVIP;
      }
      
      public function get honor() : String
      {
         return this._honor;
      }
      
      public function set honor(param1:String) : void
      {
         if(this._honor == param1)
         {
            return;
         }
         this._honor = param1;
         this.onPropertiesChanged("honor");
      }
      
      public function get AchievementPoint() : int
      {
         return this._achievementPoint;
      }
      
      public function set AchievementPoint(param1:int) : void
      {
         this._achievementPoint = param1;
      }
      
      public function set SpouseName(param1:String) : void
      {
         if(this._spouseName == param1)
         {
            return;
         }
         this._spouseName = param1;
         this.onPropertiesChanged("SpouseName");
      }
      
      public function get SpouseName() : String
      {
         return this._spouseName;
      }
      
      public function set IsMarried(param1:Boolean) : void
      {
         if(param1 && !this._isMarried)
         {
         }
         this._isMarried = param1;
         this.onPropertiesChanged("IsMarried");
      }
      
      public function get IsMarried() : Boolean
      {
         return this._isMarried;
      }
      
      public function get DutyName() : String
      {
         return this._dutyName;
      }
      
      public function set DutyName(param1:String) : void
      {
         if(this._dutyName == param1)
         {
            return;
         }
         this._dutyName = param1;
         this.onPropertiesChanged("dutyName");
      }
      
      public function get Right() : int
      {
         return this._right;
      }
      
      public function set Right(param1:int) : void
      {
         if(this._right == param1)
         {
            return;
         }
         this._right = param1;
         this.onPropertiesChanged("Right");
      }
      
      public function get RichesRob() : int
      {
         return this._RichesRob;
      }
      
      public function set RichesRob(param1:int) : void
      {
         if(this._RichesRob == param1)
         {
            return;
         }
         this._RichesRob = param1;
         this.onPropertiesChanged("RichesRob");
      }
      
      public function get RichesOffer() : int
      {
         return this._RichesOffer;
      }
      
      public function set RichesOffer(param1:int) : void
      {
         if(this._RichesOffer == param1)
         {
            return;
         }
         this._RichesOffer = param1;
         this.onPropertiesChanged("RichesOffer");
      }
      
      public function get UseOffer() : int
      {
         return this._UseOffer;
      }
      
      public function set UseOffer(param1:int) : void
      {
         if(this._UseOffer == param1)
         {
            return;
         }
         this._UseOffer = param1;
         this.onPropertiesChanged("UseOffer");
      }
      
      public function get Riches() : int
      {
         return this.RichesOffer + this.RichesRob;
      }
      
      public function set Riches(param1:int) : void
      {
         this.RichesOffer = param1;
      }
      
      public function get badgeID() : int
      {
         return this._badgeID;
      }
      
      public function set badgeID(param1:int) : void
      {
         this._badgeID = param1;
         this.onPropertiesChanged(BADGE_ID);
      }
      
      public function getVipNameTxt(param1:int = -1) : GradientText
      {
         var _loc2_:GradientText = ComponentFactory.Instance.creatComponentByStylename("vipName");
         if(param1 != -1)
         {
            _loc2_.textField.width = param1;
         }
         else
         {
            _loc2_.textField.autoSize = "left";
         }
         return _loc2_;
      }
      
      public function set apprenticeshipState(param1:int) : void
      {
         this._apprenticeshipState = param1;
      }
      
      public function get apprenticeshipState() : int
      {
         return this._apprenticeshipState;
      }
      
      public function get hpTexpExp() : int
      {
         return this._hpTexpExp;
      }
      
      public function set hpTexpExp(param1:int) : void
      {
         if(this._hpTexpExp == param1)
         {
            return;
         }
         this._lastValue["hpTexpExp"] = this._hpTexpExp;
         this._hpTexpExp = param1;
         if(this._lastValue["hpTexpExp"] != -1)
         {
            this.onPropertiesChanged("hpTexpExp");
         }
      }
      
      public function get attTexpExp() : int
      {
         return this._attTexpExp;
      }
      
      public function set attTexpExp(param1:int) : void
      {
         if(this._attTexpExp == param1)
         {
            return;
         }
         this._lastValue["attTexpExp"] = this._attTexpExp;
         this._attTexpExp = param1;
         if(this._lastValue["attTexpExp"] != -1)
         {
            this.onPropertiesChanged("attTexpExp");
         }
      }
      
      public function get defTexpExp() : int
      {
         return this._defTexpExp;
      }
      
      public function set defTexpExp(param1:int) : void
      {
         if(this._defTexpExp == param1)
         {
            return;
         }
         this._lastValue["defTexpExp"] = this._defTexpExp;
         this._defTexpExp = param1;
         if(this._lastValue["defTexpExp"] != -1)
         {
            this.onPropertiesChanged("defTexpExp");
         }
      }
      
      public function get spdTexpExp() : int
      {
         return this._spdTexpExp;
      }
      
      public function set spdTexpExp(param1:int) : void
      {
         if(this._spdTexpExp == param1)
         {
            return;
         }
         this._lastValue["spdTexpExp"] = this._spdTexpExp;
         this._spdTexpExp = param1;
         if(this._lastValue["spdTexpExp"] != -1)
         {
            this.onPropertiesChanged("spdTexpExp");
         }
      }
      
      public function get lukTexpExp() : int
      {
         return this._lukTexpExp;
      }
      
      public function set lukTexpExp(param1:int) : void
      {
         if(this._lukTexpExp == param1)
         {
            return;
         }
         this._lastValue["lukTexpExp"] = this._lukTexpExp;
         this._lukTexpExp = param1;
         if(this._lastValue["lukTexpExp"] != -1)
         {
            this.onPropertiesChanged("lukTexpExp");
         }
      }
      
      public function get texpCount() : int
      {
         return this._texpCount;
      }
      
      public function set texpCount(param1:int) : void
      {
         this._texpCount = param1;
      }
      
      public function get texpTaskCount() : int
      {
         return this._texpTaskCount;
      }
      
      public function set texpTaskCount(param1:int) : void
      {
         this._texpTaskCount = param1;
      }
      
      public function get texpTaskDate() : Date
      {
         return this._texpTaskDate;
      }
      
      public function set texpTaskDate(param1:Date) : void
      {
         this._texpTaskDate = param1;
      }
      
      public function beginChanges() : void
      {
         ++this._changeCount;
      }
      
      public function commitChanges() : void
      {
         --this._changeCount;
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      protected function onPropertiesChanged(param1:String = null) : void
      {
         if(param1 != null)
         {
            this._changedPropeties[param1] = true;
         }
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      public function updateProperties() : void
      {
         var _loc1_:Dictionary = this._changedPropeties;
         var _loc2_:Dictionary = this._lastValue;
         this._changedPropeties = new Dictionary();
         this._lastValue = new Dictionary();
         dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE,_loc1_,_loc2_));
      }
   }
}
