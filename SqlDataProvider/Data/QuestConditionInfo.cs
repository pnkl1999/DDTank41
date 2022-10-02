namespace SqlDataProvider.Data
{
    public class QuestConditionInfo
    {
        public int CondictionID { get; set; }

        public string CondictionTitle { get; set; }

        public int CondictionType { get; set; }

        public bool isOpitional { get; set; }

        public int Para1 { get; set; }

        public int Para2 { get; set; }

        public int QuestID { get; set; }

        public int Tagert()
        {
			if (CondictionType == 20 && Para1 != 3)
			{
				return 0;
			}
			return Para2;
        }
    }
}
