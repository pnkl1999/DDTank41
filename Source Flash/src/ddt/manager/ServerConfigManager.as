package ddt.manager
{
   import ddt.data.ServerConfigInfo;
   import ddt.data.analyze.ServerConfigAnalyz;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ServerConfigManager
   {
      
      private static var _instance:ServerConfigManager;
      
      public static const MARRT_ROOM_CREATE_MONET:String = "MarryRoomCreateMoney";
      
      public static const MISSION_RICHES:String = "MissionRiches";
      
      public static const VIP_EXP_NEEDEDFOREACHLV:String = "VIPExpNeededForEachLv";
      
      public static const HOT_SPRING_EXP:String = "HotSpringExp";
      
      public static const FIRSTRECHARGE_RETURN:String = "FirstChargeReturn";
      
      public static const PLAYER_MIN_LEVEL:String = "PlayerMinLevel";
      
      public static const WARRIORFAMRAIDPRICEPERMIN:String = "WarriorFamRaidPricePerMin";
      
      public static const VIP_PRIVILEGE:String = "VIPPrivilege";
      
      public static const PRIVILEGE_CANBUYFERT:String = "8";
      
      public static const PET_SCORE_ENABLE:String = "IsOpenPetScore";
	  
	  public static const ISCHICKENACTIVEKEYOPEN:String = "IsChickenActiveKeyOpen";
	  
	  public static const CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE:String = "ChickenActiveKeyLvAwardNeedPrestige";
	  
	  public static const LIGHTROAD_MINLEVEL:String = "GoodsCollectMinLevel";
	  
	  public static const AUCTION_RATE:String = "Cess";
	  
	  public static const TOTEMPROPMONEYOFFSET:String = "TotemPropMoneyOffset";
	  
	  public static const VIPEXTTRA_BIND_MOMEYUPPER:String = "VIPExtraBindMoneyUpper";
      
      private static var privileges:Dictionary;
       
	  private var _BindMoneyMax:Array;
	  
	  private var _VIPExtraBindMoneyUpper:Array;
	  
      private var _serverConfigInfoList:DictionaryData;
      
      public function ServerConfigManager()
      {
         super();
      }
      
      public static function get instance() : ServerConfigManager
      {
         if(_instance == null)
         {
            _instance = new ServerConfigManager();
         }
         return _instance;
      }
      
      public function getserverConfigInfo(param1:ServerConfigAnalyz) : void
      {
         this._serverConfigInfoList = param1.serverConfigInfoList;
		 this._BindMoneyMax = this._serverConfigInfoList["BindMoneyMax"].Value.split("|");
		 this._VIPExtraBindMoneyUpper = this._serverConfigInfoList["VIPExtraBindMoneyUpper"].Value.split("|");
      }
      
      public function get serverConfigInfo() : DictionaryData
      {
         return this._serverConfigInfoList;
      }
      
      public function get weddingMoney() : Array
      {
         return this.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
      }
      
      public function get MissionRiches() : Array
      {
         return this.findInfoByName(ServerConfigManager.MISSION_RICHES).Value.split("|");
      }
      
      public function get VIPExpNeededForEachLv() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_EXP_NEEDEDFOREACHLV).Value.split("|");
      }
      
      public function get HotSpringExp() : Array
      {
         return this.findInfoByName(ServerConfigManager.HOT_SPRING_EXP).Value.split(",");
      }
      
      public function findInfoByName(param1:String) : ServerConfigInfo
      {
         return this._serverConfigInfoList[param1];
      }
      
      public function getPrivilegeString(param1:int) : String
      {
         var _loc2_:Object = this.findInfoByName(VIP_PRIVILEGE);
         if(_loc2_)
         {
            return String(_loc2_.Value);
         }
         return null;
      }
      
      public function getFirstRechargeRebateAndValue() : Array
      {
         var _loc1_:Object = this.findInfoByName(FIRSTRECHARGE_RETURN);
         if(_loc1_)
         {
            return this.findInfoByName(FIRSTRECHARGE_RETURN).Value.split("|");
         }
         return [1,998];
      }
      
      public function get minOpenPetSystemLevel() : int
      {
         var _loc1_:Object = this.findInfoByName(PLAYER_MIN_LEVEL);
         return int(_loc1_.Value);
      }
      
      public function get WarriorFamRaidPricePerMin() : Number
      {
         return Number(this.findInfoByName(WARRIORFAMRAIDPRICEPERMIN).Value);
      }
      
      public function getPrivilegeMinLevel(param1:String) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(privileges == null)
         {
            _loc2_ = this.findInfoByName(VIP_PRIVILEGE);
            _loc3_ = 1;
            _loc4_ = String(_loc2_.Value).split("|");
            privileges = new Dictionary();
            for each(_loc5_ in _loc4_)
            {
               for each(_loc6_ in _loc5_.split(","))
               {
                  privileges[_loc6_] = _loc3_;
               }
               _loc3_++;
            }
         }
         return int(privileges[param1]);
      }
      
      public function get petScoreEnable() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(PET_SCORE_ENABLE);
         if(_loc1_)
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
	  
	  //Code ga hanh
	  public function get chickActivationIsOpen() : Boolean
	  {
		  var _loc1_:ServerConfigInfo = this.findInfoByName(ISCHICKENACTIVEKEYOPEN);
		  if(_loc1_)
		  {
			  return _loc1_.Value.toLowerCase() == "true";
		  }
		  return false;
	  }
	  
	  public function get chickenActiveKeyLvAwardNeedPrestige() : Array
	  {
		  var _loc1_:ServerConfigInfo = this.findInfoByName(CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE);
		  if(_loc1_)
		  {
			  return _loc1_.Value.split("|");
		  }
		  return null;
	  }
	  //
	  
	  public function get lightRoadLevel() : int
	  {
		  return int(this.findInfoByName(LIGHTROAD_MINLEVEL).Value);
	  }
	  
	  public function get AuctionRate() : String
	  {
		  return String(Number(this.findInfoByName(AUCTION_RATE).Value) * 100);
	  }
	  
	  public function get totemSignDiscount() : Number
	  {
		  var _loc1_:ServerConfigInfo = this.findInfoByName(TOTEMPROPMONEYOFFSET);
		  if(_loc1_)
		  {
			  return Number(_loc1_.Value);
		  }
		  return 40;
	  }
	  
	  public function getBindBidLimit(param1:int, param2:int = 0) : int
	  {
		  var _loc3_:int = param1 % 10 == 0 ? int(int(int(this._BindMoneyMax[int(param1 / 10) - 1]))) : int(int(int(this._BindMoneyMax[int(param1 / 10)])));
		  var _loc4_:int = 0;
		  if(PlayerManager.Instance.Self.IsVIP && param2 > 0)
		  {
			  _loc4_ = int(this._VIPExtraBindMoneyUpper[param2 - 1]);
		  }
		  return _loc3_ + _loc4_;
	  }
	  
	  public function get VIPExtraBindMoneyUpper() : Array
	  {
		  return this.findInfoByName(ServerConfigManager.VIPEXTTRA_BIND_MOMEYUPPER).Value.split("|");
	  }
   }
}
