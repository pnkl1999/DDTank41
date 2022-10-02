using System;

namespace SqlDataProvider.Data
{
    public class UserLabyrinthInfo : DataObject
    {
        private int int_0;

        private int int_1;

        private int int_2;

        private int int_3;

        private bool bool_0;

        private bool bool_1;

        private int int_4;

        private int int_5;

        private int int_6;

        private int int_7;

        private int int_8;

        private int int_9;

        private bool bool_2;

        private bool bool_3;

        private bool bool_4;

        private bool bool_5;

        private DateTime dateTime_0;

        private string string_0;

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

        public int sType
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

        public int myProgress
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

        public int myRanking
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

        public bool completeChallenge
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

        public bool isDoubleAward
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

        public int currentFloor
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

        public int accumulateExp
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

        public int remainTime
        {
			get
			{
				return int_6;
			}
			set
			{
				int_6 = value;
				_isDirty = true;
			}
        }

        public int currentRemainTime
        {
			get
			{
				return int_7;
			}
			set
			{
				int_7 = value;
				_isDirty = true;
			}
        }

        public int cleanOutAllTime
        {
			get
			{
				return int_8;
			}
			set
			{
				int_8 = value;
				_isDirty = true;
			}
        }

        public int cleanOutGold
        {
			get
			{
				return int_9;
			}
			set
			{
				int_9 = value;
				_isDirty = true;
			}
        }

        public bool tryAgainComplete
        {
			get
			{
				return bool_2;
			}
			set
			{
				bool_2 = value;
				_isDirty = true;
			}
        }

        public bool isInGame
        {
			get
			{
				return bool_3;
			}
			set
			{
				bool_3 = value;
				_isDirty = true;
			}
        }

        public bool isCleanOut
        {
			get
			{
				return bool_4;
			}
			set
			{
				bool_4 = value;
				_isDirty = true;
			}
        }

        public bool serverMultiplyingPower
        {
			get
			{
				return bool_5;
			}
			set
			{
				bool_5 = value;
				_isDirty = true;
			}
        }

        public DateTime LastDate
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

        public string ProcessAward
        {
			get
			{
				return string_0;
			}
			set
			{
				string_0 = value;
				_isDirty = true;
			}
        }

        public bool isValidDate()
        {
			return dateTime_0.Date < DateTime.Now.Date;
        }
    }
}
