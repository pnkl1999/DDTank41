package ddt.data.analyze
{
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import guildMemberWeek.data.GuildMemberWeekItemsInfo;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class ActivitySystemItemsDataAnalyzer extends DataAnalyzer
   {
      public var guildMemberWeekDataList:Array;
      
      public var chickActivationDataList:Array;
      
      public function ActivitySystemItemsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:GuildMemberWeekItemsInfo = null;
         var _loc8_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:ChickActivationInfo = null;
         var _loc14_:Array = null;
         this.guildMemberWeekDataList = [];
         this.chickActivationDataList = [];
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
				if(_loc3_[_loc4_].@ActivityType == String(GuildMemberWeekManager.instance.getGiftType))
				{
					_loc7_ = new GuildMemberWeekItemsInfo();
					ObjectUtils.copyPorpertiesByXML(_loc7_,_loc3_[_loc4_]);
					_loc8_ = this.guildMemberWeekDataList[_loc7_.Quality - 1];
					if(!_loc8_)
					{
						_loc8_ = [];
					}
					_loc8_.push(_loc7_);
					this.guildMemberWeekDataList[_loc7_.Quality - 1] = _loc8_;
				}
				else if(_loc3_[_loc4_].@ActivityType == "40")
               {
                  _loc13_ = new ChickActivationInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc13_,_loc3_[_loc4_]);
                  if(_loc13_.Quality >= 10001 && _loc13_.Quality <= 10010)
                  {
                     _loc14_ = this.chickActivationDataList[12];
                     if(!_loc14_)
                     {
                        _loc14_ = new Array();
                     }
                     _loc14_.push(_loc13_);
                     _loc14_.sortOn("Quality",Array.NUMERIC);
                     this.chickActivationDataList[12] = _loc14_;
                  }
                  else
                  {
                     _loc14_ = this.chickActivationDataList[_loc13_.Quality];
                     if(!_loc14_)
                     {
                        _loc14_ = new Array();
                     }
                     _loc14_.push(_loc13_);
                     this.chickActivationDataList[_loc13_.Quality] = _loc14_;
                  }
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
   }
}
