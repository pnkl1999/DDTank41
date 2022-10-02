package ddt.data
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class BuffInfo
   {
      
      public static const FREE:int = 15;
      
      public static const DOUBEL_EXP:int = 13;
      
      public static const DOUBLE_GESTE:int = 12;
      
      public static const PREVENT_KICK:int = 11;
      
      public static const GROW_HELP:int = 14;
      
      public static const LABYRINTH_BUFF:int = 17;
      
      public static const Caddy_Good:int = 70;
      
      public static const Save_Life:int = 51;
      
      public static const Agility:int = 50;
      
      public static const ReHealth:int = 52;
      
      public static const Train_Good:int = 71;
      
      public static const Level_Try:int = 72;
      
      public static const Card_Get:int = 73;
      
      public static const Pay_Buff:int = 16;
      
      public static const PropertyWater_74:int = 74;
       
      
      public var Type:int;
      
      public var IsExist:Boolean;
      
      public var BeginData:Date;
      
      public var ValidDate:int;
      
      public var Value:int;
      
      public var TemplateID:int;
      
      public var ValidCount:int;
      
      public var isSelf:Boolean = true;
      
      private var _buffName:String;
      
      private var _buffItem:ItemTemplateInfo;
      
      private var _description:String;
      
      public var day:int;
      
      private var _valided:Boolean = true;
      
      public function BuffInfo(param1:int = -1, param2:Boolean = false, param3:Date = null, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         this.Type = param1;
         this.IsExist = param2;
         this.BeginData = param3;
         this.ValidDate = param4;
         this.Value = param5;
         this.ValidCount = param6;
         this.TemplateID = param7;
         this.initItemInfo();
      }
      
      public function get maxCount() : int
      {
         return this._buffItem != null ? int(int(int(this._buffItem.Property3))) : int(int(0));
      }
      
      public function getLeftTimeByUnit(param1:Number) : int
      {
         if(this.getLeftTime() > 0)
         {
            switch(param1)
            {
               case TimeManager.DAY_TICKS:
                  return Math.floor(this.getLeftTime() / TimeManager.DAY_TICKS);
               case TimeManager.HOUR_TICKS:
                  return Math.floor(this.getLeftTime() % TimeManager.DAY_TICKS / TimeManager.HOUR_TICKS);
               case TimeManager.Minute_TICKS:
                  return Math.floor(this.getLeftTime() % TimeManager.HOUR_TICKS / TimeManager.Minute_TICKS);
            }
         }
         return 0;
      }
      
      public function get valided() : Boolean
      {
         return this._valided;
      }
      
      public function calculatePayBuffValidDay() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         if(this.BeginData)
         {
            _loc1_ = TimeManager.Instance.Now();
            _loc2_ = new Date(this.BeginData.fullYear,this.BeginData.month,this.BeginData.date);
            _loc1_ = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date);
            _loc3_ = (_loc1_.time - _loc2_.time) / TimeManager.DAY_TICKS;
            if(_loc3_ < this.ValidDate)
            {
               this._valided = true;
               this.day = this.ValidDate - _loc3_;
            }
            else
            {
               this._valided = false;
            }
         }
      }
      
      private function getLeftTime() : Number
      {
         var _loc1_:Number = NaN;
         if(this.IsExist)
         {
            _loc1_ = this.ValidDate - Math.floor((TimeManager.Instance.Now().time - this.BeginData.time) / TimeManager.Minute_TICKS);
         }
         else
         {
            _loc1_ = -1;
         }
         return _loc1_ * TimeManager.Minute_TICKS;
      }
      
      public function get buffName() : String
      {
         return this._buffItem.Name;
      }
      
      public function get description() : String
      {
         return this._buffItem.Data;
      }
      
      public function set description(param1:String) : void
      {
         this._buffItem.Data = param1;
      }
      
      public function get buffItemInfo() : ItemTemplateInfo
      {
         return this._buffItem;
      }
      
      public function initItemInfo() : void
      {
         switch(this.Type)
         {
            case PREVENT_KICK:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.PREVENT_KICK);
               break;
            case DOUBLE_GESTE:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_GESTE_CARD);
               break;
            case DOUBEL_EXP:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.DOUBLE_EXP_CARD);
               break;
            case FREE:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.FREE_PROP_CARD);
               break;
            case Caddy_Good:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Caddy_Good);
               break;
            case Save_Life:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Save_Life);
               break;
            case Agility:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Agility_Get);
               break;
            case ReHealth:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.ReHealth);
               break;
            case Level_Try:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Level_Try);
               break;
            case Card_Get:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Card_Get);
               break;
            case Train_Good:
               this._buffItem = ItemManager.Instance.getTemplateById(EquipType.Train_Good);
               break;
            case LABYRINTH_BUFF:
               this._buffItem = new ItemTemplateInfo();
               break;
            default:
               this._buffItem = ItemManager.Instance.getTemplateById(this.TemplateID);
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
