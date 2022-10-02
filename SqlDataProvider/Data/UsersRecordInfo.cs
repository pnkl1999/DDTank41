namespace SqlDataProvider.Data
{
    public class UsersRecordInfo : DataObject
    {
        private int _userID;

        private int _recordID;

        private int _total;

        public int UserID
        {
			get
			{
				return _userID;
			}
			set
			{
				_userID = value;
				_isDirty = true;
			}
        }

        public int RecordID
        {
			get
			{
				return _recordID;
			}
			set
			{
				_recordID = value;
				_isDirty = true;
			}
        }

        public int Total
        {
			get
			{
				return _total;
			}
			set
			{
				_total = value;
				_isDirty = true;
			}
        }
    }
}
