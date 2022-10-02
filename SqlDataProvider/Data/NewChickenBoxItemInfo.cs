namespace SqlDataProvider.Data
{
    public class NewChickenBoxItemInfo : DataObject
    {
        private int _ID;

        private int _userID;

        private int _templateID;

        private int _count;

        private int _validDate;

        private int _strengthenLevel;

        private int _attackCompose;

        private int _defendCompose;

        private int _agilityCompose;

        private int _luckCompose;

        private int _position;

        private bool _isSelected;

        private bool _isSeeded;

        private bool _isBinds;

        private int _quality;

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

        public int Count
        {
			get
			{
				return _count;
			}
			set
			{
				_count = value;
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

        public int StrengthenLevel
        {
			get
			{
				return _strengthenLevel;
			}
			set
			{
				_strengthenLevel = value;
				_isDirty = true;
			}
        }

        public int AttackCompose
        {
			get
			{
				return _attackCompose;
			}
			set
			{
				_attackCompose = value;
				_isDirty = true;
			}
        }

        public int DefendCompose
        {
			get
			{
				return _defendCompose;
			}
			set
			{
				_defendCompose = value;
				_isDirty = true;
			}
        }

        public int AgilityCompose
        {
			get
			{
				return _agilityCompose;
			}
			set
			{
				_agilityCompose = value;
				_isDirty = true;
			}
        }

        public int LuckCompose
        {
			get
			{
				return _luckCompose;
			}
			set
			{
				_luckCompose = value;
				_isDirty = true;
			}
        }

        public int Position
        {
			get
			{
				return _position;
			}
			set
			{
				_position = value;
				_isDirty = true;
			}
        }

        public bool IsSelected
        {
			get
			{
				return _isSelected;
			}
			set
			{
				_isSelected = value;
				_isDirty = true;
			}
        }

        public bool IsSeeded
        {
			get
			{
				return _isSeeded;
			}
			set
			{
				_isSeeded = value;
				_isDirty = true;
			}
        }

        public bool IsBinds
        {
			get
			{
				return _isBinds;
			}
			set
			{
				_isBinds = value;
				_isDirty = true;
			}
        }

        public int Quality
        {
			get
			{
				return _quality;
			}
			set
			{
				_quality = value;
				_isDirty = true;
			}
        }


		public int Random;
		public int StartRandom;
		public int EndRandom;
	}
}
