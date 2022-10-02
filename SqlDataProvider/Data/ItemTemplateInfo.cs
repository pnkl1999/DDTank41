namespace SqlDataProvider.Data
{
    public class ItemTemplateInfo : DataObject
    {
        public string AddTime { get; set; }

        public int Agility { get; set; }

        public int Attack { get; set; }

        public eBageType BagType
        {
			get
			{
				switch (CategoryID)
				{
				case 10:
				case 11:
				case 12:
				case 20:
				case 26:
				case 34:
				case 35:
				case 53:
					return eBageType.PropBag;
				case 32:
					return eBageType.FarmBag;
				default:
					return eBageType.EquipBag;
				}
			}
        }

        public bool IsOnly=> MaxCount > 1;

        public int BindType { get; set; }

        public bool CanCompose { get; set; }

        public bool CanDelete { get; set; }

        public bool CanDrop { get; set; }

        public bool CanEquip { get; set; }

        public int CanRecycle { get; set; }

        public bool CanStrengthen { get; set; }

        public bool CanUse { get; set; }

        public int CategoryID { get; set; }

        public string Colors { get; set; }

        public string Data { get; set; }

        public int Defence { get; set; }

        public string Description { get; set; }

        public int FloorPrice { get; set; }

        public int FusionNeedRate { get; set; }

        public int FusionRate { get; set; }

        public int FusionType { get; set; }

        public string Hole { get; set; }

        public int Level { get; set; }

        public int Luck { get; set; }

        public int MaxCount { get; set; }

        public string Name { get; set; }

        public int NeedLevel { get; set; }

        public int NeedSex { get; set; }

        public string Pic { get; set; }

        public int Property1 { get; set; }

        public int Property2 { get; set; }

        public int Property3 { get; set; }

        public int Property4 { get; set; }

        public int Property5 { get; set; }

        public int Property6 { get; set; }

        public int Property7 { get; set; }

        public int Property8 { get; set; }

        public int Quality { get; set; }

        public int ReclaimType { get; set; }

        public int ReclaimValue { get; set; }

        public int RefineryLevel { get; set; }

        public int RefineryType { get; set; }

        public string Script { get; set; }

        public int SuitId { get; set; }

        public int TemplateID { get; set; }

        public bool CanAdvanced()
        {
			switch (CategoryID)
			{
			case 1:
			case 5:
			case 7:
			case 17:
				return true;
			default:
				return false;
			}
        }

        public bool IsRing()
        {
			switch (TemplateID)
			{
			case 9022:
			case 9122:
			case 9222:
			case 9322:
			case 9422:
			case 9522:
				return true;
			default:
				return false;
			}
        }

        public bool IsSpecial()
        {
			switch (TemplateID)
			{
			case -2300:
			case -2200:
			case -2100:
			case -2000:
			case -1900:
			case -1800:
			case -1700:
			case -1600:
			case -1500:
			case -1400:
			case -1300:
			case -1200:
			case -1100:
			case -1000:
			case -900:
			case -800:
			case -400:
			case -300:
			case -200:
			case -100:
			case 11107:
				return true;
			default:
				return false;
			}
        }
    }
}
