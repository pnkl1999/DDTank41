package noviceactivity
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class NoviceActivityAnalyzer extends DataAnalyzer
   {
       
      
      private var _activityInfos:Array;
      
      private var _firstrechargeawards:Array;
      
      public function NoviceActivityAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:XMLList = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:NoviceActivityInfo = null;
         var _loc9_:XMLList = null;
         var _loc10_:int = 0;
         var _loc11_:NoviceActivityRightAwardInfo = null;
         var _loc12_:XMLList = null;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..ActivityType;
            this._activityInfos = [];
            this._firstrechargeawards = [];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               if(_loc3_[_loc4_].@value == 7)
               {
                  _loc5_ = new XMLList();
                  _loc5_ = _loc3_[_loc4_].children()[0].children();
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length())
                  {
                     _loc7_ = new Object();
                     _loc7_.TemplateID = _loc5_[_loc6_].@TemplateId;
                     _loc7_.Count = _loc5_[_loc6_].@Count;
                     _loc7_.StrengthLevel = _loc5_[_loc6_].@StrengthLevel;
                     _loc7_.AttackCompose = _loc5_[_loc6_].@AttackCompose;
                     _loc7_.DefendCompose = _loc5_[_loc6_].@DefendCompose;
                     _loc7_.LuckCompose = _loc5_[_loc6_].@LuckCompose;
                     _loc7_.AgilityCompose = _loc5_[_loc6_].@AgilityCompose;
                     _loc7_.IsBind = _loc5_[_loc6_].@IsBind;
                     _loc7_.ValidDate = _loc5_[_loc6_].@ValidDate;
                     this._firstrechargeawards.push(_loc7_);
                     _loc6_++;
                  }
               }
               else
               {
                  _loc8_ = new NoviceActivityInfo();
                  _loc8_.activityType = _loc3_[_loc4_].@value;
                  _loc8_.awardList = [];
                  _loc9_ = _loc3_[_loc4_].children();
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.length())
                  {
                     _loc11_ = new NoviceActivityRightAwardInfo();
                     _loc11_.subActivityType = _loc9_[_loc10_].@SubActivityType;
                     _loc11_.condition = _loc9_[_loc10_].@Condition;
                     _loc11_.awardList = [];
                     _loc12_ = _loc9_[_loc10_].children();
                     _loc13_ = 0;
                     while(_loc13_ < _loc12_.length())
                     {
                        _loc14_ = new Object();
                        _loc14_.TemplateID = _loc12_[_loc13_].@TemplateId;
                        _loc14_.Count = _loc12_[_loc13_].@Count;
                        _loc14_.StrengthLevel = _loc12_[_loc13_].@StrengthLevel;
                        _loc14_.AttackCompose = _loc12_[_loc13_].@AttackCompose;
                        _loc14_.DefendCompose = _loc12_[_loc13_].@DefendCompose;
                        _loc14_.LuckCompose = _loc12_[_loc13_].@LuckCompose;
                        _loc14_.AgilityCompose = _loc12_[_loc13_].@AgilityCompose;
                        _loc14_.IsBind = _loc12_[_loc13_].@IsBind;
                        _loc14_.ValidDate = _loc12_[_loc13_].@ValidDate;
                        _loc11_.awardList.push(_loc14_);
                        _loc13_++;
                     }
                     _loc8_.awardList.push(_loc11_);
                     _loc10_++;
                  }
                  this._activityInfos.push(_loc8_);
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
      
      public function get activityInfos() : Array
      {
         return this._activityInfos;
      }
      
      public function get firstrechargeawards() : Array
      {
         return this._firstrechargeawards;
      }
   }
}
