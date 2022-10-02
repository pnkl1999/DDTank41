using System;

namespace SqlDataProvider.Data
{
    public class UserFieldInfo : DataObject
    {
        private int _id;

        private int _farmID;

        private int _fieldID;

        private int _seedID;

        private DateTime _plantTime;

        private int _accelerateTime;

        private int _fieldValidDate;

        private DateTime _payTime;

        private int _payFieldTime;

        private int _gainCount;

        private int _gainFieldId;

        private int _autoSeedID;

        private int _autoFertilizerID;

        private int _autoSeedIDCount;

        private int _autoFertilizerCount;

        private bool _isAutomatic;

        private bool _isExist;

        private DateTime _automaticTime;

        public int ID
        {
			get
			{
				return _id;
			}
			set
			{
				_id = value;
				_isDirty = true;
			}
        }

        public int FarmID
        {
			get
			{
				return _farmID;
			}
			set
			{
				_farmID = value;
				_isDirty = true;
			}
        }

        public int FieldID
        {
			get
			{
				return _fieldID;
			}
			set
			{
				_fieldID = value;
				_isDirty = true;
			}
        }

        public int SeedID
        {
			get
			{
				return _seedID;
			}
			set
			{
				_seedID = value;
				_isDirty = true;
			}
        }

        public DateTime PlantTime
        {
			get
			{
				return _plantTime;
			}
			set
			{
				_plantTime = value;
				_isDirty = true;
			}
        }

        public int AccelerateTime
        {
			get
			{
				return _accelerateTime;
			}
			set
			{
				_accelerateTime = value;
				_isDirty = true;
			}
        }

        public int FieldValidDate
        {
			get
			{
				return _fieldValidDate;
			}
			set
			{
				_fieldValidDate = value;
				_isDirty = true;
			}
        }

        public DateTime PayTime
        {
			get
			{
				return _payTime;
			}
			set
			{
				_payTime = value;
				_isDirty = true;
			}
        }

        public int payFieldTime
        {
			get
			{
				return _payFieldTime;
			}
			set
			{
				_payFieldTime = value;
				_isDirty = true;
			}
        }

        public int GainCount
        {
			get
			{
				return _gainCount;
			}
			set
			{
				_gainCount = value;
				_isDirty = true;
			}
        }

        public int gainFieldId
        {
			get
			{
				return _gainFieldId;
			}
			set
			{
				_gainFieldId = value;
				_isDirty = true;
			}
        }

        public int AutoSeedID
        {
			get
			{
				return _autoSeedID;
			}
			set
			{
				_autoSeedID = value;
				_isDirty = true;
			}
        }

        public int AutoFertilizerID
        {
			get
			{
				return _autoFertilizerID;
			}
			set
			{
				_autoFertilizerID = value;
				_isDirty = true;
			}
        }

        public int AutoSeedIDCount
        {
			get
			{
				return _autoSeedIDCount;
			}
			set
			{
				_autoSeedIDCount = value;
				_isDirty = true;
			}
        }

        public int AutoFertilizerCount
        {
			get
			{
				return _autoFertilizerCount;
			}
			set
			{
				_autoFertilizerCount = value;
				_isDirty = true;
			}
        }

        public bool isAutomatic
        {
			get
			{
				return _isAutomatic;
			}
			set
			{
				_isAutomatic = value;
				_isDirty = true;
			}
        }

        public bool IsExit
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

        public DateTime AutomaticTime
        {
			get
			{
				return _automaticTime;
			}
			set
			{
				_automaticTime = value;
				_isDirty = true;
			}
        }

        public bool IsValidField()
        {
			if (_payFieldTime != 0)
			{
				return DateTime.Compare(_payTime.AddDays(_payFieldTime), DateTime.Now) > 0;
			}
			return true;
        }

        public bool isDig()
        {
			TimeSpan usedTime = DateTime.Now - _plantTime;
			int timeLeft = _fieldValidDate - ((int)usedTime.TotalMinutes + _accelerateTime);
			return timeLeft <= 0;
        }
    }
}
