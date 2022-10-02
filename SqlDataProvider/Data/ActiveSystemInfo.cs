using System;

namespace SqlDataProvider.Data
{
    public class ActiveSystemInfo : DataObject
    {
        private int _ID;

        private int _userID;

        private int _canEagleEyeCounts;

        private int _canOpenCounts;

        private bool _isShowAll;

        private DateTime _lastFlushTime;

		private string _chickActiveData;

		private int _luckystarCoins;

		private int _activeMoney;

		public int ID
        {
			get
			{
				return _ID;
			}
			set
			{
				_ID = value;
				_isDirty = true;
			}
        }

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

        public int canEagleEyeCounts
        {
			get
			{
				return _canEagleEyeCounts;
			}
			set
			{
				_canEagleEyeCounts = value;
				_isDirty = true;
			}
        }

        public int canOpenCounts
        {
			get
			{
				return _canOpenCounts;
			}
			set
			{
				_canOpenCounts = value;
				_isDirty = true;
			}
        }

        public bool isShowAll
        {
			get
			{
				return _isShowAll;
			}
			set
			{
				_isShowAll = value;
				_isDirty = true;
			}
        }

        public DateTime lastFlushTime
        {
			get
			{
				return _lastFlushTime;
			}
			set
			{
				_lastFlushTime = value;
				_isDirty = true;
			}
        }

        public string ChickActiveData
		{
			get { return _chickActiveData; }
			set { _chickActiveData = value; _isDirty = true; }
		}

		public int LuckystarCoins
		{
			get { return _luckystarCoins; }
			set { _luckystarCoins = value; _isDirty = true; }
		}

		public int ActiveMoney
		{
			get { return _activeMoney; }
			set { _activeMoney = value; _isDirty = true; }
		}
	}
}
