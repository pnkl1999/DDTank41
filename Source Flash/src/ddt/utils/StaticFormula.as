package ddt.utils
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import game.model.Living;
   import totem.TotemManager;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.data.GhostPropertyData;
   import bagAndInfo.info.PlayerInfoViewControl;
   
   public class StaticFormula
   {
       
      
      public function StaticFormula()
      {
         super();
      }
      
      public static function getHertAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.round(_loc3_);
      }
      
      public static function getDefenseAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.round(_loc3_);
      }
      
      public static function getRecoverHPAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.floor(_loc3_);
      }
      
      public static function getImmuneHertAddition(param1:int) : Number
      {
         var _loc2_:Number = 0.95 * param1 / (param1 + 500);
         _loc2_ *= 100;
         return Number(_loc2_.toFixed(1));
      }
      
      public static function isDeputyWeapon(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.TemplateID >= 17000 && param1.TemplateID <= 17010)
         {
            return true;
         }
         return false;
      }
      
      public static function getActionValue(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         return int((param1.Attack + param1.Agility + param1.Luck + param1.Defence + 1000) * (Math.pow(getDamage(param1),3) + Math.pow(getRecovery(param1),3) * 3.5) / 100000000 + getMaxHp(param1) * 0.95 - 950);
      }
      
      public static function isShield(param1:PlayerInfo) : Boolean
      {
         return false;
      }
      
      public static function getDamage(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
		 var _loc33_:* = null;
         if(param1.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && param1.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var _loc3_:InventoryItemInfo = param1.Bag.items[6] as InventoryItemInfo;
         if(_loc3_)
         {
            _loc2_ = getHertAddition(int(_loc3_.Property7),_loc3_.StrengthenLevel + (!!_loc3_.isGold ? 1 : 0)) + int(_loc3_.Property7) + getJewelDamage(_loc3_);
			_loc33_ = getGhostPropertyData(_loc3_);
			if(_loc33_)
			{
				_loc2_ += _loc33_.mainProperty;
			}
         }
         if(param1.Bag.items[0])
         {
            _loc2_ += getJewelDamage(param1.Bag.items[0]);
         }
         if(param1.Bag.items[4])
         {
            _loc2_ += getJewelDamage(param1.Bag.items[4]);
         }
		 _loc2_ += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(param1.totemId)).Damage;
         return _loc2_;
      }
      
      public static function getRecovery(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
		 var _loc33_:* = null;
         if(param1.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && param1.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var _loc3_:InventoryItemInfo = param1.Bag.items[0] as InventoryItemInfo;
         if(_loc3_)
         {
            _loc2_ = getDefenseAddition(int(_loc3_.Property7),_loc3_.StrengthenLevel + (!!_loc3_.isGold ? 1 : 0)) + int(_loc3_.Property7) + getJewelRecovery(_loc3_);
			_loc33_ = getGhostPropertyData(_loc3_);
			if(_loc33_)
			{
				_loc2_ += _loc33_.mainProperty;
			}
         }
         _loc3_ = param1.Bag.items[4] as InventoryItemInfo;
         if(_loc3_)
         {
            _loc2_ += getDefenseAddition(int(_loc3_.Property7),_loc3_.StrengthenLevel + (!!_loc3_.isGold ? 1 : 0)) + int(_loc3_.Property7) + getJewelRecovery(_loc3_);
			_loc33_ = getGhostPropertyData(_loc3_);
			if(_loc33_)
			{
				_loc2_ += _loc33_.mainProperty;
			}
         }
         _loc3_ = param1.Bag.items[6] as InventoryItemInfo;
         if(_loc3_)
         {
            _loc2_ += getJewelRecovery(_loc3_);
         }
		 _loc2_ += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(param1.totemId)).Guard;
         return _loc2_;
      }
      
      public static function getMaxHp(param1:PlayerInfo) : int
      {
         return param1.hp;
      }
      
      public static function getEnergy(param1:PlayerInfo) : int
      {
         if(param1.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && param1.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var _loc2_:int = 0;
         return int(240 + param1.Agility / 30);
      }
      
      private static function isDamageJewel(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID == 11 && param1.Property1 == "31" && param1.Property2 == "3")
         {
            return true;
         }
         return false;
      }
      
      public static function getJewelDamage(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return 0;
         }
         if(param1.Hole1 != -1 && param1.Hole1 != 0 && int(param1.StrengthenLevel / 3) >= 1)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole1)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole1).Property7);
            }
         }
         if(param1.Hole2 != -1 && param1.Hole2 != 0 && int(param1.StrengthenLevel / 3) >= 2)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole2)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole2).Property7);
            }
         }
         if(param1.Hole3 != -1 && param1.Hole3 != 0 && int(param1.StrengthenLevel / 3) >= 3)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole3)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole3).Property7);
            }
         }
         if(param1.Hole4 != -1 && param1.Hole4 != 0 && int(param1.StrengthenLevel / 3) >= 4)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole4)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole4).Property7);
            }
         }
         if(param1.Hole5 != -1 && param1.Hole5 != 0 && param1.Hole5Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole5)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole5).Property7);
            }
         }
         if(param1.Hole6 != -1 && param1.Hole6 != 0 && param1.Hole6Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole6)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole6).Property7);
            }
         }
         return _loc2_;
      }
	  
	  private static function getGhostPropertyData(param1:InventoryItemInfo) : GhostPropertyData
	  {
		  var _loc4_:PlayerInfo = null;
		  var _loc2_:GhostPropertyData = null;
		  var _loc3_:* = param1;
		  if(_loc3_ == null)
		  {
			  return null;
		  }
		  var _loc5_:* = (_loc4_ = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self).ID != PlayerManager.Instance.Self.ID;
		  var _loc6_:Boolean = _loc3_.BagType == 0 && _loc3_.Place <= 30;
		  return !!_loc6_ ? EquipGhostManager.getInstance().getPorpertyData(_loc3_,_loc4_) : null;
	  }
      
      public static function getJewelRecovery(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return 0;
         }
         if(param1.Hole1 != -1 && param1.Hole1 != 0 && int(param1.StrengthenLevel / 3) >= 1)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole1).Property8);
         }
         if(param1.Hole2 != -1 && param1.Hole2 != 0 && int(param1.StrengthenLevel / 3) >= 2)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole2).Property8);
         }
         if(param1.Hole3 != -1 && param1.Hole3 != 0 && int(param1.StrengthenLevel / 3) >= 3)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole3).Property8);
         }
         if(param1.Hole4 != -1 && param1.Hole4 != 0 && int(param1.StrengthenLevel / 3) >= 4)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole4).Property8);
         }
         if(param1.Hole5 != -1 && param1.Hole5 != 0 && param1.Hole5Level > 0)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole5).Property8);
         }
         if(param1.Hole6 != -1 && param1.Hole6 != 0 && param1.Hole6Level > 0)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole6).Property8);
         }
         return _loc2_;
      }
   }
}
