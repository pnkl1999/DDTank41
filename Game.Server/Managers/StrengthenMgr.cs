using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class StrengthenMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, StrengthenInfo> _strengthens;

        private static Dictionary<int, StrengthenInfo> _Refinery_Strengthens;

        private static Dictionary<int, StrengthenGoodsInfo> _Strengthens_Goods;

		private static Dictionary<int, StrengThenExpInfo> _Strengthens_Exps;

		private static ReaderWriterLock _lock;

        private static ThreadSafeRandom _random;

		public static readonly int NECKLACE_MAX_LEVEL = 12;

		public static readonly List<double> RateItems = new List<double>
		{
			0.75,
			3.0,
			12.0,
			48.0,
			240.0,
			768.0
		};

        public static readonly double VIPStrengthenEx = 0.3;

        public static readonly int[] StrengthenExp = new int[16]
		{
			0,
			10,
			50,
			150,
			350,
			700,
			1500,
			2300,
			3300,
			4500,
			6000,
			7500,
			9000,
			15000,
			25000,
			50000
		};

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, StrengthenInfo> tempStrengthens = new Dictionary<int, StrengthenInfo>();
				Dictionary<int, StrengthenInfo> tempRefineryStrengthens = new Dictionary<int, StrengthenInfo>();
				Dictionary<int, StrengthenGoodsInfo> strengthens_Goods = new Dictionary<int, StrengthenGoodsInfo>();
				Dictionary<int, StrengThenExpInfo> tempStrengthenExps = new Dictionary<int, StrengThenExpInfo>();
				if (LoadStrengthen(tempStrengthens, tempRefineryStrengthens, tempStrengthenExps))
				{
					_lock.AcquireWriterLock(-1);
					try
					{
						_strengthens = tempStrengthens;
						_Refinery_Strengthens = tempRefineryStrengthens;
						_Strengthens_Goods = strengthens_Goods;
						_Strengthens_Exps = tempStrengthenExps;
						return true;
					}
					catch
					{
					}
					finally
					{
						_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("StrengthenMgr", exception);
				}
			}
			return false;
        }

        public static bool Init()
        {
			try
			{
				_lock = new ReaderWriterLock();
				_strengthens = new Dictionary<int, StrengthenInfo>();
				_Refinery_Strengthens = new Dictionary<int, StrengthenInfo>();
				_Strengthens_Goods = new Dictionary<int, StrengthenGoodsInfo>();
				_Strengthens_Exps = new Dictionary<int, StrengThenExpInfo>();
				_random = new ThreadSafeRandom();
				return LoadStrengthen(_strengthens, _Refinery_Strengthens, _Strengthens_Exps);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("StrengthenMgr", exception);
				}
				return false;
			}
        }

        private static bool LoadStrengthen(Dictionary<int, StrengthenInfo> strengthen, Dictionary<int, StrengthenInfo> RefineryStrengthen, Dictionary<int, StrengThenExpInfo> StrengthenExp)
        {
			using (ProduceBussiness db = new ProduceBussiness())
			{
				StrengthenInfo[] allStrengthen = db.GetAllStrengthen();
				StrengthenInfo[] allRefineryStrengthen = db.GetAllRefineryStrengthen();
				StrengthenGoodsInfo[] allStrengthenGoodsInfo = db.GetAllStrengthenGoodsInfo();
				StrengThenExpInfo[] Expinfos = db.GetAllStrengThenExp();
				//StrengthenInfo[] array = allStrengthen;
				//StrengthenInfo[] array2 = array;
				foreach (StrengthenInfo strengthenInfo in allStrengthen)
				{
					if (!strengthen.ContainsKey(strengthenInfo.StrengthenLevel))
					{
						strengthen.Add(strengthenInfo.StrengthenLevel, strengthenInfo);
					}
				}
				//array = allRefineryStrengthen;
				//StrengthenInfo[] array3 = array;
				foreach (StrengthenInfo strengthenInfo2 in allRefineryStrengthen)
				{
					if (!RefineryStrengthen.ContainsKey(strengthenInfo2.StrengthenLevel))
					{
						RefineryStrengthen.Add(strengthenInfo2.StrengthenLevel, strengthenInfo2);
					}
				}
				//StrengthenGoodsInfo[] array4 = allStrengthenGoodsInfo;
				//StrengthenGoodsInfo[] array5 = array4;
				foreach (StrengthenGoodsInfo strengthenGoodsInfo in allStrengthenGoodsInfo)
				{
					if (!_Strengthens_Goods.ContainsKey(strengthenGoodsInfo.ID))
					{
						_Strengthens_Goods.Add(strengthenGoodsInfo.ID, strengthenGoodsInfo);
					}
				}
				foreach (StrengThenExpInfo info in Expinfos)
				{
					if (!StrengthenExp.ContainsKey(info.Level))
					{
						StrengthenExp.Add(info.Level, info);
					}
				}
			}
			return true;
        }

        public static StrengthenInfo FindStrengthenInfo(int level)
        {
			_lock.AcquireReaderLock(-1);
			try
			{
				if (_strengthens.ContainsKey(level))
				{
					return _strengthens[level];
				}
			}
			catch
			{
			}
			finally
			{
				_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static StrengthenInfo FindRefineryStrengthenInfo(int level)
        {
			_lock.AcquireReaderLock(-1);
			try
			{
				if (_Refinery_Strengthens.ContainsKey(level))
				{
					return _Refinery_Strengthens[level];
				}
			}
			catch
			{
			}
			finally
			{
				_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static StrengthenGoodsInfo FindStrengthenGoodsInfo(int level, int templateId)
        {
			foreach (StrengthenGoodsInfo value in _Strengthens_Goods.Values)
			{
				if (value.Level == level && templateId == value.CurrentEquip)
				{
					return value;
				}
			}
			return null;
        }

        public static StrengthenGoodsInfo FindTransferInfo(int level, int templateId)
        {
			foreach (StrengthenGoodsInfo value in _Strengthens_Goods.Values)
			{
				if (value.Level == level && templateId == value.CurrentEquip)
				{
					return value;
				}
			}
			return null;
        }

        public static StrengthenGoodsInfo FindTransferInfo(int templateId)
        {
			foreach (StrengthenGoodsInfo value in _Strengthens_Goods.Values)
			{
				if (templateId == value.GainEquip || templateId == value.CurrentEquip)
				{
					return value;
				}
			}
			return null;
        }

        public static StrengthenGoodsInfo FindRealStrengthenGoodInfo(int level, int templateid)
        {
			StrengthenGoodsInfo strengthenGoodsInfo = FindTransferInfo(templateid);
			if (strengthenGoodsInfo != null)
			{
				return FindStrengthenGoodsInfo(level, strengthenGoodsInfo.OrginEquip);
			}
			return null;
        }

        public static void InheritTransferProperty(ref ItemInfo itemZero, ref ItemInfo itemOne, bool tranHole, bool tranHoleFivSix)
        {
			int hole = itemZero.Hole1;
			int hole2 = itemZero.Hole2;
			int hole3 = itemZero.Hole3;
			int hole4 = itemZero.Hole4;
			int hole5 = itemZero.Hole5;
			int hole6 = itemZero.Hole6;
			int hole5Exp = itemZero.Hole5Exp;
			int hole5Level = itemZero.Hole5Level;
			int hole6Exp = itemZero.Hole6Exp;
			int hole6Level = itemZero.Hole6Level;
			int attackCompose = itemZero.AttackCompose;
			int defendCompose = itemZero.DefendCompose;
			int agilityCompose = itemZero.AgilityCompose;
			int luckCompose = itemZero.LuckCompose;
			int strengthenLevel = itemZero.StrengthenLevel;
			int strengthenExp = itemZero.StrengthenExp;
			int strengthenTimes = itemZero.StrengthenTimes;
			bool isGold = itemZero.isGold;
			int goldValidDate = itemZero.goldValidDate;
			DateTime goldBeginTime = itemZero.goldBeginTime;
			string latentEnergyCurStr = itemZero.latentEnergyCurStr;
			string latentEnergyNewStr = itemZero.latentEnergyNewStr;
			DateTime latentEnergyEndTime = itemZero.latentEnergyEndTime;

			int hole7 = itemOne.Hole1;
			int hole8 = itemOne.Hole2;
			int hole9 = itemOne.Hole3;
			int hole10 = itemOne.Hole4;
			int hole11 = itemOne.Hole5;
			int hole12 = itemOne.Hole6;
			int hole5Exp2 = itemOne.Hole5Exp;
			int hole5Level2 = itemOne.Hole5Level;
			int hole6Exp2 = itemOne.Hole6Exp;
			int hole6Level2 = itemOne.Hole6Level;
			int attackCompose2 = itemOne.AttackCompose;
			int defendCompose2 = itemOne.DefendCompose;
			int agilityCompose2 = itemOne.AgilityCompose;
			int luckCompose2 = itemOne.LuckCompose;
			int strengthenLevel2 = itemOne.StrengthenLevel;
			int strengthenExp2 = itemOne.StrengthenExp;
			int strengthenTimes2 = itemOne.StrengthenTimes;
			bool isGold2 = itemOne.isGold;
			int goldValidDate2 = itemOne.goldValidDate;
			DateTime goldBeginTime2 = itemOne.goldBeginTime;
			string latentEnergyCurStr2 = itemOne.latentEnergyCurStr;
			string latentEnergyNewStr2 = itemOne.latentEnergyNewStr;
			DateTime latentEnergyEndTime2 = itemOne.latentEnergyEndTime;
			if (tranHole)
			{
				itemOne.Hole1 = hole;
				itemZero.Hole1 = hole7;
				itemOne.Hole2 = hole2;
				itemZero.Hole2 = hole8;
				itemOne.Hole3 = hole3;
				itemZero.Hole3 = hole9;
				itemOne.Hole4 = hole4;
				itemZero.Hole4 = hole10;
			}
			if (tranHoleFivSix)
			{
				itemOne.Hole5 = hole5;
				itemZero.Hole5 = hole11;
				itemOne.Hole6 = hole6;
				itemZero.Hole6 = hole12;
			}
			itemOne.Hole5Exp = hole5Exp;
			itemZero.Hole5Exp = hole5Exp2;
			itemOne.Hole5Level = hole5Level;
			itemZero.Hole5Level = hole5Level2;
			itemOne.Hole6Exp = hole6Exp;
			itemZero.Hole6Exp = hole6Exp2;
			itemOne.Hole6Level = hole6Level;
			itemZero.Hole6Level = hole6Level2;
			itemZero.StrengthenLevel = strengthenLevel2;
			itemOne.StrengthenLevel = strengthenLevel;
			itemZero.StrengthenExp = strengthenExp2;
			itemOne.StrengthenExp = strengthenExp;
			itemZero.AttackCompose = attackCompose2;
			itemOne.AttackCompose = attackCompose;
			itemZero.DefendCompose = defendCompose2;
			itemOne.DefendCompose = defendCompose;
			itemZero.LuckCompose = luckCompose2;
			itemOne.LuckCompose = luckCompose;
			itemZero.AgilityCompose = agilityCompose2;
			itemOne.AgilityCompose = agilityCompose;
			if (itemZero.IsBinds || itemOne.IsBinds)
			{
				itemOne.IsBinds = true;
				itemZero.IsBinds = true;
			}
			itemZero.goldBeginTime = goldBeginTime2;
			itemOne.goldBeginTime = goldBeginTime;
			itemZero.goldValidDate = goldValidDate2;
			itemOne.goldValidDate = goldValidDate;
			itemZero.StrengthenTimes = strengthenTimes2;
			itemOne.StrengthenTimes = strengthenTimes;

			itemZero.latentEnergyCurStr = latentEnergyCurStr2;
			itemOne.latentEnergyCurStr = latentEnergyCurStr;
			itemZero.latentEnergyNewStr = latentEnergyNewStr2;
			itemOne.latentEnergyNewStr = latentEnergyNewStr;
			itemZero.latentEnergyEndTime = latentEnergyEndTime2;
			itemOne.latentEnergyEndTime = latentEnergyEndTime;
		}

        public static int GetNeedRate(ItemInfo mainItem)
        {
			int result = 0;
			StrengthenInfo strengthenInfo = FindStrengthenInfo(mainItem.StrengthenLevel + 1);
			switch (mainItem.Template.CategoryID)
			{
			case 5:
				result = strengthenInfo.Rock2;
				break;
			case 1:
				result = strengthenInfo.Rock1;
				break;
			case 17:
				result = strengthenInfo.Rock3;
				break;
			case 7:
				result = strengthenInfo.Rock;
				break;
			}
			return result;
        }

		public static StrengThenExpInfo FindStrengthenExpInfo(int level)
		{
			if (_Strengthens_Exps.ContainsKey(level))
				return _Strengthens_Exps[level];

			return null;
		}


		public static int GetNecklaceExpAdd(int exp, int currentPlus)
		{
			int level = GetNecklaceLevelByGP(exp);
			StrengThenExpInfo stre = FindStrengthenExpInfo(level);
			if (stre == null)
				return currentPlus;
			return stre.NecklaceStrengthPlus;
		}

		public static int GetNecklaceLevelByGP(int exp)
		{
			int level = NECKLACE_MAX_LEVEL;
			while (level > -1)
			{
				if (_Strengthens_Exps[level].NecklaceStrengthExp <= exp)
					return level;

				level--;
			}
			return 1;
		}

		public static int GetNecklaceMaxExp()
		{
			StrengThenExpInfo stre = FindStrengthenExpInfo(NECKLACE_MAX_LEVEL);
			if (stre == null)
				return 0;

			return stre.NecklaceStrengthExp;
		}
	}
}
