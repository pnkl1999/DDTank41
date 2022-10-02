namespace SqlDataProvider.Data
{
    public class AchievementProcessInfo : DataObject
    {
        private int _CondictionType;

        private int _Value;

        public int CondictionType
        {
			get
			{
				return _CondictionType;
			}
			set
			{
				_CondictionType = value;
				_isDirty = true;
			}
        }

        public int Value
        {
			get
			{
				return _Value;
			}
			set
			{
				_Value = value;
				_isDirty = true;
			}
        }

        public AchievementProcessInfo()
        {
        }

        public AchievementProcessInfo(int type, int value)
        {
			CondictionType = type;
			Value = value;
        }
    }
}
