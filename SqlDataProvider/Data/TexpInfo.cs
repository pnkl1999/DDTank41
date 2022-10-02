using System;

namespace SqlDataProvider.Data
{
    public class TexpInfo : DataObject
    {
        private int _attTexpExp;

        private int _defTexpExp;

        private int _hpTexpExp;

        private int _lukTexpExp;

        private int _spdTexpExp;

        private int _texpCount;

        private int _texpTaskCount;

        private DateTime _texpTaskDate;

        private int _userID;

        public int attTexpExp
        {
			get
			{
				return _attTexpExp;
			}
			set
			{
				_attTexpExp = value;
				_isDirty = true;
			}
        }

        public int defTexpExp
        {
			get
			{
				return _defTexpExp;
			}
			set
			{
				_defTexpExp = value;
				_isDirty = true;
			}
        }

        public int hpTexpExp
        {
			get
			{
				return _hpTexpExp;
			}
			set
			{
				_hpTexpExp = value;
				_isDirty = true;
			}
        }

        public int ID { get; set; }

        public int lukTexpExp
        {
			get
			{
				return _lukTexpExp;
			}
			set
			{
				_lukTexpExp = value;
				_isDirty = true;
			}
        }

        public int spdTexpExp
        {
			get
			{
				return _spdTexpExp;
			}
			set
			{
				_spdTexpExp = value;
				_isDirty = true;
			}
        }

        public int texpCount
        {
			get
			{
				return _texpCount;
			}
			set
			{
				_texpCount = value;
				_isDirty = true;
			}
        }

        public int texpTaskCount
        {
			get
			{
				return _texpTaskCount;
			}
			set
			{
				_texpTaskCount = value;
				_isDirty = true;
			}
        }

        public DateTime texpTaskDate
        {
			get
			{
				return _texpTaskDate;
			}
			set
			{
				_texpTaskDate = value;
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

        public bool IsValidadteTexp()
        {
			return _texpTaskDate.Date < DateTime.Now.Date;
        }
    }
}
