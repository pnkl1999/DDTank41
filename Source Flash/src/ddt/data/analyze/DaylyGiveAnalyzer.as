package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import daily.DailyManager;
   import ddt.data.DailyAwardType;
   import ddt.data.DaylyGiveInfo;
   import flash.utils.Dictionary;
   
   public class DaylyGiveAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public var signAwardList:Array;
      
      public var signAwardCounts:Array;
      
      public var userAwardLog:int;
      
      public var awardLen:int;
      
      private var _xml:XML;
      
      private var _awardDic:Dictionary;
      
      public var list200:Array;
      
      public var list201:Array;
      
      public var list203:Array;
      
      public var list205:Array;
      
      public var list210:Array;
      
      public function DaylyGiveAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DaylyGiveInfo = null;
         var _loc5_:DaylyGiveInfo = null;
         var _loc6_:DaylyGiveInfo = null;
         var _loc7_:DaylyGiveInfo = null;
         var _loc8_:DaylyGiveInfo = null;
         var _loc9_:DaylyGiveInfo = null;
         this._xml = new XML(param1);
         this.list = new Array();
         this.list200 = new Array();
         this.list201 = new Array();
         this.list203 = new Array();
         this.list205 = new Array();
         this.list210 = new Array();
         this.signAwardList = new Array();
         this._awardDic = new Dictionary(true);
         this.signAwardCounts = new Array();
         if(this._xml.@value == "true")
         {
            _loc2_ = this._xml..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@GetWay == DailyAwardType.Normal)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.list.push(_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.Sign)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.signAwardList.push(_loc4_);
                  if(!this._awardDic[String(_loc2_[_loc3_].@AwardDays)])
                  {
                     this._awardDic[String(_loc2_[_loc3_].@AwardDays)] = true;
                     this.signAwardCounts.push(_loc2_[_loc3_].@AwardDays);
                  }
               }
               if(_loc2_[_loc3_].@GetWay == 200)
               {
                  _loc5_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc3_]);
                  DailyManager.list200.push(_loc5_);
                  this.list200.push(_loc5_);
               }
               if(_loc2_[_loc3_].@GetWay == 201)
               {
                  _loc6_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc6_,_loc2_[_loc3_]);
                  DailyManager.list201.push(_loc6_);
                  this.list201.push(_loc6_);
               }
               if(_loc2_[_loc3_].@GetWay == 203)
               {
                  _loc7_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc7_,_loc2_[_loc3_]);
                  DailyManager.list203.push(_loc7_);
                  this.list203.push(_loc7_);
               }
               if(_loc2_[_loc3_].@GetWay == 205)
               {
                  _loc8_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc8_,_loc2_[_loc3_]);
                  DailyManager.list205.push(_loc8_);
                  this.list205.push(_loc8_);
               }
               if(_loc2_[_loc3_].@GetWay == 210)
               {
                  _loc9_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc9_,_loc2_[_loc3_]);
                  DailyManager.list210.push(_loc9_);
                  this.list210.push(_loc9_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
