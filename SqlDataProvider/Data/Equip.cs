namespace SqlDataProvider.Data
{
    public class Equip
    {
        public static bool isAvatar(ItemTemplateInfo info)
        {
			switch (info.TemplateID)
			{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 13:
			case 15:
				return true;
			default:
				return false;
			}
        }

        public static bool isDress(ItemTemplateInfo info)
        {
			return false;
        }

        public static bool isMagicStone(ItemTemplateInfo info)
        {
			bool flag = false;
			if (info.CategoryID == 61)
			{
				flag = true;
			}
			return flag;
        }

        public static bool isShowImp(ItemTemplateInfo info)
        {
			switch (info.CategoryID)
			{
			case 5:
			case 7:
				return true;
			case 1:
				return true;
			default:
				return false;
			}
        }

        public static bool isWeddingRing(ItemTemplateInfo info)
        {
			int templateID = info.TemplateID;
			if (templateID <= 9222)
			{
				if (templateID != 9022 && templateID != 9122 && templateID != 9222)
				{
					return false;
				}
			}
			else if (templateID != 9322 && templateID != 9422 && templateID != 9522 && templateID != 9622 && templateID != 9722 && templateID != 9822 && templateID != 9922)
			{
				return false;
			}
			return true;
        }
    }
}
