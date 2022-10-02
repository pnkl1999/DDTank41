using System;

namespace SqlDataProvider.Data
{
    public class PetEquipInfo
    {
        private ItemTemplateInfo itemTemplateInfo_0;

        public ItemTemplateInfo Template=> itemTemplateInfo_0;

        public int eqType { get; set; }

        public int eqTemplateID { get; set; }

        public DateTime startTime { get; set; }

        public int ValidDate { get; set; }

        public PetEquipInfo(ItemTemplateInfo temp)
        {
			itemTemplateInfo_0 = temp;
        }

        public bool IsValidItem()
        {
			if (ValidDate != 0)
			{
				return DateTime.Compare(startTime.AddDays(ValidDate), DateTime.Now) > 0;
			}
			return true;
        }
    }
}
