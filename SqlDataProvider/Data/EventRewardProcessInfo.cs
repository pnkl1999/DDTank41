namespace SqlDataProvider.Data
{
    public class EventRewardProcessInfo : DataObject
    {
        private int int_0;

        private int int_1;

        private int int_2;

        private int int_3;

        public int ActiveType
        {
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
				_isDirty = true;
			}
        }

        public int AwardGot
        {
			get
			{
				return int_3;
			}
			set
			{
				int_3 = value;
				_isDirty = true;
			}
        }

        public int Conditions
        {
			get
			{
				return int_2;
			}
			set
			{
				int_2 = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
				_isDirty = true;
			}
        }
    }
}
