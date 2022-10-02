package activeEvents.data
{
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class ActiveEventsInfo
   {
      
      public static const COMMON:int = 0;
      
      public static const GOODS_EXCHANGE:int = 1;
      
      public static const PICC:int = 2;
       
      
      public var ActiveID:int;
      
      public var Title:String;
      
      public var isAttend:Boolean = false;
      
      public var Description:String;
      
      private var _StartDate:String;
      
      public var IsShow:Boolean;
      
      private var _start:Date;
      
      private var _EndDate:String;
      
      private var _end:Date;
      
      public var Content:String;
      
      public var AwardContent:String;
      
      public var IsAdvance:Boolean;
      
      public var Type:int;
      
      public var IsOnly:int;
      
      public var HasKey:int;
      
      public var ActiveType:int;
      
      public var GoodsExchangeTypes:String;
      
      public var limitType:String;
      
      public var limitValue:String;
      
      public var GoodsExchangeNum:String;
      
      public var goodsExchangeInfos:Vector.<GoodsExchangeInfo>;
      
      public var ActionTimeContent:String;
      
      public function ActiveEventsInfo()
      {
         super();
      }
      
      public function get StartDate() : String
      {
         return this._StartDate;
      }
      
      public function set StartDate(param1:String) : void
      {
         this._StartDate = param1;
         this._start = DateUtils.getDateByStr(this._StartDate);
      }
      
      public function get start() : Date
      {
         return this._start;
      }
      
      public function get EndDate() : String
      {
         return this._EndDate;
      }
      
      public function set EndDate(param1:String) : void
      {
         this._EndDate = param1;
         this._end = DateUtils.getDateByStr(this._EndDate);
      }
      
      public function get end() : Date
      {
         return this._end;
      }
      
      public function analyzeGoodsExchangeInfo() : void
      {
         var _loc6_:GoodsExchangeInfo = null;
         if(this.GoodsExchangeTypes == "")
         {
            return;
         }
         this.goodsExchangeInfos = new Vector.<GoodsExchangeInfo>();
         var _loc1_:Array = this.GoodsExchangeTypes.split(",");
         var _loc2_:Array = this.limitType.split(",");
         var _loc3_:Array = this.limitValue.split(",");
         var _loc4_:Array = this.GoodsExchangeNum.split(",");
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc6_ = new GoodsExchangeInfo();
            _loc6_.goodsExchangeType = _loc1_[_loc5_];
            _loc6_.limitType = _loc2_[_loc5_];
            _loc6_.limitValue = _loc3_[_loc5_];
            _loc6_.GoodsExchangeNum = _loc4_[_loc5_];
            this.goodsExchangeInfos.push(_loc6_);
            _loc5_++;
         }
      }
      
      public function activeTime() : String
      {
         var _loc1_:String = null;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         if(this.ActionTimeContent)
         {
            _loc1_ = this.ActionTimeContent;
         }
         else if(this.EndDate)
         {
            _loc2_ = DateUtils.getDateByStr(this.StartDate);
            _loc3_ = DateUtils.getDateByStr(this.EndDate);
            _loc1_ = this.getActiveString(_loc2_) + "-" + this.getActiveString(_loc3_);
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.data.MovementInfo.begin",this.getActiveString(_loc2_));
         }
         return _loc1_;
      }
      
      private function getActiveString(param1:Date) : String
      {
         return LanguageMgr.GetTranslation("tank.data.MovementInfo.date",this.addZero(param1.getFullYear()),this.addZero(param1.getMonth() + 1),this.addZero(param1.getDate()));
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 < 10)
         {
            _loc2_ = "0" + param1.toString();
         }
         else
         {
            _loc2_ = param1.toString();
         }
         return _loc2_;
      }
      
      public function overdue() : Boolean
      {
         var _loc4_:Date = null;
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Number = _loc1_.time;
         var _loc3_:Date = DateUtils.getDateByStr(this.StartDate);
         if(_loc2_ < _loc3_.getTime())
         {
            return true;
         }
         if(this.EndDate)
         {
            _loc4_ = DateUtils.getDateByStr(this.EndDate);
            if(_loc2_ > _loc4_.getTime())
            {
               return true;
            }
         }
         return false;
      }
   }
}
