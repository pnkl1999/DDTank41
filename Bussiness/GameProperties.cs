using Game.Base.Config;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Bussiness
{
    public abstract class GameProperties
    {

        [ConfigProperty("BeginAuction", "ÅÄÂòÊ±ÆðÊ¼Ëæ»úÊ±¼ä", 20)]
		public static int BeginAuction;

        [ConfigProperty("BigExp", "µ±Ç°ÓÎÏ·°æ±¾", "11906|99")]
		public static readonly string BigExp;

        [ConfigProperty("BoxAppearCondition", "Ïä×ÓÎïÆ·ÌáÊ¾µÄµÈ¼¶", 4)]
		public static readonly int BOX_APPEAR_CONDITION;

        [ConfigProperty("Cess", "½»Ò×¿ÛË°", 0.1)]
		public static readonly double Cess;

        [ConfigProperty("CustomLimit", "sendattackmail|addaution|PresentGoods|PresentMoney|unknow", "20|20|20|20|20")]
		public static readonly string CustomLimit;

        [ConfigProperty("CheckCount", "×î\u00b4óÑéÖ¤ÂëÊ§°Ü\u00b4ÎÊý", 2)]
		public static readonly int CHECK_MAX_FAILED_COUNT;

        [ConfigProperty("WarriorFamRaidPriceBig", "WarriorFamRaidPriceBig ", 40000)]
		public static readonly int WarriorFamRaidPriceBig;

        [ConfigProperty("WarriorFamRaidDDTPrice", "WarriorFamRaidDDTPrice", 5000)]
		public static readonly int WarriorFamRaidDDTPrice;

        [ConfigProperty("WarriorFamRaidTimeRemain", "WarriorFamRaidTimeRemain", 120)]
		public static readonly int WarriorFamRaidTimeRemain;

        [ConfigProperty("WarriorFamRaidPriceSmall", "WarriorFamRaidPriceSmall", 30000)]
		public static readonly int WarriorFamRaidPriceSmall;

        [ConfigProperty("WarriorFamRaidPricePerMin", "WarriorFamRaidPricePerMin", 10)]
		public static readonly int WarriorFamRaidPricePerMin;

        [ConfigProperty("Edition", "µ±Ç°ÓÎÏ·°æ±¾", "2612558")]
		public static readonly string EDITION;

        [ConfigProperty("EndAuction", "ÅÄÂòÊ±½áÊøËæ»úÊ±¼ä", 40)]
		public static int EndAuction;

        [ConfigProperty("FreeExp", "µ±Ç°ÓÎÏ·°æ±¾", "11901|1")]
		public static readonly string FreeExp;

        [ConfigProperty("FreeMoney", "µ±Ç°ÓÎÏ·°æ±¾", 9990000)]
		public static readonly int FreeMoney;

        [ConfigProperty("HoleLevelUpExpList", "HoleLevelUpExpList", "400|600|700|800|800")]
		public static string HoleLevelUpExpList;

        [ConfigProperty("HotSpringExp", "Kinh nghiệm Spa", "1|2")]
		public static readonly string HotSpringExp;

        [ConfigProperty("IsLimitCount", "IsLimitCount", false)]
		public static readonly bool IsLimitCount;

        [ConfigProperty("IsLimitMail", "IsLimitMail", false)]
		public static readonly bool IsLimitMail;

        [ConfigProperty("IsLimitMoney", "IsLimitMoney", false)]
		public static readonly bool IsLimitMoney;

        [ConfigProperty("WishBeadLimitLv", "WishBeadLimitLv", 12)]
		public static readonly int WishBeadLimitLv;

        [ConfigProperty("IsWishBeadLimit", "IsWishBeadLimit", false)]
		public static readonly bool IsWishBeadLimit;

        [ConfigProperty("LimitCount", "LimitCount", 10)]
		public static readonly int LimitCount;

        [ConfigProperty("LimitMail", "LimitMail", 3)]
		public static readonly int LimitMail;

        [ConfigProperty("LimitMoney", "LimitMoney", 999000)]
		public static readonly int LimitMoney;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        [ConfigProperty("NewChickenBeginTime", "NewChickenBeginTime", "2013/12/17 0:00:00")]
		public static readonly string NewChickenBeginTime;

        [ConfigProperty("NewChickenEagleEyePrice", "NewChickenEagleEyePrice", "3000, 2000, 1000")]
		public static readonly string NewChickenEagleEyePrice;

        [ConfigProperty("NewChickenEndTime", "NewChickenEndTime", "2013/12/25 0:00:00")]
		public static readonly string NewChickenEndTime;

        [ConfigProperty("NewChickenFlushPrice", "NewChickenFlushPrice", 10000)]
		public static readonly int NewChickenFlushPrice;

        [ConfigProperty("NewChickenOpenCardPrice", "NewChickenOpenCardPrice", "2500, 2000, 1500, 1000, 500")]
		public static readonly string NewChickenOpenCardPrice;

        [ConfigProperty("PetExp", "µ±Ç°ÓÎÏ·°æ±¾", "334103|999")]
		public static readonly string PetExp;

        [ConfigProperty("DivorcedMoney", "Àë»éµÄ¼Û\u00b8ñ", 1499)]
		public static readonly int PRICE_DIVORCED;

        [ConfigProperty("DivorcedDiscountMoney", "Àë»éµÄ¼Û\u00b8ñ", 999)]
		public static readonly int PRICE_DIVORCED_DISCOUNT;

        [ConfigProperty("MarryRoomCreateMoney", "½á»é·¿¼äµÄ¼Û\u00b8ñ,2Ð¡Ê±¡¢3Ð¡Ê±¡¢4Ð¡Ê±ÓÃ¶ººÅ·Ö\u00b8ô", "2000,2700,3400")]
		public static readonly string PRICE_MARRY_ROOM;

        [ConfigProperty("HymenealMoney", "Çó»éµÄ¼Û\u00b8ñ", 300)]
		public static readonly int PRICE_PROPOSE;

        public static int SpaAddictionMoneyNeeded = 1299;

        [ConfigProperty("SpaPriRoomContinueTime", "ÅÄÂòÊ±½áÊøËæ»úÊ±¼ä", 30)]
		public static int SpaPriRoomContinueTime;

        [ConfigProperty("SpaPubRoomLoginPay", "ÅÄÂòÊ±½áÊøËæ»úÊ±¼ä", "10000,200")]
		public static string SpaPubRoomLoginPay;

        [ConfigProperty("TestActive", "TestActive", false)]
		public static readonly bool TestActive;

        [ConfigProperty("VIPExpForEachLv", "VIPExpForEachLv", "1|2")]
		public static readonly string VIPExpForEachLv;

        [ConfigProperty("VirtualName", "VirtualName", "Doreamon,Nobita,Xuneo,Xuka")]
		public static readonly string VirtualName;

        [ConfigProperty("TimeForLeague", "TimeForLeague", "19:30|21:30")]
		public static readonly string TimeForLeague;

        [ConfigProperty("GoldTimes", "GoldTimes", "20:00|21:00")]
		public static readonly string GoldTimes;

        [ConfigProperty("AcademyMasterFreezeHours", "AcademyMasterFreezeHours", 48)]
		public static int AcademyMasterFreezeHours;

        [ConfigProperty("AcademyApprenticeFreezeHours", "AcademyApprenticeFreezeHours", 24)]
		public static int AcademyApprenticeFreezeHours;

        [ConfigProperty("AcademyApprenticeAward", "AcademyApprenticeAward", "10|112085,15|112086,18|112087,20|112125")]
		public static string AcademyApprenticeAward;

        [ConfigProperty("AcademyMasterAward", "AcademyMasterAward", "10|112088,15|112089,18|112090,20|112124")]
		public static string AcademyMasterAward;

        [ConfigProperty("AcademyAppAwardComplete", "AcademyAppAwardComplete", "1401|5293,1301|5192")]
		public static string AcademyAppAwardComplete;

        [ConfigProperty("AcademyMasAwardComplete", "AcademyMasAwardComplete", "1414|5409,1314|5306")]
		public static string AcademyMasAwardComplete;

        [ConfigProperty("LeftRouterRateData", "LeftRouterRateData", "0.0003|0.0002|0.0001|0.001|0.002|")]
		public static string LeftRouterRateData;

        [ConfigProperty("LeftRouterMaxDay", "LeftRouterMaxDay", 5)]
		public static int LeftRouterMaxDay;

        [ConfigProperty("LeftRouterEndDate", "LeftRouterEndDate", "2012-01-01 20:55:27.270")]
		public static string LeftRouterEndDate;

        [ConfigProperty("EliteGameBlockWeapon", "ÅÄÂòÊ±½áÊøËæ»úÊ±¼ä", "7144|71441|71442|71443|71444|7145|71451|71452|71453|71454")]
		public static string EliteGameBlockWeapon;

        [ConfigProperty("InlayGoldPrice", "InlayGoldPrice", 2000)]
		public static int InlayGoldPrice;

        [ConfigProperty("IsOpenPetScore", "IsOpenPetScore", true)]
		public static readonly bool IsOpenPetScore;

        [ConfigProperty("FastGrowNeedMoney", "FastGrowNeedMoney", 30)]
		public static readonly int FastGrowNeedMoney;

        [ConfigProperty("FastGrowSubTime", "FastGrowSubTime", 30)]
		public static readonly int FastGrowSubTime;

        [ConfigProperty("LittleGameBoguConfig", "LittleGameBoguConfig", "200,1,1|100,4,1|5000,80,3|10000,125,5")]
		public static string LittleGameBoguConfig;

        [ConfigProperty("LittleGameMaxBoguCount", "LittleGameMaxBoguCount", 20)]
		public static int LittleGameMaxBoguCount;

        [ConfigProperty("LittleGameStartHourse", "LittleGameStartHourse", 7)]
		public static int LittleGameStartHourse;

        [ConfigProperty("LittleGameTimeSpendingHours", "LittleGameTimeSpendingHours", 1)]
		public static int LittleGameTimeSpending;

		[ConfigProperty("DebugMode", "DebugMode", false)]
		public static bool DebugMode;

        [ConfigProperty("VIPStrengthenEx", "VIPStrengthenEx", "25|25|25|35|35|50|50|50|50|50|50|50")]
        public static readonly string VIPStrengthenEx;

        [ConfigProperty("MissionRiches", "MissionRiches", "3000|3000|5000|5000|8000|8000|10000|10000|12000|12000")]
        public static readonly string MissionRiches;

        [ConfigProperty("EventStartDate", "EventStartDate", "2021-01-01 20:55:27.270")]
        public static string EventStartDate;

        [ConfigProperty("EventEndDate", "EventEndDate", "2025-01-01 20:55:27.270")]
        public static string EventEndDate;

        [ConfigProperty("EventStartMoney", "EventStartMoney", "2021-01-01 20:55:27.270")]
        public static string EventStartMoney;

        [ConfigProperty("EventEndMoney", "EventEndMoney", "2022-01-01 20:55:27.270")]
        public static string EventEndMoney;

        [ConfigProperty("WorldBossStart", "WorldBossStart", "01:00:00")]
        public static string WorldBossStart;

        [ConfigProperty("WorldBossEnd", "WorldBossEnd", "23:59:00")]
        public static string WorldBossEnd;

        [ConfigProperty("WorldBossID1", "WorldBossID1", 4)]
        public static int WorldBossID1;

        [ConfigProperty("WorldBossID2", "WorldBossID2", 1)]
        public static int WorldBossID2;

        [ConfigProperty("GoldTimeStart", "GoldTimeStart", "01:00:00")]
        public static string GoldTimeStart;

        [ConfigProperty("GoldTimeEnd", "GoldTimeEnd", "23:59:00")]
        public static string GoldTimeEnd;

        [ConfigProperty("CountHWIDLimit", "CountHWIDLimit", 99)]
        public static int CountHWIDLimit;

        [ConfigProperty("CountIPLimit", "CountIPLimit", 99)]
        public static int CountIPLimit;

        [ConfigPropertyAttribute("LuckStarActivityBeginDate", "LuckStarActivityBeginDate", "2013/12/1 0:00:00")]
        public static readonly string LuckStarActivityBeginDate;

        [ConfigPropertyAttribute("LuckStarActivityEndDate", "LuckStarActivityEndDate", "2014/12/24 0:00:00")]
        public static readonly string LuckStarActivityEndDate;

        [ConfigPropertyAttribute("MinUseNum", "MinUseNum", 1000)]
        public static readonly int MinUseNum;

        [ConfigPropertyAttribute("IsActiveMoney", "IsActiveMoney", true)]
        public static readonly bool IsActiveMoney;

        [ConfigProperty("FightSpiritLevelAddDamage", "FightSpiritLevelAddDamage", "6|2")]
        public readonly static string FightSpiritLevelAddDamage;

        [ConfigPropertyAttribute("FightSpiritMaxLevel", "FightSpiritMaxLevel", 5)]
        public static readonly int FightSpiritMaxLevel;
        
        [ConfigPropertyAttribute("PRICE_COMPOSE_GOLD", "PRICE_COMPOSE_GOLD", 1600)]
        public static readonly int PRICE_COMPOSE_GOLD;

        [ConfigPropertyAttribute("RateAdvance", "RateAdvance", 50000)]
        public static readonly int RateAdvance;

        [ConfigPropertyAttribute("TimeX2", "TimeX2", 2)]
        public static readonly int TimeX2;

        private static void Load(Type type)
        {
            using (ServiceBussiness sb = new ServiceBussiness())
            {
                foreach (FieldInfo f in type.GetFields())
                {
                    if (!f.IsStatic)
                        continue;
                    object[] attribs = f.GetCustomAttributes(typeof(ConfigPropertyAttribute), false);
                    if (attribs.Length == 0)
                        continue;
                    ConfigPropertyAttribute attrib = (ConfigPropertyAttribute)attribs[0];
                    f.SetValue(null, LoadProperty(attrib, sb));
                }
            }
        }

        private static void Save(Type type)
        {
            using (ServiceBussiness sb = new ServiceBussiness())
            {
                foreach (FieldInfo f in type.GetFields())
                {
                    if (!f.IsStatic)
                        continue;
                    object[] attribs = f.GetCustomAttributes(typeof(ConfigPropertyAttribute), false);
                    if (attribs.Length == 0)
                        continue;
                    ConfigPropertyAttribute attrib = (ConfigPropertyAttribute)attribs[0];
                    SaveProperty(attrib, sb, f.GetValue(null));
                }
            }
        }

        private static object LoadProperty(ConfigPropertyAttribute attrib, ServiceBussiness sb)
        {
            String key = attrib.Key;
            ServerProperty property = sb.GetServerPropertyByKey(key);
            if (property == null)
            {
                property = new ServerProperty();
                property.Value = attrib.DefaultValue.ToString();
                log.Info("Cannot find server property " + key + ",keep it default value!");
                SaveProperty(attrib, sb, property.Value);
            }
            try
            {
                return Convert.ChangeType(property.Value, attrib.DefaultValue.GetType());
            }
            catch (Exception e)
            {
                log.Error("Exception in GameProperties Load: ", e);
                return null;
            }
        }

        private static void SaveProperty(ConfigPropertyAttribute attrib, ServiceBussiness sb, object value)
        {
            try
            {
                sb.UpdateServerPropertyByKey(attrib.Key, value.ToString());
            }
            catch (Exception ex)
            {
                log.Error("Exception in GameProperties Save: ", ex);
            }
        }

        public static void Refresh()
        {
            log.Info("Refreshing game properties!");
            Load(typeof(GameProperties));
        }
        public static List<int> getProp(string prop)
        {
            List<int> listInt = new List<int>();
            string[] strs = prop.Split('|');
            foreach (string str in strs)
            {
                listInt.Add(Convert.ToInt32(str));
            }
            return listInt;
        }

        public static int LimitLevel(int index)
        {
            string[] strs = CustomLimit.Split('|');
            return Convert.ToInt32(strs[index]);
        }

        public static List<int> VIPExp()
        {
            return getProp(VIPExpForEachLv);
        }

        public static int[] ConvertStringArrayToIntArray(string str)
        {
            List<int> listInts = new List<int>();
            string[] strs = new string[] { "99999", "999999", "9999999" };
            switch (str)
            {
                case "NewChickenEagleEyePrice":
                    strs = NewChickenEagleEyePrice.Split(',');
                    break;
                case "NewChickenOpenCardPrice":
                    strs = NewChickenOpenCardPrice.Split(',');
                    break;
            }

            foreach (string value in strs)
            {
                listInts.Add(Convert.ToInt32(value));
            }
            return listInts.ToArray();
        }

        public static void Save()
        {
            log.Info("Saving game properties into db!");
        }

        public static Dictionary<int, int> AcademyApprenticeAwardArr()
        {
            return ConvertIntDict(AcademyApprenticeAward, ',', '|');
        }

        public static Dictionary<int, int> AcademyMasterAwardArr()
        {
            return ConvertIntDict(AcademyMasterAward, ',', '|');
        }

        public static Dictionary<int, int> ConvertIntDict(string value, char splitChar, char subSplitChar)
        {
            string[] strArray1 = value.Split(splitChar);
            Dictionary<int, int> dictionary = new Dictionary<int, int>();
            for (int index = 0; index < strArray1.Length; index++)
            {
                string[] strArray2 = strArray1[index].Split(subSplitChar);
                if (!dictionary.ContainsKey(int.Parse(strArray2[0])))
                {
                    dictionary.Add(int.Parse(strArray2[0]), int.Parse(strArray2[1]));
                }
            }
            return dictionary;
        }
    }
}
