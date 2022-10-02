package store.data
{
	import road7th.data.DictionaryData;
	import store.analyze.StoreEquipExpericenceAnalyze;
	
	public class StoreEquipExperience
	{
		
		public static var expericence:Array;
		
		public static var MAX_LEVEL:int = 0;
		
		public static var NECKLACE_MAX_LEVEL:int = 12;
		
		public static var necklaceStrengthExpList:DictionaryData;
		
		public static var necklaceStrengthPlusList:DictionaryData;
		
		
		public function StoreEquipExperience()
		{
			super();
		}
		
		public static function setup(param1:StoreEquipExpericenceAnalyze) : void
		{
			expericence = param1.expericence;
			MAX_LEVEL = param1.expericence.length;
			necklaceStrengthExpList = param1.necklaceStrengthExpList;
			necklaceStrengthPlusList = param1.necklaceStrengthPlusList;
		}
		
		public static function getNecklaceStrengthPlus(param1:int) : int
		{
			return necklaceStrengthPlusList[param1];
		}
		
		public static function getExpPercent(param1:int, param2:int) : Number
		{
			if(expericence.hasOwnProperty(param1))
			{
				return Math.floor(param2 / expericence[param1 + 1] * 10000) / 100;
			}
			return 0;
		}
		
		public static function getExpMax(param1:int) : int
		{
			var _loc2_:int = 0;
			while(_loc2_ < expericence.length)
			{
				if(expericence[_loc2_] > param1)
				{
					return expericence[_loc2_];
				}
				_loc2_++;
			}
			return expericence[_loc2_];
		}
		
		public static function getLevelByGP(param1:int) : int
		{
			var _loc2_:int = MAX_LEVEL - 1;
			while(_loc2_ > -1)
			{
				if(expericence[_loc2_] <= param1)
				{
					return _loc2_ + 1;
				}
				_loc2_--;
			}
			return 1;
		}
		
		public static function getNecklaceLevelByGP(param1:int) : int
		{
			var _loc2_:int = NECKLACE_MAX_LEVEL;
			while(_loc2_ > -1)
			{
				if(necklaceStrengthExpList.list[_loc2_] <= param1)
				{
					return _loc2_;
				}
				_loc2_--;
			}
			return 1;
		}
		
		public static function getNecklaceExpMax(param1:int) : int
		{
			var _loc2_:int = 0;
			while(_loc2_ < expericence.length)
			{
				if(necklaceStrengthExpList.list[_loc2_] > param1)
				{
					return necklaceStrengthExpList.list[_loc2_];
				}
				_loc2_++;
			}
			return necklaceStrengthExpList.list[_loc2_];
		}
		
		public static function getNecklaceCurrentlevelExp(param1:int) : int
		{
			var _loc2_:int = getNecklaceLevelByGP(param1);
			return param1 - necklaceStrengthExpList[_loc2_];
		}
		
		public static function getNecklaceCurrentlevelMaxExp(param1:int) : int
		{
			if(param1 < NECKLACE_MAX_LEVEL)
			{
				return necklaceStrengthExpList[param1 + 1] - necklaceStrengthExpList[param1];
			}
			return necklaceStrengthExpList[param1] - necklaceStrengthExpList[param1 - 1];
		}
	}
}