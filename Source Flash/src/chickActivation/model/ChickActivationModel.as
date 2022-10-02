package chickActivation.model
{
   import chickActivation.data.ChickActivationInfo;
   import chickActivation.event.ChickActivationEvent;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   public class ChickActivationModel extends EventDispatcher
   {
       
      
      public var isOpen:Boolean = true;
      
      private var _itemInfoList:Array;
      
      public var qualityDic:Dictionary;
      
      public var isKeyOpened:int;
      
      public var keyIndex:int;
      
      public var keyOpenedTime:Date;
      
      public var keyOpenedType:int;
      
      public var gainArr:Array;
      
      public function ChickActivationModel(param1:IEventDispatcher = null)
      {
         this.gainArr = [];
         super(param1);
      }
      
      public function getInventoryItemInfo(param1:ChickActivationInfo) : InventoryItemInfo
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc3_.LuckCompose = param1.TemplateID;
         _loc3_.ValidDate = param1.ValidDate;
         _loc3_.Count = param1.Count;
         _loc3_.IsBinds = param1.IsBind;
         _loc3_.StrengthenLevel = param1.StrengthLevel;
         _loc3_.AttackCompose = param1.AttackCompose;
         _loc3_.DefendCompose = param1.DefendCompose;
         _loc3_.AgilityCompose = param1.AgilityCompose;
         _loc3_.LuckCompose = param1.LuckCompose;
         return _loc3_;
      }
      
      public function findQualityValue(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.qualityDic.hasOwnProperty(param1))
         {
            _loc2_ = this.qualityDic[param1];
         }
         return _loc2_;
      }
      
      public function getRemainingDay() : int
      {
         var _loc1_:Number = 24 * 60 * 60 * 1000;
         var _loc2_:int = 0;
         if(this.isKeyOpened && this.keyOpenedTime)
         {
            _loc2_ = Math.ceil((60 * _loc1_ - (TimeManager.Instance.Now().time - this.keyOpenedTime.time)) / _loc1_);
            if(_loc2_ > 60)
            {
               _loc2_ = 60;
            }
         }
         return _loc2_;
      }
      
      public function getGainLevel(param1:int) : Boolean
      {
         return (this.gainArr[11] & 1 << param1 - 1) > 0;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function set itemInfoList(param1:Array) : void
      {
         this._itemInfoList = param1;
      }
      
      public function dataChange(param1:String, param2:Object = null) : void
      {
         dispatchEvent(new ChickActivationEvent(param1,param2));
      }
   }
}
