using System;

namespace SqlDataProvider.Data
{
    public class BufferInfo : DataObject
    {
        private DateTime _beginDate;

        private string _data;

        private bool _isExist;

        private int _templateID;

        private int _type;

        private int _userID;

        private int _validCount;

        private int _validDate;

        private int _value;

        public DateTime BeginDate
        {
			get
			{
				return _beginDate;
			}
			set
			{
				_beginDate = value;
				_isDirty = true;
			}
        }

        public string Data
        {
			get
			{
				return _data;
			}
			set
			{
				_data = value;
				_isDirty = true;
			}
        }

        public bool IsExist
        {
			get
			{
				return _isExist;
			}
			set
			{
				_isExist = value;
				_isDirty = true;
			}
        }

        public int TemplateID
        {
			get
			{
				return _templateID;
			}
			set
			{
				_templateID = value;
				_isDirty = true;
			}
        }

        public int Type
        {
			get
			{
				return _type;
			}
			set
			{
				_type = value;
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

        public int ValidCount
        {
			get
			{
				return _validCount;
			}
			set
			{
				_validCount = value;
				_isDirty = true;
			}
        }

        public int ValidDate
        {
			get
			{
				return _validDate;
			}
			set
			{
				_validDate = value;
				_isDirty = true;
			}
        }

        public int Value
        {
			get
			{
				return _value;
			}
			set
			{
				_value = value;
				_isDirty = true;
			}
        }

        public DateTime GetEndDate()
        {
			return _beginDate.AddMinutes(_validDate);
        }

        public bool IsValid()
        {
			return _beginDate.AddMinutes(_validDate) > DateTime.Now;
        }
    }
}
