using System;

namespace SqlDataProvider.Data
{
    public class UsersExtraInfo : DataObject
    {
        private int int_0;

        private DateTime dateTime_0;

        private DateTime dateTime_1;

        private int int_1;

        private DateTime dateTime_2;

        private int int_2;

        private int int_3;

        private int int_4;

        private int int_5;

        private DateTime dateTime_3;

        private int int_6;

        private int int_7;

        private int int_8;

        private bool bool_0;

        private bool bool_1;

        private int int_9;

        private int int_10;

        private int int_11;

        private int int_12;

        private bool bool_2;

        private int int_13;

        private int int_14;

        private int int_15;

        private int int_16;

        private int int_17;

        private int int_18;

        private DateTime dateTime_4;

        private int int_19;

        private int int_20;

        private float float_0;

        private int _freeSendMailCount;

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

        public string NickName { get; set; }

        public DateTime LastTimeHotSpring
        {
			get
			{
				return dateTime_0;
			}
			set
			{
				dateTime_0 = value;
				_isDirty = true;
			}
        }

        public DateTime LastFreeTimeHotSpring
        {
			get
			{
				return dateTime_1;
			}
			set
			{
				dateTime_1 = value;
				_isDirty = true;
			}
        }

        public int MinHotSpring
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

        public int coupleBossEnterNum
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

        public int coupleBossHurt
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

        public int coupleBossBoxNum
        {
			get
			{
				return int_4;
			}
			set
			{
				int_4 = value;
				_isDirty = true;
			}
        }

        public int TotalCaddyOpen
        {
			get
			{
				return int_5;
			}
			set
			{
				int_5 = value;
				_isDirty = true;
			}
        }

        public bool isGetAwardMarry
        {
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
				_isDirty = true;
			}
        }

        public bool isFirstAwardMarry
        {
			get
			{
				return bool_1;
			}
			set
			{
				bool_1 = value;
				_isDirty = true;
			}
        }

        public int LeftRoutteCount
        {
			get
			{
				return int_20;
			}
			set
			{
				int_20 = value;
				_isDirty = true;
			}
        }

        public float LeftRoutteRate
        {
			get
			{
				return float_0;
			}
			set
			{
				float_0 = value;
				_isDirty = true;
			}
        }

        public int FreeSendMailCount
        {
			get
			{
				return _freeSendMailCount;
			}
			set
			{
				_freeSendMailCount = value;
				_isDirty = true;
			}
        }

        public bool IsVaildFreeHotSpring()
        {
			return dateTime_1.Date < DateTime.Now.Date;
        }
    }
}
