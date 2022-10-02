using System;

namespace SqlDataProvider.Data
{
    public class PetEquipDataInfo : DataObject
    {
        private int _eqtemplateID;

        private int _eqType;

        private int _ID;

        private bool _isExit;

        private int _petID;

        private DateTime _startTime;

        private ItemTemplateInfo _template;

        private int _userID;

        private int _validDate;

        public int eqTemplateID
        {
			get
			{
				return _eqtemplateID;
			}
			set
			{
				_eqtemplateID = value;
				_isDirty = true;
			}
        }

        public int eqType
        {
			get
			{
				return _eqType;
			}
			set
			{
				_eqType = value;
				_isDirty = true;
			}
        }

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

        public bool IsExit
        {
			get
			{
				return _isExit;
			}
			set
			{
				_isExit = value;
				_isDirty = true;
			}
        }

        public int PetID
        {
			get
			{
				return _petID;
			}
			set
			{
				_petID = value;
				_isDirty = true;
			}
        }

        public DateTime startTime
        {
			get
			{
				return _startTime;
			}
			set
			{
				_startTime = value;
				_isDirty = true;
			}
        }

        public ItemTemplateInfo Template=> _template;

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

        public PetEquipDataInfo(ItemTemplateInfo temp)
        {
			_template = temp;
        }

        public PetEquipDataInfo addTempalte(ItemTemplateInfo Template)
        {
			return new PetEquipDataInfo(Template)
			{
				_ID = _ID,
				_userID = _userID,
				_petID = _petID,
				_eqType = _eqType,
				_eqtemplateID = _eqtemplateID,
				_validDate = _validDate,
				_startTime = _startTime,
				_isExit = _isExit
			};
        }

        public bool IsValidate()
        {
			if (_validDate != 0)
			{
				return DateTime.Compare(_startTime.AddDays(_validDate), DateTime.Now) > 0;
			}
			return true;
        }
    }
}
