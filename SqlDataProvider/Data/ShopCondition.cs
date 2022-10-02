namespace SqlDataProvider.Data
{
    public class ShopCondition
    {
        public static bool isDDTMoney(int type)
        {
			return type == 2;
        }

        public static bool isLabyrinth(int type)
        {
			return type == 94;
        }

        public static bool isLeague(int type)
        {
			return type == 93;
        }

        public static bool isMoney(int type)
        {
			return type == 1;
        }

        public static bool isOffer(int type)
        {
			if ((uint)(type - 11) <= 4u)
			{
				return true;
			}
			return false;
        }

        public static bool isPetScrore(int type)
        {
			return type == 92;
        }

        public static bool isSearchGoods(int type)
        {
			return type == 99;
        }

        public static bool isWorldBoss(int type)
        {
			return type == 91;
        }
    }
}
