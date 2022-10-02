namespace SqlDataProvider.Data
{
    public class RuneTemplateInfo
    {
        public string Attribute1 { get; set; }

        public string Attribute2 { get; set; }

        public string Attribute3 { get; set; }

        public int BaseLevel { get; set; }

        public int MaxLevel { get; set; }

        public string Name { get; set; }

        public int NextTemplateID { get; set; }

        public int Rate1 { get; set; }

        public int Rate2 { get; set; }

        public int Rate3 { get; set; }

        public int TemplateID { get; set; }

        public int Turn1 { get; set; }

        public int Turn2 { get; set; }

        public int Turn3 { get; set; }

        public int Type1 { get; set; }

        public int Type2 { get; set; }

        public int Type3 { get; set; }

        public bool IsAttack()
        {
			switch ((Type1 == 37) ? Type2 : Type1)
			{
			case 1:
			case 4:
			case 5:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 16:
			case 17:
			case 18:
			case 21:
			case 22:
			case 23:
			case 24:
			case 25:
				return true;
			default:
				return false;
			}
        }

        public bool IsDefend()
        {
			int num2 = ((Type1 == 39) ? Type2 : Type1);
			if (num2 <= 10)
			{
				if (num2 != 2 && num2 != 6 && num2 != 10)
				{
					return false;
				}
			}
			else
			{
				switch (num2)
				{
				case 14:
					return false;
				default:
					return false;
				case 13:
				case 15:
				case 19:
				case 26:
					break;
				}
			}
			return true;
        }

        public bool IsProp()
        {
			int type = Type1;
			if ((uint)(type - 31) <= 5u)
			{
				return true;
			}
			return false;
        }
    }
}
